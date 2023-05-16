{ lib
, stdenv
, buildPythonPackage
, cargo
, fetchFromGitHub
, libiconv
, Foundation
, rustPlatform
, rustc
, setuptools-rust
, range-typed-integers
}:

buildPythonPackage rec {
  pname = "skytemple-rust";
<<<<<<< HEAD
  version = "1.5.3";
=======
  version = "1.4.0.post0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-Txx8kQNb3ODbaJXfuHERzPx4zGUqYXzy+jbLNaMyf+w=";
=======
    hash = "sha256-aw57B15sDbMcdNPD8MW+O7AdqSSqjlOcuXNSm10GdPM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-KQA8dfHnuysx9EUySJXZ/52Hfq6AbALwkBp3B1WJJuc=";
=======
    hash = "sha256-SvHrMr5k4afVdU5nvg+bcoHVmzHYyoOYqv7nOSVxRCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Foundation ];
  nativeBuildInputs = [ setuptools-rust rustPlatform.cargoSetupHook cargo rustc ];
  propagatedBuildInputs = [ range-typed-integers ];

  GETTEXT_SYSTEM = true;

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_rust" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-rust";
    description = "Binary Rust extensions for SkyTemple";
    license = licenses.mit;
    maintainers = with maintainers; [ xfix marius851000 ];
  };
}
