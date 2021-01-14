{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, lib, stdenv, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "1.0.8";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "14bg9rdfxkpw00phc8faz4ghiyb0j7a9qai74lidrzplzl139bzf";
  };

  buildFlags = [ "--tags" "release" ];

  buildFlagsArray = [ "-ldflags=-X main.Version=${version}" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1  libiconv ];

  meta = with lib; {
    inherit version;
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = with maintainers; [imalsogreg Chili-Man];
    homepage = "https://github.com/segmentio/aws-okta";
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
