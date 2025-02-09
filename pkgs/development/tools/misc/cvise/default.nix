{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
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
  version = "2.9.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "refs/tags/v${version}";
    hash = "sha256-4LEKVh3jNU3xOq75+IQezjhbL/6uAGQ3r0Au2cxx1WA=";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch

    # Refer to shell via /usr/bin/env:
    #   https://github.com/marxin/cvise/pull/121
    (fetchpatch {
      name = "env-shell.patch";
      url = "https://github.com/marxin/cvise/commit/6a416eb590be978a2ad25c610974fdde84e88651.patch";
      hash = "sha256-Kn6+TXP+wJpMs6jrgsa9OwjXf6vmIgGzny8jg3dfKWA=";
    })
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
