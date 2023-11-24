{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
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

  src = fetchFromGitHub {
    owner = "crytic";
    repo = "echidna";
    rev = "v${version}";
    sha256 = "sha256-5d9ttPR3rRHywBeLM85EGCEZLNZNZzOAhIN6AJToJyI=";
  };

  # Note: pending PR https://github.com/crytic/echidna/pull/1096
  patches = [
     (fetchpatch {
       name = "brick-1.9-update";
       url = "https://github.com/crytic/echidna/pull/1096/commits/36657d54943727e569691a6b3d85b83130480a2e.patch";
       sha256 = "sha256-AOmB/fAZCF7ruXW1HusRe7wWWsLyMCWw+j3qIPARIAc=";
     })
  ];

  isLibrary = true;
  isExecutable = true;

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
  maintainers = with lib.maintainers; [ arturcygan hellwolf ];
  platforms = lib.platforms.unix;
  mainProgram = "echidna-test";
}
