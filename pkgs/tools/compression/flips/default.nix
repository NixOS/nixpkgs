{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  libdivsufsort,
  pkg-config,
  wrapGAppsHook,
}:

stdenv.mkDerivation {
  pname = "flips";
  version = "unstable-2024-04-17";

  src = fetchFromGitHub {
    owner = "Alcaro";
    repo = "Flips";
    rev = "20b0da9ab95d23da89f821bbddedb11b8e0e6531";
    hash = "sha256-/i/0FvZqMvG4FFIKaOtUe0A5BfG4NXjpBfLYIQOFky8=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];
  buildInputs = [
    gtk3
    libdivsufsort
  ];
  patches = [ ./use-system-libdivsufsort.patch ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  buildPhase = ''
    runHook preBuild
    ./make.sh
    runHook postBuild
  '';

  meta = with lib; {
    description = "A patcher for IPS and BPS files";
    homepage = "https://github.com/Alcaro/Flips";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.jchw ];
    platforms = platforms.linux;
    mainProgram = "flips";
  };
}
