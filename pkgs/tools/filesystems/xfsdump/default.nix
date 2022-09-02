{ lib
, stdenv
, fetchurl
, attr
, gettext
, autoconf
, automake
, ncurses
, libtool
, libuuid
, libxfs
}:

stdenv.mkDerivation rec {
  pname = "xfsdump";
  version = "3.1.10";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/fs/xfs/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-mqt6U6oFzUbtyXJp6/FFaqsrYKuMH/+q+KpJLwtfZRc=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];
  buildInputs = [
    attr
    libuuid
    libxfs
    ncurses
  ];

  # fixes build against xfsprogs >= 5.18
  # taken from https://lore.kernel.org/linux-xfs/20220203174540.GT8313@magnolia/
  # should be included upsteam next release
  patches = [ ./remove-dmapapi.patch ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace "cp include/install-sh ." "cp -f include/install-sh ."
  '';

  # Conifigure scripts don't check PATH, see xfstests derviation
  preConfigure = ''
    export MAKE=$(type -P make)
    export MSGFMT=$(type -P msgfmt)
    export MSGMERGE=$(type -P msgmerge)
    export XGETTEXT=$(type -P xgettext)

    make configure
    patchShebangs ./install-sh
  '';

  meta = with lib; {
    description = "XFS filesystem incremental dump utility";
    homepage = "https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/tree/doc/CHANGES";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.lunik1 ];
    platforms = platforms.linux;
  };
}
