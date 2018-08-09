{ buildGoPackage, fetchFromGitHub, stdenv }:
buildGoPackage rec {
  name = "aws-okta-${version}";
  version = "0.19.0";

  goPackagePath = "github.com/segmentio/aws-okta";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "aws-okta";
    rev = "v${version}";
    sha256 = "1c9mn492yva7cdsx2b0n8g2fdl9660v3xma0v82jzb0c9y9rq0ms";
  };

  buildFlags = "--tags release";

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
