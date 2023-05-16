{ lib
, stdenv
, fetchFromGitHub
, patsh
}:

stdenv.mkDerivation rec {
  pname = "csvquote";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "dbro";
    repo = "csvquote";
    rev = "v${version}";
    hash = "sha256-847JAoDEfA9K4LB8z9cqSw+GTImqmITBylB/4odLDb0=";
  };

  patches = [
    # patch csvheader to use csvquote from the derivation
    ./csvquote-path.patch
  ];

  nativeBuildInputs = [
    patsh
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
  ];

  preInstall = ''
    mkdir -p "$out/bin"
  '';

  postInstall = ''
    substituteAllInPlace $out/bin/csvheader
    patsh $out/bin/csvheader -fs ${builtins.storeDir}
  '';

  meta = with lib; {
<<<<<<< HEAD
    description = "Enables common unix utilities like cut, awk, wc, head to work correctly with csv data containing delimiters and newlines";
=======
    description = "Enables common unix utlities like cut, awk, wc, head to work correctly with csv data containing delimiters and newlines";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/dbro/csvquote";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.all;
  };
}
