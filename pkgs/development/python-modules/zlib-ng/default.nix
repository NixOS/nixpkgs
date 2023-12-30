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
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pycompression";
    repo = "python-zlib-ng";
    rev = "v${version}";
    hash = "sha256-bVdt4GYdbzhoT6et+LOycg0Bt6dX9DtusNr8HPpgIFI=";
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

  disabledTests = [
    # commandline tests fail to find the built module
    "test_compress_fast_best_are_exclusive"
    "test_compress_infile_outfile"
    "test_compress_infile_outfile_default"
    "test_decompress_cannot_have_flags_compression"
    "test_decompress_infile_outfile"
    "test_decompress_infile_outfile_error"
  ];

  meta = with lib; {
    description = "A drop-in replacement for Python's zlib and gzip modules using zlib-ng";
    homepage = "https://github.com/pycompression/python-zlib-ng";
    changelog = "https://github.com/pycompression/python-zlib-ng/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.psfl;
    maintainers = with maintainers; [ hexa ];
  };
}
