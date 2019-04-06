{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "statik-unstable-${version}";
  version = "2018-11-28";
  goPackagePath = "github.com/rakyll/statik";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "rakyll";
    repo = "statik";
    rev = "79258177a57a85a8ab2eca7ce0936aad80307f4e";
    sha256 = "14wqh38a7dhm2jgr1lsl2wdvjmkgdapzl2z4a1vl7ncv3x43gkg5";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rakyll/statik";
    description = "Embed files into a Go executable ";
    license = licenses.asl20;
    maintainers = with maintainers; [ chiiruno ];
    platforms = platforms.all;
  };
}
