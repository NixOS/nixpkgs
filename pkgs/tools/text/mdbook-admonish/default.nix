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

  useFetchCargoVendor = true;
  cargoHash = "sha256-GbXLlWHbLL7HbyuX223S/o1/+LwbK8FjL7lnEgVVn00=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook to add Material Design admonishments";
    mainProgram = "mdbook-admonish";
    license = licenses.mit;
    maintainers = with maintainers; [
      jmgilman
      Frostman
      matthiasbeyer
    ];
    homepage = "https://github.com/tommilligan/mdbook-admonish";
  };
}
