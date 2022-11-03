{ lib
, buildGoModule
, fetchFromGitHub
, updateGolangSysHook
}:

buildGoModule rec {
  pname = "gosh";
  # https://github.com/redcode-labs/GoSH/issues/4
  version = "2020523-${lib.strings.substring 0 7 rev}";
  rev = "7ccb068279cded1121eacc5a962c14b2064a1859";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GoSH";
    inherit rev;
    sha256 = "143ig0lqnkpnydhl8gnfzhg613x4wc38ibdbikkqwfyijlr6sgzd";
  };

  nativeBuildInputs = [ updateGolangSysHook ];

  vendorSha256 = "sha256-Q/8MId0czuGokiypI2K7isr0yDkqPRV90GgipNqhaf4=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Reverse/bind shell generator";
    homepage = "https://github.com/redcode-labs/GoSH";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ] ++ teams.redcodelabs.members;
    mainProgram = "GoSH";
  };
}
