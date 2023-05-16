{ stdenv, fetchFromGitHub, lib, rustPlatform, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "Lighthouse";
<<<<<<< HEAD
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = pname;
    rev = version;
    sha256 = "0g0cs54j1vmcig5nc8sqgx30nfn2zjs40pvv30j5g9cyyszbzwkw";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "clap-verbosity-flag-2.1.1" = "1213bsb0bpvv6621j9zicjsqy05sv21gh6inrvszqwcmj6fxxc7j";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';
=======
  version = "unstable-2021-03-28";

  src = fetchFromGitHub {
    owner = "ShayBox";
    repo = "Lighthouse";
    rev = "a090889077557fe92610ca503979b5cfc0724d61";
    sha256 = "0vfl4y61cdrah98x6xcnb3cyi8rwhlws8ps6vfdlmr3dv30mbnbb";
  };

  cargoSha256 = "0aqd9ixszwq6qmj751gxx453gwbhwqi16m72bkbkj9s6nfyqihql";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ dbus ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "VR Lighthouse power state management";
    homepage = "https://github.com/ShayBox/Lighthouse";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = with maintainers; [ expipiplus1 bddvlpr ];
  };
}
=======
    maintainers = with maintainers; [ expipiplus1 ];
  };
}

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
