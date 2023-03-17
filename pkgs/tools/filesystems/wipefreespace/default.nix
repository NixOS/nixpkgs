{ stdenv
, pkgs
, lib
, fetchurl
, e2fsprogs
, ntfs3g
, xfsprogs
, reiser4progs
, libaal
, jfsutils
, libuuid
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "wipefreespace";
  version = "2.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/wipefreespace/wipefreespace/${version}/wipefreespace-${version}.tar.gz";
    hash = "sha256-wymV6G4Et5TCoIztZfdb3xuzjdBHFyB5OmI4EcsJKwQ=";
  };

  nativeBuildInputs = [
    texinfo
  ];

  # missed: Reiser3 FAT12/16/32 MinixFS HFS+ OCFS
  buildInputs = [
    e2fsprogs
    ntfs3g
    xfsprogs
    reiser4progs
    libaal
    jfsutils
    libuuid
  ];

  strictDeps = true;

  preConfigure = ''
    export PATH=$PATH:${xfsprogs}/bin
    export CFLAGS=-I${jfsutils}/include
    export LDFLAGS="-L${jfsutils}/lib -L${reiser4progs}/lib"
  '';

  meta = with lib; {
    description = "A program which will securely wipe the free space";
    homepage = "https://wipefreespace.sourceforge.io";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ catap ];
  };
}
