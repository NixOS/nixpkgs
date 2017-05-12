{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "dobi-${version}";
  version = "v0.8";
  rev = "1b5f0c4c7304b4b279581eac6d7f017a9a7d4f4e";

  buildFlagsArray = let t = "${goPackagePath}/cmd"; in ''
    -ldflags=
       -X ${t}.gitsha=${rev}
       -X ${t}.buildDate=unknown
  '';
  goPackagePath = "github.com/dnephin/dobi";
  excludedPackages = "docs";

  src = fetchFromGitHub {
    inherit rev;
    owner = "dnephin";
    repo = "dobi";
    sha256 = "0qhmbb172mkj4sifiapgscqq71fw3ccbh9ybyf7ihkysf94smkgk";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A build automation tool for Docker applications";
    homepage = https://dnephin.github.io/dobi/;
    maintainers = with stdenv.lib.maintainers; [ vdemeester ];
    license = stdenv.lib.licenses.asl20;
  };
}
