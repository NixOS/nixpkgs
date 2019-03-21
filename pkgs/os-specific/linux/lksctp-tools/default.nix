{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lksctp-tools-1.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/lksctp/${name}.tar.gz";
    sha256 = "05da6c2v3acc18ndvmkrag6x5lf914b7s0xkkr6wkvrbvd621sqs";
  };

  meta = with stdenv.lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools.";
    homepage = http://lksctp.sourceforge.net/;
    license = with licenses; [ gpl2 lgpl21 ]; # library is lgpl21
    platforms = platforms.linux;
  };
}
