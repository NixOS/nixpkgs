{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.17";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-cC6qPPRrMUMpwQ/FH+H6LuwC35dfgcZyB2yqz7tvSIg=";
  };

  vendorSha256 = "sha256-nNzmecvTAIno6+OkpmlQ0eHfNfQGUH+ICLumvLswlWA=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
