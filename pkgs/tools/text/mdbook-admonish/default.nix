{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GNQIOjgHCt3XPCzF0RjV9YStI8psLdHhTPuTkdgx8vA=";
  };

  cargoHash = "sha256-CG4WvAFDqtRUjF4kJ29363F6jWRChIXgT5i6ozwV4pw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jmgilman
      Frostman
      matthiasbeyer
    ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
