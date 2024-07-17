{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "xcp";
  version = "0.21.2";

  src = fetchFromGitHub {
    owner = "tarka";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dcNnj8j6eItDoP2K33nBPC8kvB9DuHc4/LxsoKF9H/g=";
  };

  # no such file or directory errors
  doCheck = false;

  cargoHash = "sha256-CT3vo5ctgB6kVOGPjMI/tLCvdWvXEFdOWip5nH9fxfo=";

  meta = with lib; {
    description = "Extended cp(1)";
    homepage = "https://github.com/tarka/xcp";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lom ];
    mainProgram = "xcp";
  };
}
