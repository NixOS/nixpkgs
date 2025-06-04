{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  clang-tools,
  cmake,
  colordiff,
  flex,
  libclang,
  llvm,
  unifdef,
  chardet,
  pebble,
  psutil,
  pytestCheckHook,
}:

buildPythonApplication rec {
  pname = "cvise";
  version = "2.11.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    tag = "v${version}";
    hash = "sha256-xaX3QMnTKXTXPuLzui0e0WgaQNvbz8u1JNRBkfe4QWg=";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  postPatch = ''
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    substituteInPlace CMakeLists.txt \
      --replace-fail " -Werror " " "

    substituteInPlace cvise/utils/testing.py \
      --replace-fail "'colordiff --version'" "'${colordiff}/bin/colordiff --version'" \
      --replace-fail "'colordiff'" "'${colordiff}/bin/colordiff'"
  '';

  nativeBuildInputs = [
    cmake
    flex
    llvm.dev
  ];

  buildInputs = [
    libclang
    llvm
    llvm.dev
    unifdef
  ];

  propagatedBuildInputs = [
    chardet
    pebble
    psutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    unifdef
  ];

  cmakeFlags = [
    # By default `cvise` looks it up in `llvm` bin directory. But
    # `nixpkgs` moves it into a separate derivation.
    "-DCLANG_FORMAT_PATH=${clang-tools}/bin/clang-format"
  ];

  disabledTests = [
    # Needs gcc, fails when run noninteractively (without tty).
    "test_simple_reduction"
  ];

  meta = with lib; {
    homepage = "https://github.com/marxin/cvise";
    description = "Super-parallel Python port of C-Reduce";
    license = licenses.ncsa;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
