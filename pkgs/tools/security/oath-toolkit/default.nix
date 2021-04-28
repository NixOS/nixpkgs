{ lib, stdenv, fetchurl, pam, xmlsec }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;

in stdenv.mkDerivation rec {
  pname = "oath-toolkit";
  version = "2.6.6";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0v4lrgip08b8xlivsfn3mwql3nv8hmcpzrn6pi3xp88vqwav6s7x";
  };

  buildInputs = [ securityDependency ];

  meta = with lib; {
    description = "Components for building one-time password authentication systems";
    homepage = "https://www.nongnu.org/oath-toolkit/";
    maintainers = with maintainers; [ schnusch ];
    platforms = with platforms; linux ++ darwin;
  };
}
