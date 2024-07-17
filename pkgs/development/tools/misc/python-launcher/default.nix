{
  lib,
  rustPlatform,
  fetchFromGitHub,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "python-launcher";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "brettcannon";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r2pmli4jsdjag9zsgd9q1qlj3hxxjj2bni6yybjh1a10fcqxzzv";
  };

  cargoSha256 = "sha256-2lgWybEPi6HEUMYuGDRWMjWoc94CrFHPP5IeKUjj0q4=";

  nativeCheckInputs = [ python3 ];

  useNextest = true;

  meta = with lib; {
    description = "An implementation of the `py` command for Unix-based platforms";
    homepage = "https://github.com/brettcannon/python-launcher";
    changelog = "https://github.com/brettcannon/python-launcher/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "py";
  };
}
