<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "moodle-dl";
  version = "2.2.2.4";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-76JU/uYJH7nVWCR+d8vvjYCCSMfe/8R9l756AmzZPHU=";
  };

  propagatedBuildInputs = with python3Packages; [
    sentry-sdk
    colorama
    yt-dlp
    certifi
    html2text
    requests
    aioxmpp
  ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/C0D3D3V/Moodle-Downloader-2";
    maintainers = [ maintainers.kmein ];
    description = "A Moodle downloader that downloads course content fast from Moodle";
    license = licenses.gpl3Plus;
  };
}
