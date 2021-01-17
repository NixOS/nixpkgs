{ lib, stdenv, fetchFromGitHub, ncurses, parted, automake, autoconf, pkg-config }:

stdenv.mkDerivation rec {
  version = "0.28";
  pname = "nwipe";
  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "1aw905lmn1vm6klqn3q7445dwmwbjhcmwnkygpq9rddacgig1gdx";
  };
  nativeBuildInputs = [ automake autoconf pkg-config ];
  buildInputs = [ ncurses parted ];
  preConfigure = "sh init.sh || :";
  meta = with lib; {
    description = "Securely erase disks";
    homepage = "https://github.com/martijnvanbrummelen/nwipe";
    license = licenses.gpl2;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.linux;
  };
}
