{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
  python3,
}:

buildFishPlugin rec {
  pname = "bass";
  version = "unstable-2021-02-18";

  src = fetchFromGitHub {
    owner = "edc";
    repo = pname;
    rev = "2fd3d2157d5271ca3575b13daec975ca4c10577a";
    sha256 = "0mb01y1d0g8ilsr5m8a71j6xmqlyhf8w4xjf00wkk8k41cz3ypky";
  };

  #buildFishplugin will only move the .fish files, but bass also relies on python
  postInstall = ''
    cp functions/__bass.py $out/share/fish/vendor_functions.d/
  '';

  nativeCheckInputs = [ python3 ];
  checkPhase = ''
    make test
  '';

  meta = with lib; {
    description = "Fish function making it easy to use utilities written for Bash in Fish shell";
    homepage = "https://github.com/edc/bass";
    license = licenses.mit;
    maintainers = with maintainers; [ beezow ];
  };
}
