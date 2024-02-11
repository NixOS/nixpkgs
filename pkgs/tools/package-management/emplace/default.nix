{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gq9JapddDCllczT7Xb71pui3ywbS/ArrjhIU6XfM0B8=";
  };

  cargoHash = "sha256-jE0nxIM0K6rQDlYGDFyqcQrqRVh+wqoXQE+SHZMwe+A=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
