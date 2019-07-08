{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, stdenv }:

buildGoPackage rec {
  name = "aws-okta-${version}";
  version = "0.20.1";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "084lb9rp04vbpzmvsb2l92a4gp7c8g28x4xsagzwkqqpwi3fd15d";
  };

  goDeps = ./deps.nix;

  buildFlags = "--tags release";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 ];

  meta = with stdenv.lib; {
    inherit version;
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = [maintainers.imalsogreg];
    broken = stdenv.isDarwin;  # test with CoreFoundation 10.11
    platforms = platforms.all;
    homepage = https://github.com/segmentio/aws-okta;
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
