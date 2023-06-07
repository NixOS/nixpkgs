{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "fits-cloudctl";
  version = "0.11.7";

  src = fetchFromGitHub {
    owner = "fi-ts";
    repo = "cloudctl";
    rev = "v${version}";
    sha256 = "sha256-wsv1d7CdrZeAOgY0a0L1ZjSJVahtfDsOzKaz3Uu2RWM=";
  };

  vendorHash = "sha256-/lDhvmeeEiXP+mihrz6076Cm/29UeJ0QH9GW3hIHKB8=";

  meta = with lib; {
    description = "Command-line client for FI-TS Finance Cloud Native services";
    homepage = "https://github.com/fi-ts/cloudctl";
    license = licenses.mit;
    maintainers = with maintainers; [ j0xaf ];
    mainProgram = "cloudctl";
  };
}
