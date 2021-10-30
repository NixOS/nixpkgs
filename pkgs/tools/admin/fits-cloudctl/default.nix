{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-FbKULHBzx4HcOFhIRdy7DiewOQzBdac3B+N34M/Kbzk=";
  };

  vendorSha256 = "sha256-ImKN3rNotgUkQaKzoetAEG6Q/zlfH8FTK4HTIO0xn4s=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
