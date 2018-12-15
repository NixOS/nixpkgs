{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec{
  name = "spaceship-prompt-${version}";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = "spaceship-prompt";
    sha256 = "0laihax18bs254rm2sww5wkjbmkp4m5c8aicgqpi4diz7difxk6z";
    rev = "aaa34aeab9ba0a99416788f627ec9aeffba392f0";
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
