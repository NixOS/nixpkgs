{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, stdenv, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "1.0.2";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "0rqkbhprz1j9b9bx3wvl5zi4p02q1qza905wkrvh42f9pbknajww";
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
