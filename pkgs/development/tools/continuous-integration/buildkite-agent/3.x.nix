{ bash, callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "0ydzpfhp9nmpnmigzsg5yq2llfhbmqgrcignnk6qpykrrinv6pry";
  };
  version = "3.8.2";
  hasBootstrapScript = false;
  postPatch = ''
    substituteInPlace bootstrap/shell/shell.go --replace /bin/bash ${bash}/bin/bash
  '';
})
