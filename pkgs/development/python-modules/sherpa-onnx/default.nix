{
  buildPythonPackage,
  sherpa-onnx,
  numpy,
  python,
}:

buildPythonPackage {
  pname = "sherpa-onnx";
  inherit (sherpa-onnx) version;
  pyproject = false;

  src = sherpa-onnx.python;

  dependencies = [ numpy ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp -Rv * $out/${python.sitePackages}/

    runHook postInstall
  '';

  pythonImportsCheck = [ "sherpa_onnx" ];

  meta = removeAttrs sherpa-onnx.meta [ "mainProgram" ] // {
    description = "Python bindings for sherpa-onnx speech recognition";
  };
}
