{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "modvendor";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "goware";
    repo = "modvendor";
    rev = "v${version}";
    sha256 = "1pdh2ck40b2z2www38a86snp65n5dg2w4zbabh6d4g29gq668wyr";
  };

  vendorSha256 = null;

  meta = with lib; {
    homepage = "https://github.com/goware/modvendor";
    description = "Simple tool to copy additional module files into a local vendor folder";
    license = licenses.mit;
  };
}
