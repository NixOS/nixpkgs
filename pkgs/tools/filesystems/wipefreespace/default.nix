{ stdenv
, lib
, fetchurl
, e2fsprogs
, ntfs3g
, xfsprogs
, reiserfsprogs
, reiser4progs
, jfsutils
, libuuid
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "wipefreespace";
  version = "2.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/wipefreespace/wipefreespace/${version}/wipefreespace-${version}.tar.gz";
    sha256 = "sha256-wymV6G4Et5TCoIztZfdb3xuzjdBHFyB5OmI4EcsJKwQ=";
  };

  # missed: FAT12/16/32 MinixFS HFS+ OCFS
  buildInputs = [
    e2fsprogs
    ntfs3g
    xfsprogs
    reiserfsprogs
    reiser4progs
    jfsutils
    libuuid
  ];

  nativeBuildInputs = [
    texinfo
  ];

  meta = with lib; {
    description = "A program which will securely wipe the free space";
    homepage = "https://wipefreespace.sourceforge.io";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ catap ];
  };
}
