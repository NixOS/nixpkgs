{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, boost
, zlib
, libX11
, libICE
, libSM
, libpng
, libjpeg
, libtiff
, SDL
}:

stdenv.mkDerivation rec {
  pname = "povray";
  version = "3.8.0-x.10064738";

  src = fetchFromGitHub {
    owner = "POV-Ray";
    repo = "povray";
    rev = "v${version}";
    sha256 = "0hy5a3q5092szk2x3s9lpn1zkszgq9bp15rxzdncxlvnanyzsasf";
  };

  nativeBuildInputs = [ automake autoconf ];
  buildInputs = [ boost zlib libX11 libICE libSM libpng libjpeg libtiff SDL ];

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

  meta = with lib; {
    homepage = "http://www.povray.org/";
    description = "Persistence of Vision Raytracer";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
