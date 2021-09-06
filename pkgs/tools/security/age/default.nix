{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "age";
  version = "1.0.0";
  vendorSha256 = "sha256-cnFDs5Qos1KHn7TqaEgmt4sSzpjZor615euwxka14mY=";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "age";
    rev = "v${version}";
    sha256 = "sha256-MfyW8Yv8swKqA7Hl45l5Zn4wZrQmE661eHsKIywy36U=";
  };

  meta = with lib; {
    homepage = "https://age-encryption.org/";
    description = "Modern encryption tool with small explicit keys";
    license = licenses.bsd3;
    maintainers = with maintainers; [ tazjin ];
  };
}
