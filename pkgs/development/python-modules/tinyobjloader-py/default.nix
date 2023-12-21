{ lib, buildPythonPackage, pybind11, tinyobjloader }:

buildPythonPackage rec {
  pname = "tinyobjloader-py";
  inherit (tinyobjloader) version src;

  # Build needs headers from ${src}, setting sourceRoot or fetching from pypi won't work.
  preConfigure = ''
    cd python
  '';

  buildInputs = [ pybind11 ];

  # No tests are included upstream
  doCheck = false;
  pythonImportsCheck = [ "tinyobjloader" ];

  meta = with lib; tinyobjloader.meta // {
    description = "Python wrapper for the C++ wavefront .obj loader tinyobjloader";
  };
}
