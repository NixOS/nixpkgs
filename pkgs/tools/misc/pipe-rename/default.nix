{ lib, rustPlatform, fetchCrate, python3 }:

rustPlatform.buildRustPackage rec {
  pname = "pipe-rename";
<<<<<<< HEAD
  version = "1.6.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-av/ig76O7t3dB4Irfi3yqyL30nkJJCzs5EayWRbpOI0=";
  };

  cargoHash = "sha256-3p6Bf9UfCb5uc5rp/yuXixcDkuXfTiboLl8TI0O52hE=";
=======
  version = "1.6.2";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-eMTqKKcFeEICref35/RHWNzpnjLDrG7rjcXjOSAnwIo=";
  };

  cargoSha256 = "sha256-X4wmhyWpjq4EyAVsfdeP76NSC9tcZjZ6woCsRvw0Gzo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ python3 ];

  preCheck = ''
    patchShebangs tests/editors/env-editor.py
  '';

  meta = with lib; {
    description = "Rename your files using your favorite text editor";
<<<<<<< HEAD
    homepage = "https://github.com/marcusbuffett/pipe-rename";
=======
    homepage = "https://github.com/marcusbuffet/pipe-rename";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "renamer";
  };
}
