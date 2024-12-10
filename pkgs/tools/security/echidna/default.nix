{
  lib,
  mkDerivation,
  fetchFromGitHub,
  fetchpatch,
  haskellPackages,
  haskell,
  slither-analyzer,
}:

mkDerivation rec {
  pname = "echidna";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "sha256-l1ILdO+xb0zx/TFM6Am9j5hq1RnIMNf2HU6YvslAj0w=";
  };

  isLibrary = true;
  isExecutable = true;

  libraryToolDepends = with haskellPackages; [
    haskellPackages.hpack
  ];

  executableHaskellDepends = with haskellPackages; [
    aeson
    base
    base16-bytestring
    binary
    bytestring
    code-page
    containers
    data-bword
    data-dword
    deepseq
    directory
    exceptions
    extra
    filepath
    hashable
    hevm
    html-conduit
    html-entities
    http-conduit
    ListLike
    MonadRandom
    mtl
    optics
    optics-core
    optparse-applicative
    process
    random
    rosezipper
    semver
    split
    strip-ansi-escape
    text
    time
    transformers
    unliftio
    utf8-string
    vector
    wai-extra
    warp
    with-utf8
    word-wrap
    xml-conduit
    yaml
  ];

  # Note: there is also a runtime dependency of slither-analyzer, let's include it also.
  executableSystemDepends = [ slither-analyzer ];

  testHaskellDepends = with haskellPackages; [
    tasty
    tasty-hunit
    tasty-quickcheck
  ];

  preConfigure = ''
    hpack
    # re-enable dynamic build for Linux
    sed -i -e 's/os(linux)/false/' echidna.cabal
  '';
  shellHook = "hpack";
  doHaddock = false;
  # tests depend on a specific version of solc
  doCheck = false;

  description = "Ethereum smart contract fuzzer";
  homepage = "https://github.com/crytic/echidna";
  license = lib.licenses.agpl3Plus;
  maintainers = with lib.maintainers; [
    arturcygan
    hellwolf
  ];
  platforms = lib.platforms.unix;
  mainProgram = "echidna-test";
}
