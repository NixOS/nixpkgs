{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.22";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-9Vl4FWmKaNWl5QcfFc5KDyLWMRmAEqkBwMqwqhXkjgo=";
  };

  vendorSha256 = "sha256-10QeWL3tIcs2E4pK9UAY8C41YYjA3LHlvIbDhWVYATE=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
