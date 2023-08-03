{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-cRQdPOiERvxBZzaS26op1bDba9sCn3TyBIhlwI5XCro=";
  };

  cargoHash = "sha256-hw9DUe4iJ0DLX4P48ZpvZr6Xmq5rQ5rGmT13fO5uRoY=";

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
