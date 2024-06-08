{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FZ+lvf5HRSruUdmkm/Hqz0aRa95SjfIa43WQczRCGNg=";
  };

  cargoHash = "sha256-0bKLN0l3ldHJizqWuSoBUxQ8I114BQz6ZTtsro3eYEI=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
