{ bash, callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "0a7x919kxnpdn0pnhc5ilx1z6ninx8zgjvsd0jcg4qwh0qqp5ppr";
  };
  version = "3.17.0";
  hasBootstrapScript = false;
  postPatch = ''
    substituteInPlace bootstrap/shell/shell.go --replace /bin/bash ${bash}/bin/bash
  '';
})
