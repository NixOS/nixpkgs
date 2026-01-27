{
  buildPythonPackage,
  sherpa-onnx,
  ml-dtypes,
  numpy,
  protobuf,
  typing-extensions,
}:
buildPythonPackage {
  inherit (sherpa-onnx)
    pname
    version
    src
    ;
  format = "wheel";

  dontUseWheelUnpack = true;

  buildInputs = [
    sherpa-onnx
  ];

  dependencies = [
    sherpa-onnx
    ml-dtypes
    numpy
    protobuf
    typing-extensions
  ];

  postUnpack = ''
    cp -rv "${sherpa-onnx.python}" "$sourceRoot/dist"
    chmod +w "$sourceRoot/dist"
  '';

  # The executables are just utility scripts that aren't too important
  postInstall = ''
    rm -rv $out/bin
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sherpa_onnx" ];

  meta = {
    # Explicitly inherit from ONNX's meta to avoid pulling in attributes added by stdenv.mkDerivation.
    inherit (sherpa-onnx.meta)
      changelog
      description
      homepage
      license
      maintainers
      ;
  };
}
