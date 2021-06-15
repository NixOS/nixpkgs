{ lib, stdenv, fetchFromGitHub, libx86emu, flex, perl, libuuid }:

stdenv.mkDerivation rec {
  pname = "hwinfo";
  version = "21.74";

  src = fetchFromGitHub {
    owner = "opensuse";
    repo = "hwinfo";
    rev = version;
    sha256 = "sha256-pPL/RYL8eVPuX71kT64p/ZkUE4uVFALMVj8mWZM3NuU=";
  };

  postPatch = ''
    # VERSION and changelog are usually generated using Git
    # unless HWINFO_VERSION is defined (see Makefile)
    export HWINFO_VERSION="${version}"
    sed -i 's|^\(TARGETS\s*=.*\)\<changelog\>\(.*\)$|\1\2|g' Makefile

    substituteInPlace Makefile --replace "/sbin" "/bin" --replace "/usr/" "/"
    substituteInPlace src/isdn/cdb/Makefile --replace "lex isdn_cdb.lex" "flex isdn_cdb.lex"
    substituteInPlace hwinfo.pc.in --replace "prefix=/usr" "prefix=$out"
  '';

  nativeBuildInputs = [ flex ];
  buildInputs = [ libx86emu perl libuuid ];

  makeFlags = [ "LIBDIR=/lib" ];
  #enableParallelBuilding = true;

  installFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Hardware detection tool from openSUSE";
    license = licenses.gpl2Only;
    homepage = "https://github.com/openSUSE/hwinfo";
    maintainers = with maintainers; [ bobvanderlinden ];
    platforms = platforms.linux;
  };
}
