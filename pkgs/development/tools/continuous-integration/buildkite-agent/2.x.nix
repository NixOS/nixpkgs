{ callPackage, fetchFromGitHub, ... } @ args:

callPackage ./generic.nix (args // rec {
  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "agent";
    rev = "v${version}";
    sha256 = "07065hhhb418w5qlqnyiap45r59paysysbwz1l7dmaw3j4q8m8rg";
  };
  version = "2.6.10";
  hasBootstrapScript = true;
})
