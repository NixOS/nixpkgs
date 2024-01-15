{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.4";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-arvDV1AlhrXfndoXGd7jn6O9ZAc1+7hq30QpYPLhpJw=";
  };

  vendorHash = "sha256-wqenEPTRsZvQscXv+/eVEFVk8Fd1/Aj3QcBSZzpkmGA=";

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
