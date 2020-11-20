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
, xcodebuild
, makeWrapper
}:

let ccache = stdenv.mkDerivation rec {
  pname = "ccache";
  version = "4.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1frcplrv61m2iwc6jwycpbcz1101xl6s4sh8p87prdj98l60lyrx";
  };

  # TODO: Remove patches from upstream in next release
  patches = [
    # Fix badly named man page filename
    (fetchpatch {
      url = "https://github.com/ccache/ccache/commit/223e706fb24ce86eb0ad86079a97e6f345b9ef40.patch";
      sha256 = "1h7amp3ka45a79zwlxh8qnzx6n371gnfpfgijcqljps7skhl5gjg";
    })
    # Build and install man page by default
    (fetchpatch {
      url = "https://github.com/ccache/ccache/commit/294ff2face26448afa68e3ef7b68bf4898d6dc77.patch";
      sha256 = "0rx69qn41bgksc4m3p59nk5d6rz72rwnfska9mh5j62pzfm8axja";
    })
    # Fixes use of undeclared identifier 'CLONE_NOOWNERCOPY' on darwin
    (fetchpatch {
      url = "https://github.com/ccache/ccache/commit/411c010c3a5ee690cd42b23ffcf026ae009e2897.patch";
      sha256 = "062s424d0d0psp6wjhmfnfn1s5dsrz403hdid5drm6l2san0jhq0";
    })
  ] ++ lib.optional stdenv.isDarwin (substituteAll {
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
              --run ${stdenv.lib.escapeShellArg extraConfig} \
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

  meta = with stdenv.lib; {
    description = "Compiler cache for fast recompilation of C/C++ code";
    homepage = "https://ccache.dev";
    downloadPage = "https://ccache.dev/download.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark r-burns ];
    platforms = platforms.unix;
  };
};
in ccache
