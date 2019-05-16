{ stdenv, fetchFromGitHub, autoconf, automake, boost
, zlib, libpng, libjpeg, libtiff, xlibsWrapper, SDL
}:

stdenv.mkDerivation rec {
  name = "povray-${version}";
  version = "3.7.0.8";

  src = fetchFromGitHub {
    owner = "POV-Ray";
    repo = "povray";
    rev = "v${version}";
    sha256 = "1q114n4m3r7qy3yn954fq7p46rg7ypdax5fazxr9yj1jklf1lh6z";
  };


  buildInputs = [ autoconf automake boost zlib libpng libjpeg libtiff xlibsWrapper SDL ];

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
      echo '#!${stdenv.shell}' >> "$TMP/bin/$i"
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
