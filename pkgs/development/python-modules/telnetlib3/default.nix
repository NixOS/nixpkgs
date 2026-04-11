{
  addBinToPathHook,
  blessed,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pexpect,
  prettytable,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  trustme,
  wcwidth,
}:

buildPythonPackage (finalAttrs: {
  pname = "telnetlib3";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jquast";
    repo = "telnetlib3";
    tag = finalAttrs.version;
    hash = "sha256-dKvdg+1l7qRyc7COR0U6SKbrp5uJRtc4wsDPQEAkXZ8=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "wcwidth"
  ];

  dependencies = [
    blessed
    wcwidth
  ];

  optional-dependencies = {
    extras = [
      prettytable
      # FIXME package ucs-detect
    ];
  };

  pythonImportsCheck = [ "telnetlib3" ];

  nativeCheckInputs = [
    addBinToPathHook
    pexpect
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    trustme
  ];

  meta = {
    changelog = "https://github.com/jquast/telnetlib3/blob/${finalAttrs.src.tag}/docs/history.rst";
    description = "Feature-rich Telnet Server, Client, and Protocol library for Python";
    homepage = "https://github.com/jquast/telnetlib3";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
