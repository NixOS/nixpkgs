{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
}:

rustPlatform.buildRustPackage rec {
  pname = "codevis";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "sloganking";
    repo = "codevis";
    rev = "v${version}";
    hash = "sha256-Bi8V9csbqSY/n9t7FBgDzHXY2JsJQL3GBPDE0ZDXd0g=";
  };

  cargoHash = "sha256-o6ogJju4z6toE6T91ExBp+XA7GJ0FBqrIr/UzLfyCd0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ];

  RUSTONIG_SYSTEM_LIBONIG = true;

  meta = with lib; {
    description = "A tool to take all source code in a folder and render them to one image";
    homepage = "https://github.com/sloganking/codevis";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
