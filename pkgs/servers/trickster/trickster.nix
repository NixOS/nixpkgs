{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "trickster";
  version = "0.1.10";

  goPackagePath = "github.com/Comcast/trickster";

  goDeps = ./trickster_deps.nix;

  src = fetchFromGitHub {
    owner = "Comcast";
    repo = pname;
    rev = "v${version}";
    sha256 = "12z71rf03g2x8r7cgns0n4n46r0gjsfyig6z9r5xrn9kfghabfi8";
  };

  doCheck = true;

  meta = with lib; {
    description = "Reverse proxy cache for the Prometheus HTTP APIv1";
    homepage = "https://github.com/Comcast/trickster";
    license = licenses.asl20;
    maintainers = with maintainers; [ _1000101 ];
  };
}
