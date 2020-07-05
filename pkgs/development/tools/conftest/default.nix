{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "conftest";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "conftest";
    rev = "v${version}";
    sha256 = "0d6n51p4b8jwkfqympwxkqxssgy462m5pgv5qvm6jy5pm566qa08";
  };

  vendorSha256 = "150fj2c9qll39wiqk41w0qms0sdqiacb2z015j38kg60r8f6i4lm";

  buildFlagsArray = ''
    -ldflags=
        -X main.version=${version}
  '';

  meta = with lib; {
    description = "Write tests against structured configuration data";
    inherit (src.meta) homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
    platforms = platforms.all;
  };
}
