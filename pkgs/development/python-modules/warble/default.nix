{ lib
, buildPythonPackage
, fetchPypi
, gcc
, cython
, libcxx
, boost
, bluez
}:

buildPythonPackage rec {
  pname = "warble";
  version = "1.2.9";
  format = "setuptools";

  enableParallelBuilding = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oezcRD1AddWmDYDxueE0EwK0+UN/EZ5GQxwkdCz4xoY=";
  };

  nativeBuildInputs = [
    gcc
    cython
  ];

  buildInputs = [
    libcxx
    boost
    bluez
  ];

  pythonImportsCheck = [ "mbientlab" "mbientlab.warble" ];

  meta = with lib; {
    description = "Python bindings for MbientLab's Warble library";
    homepage = "https://github.com/mbientlab/pywarble";
    license = with licenses; [ unfree ];
    maintainers = with maintainers; [ stepbrobd ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
