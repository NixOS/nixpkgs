{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  psutil,
}:
buildPythonPackage rec {
  pname = "steamworks";
  version = "0-unstable-2023-11-25";

  src = fetchFromGitHub {
    owner = "twstagg";
    repo = "SteamworksPy";
    rev = "2b14087a0aac1cc589ae7c804567414a6cfdcf1c";
    hash = "sha256-sL7AhpEiDGwIbpQcrnVGU2gLoICqJDYvd5V+FEdZ6So=";
  };

  patches = [
    ./fix-setup-version-finder.patch
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    psutil
  ];

  # requires steam to be running for tests
  doCheck = false;

  pythonImportsCheck = ["steamworks"];

  meta = with lib; {
    description = "A working Python API system for Valve's Steamworks";
    homepage = "https://github.com/twstagg/SteamworksPy";
    changelog = "https://github.com/twstagg/SteamworksPy/blob/${src.rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
