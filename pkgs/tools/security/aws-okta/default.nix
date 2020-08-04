{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, stdenv, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "1.0.4";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "0a7xccnv0x0a6sydif0rvkdbw4jy9gjijajip1ac6m70l20dhl1v";
  };

  buildFlags = [ "--tags" "release" ];

  buildFlagsArray = [ "-ldflags=-X main.Version=${version}" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1  libiconv ];

  meta = with stdenv.lib; {
    inherit version;
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = [maintainers.imalsogreg];
    platforms = platforms.all;
    homepage = "https://github.com/segmentio/aws-okta";
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
