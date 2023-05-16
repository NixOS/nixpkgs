{ lib
, stdenv
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchFromGitHub
, nix-update-script
, rustPlatform
, CoreServices
, which
}:

rustPlatform.buildRustPackage rec {
  pname = "dotter";
<<<<<<< HEAD
  version = "0.13.0";
=======
  version = "0.12.15";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SuperCuber";
    repo = "dotter";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-mAvTy/11a9RGSQpElhpKMzsMC7vA7cbeHsNRy9MnIjw=";
  };

  cargoHash = "sha256-XsDp/ssoNVdTHDTPm2ucgBeYmFgbeBIxQ/NsGjCl5Qg=";
=======
    hash = "sha256-quMEwg/B4ey6zoxDZO2ce3/s1FX5xxmJfyAlt4YvFqE=";
  };

  cargoHash = "sha256-D8H95dE+th1mMzlLmd+fqU5VdlxdOSBHKSjvh21JhnE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ which ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A dotfile manager and templater written in rust 🦀";
    homepage = "https://github.com/SuperCuber/dotter";
    license = licenses.unlicense;
    maintainers = with maintainers; [ linsui ];
  };
}
