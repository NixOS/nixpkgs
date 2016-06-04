{stdenv, fetchgit, autoconf, automake, boost, zlib, libpng, libjpeg, libtiff}:

stdenv.mkDerivation {
  name = "povray-3.7";

  src = fetchgit {
    url = "https://github.com/POV-Ray/povray.git";
    rev = "39ce8a24e50651904010dda15872d63be15d7c37";
    sha256 = "1nbs9vwf6fn3jkm0myfnbn7nrc17q8ppzmr4h7kj49nr0710ifw0";
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
