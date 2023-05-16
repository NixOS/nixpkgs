{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "svgbob";
<<<<<<< HEAD
  version = "0.7.2";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchCrate {
    inherit version;
    crateName = "svgbob_cli";
<<<<<<< HEAD
    sha256 = "sha256-QWDi6cpADm5zOzz8hXuqOBtVrqb0DteWmiDXC6PsLS4=";
  };

  cargoHash = "sha256-Fj1qjG4SKlchUWW4q0tBC+9fHFFuY6MHngJCFz6J5JY=";
=======
    sha256 = "sha256-iWcd+23/Ou7K2YUDf/MJx84LsVMXXqAkGNPs6B0RDqA=";
  };

  cargoHash = "sha256-YbbVv2ln01nJfCaopKCwvVN7cgrcuaRHNXGHf9j9XUY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    mv $out/bin/svgbob_cli $out/bin/svgbob
  '';

  meta = with lib; {
    description = "Convert your ascii diagram scribbles into happy little SVG";
    homepage = "https://github.com/ivanceras/svgbob";
    changelog = "https://github.com/ivanceras/svgbob/raw/${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
