{ stdenv, fetchurl, pam, xmlsec }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;
in
stdenv.mkDerivation rec {
  name = "oath-toolkit-2.6.1";

  src = fetchurl {
    url = "mirror://savannah/oath-toolkit/${name}.tar.gz";
    sha256 = "0ybg0gnddmhxga0jwdipyz8jv5mxs0kiiflhvzffl9mw0wcq6mww";
  };

  
  buildInputs = [ securityDependency ];

  meta = {
    homepage = http://www.nongnu.org/oath-toolkit/;
    description = "Components for building one-time password authentication systems";
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
