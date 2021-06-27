{ lib, stdenv, fetchurl, pam, xmlsec }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation rec {
  pname = "oath-toolkit";
  version = "2.6.7";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1aa620k05lsw3l3slkp2mzma40q3p9wginspn9zk8digiz7dzv9n";
  };

  buildInputs = [ securityDependency ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Components for building one-time password authentication systems";
    homepage = "https://www.nongnu.org/oath-toolkit/";
    maintainers = with maintainers; [ schnusch ];
    platforms = with platforms; linux ++ darwin;
  };
}
