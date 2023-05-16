{ lib, stdenv, fetchFromGitHub, makeWrapper
<<<<<<< HEAD
, perl, pandoc, python3, git
=======
, perl, pandoc, python3Packages, git
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, par2cmdline ? null, par2Support ? true
}:

assert par2Support -> par2cmdline != null;

<<<<<<< HEAD
let
  version = "0.33.2";

  pythonDeps = with python3.pkgs; [ setuptools tornado ]
    ++ lib.optionals (!stdenv.isDarwin) [ pyxattr pylibacl fuse ];
in
=======
let version = "0.32"; in
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation {
  pname = "bup";
  inherit version;

  src = fetchFromGitHub {
    repo = "bup";
    owner = "bup";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-DDVCrY4SFqzKukXm8rIq90xAW2U+yYyhyPmUhslMMWI=";
  };

  buildInputs = [ git python3 ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  postPatch = "patchShebangs .";
=======
    sha256 = "sha256-SWnEJ5jwu/Jr2NLsTS8ajWay0WX/gYbOc3J6w00DndI=";
  };

  buildInputs = [
    git
    (python3Packages.python.withPackages
      (p: with p; [ setuptools tornado ]
        ++ lib.optionals (!stdenv.isDarwin) [ pyxattr pylibacl fuse ]))
  ];
  nativeBuildInputs = [ pandoc perl makeWrapper ];

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace "-Werror" ""
  '' + lib.optionalString par2Support ''
    substituteInPlace cmd/fsck-cmd.py --replace "'par2'" "'${par2cmdline}/bin/par2'"
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  dontAddPrefix = true;

  makeFlags = [
    "MANDIR=$(out)/share/man"
    "DOCDIR=$(out)/share/doc/bup"
    "BINDIR=$(out)/bin"
    "LIBDIR=$(out)/lib/bup"
  ];

<<<<<<< HEAD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-Wno-error=implicit-function-declaration";

  postInstall = ''
    wrapProgram $out/bin/bup \
      --prefix PATH : ${lib.makeBinPath [ git par2cmdline ]} \
      --prefix NIX_PYTHONPATH : ${lib.makeSearchPathOutput "lib" python3.sitePackages pythonDeps}
=======
  postInstall = ''
    wrapProgram $out/bin/bup \
      --prefix PATH : ${git}/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "https://github.com/bup/bup";
    description = "Efficient file backup system based on the git packfile format";
    license = licenses.gpl2Plus;

    longDescription = ''
      Highly efficient file backup system based on the git packfile format.
      Capable of doing *fast* incremental backups of virtual machine images.
    '';

    platforms = platforms.linux ++ platforms.darwin;
<<<<<<< HEAD
    maintainers = with maintainers; [ rnhmjoj ];
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
