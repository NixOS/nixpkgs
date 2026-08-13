{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "yt-dlp-dearrow";
  version = "2023.01.01-unstable-2024-01-13"; # setup.cfg
  pyproject = true;

  src = fetchFromGitHub {
    owner = "QuantumWarpCode";
    repo = "yt-dlp-dearrow";
    rev = "2e46eca7b2242d8c9765bf2d12f92270b694be64"; # no tags
    hash = "sha256-Ubi1kn/1FqkuwnxToBuSsAfCYWiNCTl/EUD8eeG3MSY=";
  };

  build-system = [ setuptools ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "yt_dlp_plugins" ];

  meta = {
    description = "Post-processor plugin to use DeArrow video titles in YT-DLP";
    homepage = "https://github.com/QuantumWarpCode/yt-dlp-dearrow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
