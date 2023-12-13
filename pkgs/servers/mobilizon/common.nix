{ fetchFromGitLab, applyPatches }: rec {

  pname = "mobilizon";
  version = "4.0.0";

  src = applyPatches {
    src = fetchFromGitLab {
      domain = "framagit.org";
      owner = "framasoft";
      repo = pname;
      rev = version;
      sha256 = "sha256-PslcIS+HjGTx8UYhb7BG2OgLXfIWHDouuiogA/rq/7M=";
    };
    patches = [
      # See https://framagit.org/framasoft/mobilizon/-/merge_requests/1452
      ./cacerts_get.patch
    ];
  };
}
