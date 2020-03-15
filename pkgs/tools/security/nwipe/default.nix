{ stdenv, fetchFromGitHub, ncurses, parted, automake, autoconf, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.27";
  pname = "nwipe";
  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "1rfqv5nxb20g7rfcmqaxwkbz5v294ak0kfsndncx3m4m1791fw04";
  };
  nativeBuildInputs = [ automake autoconf pkgconfig ];
  buildInputs = [ ncurses parted ];
  preConfigure = "sh init.sh || :";
  meta = with stdenv.lib; {
    description = "Securely erase disks";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = licenses.gpl2;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.linux;
  };
}
