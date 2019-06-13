{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
    pname = "dejsonlz4";
    version = "1.1";
    src = fetchFromGitHub {
      owner = "avih";
      repo = pname;
      rev = "v${version}";
      sha256 = "0ggs69qamaama5mid07mhp95m1x42wljdb953lrwfr7p8p6f8czh";
    };

    buildPhase = ''
      gcc -Wall -o dejsonlz4 src/dejsonlz4.c src/lz4.c
    '';

    installPhase = ''
      mkdir -p $out/bin/
      cp dejsonlz4 $out/bin/
    '';

    meta = with stdenv.lib; {
      description = "Decompress Mozilla Firefox bookmarks backup files";
      homepage = https://github.com/avih/dejsonlz4;
      license = licenses.bsd2;
      maintainers = with maintainers; [ mt-caret ];
      platforms = platforms.linux;
    };
  }
