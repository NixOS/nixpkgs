{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    hash = "sha256-beoXLTy3XikdZBS0Lh3cugHflNJ51PbqsCE3xtCHpj0=";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(command which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  cargoHash = "sha256-wWYpDU6oXT+sDCzX8VWJ6GfNPOi7T02LK0JKcWHFGi8=";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r where history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
    mainProgram = "mcfly";
  };
}
