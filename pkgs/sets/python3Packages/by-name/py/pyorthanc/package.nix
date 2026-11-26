{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  httpx2,
  pydicom,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyorthanc";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gacou54";
    repo = "pyorthanc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Know1ciqeqqVatIik5Sv0t1l3PaWQo6Irl0IMm5+gzc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    httpx2
    pydicom
  ];

  doCheck = false; # requires running Orthanc server (available as a NixOS module)

  pythonImportsCheck = [ "pyorthanc" ];

  meta = {
    description = "Python library that wraps the Orthanc REST API";
    homepage = "https://github.com/gacou54/pyorthanc";
    changelog = "https://github.com/gacou54/pyorthanc/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
