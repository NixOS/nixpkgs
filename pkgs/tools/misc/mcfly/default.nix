{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "0a2jff72l5my00pg9lhjdmnwkqfv4hmnl0a9cfbnzsqh39lbklqy";
  };

  postInstall = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.fish --replace '(which mcfly)' $out/bin/mcfly
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
    install -Dm644 -t $out/share/mcfly mcfly.fish
  '';

  cargoSha256 = "1c8qjkpc8wi095zzmgd05721kdf1knh9la91l081mvwa3inwk6ax";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    changelog = "https://github.com/cantino/mcfly/blob/v${version}/CHANGELOG.txt";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
