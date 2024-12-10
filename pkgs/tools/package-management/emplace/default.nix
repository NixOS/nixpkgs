{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-KwA0GlZatY1DvtqSR4rwq/nODSa9n+S0gPVqS6agSzM=";
  };

  cargoHash = "sha256-eQ+T6YiYYeWaUezXB59+Ki05PXtJd7ISwnRw/x/YTZA=";

  meta = with lib; {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
