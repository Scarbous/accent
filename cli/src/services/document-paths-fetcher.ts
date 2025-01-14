import * as path from 'path';

// Types
import {DocumentPath} from '../types/document-path';
import {Project} from '../types/project';
import Document from './document';
import {fetchFromRevisions} from './revision-slug-fetcher';

export default class DocumentPathsFetcher {
  fetch(project: Project, document: Document): DocumentPath[] {
    const languageSlugs = fetchFromRevisions(project.revisions);
    const documentPaths: Set<string> = new Set();
    project.documents.entries.forEach(({path}) => documentPaths.add(path));
    document.paths.forEach((documentPath) =>
      documentPaths.add(
        path.basename(documentPath).replace(path.extname(documentPath), '')
      )
    );

    return languageSlugs.reduce((memo: DocumentPath[], slug) => {
      documentPaths.forEach((path) => {
        const parsedTarget = document.target
          .replace('%slug%', slug)
          .replace('%original_file_name%', path)
          .replace('%document_path%', path);

        if (!memo.find(({path}) => path === parsedTarget)) {
          memo.push({documentPath: path, path: parsedTarget, language: slug});
        }
      });

      return memo;
    }, []);
  }
}
