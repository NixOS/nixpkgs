{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "fblog";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "brocode";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ByojMOkdE3B9KrApOWPihg6vJHpLQy0gsIlKPd5xJog=";
  };

  cargoHash = "sha256-R7FLZ+yLvDltETphfqRLrcQZNt+rkJBFdmGL3pY0G04=";

  meta = with lib; {
    description = "A small command-line JSON log viewer";
    homepage = "https://github.com/brocode/fblog";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ figsoda ];
  };
}
