{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.9";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "0i3qjgq1b8h3bzc7rxa60kq1yc2im9m6dgzrvial086a1zk8s81r";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  cargoSha256 = "084v4fsdi25ahz068ssq29z7d5d3k3jh3s8b07irwybdsy18c629";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
