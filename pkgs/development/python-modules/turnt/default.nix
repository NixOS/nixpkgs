{ lib
, buildPythonPackage
, fetchpatch
, fetchPypi
, click
, flit-core
, tomli
}:

buildPythonPackage rec {
  pname = "turnt";
  version = "1.11.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XN+qzRgZMSdeBmW0OM36mQ79sRCuP8E++SqH8FOoEq0=";
  };

  patches = [
    # https://github.com/cucapra/turnt/pull/31
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/cucapra/turnt/commit/7c04ee5997987ce27370a19005eb3473d2a45273.patch";
      hash = "sha256-oVnYy0IuEWgDNdzxYLcpC53pdY+7fq1kGgRjuLqs/3I=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    click
    tomli
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    $out/bin/turnt test/*/*.t
    runHook postCheck
  '';

  pythonImportsCheck = [ "turnt" ];

  meta = with lib; {
    description = "Snapshot testing tool";
    homepage = "https://github.com/cucapra/turnt";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
  };
}
