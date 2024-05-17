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

stdenv.mkDerivation (finalAttrs: {
  pname = "povray";
  version = "3.8.0-beta.2";

  src = fetchFromGitHub {
    owner = "POV-Ray";
    repo = "povray";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-BsWalXzEnymiRbBfE/gsNyWgAqzbxEzO/EQiJpbwoKs=";
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
    mainProgram = "povray";
  };
})
