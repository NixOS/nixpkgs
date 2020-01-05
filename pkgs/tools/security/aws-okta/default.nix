{ buildGoPackage, fetchFromGitHub, libusb1, pkgconfig, stdenv, libiconv }:

buildGoPackage rec {
  pname = "aws-okta";
  version = "0.26.3";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "0n6xm3yv0lxfapchzfrqi05hk918n4lh1hcp7gq7hybam93rld96";
  };

  goDeps = ./deps.nix;

  buildFlags = [ "--tags" "release" ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1  libiconv ];

  meta = with stdenv.lib; {
    inherit version;
    description = "aws-vault like tool for Okta authentication";
    license = licenses.mit;
    maintainers = [maintainers.imalsogreg];
    platforms = platforms.all;
    homepage = https://github.com/segmentio/aws-okta;
    downloadPage = "https://github.com/segmentio/aws-okta";
  };
}
