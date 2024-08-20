{
  stdenv,
  lib,
  fetchpatch,
  mkDerivation,
  fetchFromGitHub,
  haskellPackages,
  slither-analyzer,
}:

mkDerivation (
  rec {
    pname = "echidna";
    version = "2.2.3";

    src = fetchFromGitHub {
      owner = "crytic";
      repo = "echidna";
      rev = "v${version}";
      sha256 = "sha256-NJ2G6EkexYE4P3GD7PZ+lLEs1dqnoqIB2zfAOD5SQ8M=";
    };

    patches = [
      # Support cross platform vty 6.x with vty-crossplatform
      # https://github.com/crytic/echidna/pull/1290
      (fetchpatch {
        url = "https://github.com/crytic/echidna/commit/2913b027d7e793390ed489ef6a47d23ec9b3c800.patch";
        hash = "sha256-5CGD9nDbDUTG869xUybWYSvGRsrm7JP7n0WMBNYfayw=";
      })
    ];

    isExecutable = true;

    libraryToolDepends = with haskellPackages; [ haskellPackages.hpack ];

    executableHaskellDepends = with haskellPackages; [
      # package.yaml - dependencies
      base
      aeson
      async
      base16-bytestring
      binary
      bytestring
      code-page
      containers
      data-bword
      data-dword
      deepseq
      extra
      directory
      exceptions
      filepath
      hashable
      hevm
      html-entities
      ListLike
      MonadRandom
      mtl
      optparse-applicative
      optics
      optics-core
      process
      random
      rosezipper
      semver
      split
      text
      transformers
      time
      unliftio
      utf8-string
      vector
      with-utf8
      word-wrap
      yaml
      http-conduit
      html-conduit
      warp
      wai-extra
      xml-conduit
      strip-ansi-escape
      # package.yaml - dependencies when "!os(windows)"
      brick
      unix
      vty
    ];

    # Note: there is also a runtime dependency of slither-analyzer. So, let's include it.
    executableSystemDepends = [ slither-analyzer ];

    preConfigure = ''
      hpack
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
  // lib.optionalAttrs (stdenv.isDarwin && stdenv.isAarch64) {

    # https://github.com/NixOS/nixpkgs/pull/304352
    postInstall = with haskellPackages; ''
      remove-references-to -t ${warp.out} "$out/bin/echidna"
      remove-references-to -t ${wreq.out} "$out/bin/echidna"
    '';
  }
)
