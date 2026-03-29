{
  fetchFromGitHub,
  lib,
  rocmVersion,
}:

{
  repo,
  hash,
  sourceSubdir,
  version ? rocmVersion,
  fetchSubmodules ? false,
  includeShared ? lib.hasPrefix "projects/" sourceSubdir,
  postFetch ? null,
}:

fetchFromGitHub (
  {
    owner = "ROCm";
    inherit
      fetchSubmodules
      hash
      repo
      ;
    rev = "rocm-${version}";
    sparseCheckout = lib.unique ([ sourceSubdir ] ++ lib.optional includeShared "shared");
  }
  // lib.optionalAttrs (postFetch != null) {
    inherit postFetch;
  }
)
