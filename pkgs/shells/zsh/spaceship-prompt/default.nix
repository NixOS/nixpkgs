{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "spaceship-prompt";
<<<<<<< HEAD
  version = "4.14.0";
=======
  version = "4.13.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "denysdovhan";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-aoifMAjJvv1WAlINNkMwCCop6znxyivoD3vQDo/ZbfQ=";
=======
    sha256 = "sha256-uFmGld5paCLNnE9yWgBLtthEBfwwMzlGCJFX6KqGJdw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    maintainers = with maintainers; [ nyanloutre fortuneteller2k kyleondy ];
  };
}
