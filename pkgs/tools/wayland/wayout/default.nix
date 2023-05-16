{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromSourcehut
=======
, stdenv
, fetchFromSourcehut
, rustPlatform
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "wayout";
  version = "1.1.3";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = pname;
    rev = version;
    sha256 = "sha256-EzRetxx0NojhBlBPwhQ7p9rGXDUBlocVqxcEVGIF3+0=";
  };

  cargoSha256 = "sha256-QlxXbfeWJdCythYRRLSpJbTzKkwrL4kmAfyL3tRt194=";

  meta = with lib; {
    description = "Simple output management tool for wlroots based compositors implementing";
    homepage = "https://git.sr.ht/~shinyzenith/wayout";
    license = licenses.bsd2;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
  };

}
