{ stdenv, fetchFromGitHub, ncurses, parted, automake, autoconf, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.26";
  pname = "nwipe";
  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "072gg7hafq4vncpgm62yswshg6qgbi9mg2hl0p22c7if908p4vaa";
  };
  nativeBuildInputs = [ automake autoconf pkgconfig ];
  buildInputs = [ ncurses parted ];
  preConfigure = "sh init.sh || :";
  meta = with stdenv.lib; {
    description = "Securely erase disks";
    homepage = https://github.com/martijnvanbrummelen/nwipe;
    license = licenses.gpl2;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.linux;
  };
}
