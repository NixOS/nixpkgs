{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "spaceship-prompt";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "spaceship-prompt";
    sha256 = "1q7m9mmg82n4fddfz01y95d5n34xnzhrnn1lli0vih39sgmzim9b";
    rev = "v${version}";
  };

  installPhase = ''
    install -D -m644 LICENSE.md "$out/share/licenses/spaceship-prompt/LICENSE"
    install -D -m644 README.md "$out/share/doc/spaceship-prompt/README.md"
    find docs -type f -exec install -D -m644 {} "$out/share/doc/spaceship-prompt/{}" \;
    find lib -type f -exec install -D -m644 {} "$out/lib/spaceship-prompt/{}" \;
    find scripts -type f -exec install -D -m644 {} "$out/lib/spaceship-prompt/{}" \;
    find sections -type f -exec install -D -m644 {} "$out/lib/spaceship-prompt/{}" \;
    install -D -m644 spaceship.zsh "$out/lib/spaceship-prompt/spaceship.zsh"
    install -d "$out/share/zsh/themes/"
    ln -s "$out/lib/spaceship-prompt/spaceship.zsh" "$out/share/zsh/themes/spaceship.zsh-theme"
  '';

  meta = with stdenv.lib; {
    description = "Zsh prompt for Astronauts";
    homepage = https://github.com/denysdovhan/spaceship-prompt/;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
