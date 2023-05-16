<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "updog";
  version = "1.4";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "7n/ddjF6eJklo+T79+/zBxSHryebc2W9gxwxsb2BbF4=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama flask flask-httpauth werkzeug pyopenssl
  ];

  checkPhase = ''
    $out/bin/updog --help > /dev/null
  '';

  meta = with lib; {
    description = "Updog is a replacement for Python's SimpleHTTPServer";
    homepage = "https://github.com/sc0tfree/updog";
    license = licenses.mit;
    maintainers = with maintainers; [ ethancedwards8 ];
  };
}
