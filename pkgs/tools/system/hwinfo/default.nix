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
<<<<<<< HEAD
  version = "23.2";
=======
  version = "22.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-YAhsnE1DJ5UlYAuhDxS/5IpfIJB6DrhCT3E0YiKENjU=";
=======
    hash = "sha256-Z/brrDrT2J4RAS+pm1xaBqWO7PG6cAVgRpH3G6Nn39E=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
