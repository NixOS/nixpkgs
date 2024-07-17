{
  lib,
  stdenv,
  fetchurl,
  gettext,
  guile,
  libuuid,
  parted,
}:

stdenv.mkDerivation rec {
  pname = "gnufdisk";
  version = "2.0.0a1";

  src = fetchurl {
    url = "mirror://gnu/fdisk/gnufdisk-${version}.tar.gz";
    hash = "sha256-yWPYTf8RxBIQ//mUdC6fkKct/csEgbzEtTAiPtNRH7U=";
  };

  postPatch = ''
    sed -i "s/gnufdisk-common.h .*/\n/g" backend/configure
  '';

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    guile
  ];

  buildInputs = [
    guile
    libuuid
    parted
  ];

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    "-I../common/include"
    "-I../debug/include"
    "-I../exception/include"
  ];

  doCheck = true;

  meta = {
    description = "A command-line disk partitioning tool";
    longDescription = ''
      GNU fdisk provides a GNU version of the common disk partitioning tool
      fdisk.  fdisk is used for the creation and manipulation of disk partition
      tables, and it understands a variety of different formats.
    '';
    homepage = "https://www.gnu.org/software/fdisk/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "gnufdisk";
    maintainers = [ lib.maintainers.wegank ];
    platforms = lib.platforms.linux;
  };
}
