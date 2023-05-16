{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation {
  pname = "mcfgthreads";
<<<<<<< HEAD
  version = "unstable-2023-06-06";
=======
  version = "git";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
<<<<<<< HEAD
    rev = "f0a335ce926906d634c787249a89220045bf0f7e";
    hash = "sha256-PLGIyoLdWgWvkHgRe0vHLIvnCxFpmHtbjS8xRhNM9Xw=";
=======
    rev = "c446cf4fcdc262fc899a188a4bb7136284c34222";
    sha256 = "1ib90lrd4dz8irq4yvzwhxqa86i5vxl2q2z3z04sf1i8hw427p2f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [ "out" "dev" ];

<<<<<<< HEAD
=======
  # Don't want prebuilt binaries sneaking in.
  postUnpack = ''
    rm -r "$sourceRoot/debug" "$sourceRoot/release"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoreconfHook
  ];
}
