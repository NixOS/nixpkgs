{ lib
, fetchFromGitHub
<<<<<<< HEAD
, gitUpdater
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python3Packages
, gnutar
, unzip
, lhasa
, rpm
, binutils
, cpio
, gzip
, p7zip
, cabextract
, unrar
, unshield
, bzip2
, xz
, lzip
, unzipSupport ? false
, unrarSupport ? false
}:

python3Packages.buildPythonApplication rec {
  pname = "dtrx";
<<<<<<< HEAD
  version = "8.5.3";
=======
  version = "8.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dtrx-py";
    repo = "dtrx";
<<<<<<< HEAD
    rev = version;
    sha256 = "sha256-LB3F6jcqQPRsjFO4L2fPAPnacDAdtcaadgGbwXA9LAw=";
  };

  makeWrapperArgs =
=======
    rev = "refs/tags/${version}";
    sha256 = "sha256-KOHafmvl17IABlcBuE7isHVCIYRbA68Dna6rgiiWlkQ=";
  };

  postInstall =
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    let
      archivers = lib.makeBinPath (
        [ gnutar lhasa rpm binutils cpio gzip p7zip cabextract unshield bzip2 xz lzip ]
        ++ lib.optional (unzipSupport) unzip
        ++ lib.optional (unrarSupport) unrar
      );
<<<<<<< HEAD
    in [
      ''--prefix PATH : "${archivers}"''
    ];

  nativeBuildInputs = [ python3Packages.invoke ];

  passthru.updateScript = gitUpdater { };

=======
    in ''
      wrapProgram "$out/bin/dtrx" --prefix PATH : "${archivers}"
    '';

  nativeBuildInputs = [ python3Packages.invoke ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Do The Right Extraction: A tool for taking the hassle out of extracting archives";
    homepage = "https://github.com/dtrx-py/dtrx";
    license = licenses.gpl3Plus;
    maintainers = [ ];
  };
}
