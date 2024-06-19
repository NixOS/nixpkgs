{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  requests,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage {
  pname = "smpp-pdu";
  version = "unstable-2022-09-02";
  format = "pyproject";

  # Upstream was once mozes/smpp.pdu, but it's dead and Python 2 only.
  src = fetchFromGitHub {
    owner = "hologram-io";
    repo = "smpp.pdu";
    rev = "20acc840ded958898eeb35ae9a18df9b29bdaaac";
    hash = "sha256-/icVexc2S8sbJqn4ioeIhYxyDFIENuCfsFhl0uAHa9g=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "smpp.pdu" ];

  meta = with lib; {
    description = "Library for parsing Protocol Data Units (PDUs) in SMPP protocol";
    homepage = "https://github.com/hologram-io/smpp.pdu";
    license = licenses.asl20;
    maintainers = with maintainers; [
      flokli
      janik
    ];
  };
}
