{ rustPlatform, lib, fetchFromGitHub, nixosTests }:
rustPlatform.buildRustPackage rec {
  pname = "envfs";
<<<<<<< HEAD
  version = "1.0.1";
=======
  version = "1.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "envfs";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-ttW1NUCtwnjAoiu7QgLGrlAB2PyY4oXm91LpWhbz8qk=";
  };
  cargoHash = "sha256-BgXKwKD6w/GraBQEq61D7S7m2Q9TnkXNFJEIgDYo9L4=";
=======
    hash = "sha256-aF8V1LwPGifFWoVxM0ydOnTX1pDVJ6HXevTxADJ/rsw=";
  };
  cargoHash = "sha256-kw56tbe5zvWY5bI//dUqR1Rlumz8kOG4HeXiyEyL0I0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = {
    envfs = nixosTests.envfs;
  };

  postInstall = ''
    ln -s envfs $out/bin/mount.envfs
    ln -s envfs $out/bin/mount.fuse.envfs
  '';
  meta = with lib; {
    description = "Fuse filesystem that returns symlinks to executables based on the PATH of the requesting process.";
    homepage = "https://github.com/Mic92/envfs";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
