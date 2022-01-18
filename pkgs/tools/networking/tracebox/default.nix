{ lib, stdenv, fetchFromGitHub, autoreconfHook, libcrafter, libpcap, lua }:

stdenv.mkDerivation rec {
  pname = "tracebox";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tracebox";
    repo = "tracebox";
    rev = "v${version}";
    hash = "sha256-2r503xEF3/F9QQCEaSnd4Hw/RbbAhVj9C0SVZepVrT8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libcrafter lua ];

  configureFlags = [ "--with-lua=yes" ];

  NIX_LDFLAGS = "${libpcap}/lib/libpcap.so ${libcrafter}/lib/libcrafter.so";

  preAutoreconf = ''
    substituteInPlace Makefile.am --replace "noinst" ""
    sed '/noinst/d' -i configure.ac
    sed '/libcrafter/d' -i src/tracebox/Makefile.am
  '';

  meta = with lib; {
    homepage = "http://www.tracebox.org/";
    description = "A middlebox detection tool";
    license = lib.licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
