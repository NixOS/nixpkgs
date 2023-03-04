{ lib, fetchFromGitHub, rtmpdump, php, wget, python3Packages, ffmpeg
, testers, yle-dl
}:

python3Packages.buildPythonApplication rec {
  pname = "yle-dl";
  version = "20220830";

  src = fetchFromGitHub {
    owner = "aajanki";
    repo = "yle-dl";
    rev = version;
    hash = "sha256-pQIe5kYsiK1tHx3hx4bgpS5UwuBrEyX3SBMLwSjxXc4=";
  };

  propagatedBuildInputs = with python3Packages; [
    attrs configargparse ffmpeg future lxml requests
  ];
  pythonPath = [ rtmpdump php wget ];

  doCheck = false; # tests require network access
  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  passthru.tests.version = testers.testVersion {
    package = yle-dl;
    command = "yle-dl -h";
  };

  meta = with lib; {
    description = "Downloads videos from Yle (Finnish Broadcasting Company) servers";
    homepage = "https://aajanki.github.io/yle-dl/";
    changelog = "https://github.com/aajanki/yle-dl/blob/${version}/ChangeLog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dezgeg ];
    platforms = platforms.unix;
  };
}
