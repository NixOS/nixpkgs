{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  zlib,
}:
buildPythonPackage rec {
  pname = "zlib-state";
  version = "0.1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "seanmacavaney";
    repo = "zlib-state";
    rev = "v${version}";
    hash = "sha256-KOlBBJ9ivRjocftSYAGGHiViAcvAXWBv34FgMOKwu2s=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ zlib ];

  # Tell setuptools where to find zlib
  buildInputs = [ zlib ];
  NIX_CFLAGS_COMPILE = "-I${zlib.dev}/include";
  NIX_LDFLAGS = "-L${zlib.out}/lib";

  pythonImportsCheck = [ "zlib_state" ];

  meta = {
    description = "Low-level interface to the zlib library that enables capturing the decoding state";
    homepage = "https://github.com/seanmacavaney/zlib-state";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gurjaka ];
    mainProgram = "zlib-state";
  };
}
