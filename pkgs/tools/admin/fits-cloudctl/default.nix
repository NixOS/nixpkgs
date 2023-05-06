{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-MshhDYBUpg7iQjZ1ptSpEVpb5y1iytQKqF1AE6BQKWk=";
  };

  vendorHash = "sha256-NLEEPCnK2VqnpZ0M57Y8r1gHtgNVKjTPzO7qOp30KRk=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
