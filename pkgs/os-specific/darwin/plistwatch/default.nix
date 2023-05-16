{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "plistwatch";
<<<<<<< HEAD
  version = "unstable-2023-06-22";
=======
  version = "unstable-2020-12-22";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "catilac";
    repo = "plistwatch";
<<<<<<< HEAD
    rev = "34d808c1509eea22fe88a2dbb6f0a1669a2a5b23";
    hash = "sha256-kMHi5xKbiwO+/6Eb8oJz7ECoUybFE+IUDz7VfJueB3g=";
  };

  vendorHash = "sha256-Layg1axFN86OFgxEyNFtIlm6Jtx317jZb/KH6IjJ8e4=";
=======
    rev = "c3a9afd8d3e5ffa8dcc379770bc4216bae88a671";
    sha256 = "0a5rfmpy6h06p02z9gdilh7vr3h9cc6n6zzygpjk6zvnqs3mm3vx";
  };

  vendorSha256 = "sha256-Layg1axFN86OFgxEyNFtIlm6Jtx317jZb/KH6IjJ8e4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  #add missing dependencies and hashes
  patches = [ ./go-modules.patch ];

  doCheck = false;

  meta = with lib; {
    description = "Monitors and prints changes to MacOS plists in real time";
    homepage = "https://github.com/catilac/plistwatch";
    maintainers = with maintainers; [ gdinh ];
    license = licenses.mit;
    platforms = platforms.darwin;
  };
}
