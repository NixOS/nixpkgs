{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rshijack";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ys1uiUQbge/eKAog2f0wL9xM+RxuxNlsc8ZceoDJk9s=";
  };

  cargoHash = "sha256-GkoRgl0jzej8HoD2wojLg71NQcGvQZTtdD4zuvsJa4Y=";
=======
    sha256 = "sha256-jpiwbjsYsb5scFbjtv2eTv6oo0HWWTYLpnpTZ8DEqb0=";
  };

  cargoSha256 = "sha256-biHDnLu7OiYpnwtmayk2m6QYvX51YUVJH2FGP4qo14Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "TCP connection hijacker";
    homepage = "https://github.com/kpcyrd/rshijack";
    license = licenses.gpl3;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.unix;
  };
}
