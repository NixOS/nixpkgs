{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {

  pname = "bkt";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "dimo414";
    repo = pname;
    rev = version;
    sha256 = "sha256-XQK7oZfutqCvFoGzMH5G5zoGvqB8YaXSdrwjS/SVTNU=";
  };

  cargoHash = "sha256-Pl+a+ZpxaguRloH8R7x4FmYpTwTUwFrYy7AS/5K3L+8=";

  meta = {
    description = "A subprocess caching utility";
    homepage = "https://github.com/dimo414/bkt";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "bkt";
  };
}
