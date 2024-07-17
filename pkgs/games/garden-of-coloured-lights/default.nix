{
  lib,
  stdenv,
  fetchurl,
  autoconf,
  automake,
  allegro,
}:

stdenv.mkDerivation rec {
  pname = "garden-of-coloured-lights";
  version = "1.0.9";

  nativeBuildInputs = [
    autoconf
    automake
  ];
  buildInputs = [ allegro ];

  prePatch = ''
    noInline='s/inline //'
    sed -e "$noInline" -i src/stuff.c
    sed -e "$noInline" -i src/stuff.h
  '';

  src = fetchurl {
    url = "mirror://sourceforge/garden/${version}/garden-${version}.tar.gz";
    sha256 = "1qsj4d7r22m5f9f5f6cyvam1y5q5pbqvy5058r7w0k4s48n77y6s";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: main.o:src/main.c:58: multiple definition of
  #     `eclass'; eclass.o:src/eclass.c:21: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = with lib; {
    description = "Old-school vertical shoot-em-up / bullet hell";
    mainProgram = "garden";
    homepage = "https://garden.sourceforge.net/drupal/";
    maintainers = with maintainers; [ ];
    license = licenses.gpl3;
  };

}
