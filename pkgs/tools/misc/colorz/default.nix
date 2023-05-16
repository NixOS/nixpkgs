<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "colorz";
  version = "1.0.3";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "0ghd90lgplf051fs5n5bb42zffd3fqpgzkbv6bhjw7r8jqwgcky0";
  };

  propagatedBuildInputs = with python3Packages; [ pillow scipy ];

  checkPhase = ''
    $out/bin/colorz --help > /dev/null
  '';

  meta = with lib; {
    description = "Color scheme generator";
    homepage = "https://github.com/metakirby5/colorz";
    license = licenses.mit;
    maintainers = with maintainers; [ skykanin ];
  };
}
