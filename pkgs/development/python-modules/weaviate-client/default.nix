{ lib, buildPythonPackage, fetchPypi, authlib, tqdm, validators }:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "3.18.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QjpSZRijJQXFKTMo5fJS5su/IOSzEkcz9w0Q/A1oI8k=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "validators>=0.18.2,<0.20.0" "validators>=0.18.2,<0.21.0"
  '';

  propagatedBuildInputs = [ authlib tqdm validators ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/weaviate/weaviate-python-client";
    description = "A python native client for easy interaction with a Weaviate instance.";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
