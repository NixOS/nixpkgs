{ lib
, rustPlatform
, fetchCrate
<<<<<<< HEAD
}:

rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-aaKvrWJGZ26wyqoblAcUkGUPkbt8XNx9Z4xT+qI2B3o=";
  };

  cargoHash = "sha256-4CUMt5aDHq943uU5PAY1TJtmCqlBvgOruGQ69OG5fB4=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];
=======
, llvmPackages
}:
rustPlatform.buildRustPackage rec {
  pname = "killport";
  version = "0.8.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ip7Ndy4i4P6n20COfSL/EtG1Y+xoab8Gox4gcNHH1/o=";
  };

  cargoSha256 = "sha256-M4riyvGueCQDKOj+lgYPm2lZ8UjCp1y/SyG692vZbS4=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A command-line tool to easily kill processes running on a specified port";
    homepage = "https://github.com/jkfran/killport";
    license = licenses.mit;
    maintainers = with maintainers; [ sno2wman ];
  };
}
