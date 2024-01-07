{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, binutils
, asciidoctor
, cmake
, perl
, zstd
, bashInteractive
, xcodebuild
, makeWrapper
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccache";
  version = "4.9";

  src = fetchFromGitHub {
    owner = "ccache";
    repo = "ccache";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-/R9ReX1l3okUuVD93IdomoaBTYdKvuIuggyk0sJoYmg=";
  };

  outputs = [ "out" "man" ];

  patches = [
    # When building for Darwin, test/run uses dwarfdump, whereas on
    # Linux it uses objdump. We don't have dwarfdump packaged for
    # Darwin, so this patch updates the test to also use objdump on
    # Darwin.
    # Additionally, when cross compiling, the correct target prefix
    # needs to be set.
    (substituteAll {
      src = ./fix-objdump-path.patch;
      objdump = "${binutils.bintools}/bin/${binutils.targetPrefix}objdump";
    })
  ];

  nativeBuildInputs = [ asciidoctor cmake perl ];
  buildInputs = [ zstd ];

  cmakeFlags = [
    # Build system does not autodetect redis library presence.
    # Requires explicit flag.
    "-DREDIS_STORAGE_BACKEND=OFF"
  ];

  doCheck = true;
  nativeCheckInputs = [
    # test/run requires the compgen function which is available in
    # bashInteractive, but not bash.
    bashInteractive
  ] ++ lib.optional stdenv.isDarwin xcodebuild;

  checkPhase =
    let
      badTests = [
        "test.trim_dir" # flaky on hydra (possibly filesystem-specific?)
      ] ++ lib.optionals stdenv.isDarwin [
        "test.basedir"
        "test.fileclone" # flaky on hydra (possibly filesystem-specific?)
        "test.multi_arch"
        "test.nocpp2"
      ];
    in
    ''
      runHook preCheck
      export HOME=$(mktemp -d)
      ctest --output-on-failure -E '^(${lib.concatStringsSep "|" badTests})$'
      runHook postCheck
    '';

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = { unwrappedCC, extraConfig }: stdenv.mkDerivation {
      pname = "ccache-links";
      inherit (finalAttrs) version;
      passthru = {
        isClang = unwrappedCC.isClang or false;
        isGNU = unwrappedCC.isGNU or false;
        isCcache = true;
      };
      inherit (unwrappedCC) lib;
      nativeBuildInputs = [ makeWrapper ];
      # Unwrapped clang does not have a targetPrefix because it is multi-target
      # target is decided with argv0.
      buildCommand = let
        targetPrefix = if unwrappedCC.isClang or false
          then
            ""
          else
            (lib.optionalString (unwrappedCC ? targetConfig && unwrappedCC.targetConfig != null && unwrappedCC.targetConfig != "") "${unwrappedCC.targetConfig}-");
      in ''
        mkdir -p $out/bin

        wrap() {
          local cname="${targetPrefix}$1"
          if [ -x "${unwrappedCC}/bin/$cname" ]; then
            makeWrapper ${finalAttrs.finalPackage}/bin/ccache $out/bin/$cname \
              --run ${lib.escapeShellArg extraConfig} \
              --add-flags ${unwrappedCC}/bin/$cname
          fi
        }

        wrap cc
        wrap c++
        wrap gcc
        wrap g++
        wrap clang
        wrap clang++

        for executable in $(ls ${unwrappedCC}/bin); do
          if [ ! -x "$out/bin/$executable" ]; then
            ln -s ${unwrappedCC}/bin/$executable $out/bin/$executable
          fi
        done
        for file in $(ls ${unwrappedCC} | grep -vw bin); do
          ln -s ${unwrappedCC}/$file $out/$file
        done
      '';
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = "https://ccache.dev";
    downloadPage = "https://ccache.dev/download.html";
    changelog = "https://ccache.dev/releasenotes.html#_ccache_${
      builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
    }";
    license = licenses.gpl3Plus;
    mainProgram = "ccache";
    maintainers = with maintainers; [ kira-bruneau r-burns ];
    platforms = platforms.unix;
  };
})
