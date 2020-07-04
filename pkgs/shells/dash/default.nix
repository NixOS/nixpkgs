{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "dash-0.5.11";

  src = fetchurl {
    url = "http://gondor.apana.org.au/~herbert/dash/files/${name}.tar.gz";
    sha256 = "1jwilfsy249d3q7fagg1ga4bgc2bg1fzw63r2nan0m77bznsdnad";
  };

  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    homepage = "http://gondor.apana.org.au/~herbert/dash/";
    description = "A POSIX-compliant implementation of /bin/sh that aims to be as small as possible";
    platforms = platforms.unix;
    license = with licenses; [ bsd3 gpl2 ];
  };

  passthru = {
    shellPath = "/bin/dash";
  };
}
