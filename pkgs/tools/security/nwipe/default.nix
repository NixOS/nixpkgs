{ stdenv, fetchFromGitHub, ncurses, parted, automake, autoconf, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.24";
  name = "nwipe-${version}";
  src = fetchFromGitHub {
    owner = "martijnvanbrummelen";
    repo = "nwipe";
    rev = "v${version}";
    sha256 = "0zminjngz98b4jl1ii6ssa7pkmf4xw6mmk8apxz3xr68cps12ls0";
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
