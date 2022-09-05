{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.10.21";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-p9q0NVk+7jZ/DKxDjvvlfRKW9N1bk5jquxxQHmNE/3s=";
  };

  vendorSha256 = "sha256-DRrf7VR1w35KRwokcDIBYr0pPmNREXiATRu4Cc+xegk=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
