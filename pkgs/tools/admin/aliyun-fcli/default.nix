{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "fcli";
  version = "1.0.4";
  goPackagePath = "github.com/aliyun/${pname}";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "aliyun";
    repo = pname;
    sha256 = "sha256:1v5la0yrpqlrsfj125wh61af8gs5m03djbfjk9k9qq14hfi956vr";
  };

  # see updatedeps.sh for how to generate this file
  goDeps = ./deps.nix;

  patches = [./uuiddep.patch];

  meta = with lib; {
    description = "Alibaba Cloud Function Compute command line tools.";
    homepage = "https://github.com/aliyun/fcli";
    license = licenses.asl20;
    maintainers = with maintainers; [ ornxka ];
  };
}
