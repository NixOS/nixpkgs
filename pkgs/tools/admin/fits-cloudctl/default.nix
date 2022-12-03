{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-wmkFBzfbMP1kwONpmchI/VQ6ti43pLC3AZfUGPNFzeI=";
  };

  vendorSha256 = "sha256-Y+RElir4mC6s5I8+mRtYYxYW/m9ihkjSWpG8mSZEjjA=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
