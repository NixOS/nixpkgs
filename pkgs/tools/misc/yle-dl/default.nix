{ lib, fetchFromGitHub, rtmpdump, php, wget, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20220213";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    sha256 = "sha256-lFb8NwKg8GBgkVsg01rlGrP31APwhFaCFT7QdqiT6J0=";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs configargparse ffmpeg future lxml requests
  ];
  pythonPath = [ rtmpdump php wget ];

  doCheck = false; # tests require network access
  checkInputs = with python3Packages; [ pytestCheckHook ];

  meta = with lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    changelog = "https://github.com/aajanki/yle-dl/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
