{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  altair,
  pandas,
  protobuf,
  psutil,
  pyarrow,
  setuptools,
  setuptools-scm,
  vegafusion-embed,
}:
buildPythonPackage rec {
  pname = "vegafusion";
  version = "1.6.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex-inc";
    repo = "vegafusion";
    rev = "v${version}";
    hash = "sha256-CItZehy5cPIU38dTOBJA5Q6Xp+4R+6OvyxHXS6L/6xc=";
  };

  sourceRoot = "source/python/vegafusion";

  patchPhase = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools_scm >= 2.0.0, <3" "setuptools_scm >= 2.0.0"
  '';

  propagatedBuildInputs = [
    vegafusion-embed
    setuptools
    setuptools-scm
    protobuf
    # Needed for pythonImportsCheck
    pandas
    psutil
    pyarrow
    altair
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vegafusion"
  ];

  meta = {
    description = "Serverside scaling for Vega and Altair visualizations";
    maintainers = with lib.maintainers; [ antonmosich ];
    homepage = "https://github.com/hex-inc/vegafusion";
    license = lib.licenses.bsd3;
  };
}
