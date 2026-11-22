{
  version = "4.7.2-stable";
  hash = "sha256-RyUaOUkE6rYQcn1KKRY2GQ4vj8Gs7N24EJ+vU13meJE=";
  default = {
    exportTemplatesHash = "sha256-8phJC41E2TS+QlpaZaUb8V9CJCiyKaBqbhHZ/+okgBE=";
  };
  mono = {
    exportTemplatesHash = "sha256-kvhoHjSe8fkIkbeS2pXjsrC9HtYQt4AYxY/rLYfhWp0=";
    nugetDeps = ./deps.json;
  };
}
