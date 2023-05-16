{ lib
<<<<<<< HEAD
, mkDerivation
, fetchFromGitHub
, haskellPackages
, haskell
, slither-analyzer
}:

let haskellPackagesOverride = haskellPackages.override {
      overrides = self: super: {
        # following the revision specified in echidna/stack.yaml
        # TODO: 0.51.3 is not in haskellPackages yet
        hevm = haskell.lib.overrideCabal super.hevm (oa: {
          version = "0.51.3";
          src = fetchFromGitHub {
            owner = "ethereum";
            repo = "hevm";
            rev = "release/0.51.3";
            hash = "sha256-H6oURBGoQWSOuPhBB+UKg2UarVzXgv1tmfDBLnOtdhU=";
          };
          libraryHaskellDepends = oa.libraryHaskellDepends
                                  ++ (with haskellPackages;[githash witch]);
        });
      };
    };
in mkDerivation rec {
  pname = "echidna";
  version = "2.2.1";
=======
, fetchFromGitHub
# Haskell deps
, mkDerivation, aeson, base, base16-bytestring, binary, brick, bytestring
, containers, data-dword, data-has, directory, exceptions, extra, filepath
, hashable, hevm, hpack, html-entities, lens, ListLike, MonadRandom, mtl
, optparse-applicative, process, random, semver, tasty, tasty-hunit
, tasty-quickcheck, text, transformers, unix, unliftio, unordered-containers
, vector, vector-instances, vty, yaml
}:
mkDerivation rec {
  pname = "echidna";
  version = "2.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-5d9ttPR3rRHywBeLM85EGCEZLNZNZzOAhIN6AJToJyI=";
=======
    sha256 = "sha256-8bChe+qA4DowfuwsR5wLckb56fXi102g8vL2gAH/kYE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  isLibrary = true;
  isExecutable = true;
<<<<<<< HEAD

  libraryToolDepends = with haskellPackagesOverride; [
    haskellPackages.hpack
  ];

  # Note: This can be extracted from package.yaml of echidna, the list is shorter because some are transitive.
  executableHaskellDepends = with haskellPackagesOverride;
    [aeson base base16-bytestring binary brick bytestring code-page containers data-dword data-has directory exceptions extra
     filepath hashable hevm html-conduit html-entities http-conduit lens ListLike MonadRandom mtl optics optparse-applicative
     process random semver text transformers unix unliftio unordered-containers vector vector-instances vty with-utf8
     xml-conduit yaml];

  # Note: there is also a runtime dependency of slither-analyzer, let's include it also.
  executableSystemDepends = [ slither-analyzer ];

  testHaskellDepends = with haskellPackagesOverride; [
    tasty tasty-hunit tasty-quickcheck
  ];

=======
  libraryHaskellDepends = [
    aeson base base16-bytestring binary brick bytestring containers data-dword
    data-has directory exceptions extra filepath hashable hevm html-entities
    lens ListLike MonadRandom mtl optparse-applicative process random semver
    text transformers unix unliftio unordered-containers vector vector-instances
    vty yaml
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = libraryHaskellDepends;
  testHaskellDepends = [
    tasty tasty-hunit tasty-quickcheck
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  maintainers = with lib.maintainers; [ arturcygan hellwolf ];
=======
  maintainers = with lib.maintainers; [ arturcygan ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  platforms = lib.platforms.unix;
  mainProgram = "echidna-test";
}
