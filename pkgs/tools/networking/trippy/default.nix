{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "trippy";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "fujiapple852";
    repo = "trippy";
    rev = version;
    hash = "sha256-ArSIeu3u+TUy18rzJvhq0+/qvi5xPZmtQ7rPpwaEx9g=";
  };

  cargoHash = "sha256-h1NQQFjtlpQuyTz7AHuAPUe1GxR0Q2yKzow8XB9375U=";

  meta = with lib; {
    description = "Network diagnostic tool";
    homepage = "https://trippy.cli.rs";
    changelog = "https://github.com/fujiapple852/trippy/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "trip";
  };
}
