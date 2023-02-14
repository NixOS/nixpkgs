{ lib
, buildPythonPackage
, fetchPypi

# from requirements.txt
, numpy
, pillow
, requests
, tqdm
, pydantic
, typing-extensions
, types-pillow
, types-requests
}:

buildPythonPackage rec {
  pname = "segments-ai";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Bd9oKWs+iT4otezQ+VSh3rfv+pDrRME2QIyehPaLWgM=";
  };

  propagatedBuildInputs = [
    numpy
    pillow
    requests
    tqdm
    pydantic
    typing-extensions
    types-pillow
    types-requests
  ];

  # tests are not published to pypi
  doCheck = false;

  pythonImportsCheck = [ "segments" ];

  meta = with lib; {
    description = "A training data platform for computer vision engineers and labeling teams";
    homepage = "https://github.com/segments-ai/segments-ai";
    license = licenses.mit;
    maintainers = with maintainers; [ rehno-lindeque ];
  };
}
