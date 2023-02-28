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

let ccache = stdenv.mkDerivation rec {
  pname = "ccache";
  version = "4.7.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mt5udwSdzGaspfpAdUavQ55dBeJdhbZjcQpd9xNOQms=";
  };

  outputs = [ "out" "man" ];

  patches = [
    # When building for Darwin, test/run uses dwarfdump, whereas on
    # Linux it uses objdump. We don't have dwarfdump packaged for
    # Darwin, so this patch updates the test to also use objdump on
    # Darwin.
    (substituteAll {
      src = ./force-objdump-on-darwin.patch;
      objdump = "${binutils.bintools}/bin/objdump";
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

  checkPhase = let
    badTests = [
      "test.trim_dir" # flaky on hydra (possibly filesystem-specific?)
    ] ++ lib.optionals stdenv.isDarwin [
      "test.basedir"
      "test.multi_arch"
      "test.nocpp2"
    ];
  in ''
    runHook preCheck
    export HOME=$(mktemp -d)
    ctest --output-on-failure -E '^(${lib.concatStringsSep "|" badTests})$'
    runHook postCheck
  '';

  passthru = {
    # A derivation that provides gcc and g++ commands, but that
    # will end up calling ccache for the given cacheDir
    links = {unwrappedCC, extraConfig}: stdenv.mkDerivation {
      name = "ccache-links";
      passthru = {
        isClang = unwrappedCC.isClang or false;
        isGNU = unwrappedCC.isGNU or false;
      };
      inherit (unwrappedCC) lib;
      nativeBuildInputs = [ makeWrapper ];
      buildCommand = ''
        mkdir -p $out/bin

        wrap() {
          local cname="$1"
          if [ -x "${unwrappedCC}/bin/$cname" ]; then
            makeWrapper ${ccache}/bin/ccache $out/bin/$cname \
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
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = "https://ccache.dev";
    downloadPage = "https://ccache.dev/download.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kira-bruneau r-burns ];
    platforms = platforms.unix;
  };
};
in ccache
