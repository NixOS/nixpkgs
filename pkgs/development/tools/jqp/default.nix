{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-z2EKtSM+/wWGgwsHKDcxtc/M6UZ01AiTZaaCYCWjU7M=";
  };

  vendorHash = "sha256-7UiQjTgcwGOTEJEaWywEdZvpkM/MoXU3d6k8oVmUiW8=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A TUI playground to experiment with jq";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
