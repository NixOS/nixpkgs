{ lib
, buildPythonPackage
, fetchFromGitHub
, cffi
, hypothesis
}:

buildPythonPackage rec {
  pname = "zstandard";
  version = "0.16.0";

  src = fetchFromGitHub {
     owner = "indygreg";
     repo = "python-zstandard";
     rev = "0.16.0";
     sha256 = "0ca26anlb4kkl98hm02nxcn9ldfl03c97wz7nkwgd2yas34fh67d";
  };

  propagatedNativeBuildInputs = [ cffi ];

  propagatedBuildInputs = [ cffi ];

  checkInputs = [ hypothesis ];

  meta = with lib; {
    description = "zstandard bindings for Python";
    homepage = "https://github.com/indygreg/python-zstandard";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
