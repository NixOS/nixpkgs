{ stdenv, lib, fetchFromGitHub, help2man, xrandr }:

stdenv.mkDerivation rec {
  pname = "mons";
  version = "20200107";

  src = fetchFromGitHub {
    owner = "Ventto";
    repo = pname;
    rev = "0c9e1a1dddff23a0525ed8e4ec9af8f9dd8cad4c";
    sha256 = "02c41mw3g1mgl91hhpz1n45iaqk9s7mdk1ixm8yv6sv17hy8rr4w";
    fetchSubmodules = true;
  };

  # PR: https://github.com/Ventto/mons/pull/36
  preConfigure = ''sed -i 's/usr\///' Makefile'';
  
  nativeBuildInputs = [ help2man ];
  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "POSIX Shell script to quickly manage 2-monitors display";
    homepage = "https://github.com/Ventto/mons.git";
    license = licenses.mit;
    maintainers = [ maintainers.mschneider ];
  };
}
