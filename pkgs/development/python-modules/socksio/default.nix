{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  flit-core,
  pytestCheckHook,
}:

let
  pname = "socksio";
  version = "1.0.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+IvrPaW1w4uYkEad5n0MsPnUlLeLEGyhhF+WwQuRxKw=";
  };

  patches = [
    # https://github.com/sethmlarson/socksio/pull/61
    (fetchpatch {
      name = "unpin-flit-core.patch";
      url = "https://github.com/sethmlarson/socksio/commit/5c50fd76e7459bb822ff8f712172a78e21b8dd04.patch";
      hash = "sha256-VVUzFvF2KCXXkCfCU5xu9acT6OLr+PlQQPeVGONtU4A=";
    })
  ];

  nativeBuildInputs = [ flit-core ];

  # remove coverage configuration
  preCheck = ''
    rm pytest.ini
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Sans-I/O implementation of SOCKS4, SOCKS4A, and SOCKS5";
    homepage = "https://github.com/sethmlarson/socksio";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
