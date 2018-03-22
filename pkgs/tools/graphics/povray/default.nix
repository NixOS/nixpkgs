{ stdenv, fetchFromGitHub, autoconf, automake, boost
, zlib, libpng, libjpeg, libtiff, x11, SDL
}:

stdenv.mkDerivation rec {
  name = "povray-${version}";
  version = "3.7.0.7";

  src = fetchFromGitHub {
    owner = "POV-Ray";
    repo = "povray";
    rev = "v${version}";
    sha256 = "0gqbc4ycjfqpnixzzqxlygmargk6sm77b0k3xzff9dxdrak3xng7";
  };


  buildInputs = [ autoconf automake boost zlib libpng libjpeg libtiff x11 SDL ];

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

  configureFlags = [ "COMPILED_BY='nix'" "--with-boost-thread=boost_thread" "--with-x" ];

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
