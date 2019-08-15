{ stdenv, fetchFromGitHub, ncurses, parted, automake, autoconf, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.25";
  pname = "nwipe";
  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "1hx041arw82k814g9r8dqsfi736mj5nlzp2zpi8n2qfqfc1q8nir";
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
