{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, dpkg
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KVHci8h30cAZZffRA3e0gb1uAMv2UDiC9HkiqNaqSS4=";
  };

  cargoHash = "sha256-swRiR+YeQVT7mMzJHQtCI4wcG9z44r34YDv8WmEPr08=";

  nativeBuildInputs = [
    makeWrapper
  ];

  # This is an FHS specific assert depending on glibc location
  checkFlags = [
    "--skip=dependencies::resolve_test"
    "--skip=run_cargo_deb_command_on_example_dir_with_separate_debug_symbols"
  ];

  postInstall = ''
    wrapProgram $out/bin/cargo-deb \
      --prefix PATH : ${lib.makeBinPath [ dpkg ]}
  '';

  meta = with lib; {
    description = "Cargo subcommand that generates Debian packages from information in Cargo.toml";
    mainProgram = "cargo-deb";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne matthiasbeyer ];
  };
}
