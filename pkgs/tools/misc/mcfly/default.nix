{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    hash = "sha256-qzi21vouUhvpmqxQpYoCnHJDLRU8ZgCvewxblD2BGJc=";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(command which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(command which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  cargoHash = "sha256-RHR+qmtnSrJOPkObRrE39EshmDVu53vEvw647ATk+os=";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r where history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
