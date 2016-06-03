{ stdenv, fetchgit
, autoconf
, automake
, libevent
, libtool
, pkgconfig
, openssl
}:

stdenv.mkDerivation {
  name = "tlsdate-0.0.12";

  src = fetchgit {
    url = https://github.com/ioerror/tlsdate;
    rev = "fd04f48ed60eb773c8e34d27ef2ee12ee7559a41";
    sha256 = "0naxlsanpgixj509z4mbzl41r2nn5wi6q2lp10a7xgcmcb4cgnbf";
  };

  buildInputs = [
    autoconf
    automake
    libevent
    libtool
    pkgconfig
    openssl
  ];

  preConfigure = ''
    export COMPILE_DATE=0
    ./autogen.sh
  '';

  doCheck = true;

  meta = {
    description = "Secure parasitic rdate replacement";
    homepage = https://github.com/ioerror/tlsdate;
    maintainers = [ stdenv.lib.maintainers.tv ];
    platforms = stdenv.lib.platforms.allBut [ "darwin" ];
  };
}
