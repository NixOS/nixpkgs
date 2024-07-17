{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "lksctp-tools";
  version = "1.0.17";

  src = fetchurl {
    url = "mirror://sourceforge/lksctp/lksctp-tools-${version}.tar.gz";
    sha256 = "05da6c2v3acc18ndvmkrag6x5lf914b7s0xkkr6wkvrbvd621sqs";
  };

  meta = with lib; {
    description = "Linux Kernel Stream Control Transmission Protocol Tools";
    homepage = "https://lksctp.sourceforge.net/";
    license = with licenses; [
      gpl2
      lgpl21
    ]; # library is lgpl21
    platforms = platforms.linux;
  };
}
