{ fetchurl, stdenv
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

  buildInputs = [ openssl libcap libnfnetlink libnetfilter_queue ];

  preConfigure = "cd user";

  meta = {
    homepage = "http://tcpcrypt.org/";
    description = "enable opportunistic encryption of all TCP traffic";

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.linux;
  };
}
