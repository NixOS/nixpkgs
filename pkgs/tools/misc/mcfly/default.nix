{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "sha256-auIerSfEKBK47mIhfmjREJohnhCmtzruobRXaoz5fqA=";
  };

  postPatch = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' '${placeholder "out"}/bin/mcfly'
    substituteInPlace mcfly.fish --replace '(which mcfly)'  '${placeholder "out"}/bin/mcfly'
  '';

  cargoSha256 = "sha256-f9kpD295syRCntwvyjZ9AeAUV61RMbfRRMgNxKAJL8g=";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/raw/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
