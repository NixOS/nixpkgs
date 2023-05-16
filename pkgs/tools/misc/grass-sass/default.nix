{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "grass";
<<<<<<< HEAD
  version = "0.13.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-IJ8kiSvuKR9f3I7TdE263cnQiARzDzfj30uL1PzdZ1s=";
  };

  cargoHash = "sha256-WRXoXB/HJkAnUKboCR9Gl2Au/1EivYQhF5rKr7PFe+s=";
=======
  version = "0.12.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-qx63icK4g/5LqKUsJpXs2Jpv30RuvIeLF6JNrTTkcLs=";
  };

  cargoHash = "sha256-v2ikP+zujj6GWN1ZwPIKK0jtF8Na5PaR1ZNelGdLzMM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # tests require rust nightly
  doCheck = false;

  meta = with lib; {
    description = "A Sass compiler written purely in Rust";
    homepage = "https://github.com/connorskees/grass";
    changelog = "https://github.com/connorskees/grass/blob/master/CHANGELOG.md#${replaceStrings [ "." ] [ "" ] version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
