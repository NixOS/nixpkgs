{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0v9cya3x0v1fqpqswayskmm0xzbvfn4hbhz2k6b3j6fzcq2dnzj3";
  };

  vendorSha256 = "1nxl00f8dbdiykwa54qm9r0cv16zcab880ay8mlmxba7srysvb1y";

  doCheck = false;

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
