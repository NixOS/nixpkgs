{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, argcomplete
, requests
, gnupg
}:

buildPythonPackage rec {
  pname = "sdkmanager";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitLab {
    owner = "fdroid";
    repo = pname;
    rev = version;
    hash = "sha256-EQ24OjQZr42C1PFtIXr4yFzYb/M4Tatqu8Zo+9dgtEE=";
  };

  propagatedBuildInputs = [
    argcomplete
    requests
  ];

  postInstall = ''
    wrapProgram $out/bin/sdkmanager \
      --suffix PATH : ${lib.makeBinPath [ gnupg ]}
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "sdkmanager" ];

  meta = with lib; {
    homepage = "https://gitlab.com/fdroid/sdkmanager";
    description = "A drop-in replacement for sdkmanager from the Android SDK written in Python";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ linsui ];
  };
}
