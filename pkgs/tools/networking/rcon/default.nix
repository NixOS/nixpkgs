{ stdenv, fetchFromGitHub, cmake, pkg-config, glib, libbsd, check, pcre }:

stdenv.mkDerivation rec {
  pname = "rcon";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "n0la";
    repo = "rcon";
    rev = version;
    sha256 = "1jsnmsm2qkiv8dan1yncx0qp6zfkcbyvf81c7xwpv6r499ijw1nb";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    glib
    libbsd
    check
    pcre
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/n0la/rcon";
    description = "Source RCON client for command line";
    maintainers = with maintainers; [ f4814n ];
    platforms = with platforms; linux ++ darwin;
    license = licenses.bsd2;
  };
}
