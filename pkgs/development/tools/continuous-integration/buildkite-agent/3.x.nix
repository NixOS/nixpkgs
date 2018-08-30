{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "09smyrzp1xkczlmh8vqb7bmjb2b5d6yf9birjgaw36c6m44bpfvs";
  };
  version = "3.0.1";
  hasBootstrapScript = false;
})
