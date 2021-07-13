{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, substituteAll
, binutils
, asciidoc
, cmake
, perl
, zstd
, bashInteractive
, xcodebuild
, makeWrapper
}:

let ccache = stdenv.mkDerivation rec {
  pname = "ccache";
  version = "4.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZBxDTMUZiZJLIYbvACTFwvlss+IZiMjiL0khfM5hFCM=";
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
    # Fix clang C++ modules test (remove in next release)
    (fetchpatch {
      url = "https://github.com/ccache/ccache/commit/8b0c783ffc77d29a3e3520345b776a5c496fd892.patch";
      sha256 = "13qllx0qhfrdila6bdij9lk74fhkm3vdj01zgq1ri6ffrv9lqrla";
    })
  ];

  nativeBuildInputs = [ asciidoc cmake perl ];
  buildInputs = [ zstd ];

  doCheck = true;
  checkInputs = [
    # test/run requires the compgen function which is available in
    # bashInteractive, but not bash.
    bashInteractive
  ] ++ lib.optional stdenv.isDarwin xcodebuild;

  checkPhase = ''
    runHook preCheck
    export HOME=$(mktemp -d)
    ctest --output-on-failure ${lib.optionalString stdenv.isDarwin ''
      -E '^(test.nocpp2|test.basedir|test.multi_arch)$'
    ''}
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
