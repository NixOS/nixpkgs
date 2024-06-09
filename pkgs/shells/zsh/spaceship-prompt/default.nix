{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spaceship-prompt";
  version = "4.15.3";

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2Z9NUC1TR0lYBQux+Tkac0oFVnYIxsMkdWNGKQIz9IU=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    install -Dm644 LICENSE.md "$out/share/licenses/spaceship-prompt/LICENSE"
    install -Dm644 README.md "$out/share/doc/spaceship-prompt/README.md"
    find docs -type f -exec install -Dm644 {} "$out/share/doc/spaceship-prompt/{}" \;
    find lib -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    find scripts -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    find sections -type f -exec install -Dm644 {} "$out/lib/spaceship-prompt/{}" \;
    install -Dm644 spaceship.zsh "$out/lib/spaceship-prompt/spaceship.zsh"
    install -Dm644 async.zsh "$out/lib/spaceship-prompt/async.zsh"
    install -d "$out/share/zsh/themes/"
    ln -s "$out/lib/spaceship-prompt/spaceship.zsh" "$out/share/zsh/themes/spaceship.zsh-theme"
    install -d "$out/share/zsh/site-functions/"
    ln -s "$out/lib/spaceship-prompt/spaceship.zsh" "$out/share/zsh/site-functions/prompt_spaceship_setup"
  '';

  meta = with lib; {
    description = "Zsh prompt for Astronauts";
    homepage = "https://github.com/denysdovhan/spaceship-prompt/";
    changelog = "https://github.com/spaceship-prompt/spaceship-prompt/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nyanloutre moni kyleondy ];
  };
}
