{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-admonish";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "tommilligan";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/P9cHxeo2HZ11ErdAULlZt1VwmVqs4hoC8inXQiGLj4=";
  };

  cargoHash = "sha256-d/jbokKsnuaJfKHQhtXVoD/JoNdhlZpnwRkgOw15p+Y=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "A preprocessor for mdbook to add Material Design admonishments";
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
