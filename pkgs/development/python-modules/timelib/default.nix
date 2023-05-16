{ lib
, buildPythonPackage
<<<<<<< HEAD
, cython
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, fetchPypi
}:

buildPythonPackage rec {
  pname = "timelib";
<<<<<<< HEAD
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0bInBlVxhuYFjaiLoPhYN0AbKuneFX9ZNT3JeNglGHo=";
  };

  nativeBuildInputs = [
    cython
  ];

=======
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6ac9f79b09b63bbc07db88525c1f62de1f6d50b0fd9937a0cb05e3d38ce0af45";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Parse english textual date descriptions";
    homepage = "https://github.com/pediapress/timelib/";
    license = licenses.zlib;
  };

}
