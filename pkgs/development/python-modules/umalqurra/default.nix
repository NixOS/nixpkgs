{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "umalqurra";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cZ9qNvkIraHCna4Nk03Q8eH24zBXhO2+wjrXGTl95ng=";
  };

  # No tests included
  doCheck = false;

  # See for license
  # https://github.com/tytkal/python-hijiri-ummalqura/issues/4
  meta = with lib; {
    description = "Date Api that support Hijri Umalqurra calendar";
    homepage = "https://github.com/tytkal/python-hijiri-ummalqura";
    license = with licenses; [ publicDomain ];
  };
}
