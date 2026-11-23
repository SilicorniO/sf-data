# Changelog

## 1.0.1

- Bulk API v2 queries that return a single column, such as `SELECT Id FROM Account`, parse correctly.

## 1.0.0

First release of sf-data.

- Ordered YAML pipelines: `get`, `insert`, `update`, `upsert`, `delete`, `transform`, `merge`, `check`, `miller`, `table`, and `sql`.
- `sfdata init` scaffolds a project folder. `sfdata --ui` opens the browser builder and runs the pipeline locally.
- Standalone binaries for macOS Apple Silicon, Linux x64, and Windows x64.
