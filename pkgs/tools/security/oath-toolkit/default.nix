{ stdenv, fetchurl, pam }:

stdenv.mkDerivation rec {
  name = "oath-toolkit-2.4.1";

  src = fetchurl {
    url = "mirror://savannah/oath-toolkit/${name}.tar.gz";
    sha256 = "094vbq66sn5f2dsy14hajpsfdnaivjxf70xzs91nrsq0q75l5ylv";
  };

  buildInputs = [ pam ];

  meta = {
    homepage = http://www.nongnu.org/oath-toolkit/;
    description = "Components for building one-time password authentication systems";
    platforms = stdenv.lib.platforms.linux;
  };
}
