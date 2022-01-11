{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oshka";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "k1LoW";
    repo = pname;
    rev = "v${version}";
    sha256 = "1niyy7yiynpwa2cvcj4r3305v8ca4324q512839y79s3izd6a1lf";
  };

  vendorSha256 = "08aj3nmj8angizkd3rbwbm7qzqxwrgfm1rka2x2a096z6mc3f4k4";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/k1LoW/oshka/version.Version=${version}"
  ];

  # Tests requires a running Docker instance
  doCheck = false;

  meta = with lib; {
    description = "Tool for extracting nested CI/CD supply chains and executing commands";
    homepage = "https://github.com/k1LoW/oshka";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
