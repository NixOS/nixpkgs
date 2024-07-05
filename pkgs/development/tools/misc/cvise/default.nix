{ lib
, buildPythonApplication
, fetchFromGitHub
, bash
, cmake
, colordiff
, flex
, libclang
, llvm
, unifdef
, chardet
, pebble
, psutil
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "cvise";
  version = "2.10.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "refs/tags/v${version}";
    hash = "sha256-0gk4O1q90eH1FMhj4ncNVqX/MfVyaU0nckh1xny2wlM=";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  postPatch = ''
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    substituteInPlace CMakeLists.txt \
      --replace " -Werror " " "

    substituteInPlace cvise/utils/testing.py \
      --replace "'colordiff --version'" "'${colordiff}/bin/colordiff --version'" \
      --replace "'colordiff'" "'${colordiff}/bin/colordiff'"
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
