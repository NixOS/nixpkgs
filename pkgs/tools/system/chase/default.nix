{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libatomic_ops,
  boehmgc,
}:

stdenv.mkDerivation rec {
  pname = "chase";
  version = "0.5.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libatomic_ops
    boehmgc
  ];
  src = fetchurl {
    url = "mirror://debian/pool/main/c/chase/chase_${version}.orig.tar.gz";
    sha256 = "68d95c2d4dc45553b75790fcea4413b7204a2618dff148116ca9bdb0310d737f";
  };

  doCheck = true;
  makeFlags = [
    "-e"
    "LIBS=-lgc"
  ];

  meta = with lib; {
    description = "Follow a symlink and print out its target file";
    longDescription = ''
      A commandline program that chases symbolic filesystems links to the original file
    '';
    homepage = "https://qa.debian.org/developer.php?login=rotty%40debian.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.polyrod ];
    platforms = platforms.all;
    mainProgram = "chase";
  };
}
