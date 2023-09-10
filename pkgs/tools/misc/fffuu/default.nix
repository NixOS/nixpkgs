{ mkDerivation, haskellPackages, fetchFromGitHub, lib }:

mkDerivation {
  pname = "fffuu";
  version = "unstable-2018-05-26";

  src = fetchFromGitHub {
    owner = "diekmann";
    repo = "Iptables_Semantics";
    rev = "e0a2516bd885708fce875023b474ae341cbdee29";
    sha256 = "1qc7p44dqja6qrjbjdc2xn7n9v41j5v59sgjnxjj5k0mxp58y1ch";
  };

  postPatch = ''
    substituteInPlace haskell_tool/fffuu.cabal \
      --replace "containers >=0.5 && <0.6" "containers >= 0.6" \
      --replace "optparse-generic >= 1.2.3 && < 1.3" "optparse-generic >= 1.2.3"
  '';

  preCompileBuildDriver = ''
    cd haskell_tool
  '';

  isLibrary = false;

  isExecutable = true;

  # fails with sandbox
  doCheck = false;

  libraryHaskellDepends = with haskellPackages; [
    base
    containers
    split
    parsec
    optparse-generic
  ];

  executableHaskellDepends = with haskellPackages; [ base ];

  testHaskellDepends = with haskellPackages; [
    tasty
    tasty-hunit
    tasty-golden
  ];

  description = "Fancy Formal Firewall Universal Understander";
  homepage = "https://github.com/diekmann/Iptables_Semantics/tree/master/haskell_tool";
  license = lib.licenses.bsd2;
  maintainers = [ lib.maintainers.marsam ];
}
