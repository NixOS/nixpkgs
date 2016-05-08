{ stdenv, fetchFromGitHub, librdf_raptor
, librdf_rasqal, glib, libxml2, pcre
, avahi, readline, ncurses, expat, autoreconfHook
, zlib, pkgconfig, which, perl, libuuid
, gmp, mpfr
, db_dir ? "/var/lib/4store" }:


stdenv.mkDerivation rec {
  name = "4store-${version}";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "garlik";
    repo = "4store";
    rev = "v${version}";
    sha256 = "1kzdfmwpzy64cgqlkcz5v4klwx99w0jk7afckyf7yqbqb4rydmpk";
  };

  buildInputs = [ librdf_raptor librdf_rasqal glib libxml2 pcre
    avahi readline ncurses expat zlib pkgconfig which perl libuuid
    gmp mpfr autoreconfHook ];

  # needed for ./autogen.sh
  prePatch = ''
    echo "${version}" > .version
  '';

  preConfigure =  ''
    sed -e 's@#! */bin/bash@#! ${stdenv.shell}@' -i configure
    find . -name Makefile -exec sed -e "s@/usr/local@$out@g" -i '{}' ';'
    
    rm src/utilities/4s-backend 
    sed -e 's@/var/lib/4store@${db_dir}@g' -i configure.ac src/utilities/*
    sed -e '/FS_STORE_ROOT/d' -i src/utilities/Makefile*
  '';

  meta = with stdenv.lib; {
    description = "SparQL query server (RDF storage)";
    homepage = http://4store.org/;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
