{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jqp";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "noahgorstein";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zcv6fYrqPp/IMg4ivqJtlJwOs2M5E8niWoIOXYiEZuA=";
  };

  vendorHash = "sha256-c+TZGLaUomlykIU4aN7awUp4kpIEoGOkkbvIC6ok7h4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "A TUI playground to experiment with jq";
    mainProgram = "jqp";
    homepage = "https://github.com/noahgorstein/jqp";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
  };
}
