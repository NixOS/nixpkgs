{ stdenv, fetchFromGitHub, openssl, trousers, autoreconfHook, libtool, bison, flex }:

stdenv.mkDerivation rec {
  name = "opencryptoki-${version}";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "opencryptoki";
    repo = "opencryptoki";
    rev = "v${version}";
    sha256 = "1m618pjfzw18irmh6i4pfq1gvcxgyfh9ikjn33nrdj55v2l27g31";
  };

  nativeBuildInputs = [ autoreconfHook libtool bison flex ];
  buildInputs = [ openssl trousers ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace "usermod" "true" \
      --replace "groupadd" "true" \
      --replace "chmod" "true" \
      --replace "chgrp" "true"
    substituteInPlace usr/lib/Makefile.am --replace "DESTDIR" "out"
  '';

  configureFlags = [
    "--prefix=$(out)"
    "--disable-ccatok"
    "--disable-icatok"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "PKCS#11 implementation for Linux";
    homepage    = https://github.com/opencryptoki/opencryptoki;
    license     = licenses.cpl10;
    maintainers = [ maintainers.tstrobel ];
    platforms   = platforms.unix;
  };
}
