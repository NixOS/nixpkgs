{ fetchurl, stdenv, autoconf, automake, libtool, autoreconfHook
, openssl, libcap, libnfnetlink, libnetfilter_queue
}:

stdenv.mkDerivation rec {
  name = "tcpcrypt-0.3-rc1";

  src = fetchurl {
    url = "https://github.com/scslab/tcpcrypt/archive/v0.3-rc1.tar.gz";
    sha256 = "1k79xfip95kyy91b6rnmsgl66g52zrnm92ln4jms133nm2k9s4sa";
    name = "${name}.tar.gz";
  };

  dontStrip = true;

  buildInputs = [ autoreconfHook autoconf automake libtool openssl libcap libnfnetlink libnetfilter_queue ];

  postUnpack = ''
    mkdir $sourceRoot/m4
  '';

  meta = {
    homepage = "http://tcpcrypt.org/";
    description = "enable opportunistic encryption of all TCP traffic";
    platforms = stdenv.lib.platforms.linux;
  };
}
