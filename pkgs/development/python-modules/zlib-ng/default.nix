{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, cmake
, setuptools

# native dependencies
, zlib-ng

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zlib-ng";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycompression";
    repo = "python-zlib-ng";
    rev = "v${version}";
    hash = "sha256-dZnX94SOuV1/zTYUecnRe6DDKf5nAvydHn7gESVQ6hs=";
  };

  nativeBuildInputs = [
    cmake
    setuptools
  ];

  dontUseCmakeConfigure = true;

  env.PYTHON_ZLIB_NG_LINK_DYNAMIC = true;

  buildInputs = [
    zlib-ng
  ];

  pythonImportsCheck = [
    "zlib_ng"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    rm -rf src
  '';

  meta = with lib; {
    description = "A drop-in replacement for Python's zlib and gzip modules using zlib-ng";
    homepage = "https://github.com/pycompression/python-zlib-ng";
    changelog = "https://github.com/pycompression/python-zlib-ng/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.psfl;
    maintainers = with maintainers; [ hexa ];
  };
}
