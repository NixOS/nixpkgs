{
  version = "4.6.1-stable";
  hash = "sha256-C3AX+Gl6a3nX/k0TP6FYjYCK9AbKmtku+1ilYBu0R74=";
  default = {
    exportTemplatesHash = "sha256-5tNyr9T9+q6VceteNWivzZbObbmlaSRANBVPrwrGmHU=";
  };
  mono = {
    exportTemplatesHash = "sha256-V5JmHtCJVQNX4OEJVK9pWEa+CjLtdJT6QKAAnjtaPqk=";
    nugetDeps = ./deps.json;
  };
}
