{ lib, stdenv, perl, fetchurl }:

stdenv.mkDerivation rec {
  pname = "ioport";
  version = "1.2";

  src = fetchurl {
    url = "https://people.redhat.com/rjones/ioport/files/ioport-${version}.tar.gz";
    sha256 = "1h4d5g78y7kla0zl25jgyrk43wy3m3bygqg0blki357bc55irb3z";
  };

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Direct access to I/O ports from the command line";
    homepage = "https://people.redhat.com/rjones/ioport/";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.cleverca22 ];
  };
}
