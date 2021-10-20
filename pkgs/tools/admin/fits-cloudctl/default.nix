{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "09v5fgqf4c2d6k2z638g29mcsmdisg3zfq1g7330wsd7yaxv9m23";
  };

  vendorSha256 = "1rdqih04mlp33m69y9zxm4llx8cafwqhjhfxw873s8b35j0xz2m5";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
