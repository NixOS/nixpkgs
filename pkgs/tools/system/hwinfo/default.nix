{ lib
, stdenv
, fetchFromGitHub
, flex
, libuuid
, libx86emu
, perl
}:

stdenv.mkDerivation rec {
  pname = "hwinfo";
  version = "22.2";

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = version;
    hash = "sha256-Z/brrDrT2J4RAS+pm1xaBqWO7PG6cAVgRpH3G6Nn39E=";
  };

  nativeBuildInputs = [
    flex
  ];

  buildInputs = [
    libuuid
    libx86emu
    perl
  ];

  postPatch = ''
    # VERSION and changelog are usually generated using Git
    # unless HWINFO_VERSION is defined (see Makefile)
    export HWINFO_VERSION="${version}"
    sed -i 's|^\(TARGETS\s*=.*\)\<changelog\>\(.*\)$|\1\2|g' Makefile

    substituteInPlace Makefile --replace "/sbin" "/bin" --replace "/usr/" "/"
    substituteInPlace src/isdn/cdb/Makefile --replace "lex isdn_cdb.lex" "flex isdn_cdb.lex"
    substituteInPlace hwinfo.pc.in --replace "prefix=/usr" "prefix=$out"
  '';

  makeFlags = [
    "LIBDIR=/lib"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  meta = with lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2Only;
    homepage = "https://github.com/openSUSE/hwinfo";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
