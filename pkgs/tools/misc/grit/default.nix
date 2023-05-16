{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "grit";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "climech";
    repo = "grit";
    rev = "v${version}";
    sha256 = "sha256-c8wBwmXFjpst6UxL5zmTxMR4bhzpHYljQHiJFKiNDms=";
  };

<<<<<<< HEAD
  vendorHash = "sha256-iMMkjJ5dnlr0oSCifBQPWkInQBCp1bh23s+BcKzDNCg=";
=======
  vendorSha256 = "sha256-iMMkjJ5dnlr0oSCifBQPWkInQBCp1bh23s+BcKzDNCg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A multitree-based personal task manager";
    homepage = "https://github.com/climech/grit";
    license = licenses.mit;
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = [ maintainers.ivar ];
  };
}
