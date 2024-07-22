{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "ogen";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ogen-go";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZjeA9ogyMsoByBzdvikut93JT6s+8m1AyyPFtwEcYwY="
  };

  vendorHash = "sha256-EL8FcAnDMekHBIDRdGqQO4JNESjGC7MQ5aUcDkRqrbg=";

  subPackages = ["cmd/ogen"];

  meta = with lib; {
    description = "OpenAPI v3 code generator for go";
    license = licenses.asl20;
    homepage = "https://github.com/ogen-go/ogen";
  };
}
