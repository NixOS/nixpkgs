{ bash, callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "0g7d8p8dh7a1ip8qxax12q25xrkig59lmq737zdlds2wxadpmk70";
  };
  version = "3.4.0";
  hasBootstrapScript = false;
  postPatch = ''
    substituteInPlace bootstrap/shell/shell.go --replace /bin/bash ${bash}/bin/bash
  '';
})
