{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  python3,
}:

buildFishPlugin {
  pname = "bass";
  version = "1.0-unstable-2023-12-17";

  src = fetchFromGitHub {
    owner = "edc";
    repo = "bass";
    rev = "79b62958ecf4e87334f24d6743e5766475bcf4d0";
    hash = "sha256-3d/qL+hovNA4VMWZ0n1L+dSM1lcz7P5CQJyy+/8exTc=";
  };

  #buildFishplugin will only move the .fish files, but bass also relies on python
  postInstall = ''
    cp functions/__bass.py $out/share/fish/vendor_functions.d/
  '';

  nativeCheckInputs = [ python3 ];
  checkPhase = ''
    make test
  '';

  meta = {
    description = "Fish function making it easy to use utilities written for Bash in Fish shell";
    homepage = "https://github.com/edc/bass";
    license = lib.licenses.mit;
  };
}
