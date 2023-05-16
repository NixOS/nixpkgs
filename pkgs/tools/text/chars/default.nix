{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "chars";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "antifuchs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-mBtwdPzIc6RgEFTyReStFlhS4UhhRWjBTKT6gD3tzpQ=";
  };

  cargoHash = "sha256-wqyExG4haco6jg1zpbouz3xMR7sjiVIAC16PnDU2tc8=";
=======
    sha256 = "sha256-aswosSXAh0wkO4N/y/H54dufMDrloWjpjrSWHvHR1rc=";
  };

  cargoSha256 = "sha256-CqPmasdpXWjCn65G2Ua0h3v+TVP0QPFAdtKOFyoYW/0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "Commandline tool to display information about unicode characters";
    homepage = "https://github.com/antifuchs/chars";
    license = licenses.mit;
    maintainers = with maintainers; [ bbigras ];
  };
}
