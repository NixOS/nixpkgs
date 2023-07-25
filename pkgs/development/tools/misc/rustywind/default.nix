{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "rustywind";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "avencera";
    repo = "rustywind";
    rev = "v${version}";
    hash = "sha256-xDpRS8WrFu5uPtbXJGXrxElJinxl1lkpYZ1tGrNrBHA=";
  };

  cargoHash = "sha256-2bo6KkHVw1lyLD4iWidAyxZzQMRTO5DWvYmqUQld15g=";

  meta = with lib; {
    description = "CLI for organizing Tailwind CSS classes";
    homepage = "https://github.com/avencera/rustywind";
    changelog = "https://github.com/avencera/rustywind/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
