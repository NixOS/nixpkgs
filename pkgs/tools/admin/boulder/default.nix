{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec{
  pname = "boulder";
  version = "release-2022-04-04";

  src = fetchFromGitHub {
    owner = "letsencrypt";
    repo = "boulder";
    rev = version;
    sha256 = "sha256-4u9aX3AiuVBL7iFsxybn4jvTJyfz13RAxGpsd7Z+UYo=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" ];

  checkFlags = [ "-short" ];

  meta = {
    homepage = "https://github.com/letsencrypt/boulder";
    description = "An ACME-based CA, written in Go";
    license = [ lib.licenses.mpl20 ];
    maintainers = [ ];
  };
}
