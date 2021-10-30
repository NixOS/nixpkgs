{ buildGoPackage, fetchFromGitHub, libusb1, pkg-config, lib, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "1.0.11";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "sha256-1cprKpIFgM3+lUEHNvda34nJTH4Ch3LtTRq/Dp6QBQ8=";
  };

  tags = [ "release" ];

  ldflags = [ "-X main.Version=${version}" ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1  libiconv ];

  meta = with lib; {
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = with maintainers; [imalsogreg Chili-Man];
    homepage = "https://github.com/segmentio/aws-okta";
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
