{ lib
, rustPlatform
, fetchFromGitHub
, makeWrapper
, dpkg
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-deb";
  version = "2.0.6";

  src = fetchFromGitHub {
    owner = "kornelski";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EYb1cJ+t5pI7KfL2SK8w2oeKbbdbOpUarNHFxpW79fQ=";
  };

  cargoHash = "sha256-eLLi79XP/G6L0+2WlVTs6xpmkXOSO+4VOt6Srw5hnvw=";

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
    description = "A cargo subcommand that generates Debian packages from information in Cargo.toml";
    homepage = "https://github.com/kornelski/cargo-deb";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne matthiasbeyer ];
  };
}
