{
  lib,
  stdenv,
  fetchFromGitHub,
  flex,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "detox";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "dharple";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cTuK5EIimRVZ1nfuTa1ds6xrawYIAbwNNIkNONd9y4Q=";
  };

  nativeBuildInputs = [
    flex
    autoreconfHook
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/dharple/detox";
    description = "Utility designed to clean up filenames";
    changelog = "https://github.com/dharple/detox/blob/v${version}/CHANGELOG.md";
    longDescription = ''
      Detox is a utility designed to clean up filenames. It replaces
      difficult to work with characters, such as spaces, with standard
      equivalents. It will also clean up filenames with UTF-8 or Latin-1
      (or CP-1252) characters in them.
    '';
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    mainProgram = "detox";
  };
}
