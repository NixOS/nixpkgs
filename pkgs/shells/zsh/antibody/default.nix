{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "antibody";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "getantibody";
    repo = "antibody";
    rev = "v${version}";
    sha256 = "0ix2liy8h48s3n7ykr85ik03kwj45iqwhwn79ap8y21bar00gybs";
  };

  vendorSha256 = "072kxr68p9f58w2q98fjcn4wzd5szy5l5sz8sh4ssapljvic2lam";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "The fastest shell plugin manager";
    homepage = "https://github.com/getantibody/antibody";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 worldofpeace ];
  };
}