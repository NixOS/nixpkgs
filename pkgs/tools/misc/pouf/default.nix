{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pouf";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "mothsart";
    repo = pname;
    rev = version;
    hash = "sha256-tW86b9a7u1jyfmHjwjs+5DaUujRZH+VhGQsj0CBj0yk=";
  };

  cargoHash = "sha256-rVJAaeg27SdM8cTx12rKLIGEYtXUhLHXUYpT78oVNlo=";

  # Cargo.lock is outdated.
  preConfigure = ''
    cargo update --offline
  '';

  postInstall = "make PREFIX=$out copy-data";

  meta = with lib; {
    description = "A CLI program for produce fake datas";
    homepage = "https://github.com/mothsart/pouf";
    changelog = "https://github.com/mothsart/pouf/releases/tag/${version}";
    maintainers = with maintainers; [ mothsart ];
    license = with licenses; [ mit ];
    mainProgram = "pouf";
  };
}
