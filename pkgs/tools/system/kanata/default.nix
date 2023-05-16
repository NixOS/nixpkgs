<<<<<<< HEAD
{ lib
, rustPlatform
, fetchFromGitHub
=======
{ fetchFromGitHub
, fetchpatch
, lib
, rustPlatform
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, withCmd ? false
}:

rustPlatform.buildRustPackage rec {
  pname = "kanata";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Tenh2LARajYAFHJ5gddeozY7rfySSvqFhudc/7b9cGg=";
  };

  cargoHash = "sha256-oJVGZhKJVK8q5lgK+G+KhVupOF05u37B7Nmv4rrI28I=";
=======
    sha256 = "sha256-gHkcOn37MNpcP6ra1Eur9O4/trPGmAOAGVU1NwiuQGY=";
  };

  cargoHash = "sha256-C2d7QdgWd9RTQtXLD4mO0txpzo/SbemJx9YYu62QbqA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildFeatures = lib.optional withCmd "cmd";

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ linj ];
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "kanata";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
