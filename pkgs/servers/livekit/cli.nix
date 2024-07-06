{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-euA+MDCqUTAJ4X9D+XQWAs8HKnWOh+KclTdpoQHGADk=";
  };

  vendorSha256 = "sha256-HZJN4ZjVkk4NDb4/E6BPsgty8oKt7A3eTmJ/qUIaUAY=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://github.com/livekit/livekit-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
