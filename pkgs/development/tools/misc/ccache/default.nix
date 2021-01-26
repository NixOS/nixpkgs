{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, binutils
, asciidoc
, cmake
, perl
, zstd
, xcodebuild
, makeWrapper
}:

let ccache = stdenv.mkDerivation rec {
  pname = "ccache";
  version = "4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1az11q3wmr8wc7alx9l70wq9am41cm0y17g5gsaqmahws3dxfi8m";
  };

  patches = lib.optional stdenv.isDarwin (substituteAll {
    src = ./force-objdump-on-darwin.patch;
    objdump = "${binutils.bintools}/bin/objdump";
  });

  nativeBuildInputs = [ asciidoc cmake perl ];

  buildInputs = [ zstd ];

  outputs = [ "out" "man" ];

  doCheck = true;
  checkInputs = lib.optional stdenv.isDarwin xcodebuild;
  checkPhase = ''
    export HOME=$(mktemp -d)
    ctest --output-on-failure ${lib.optionalString stdenv.isDarwin ''
      -E '^(test.nocpp2|test.modules)$'
    ''}
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
    maintainers = with maintainers; [ metadark r-burns ];
    platforms = platforms.unix;
  };
};
in ccache
