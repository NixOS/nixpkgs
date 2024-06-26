{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-gEiKv1YbNNWexNfzUULbe0fT0ueJ9TJojhBHp31i6OY=";
  };

  cargoHash = "sha256-eqzqIyQHHklxo3aojCvY06TUPSqChoz6yZ2zzpgRNqs=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "fselect";
  };
}
