{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "mcfly";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "cantino";
    repo = "mcfly";
    rev = "v${version}";
    sha256 = "1biahx4bji8kasqcxnixnpmfx3qwwibw1vdd172px3i75pbyybqn";
  };

  postInstall = ''
    substituteInPlace mcfly.bash --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.zsh  --replace '$(which mcfly)' $out/bin/mcfly
    substituteInPlace mcfly.fish --replace '(which mcfly)' $out/bin/mcfly
    install -Dm644 -t $out/share/mcfly mcfly.bash
    install -Dm644 -t $out/share/mcfly mcfly.zsh
    install -Dm644 -t $out/share/mcfly mcfly.fish
  '';

  cargoSha256 = "139pdhrqgl0ai94w2c948aal1j73qw4jxxdd4gxn4apglbnma1xz";

  meta = with stdenv.lib; {
    homepage = "https://github.com/cantino/mcfly";
    description = "An upgraded ctrl-r for Bash whose history results make sense for what you're working on right now";
    license = licenses.mit;
    maintainers = [ maintainers.melkor333 ];
  };
}
