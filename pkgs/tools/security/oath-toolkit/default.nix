{ stdenv, fetchurl, pam, xmlsec }:

let
  securityDependency =
    if stdenv.isDarwin then xmlsec
    else pam;
in
stdenv.mkDerivation rec {
  name = "oath-toolkit-2.6.2";

  src = fetchurl {
    url = "mirror://savannah/oath-toolkit/${name}.tar.gz";
    sha256 = "182ah8vfbg0yhv6mh1b6ap944d0na6x7lpfkwkmzb6jl9gx4cd5h";
  };


  buildInputs = [ securityDependency ];

  meta = {
    homepage = http://www.nongnu.org/oath-toolkit/;
    description = "Components for building one-time password authentication systems";
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
