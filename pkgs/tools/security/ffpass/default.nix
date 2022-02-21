{ lib
, stdenv
, fetchFromGitHub
, python37Packages
}:

python37Packages.callPackage ({ buildPythonPackage }:
  buildPythonPackage rec {
    pname = "ffpass";
    version = "0.5.0";
    src = fetchFromGitHub {
      owner = "louisabraham";
      repo = "ffpass";
      rev = "12d6fbaefa48508aadf4dc6d9cb4ea799b9f9dcd";
      sha256 = "sha256-sCg43Eu1PzykbOkMtjfVRNiMbVFThHj4urAQG03JrQk=";
    };
    propagatedBuildInputs = [ python37Packages.pycryptodome python37Packages.pyasn1 ];

    meta = with lib; {
      homepage = "https://github.com/louisabraham/ffpass";
      description = "A tool to import and export Mozilla Firefox passwords";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  }) {}
