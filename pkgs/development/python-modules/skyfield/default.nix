{ lib, buildPythonPackage, fetchFromGitHub, certifi, numpy, sgp4, jplephem
, pandas, ipython, matplotlib, assay
}:

buildPythonPackage rec {
  pname = "skyfield";
  version = "1.42";

  src = fetchFromGitHub {
    owner = "skyfielders";
    repo = "python-skyfield";
    rev = version;
    hash = "sha256-aoSkuLhZcEy+13EJQOBHV2/rgmN6aZQHqfj4OOirOG0=";
  };

  propagatedBuildInputs = [ certifi numpy sgp4 jplephem ];

  nativeCheckInputs = [ pandas ipython matplotlib assay ];

  checkPhase = ''
    runHook preCheck

    cd ci
    assay --batch skyfield.tests

    runHook postCheck
  '';

  pythonImportsCheck = [ "skyfield" ];

  meta = with lib; {
    homepage = "https://github.com/skyfielders/python-skyfield";
    description = "Elegant astronomy for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ zane ];
  };
}
