{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "inadyn-1.96.3";

  src = fetchurl {
    url = "mirror://sourceforge/inadyn/${name}.tar.gz";
    sha256 = "0zyqhq1y3wrns4bxlmbkgs5bl5g7wrvkc7xc4fk50papygyc4q51";
  };

  meta = {
    homepage = http://inadyn.sourceforge.net/;
    description = "Free dynamic DNS client";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
