{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sops";
  version = "3.7.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "mozilla";
    repo = pname;
    sha256 = "1a0v1jgbz8n3dymzr2shg2ms9sxjwaci209ldzq8v4g737v10zgm";
  };

  vendorSha256 = "1qaml2h3c8fhmi8ahp2fmd0hagqp5xqaf8jxjh4mfmbv2is3yz1l";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/mozilla/sops";
    description = "Mozilla sops (Secrets OPerationS) is an editor of encrypted files";
    changelog = "https://github.com/mozilla/sops/raw/v${version}/CHANGELOG.rst";
    maintainers = [ maintainers.marsam ];
    license = licenses.mpl20;
  };
}
