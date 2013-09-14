{ fetchurl, stdenv, autoconf, automake, libtool
, openssl, libcap, libnfnetlink, libnetfilter_queue
}:

let
  rev = "0e07772316061ad67b8770e7d98d5dd099c9c7c7";
in
stdenv.mkDerivation rec {
  name = "tcpcrypt-2011.07.22";

  src = fetchurl {
    url = "https://github.com/sorbo/tcpcrypt/archive/${rev}.tar.gz";
    sha256 = "1f1f1iawlvipnccwh31fxnb8yam1fgh36m0qcbc29qk1ggwrfnkk";
    name = "${name}.tar.gz";
  };

  dontStrip = true;

  buildInputs = [ autoconf automake libtool openssl libcap libnfnetlink libnetfilter_queue ];

  patches = [ ./0001-Run-tcpcryptd-under-uid-93-instead-of-666.patch ];

  preConfigure = "cd user; autoreconf -i";

  meta = {
    homepage = "http://tcpcrypt.org/";
    description = "enable opportunistic encryption of all TCP traffic";

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
