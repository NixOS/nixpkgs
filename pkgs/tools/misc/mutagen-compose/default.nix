{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Y81m3kUu8R1uFLA+IRXP0llB6iC0uHeSW0SjTBGLmUc=";
  };

  vendorHash = "sha256-2+1PTUvhAS28lMXMLockLvX6aJyZsjuXZq8kIx4un8E=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  tags = [ "mutagencompose" ];

  meta = with lib; {
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
    mainProgram = "mutagen-compose";
  };
}
