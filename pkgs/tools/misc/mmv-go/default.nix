{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmv-go";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "sha256-5pVjonlVhIzov8YXgXIqpV3Hy/2ikW4YXJfz68zdxVo=";
  };

  vendorHash = "sha256-XK+Puic5Bbb7QTc3SHltUuRfTTK7FpCEudN1+tVv18w=";

  ldflags = [ "-s" "-w" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "mmv";
  };
}
