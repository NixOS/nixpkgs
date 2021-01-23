{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "1p51wdv47cyg6dmb81fm0d92x1kp7bwwpgax6vlh669nkddiwvmm";
  };

  postInstall = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.fish --replace '(which mcfly)' $out/bin/mcfly
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
    install -Dm644 -t $out/share/mcfly mcfly.fish
  '';

  cargoSha256 = "0gcdgca8w8i978b067rwm5zrc81rxb704006k9pbcwizkq2281yy";

  meta = with lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/blob/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
