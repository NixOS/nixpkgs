{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, stdenv, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "1.0.5";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "1xd73j6rbbdrnzj0m8dqwcvn62cz6bygdpxsx8g7117qbdzz2lj1";
  };

  buildFlags = [ "--tags" "release" ];

  buildFlagsArray = [ "-ldflags=-X main.Version=${version}" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1  libiconv ];

  meta = with stdenv.lib; {
    inherit version;
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = with maintainers; [imalsogreg Chili-Man];
    homepage = "https://github.com/segmentio/aws-okta";
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
