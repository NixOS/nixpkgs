{ stdenv, fetchFromGitHub, asciidoc-full, gperf, perl, autoreconfHook, zlib, makeWrapper }:

let ccache = stdenv.mkDerivation rec {
  pname = "ccache";
  version = "3.7.11";

  src = fetchFromGitHub {
    owner = "ccache";
    repo = "ccache";
    rev = "v${version}";
    sha256 = "03c6riz4vb0jipplk69c1j8arjjrjn676kglsrzqf8cidrh8j91c";
  };

  nativeBuildInputs = [ asciidoc-full autoreconfHook gperf perl ];

  buildInputs = [ zlib ];

  outputs = [ "out" "man" ];

  doCheck = !stdenv.isDarwin;

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
    homepage = "https://ccache.dev/";
    downloadPage = "https://ccache.dev/download.html";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
};
in ccache
