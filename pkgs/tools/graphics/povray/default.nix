{ stdenv, fetchFromGitHub, autoconf, automake, boost
, zlib, libpng, libjpeg, libtiff
}:

stdenv.mkDerivation rec {
  name = "povray-${version}";
  version = "3.7.0.4";

  src = fetchFromGitHub {
    owner = "POV-Ray";
    repo = "povray";
    rev = "v${version}";
    sha256 = "1wkwb43w5r9pa79yazy4w4s8n6g280igag97hgl7dyi289q39n0q";
  };


  buildInputs = [ autoconf automake boost zlib libpng libjpeg libtiff ];

  # the installPhase wants to put files into $HOME. I let it put the files
  # to $TMPDIR, so they don't get into the $out
  postPatch = '' cd unix
                 ./prebuild.sh
                 cd ..
                 sed -i -e 's/^povconfuser.*/povconfuser=$(TMPDIR)\/povray/' Makefile.{am,in}
                 sed -i -e 's/^povuser.*/povuser=$(TMPDIR)\/.povray/' Makefile.{am,in}
                 sed -i -e 's/^povowner.*/povowner=nobody/' Makefile.{am,in}
                 sed -i -e 's/^povgroup.*/povgroup=nogroup/' Makefile.{am,in}
               '';

  configureFlags = [ "COMPILED_BY='nix'" "--with-boost-thread=boost_thread" ];

  enableParallelBuilding = true;
  
  preInstall = ''
    mkdir "$TMP/bin"
    for i in chown chgrp; do
      echo '#!/bin/sh' >> "$TMP/bin/$i"
      chmod +x "$TMP/bin/$i"
      PATH="$TMP/bin:$PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.povray.org/;
    description = "Persistence of Vision Raytracer";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
