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
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Nt6Zs3FxO8Ti+ikVPVaMCejzBIuUxrzG4VLhChCSJQw=";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  postPatch = ''
    # 'cvise --command=...' generates a script with hardcoded shebang.
    substituteInPlace cvise.py \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"

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

  checkInputs = [
    pytestCheckHook
    unifdef
  ];

  disabledTests = [
    # Needs gcc, fails when run noninteractively (without tty).
    "test_simple_reduction"
  ];

  dontUsePipInstall = true;
  dontUseSetuptoolsBuild = true;
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    homepage = "https://github.com/marxin/cvise";
    description = "Super-parallel Python port of C-Reduce";
    license = licenses.ncsa;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
