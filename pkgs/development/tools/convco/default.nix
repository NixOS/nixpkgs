{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, cmake
, libiconv
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
<<<<<<< HEAD
  version = "0.4.2";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-RNUMLc4lY18tsOr2vmpkYdQ2poVOQxsSVl5PEuhzQxw=";
  };

  cargoHash = "sha256-ChB4w9qnSzuOGTPYfpAJS2icy9wi1RjONCsfT+3vlRo=";
=======
    sha256 = "sha256-Fv1yaBnfn/wik1Ix24shwfritwxno3NoeJgHPsHgZOI=";
  };

  cargoHash = "sha256-q0VrN+5Ypq4ga/gI5MlyRaMdD8NxzuaZ804KaRQzpRs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear ];
  };
}
