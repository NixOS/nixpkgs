{ lib
, buildPythonApplication
, fetchFromGitHub
, bash
, cmake
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
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "v${version}";
    sha256 = "0cfzikkhp91hjgxjk3izzczb8d9p8v9zsfyk6iklk92n5qf1aakq";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  postPatch = ''
    # 'cvise --command=...' generates a script with hardcoded shebang.
    substituteInPlace cvise.py \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"

    substituteInPlace setup.cfg \
      --replace "--flake8" ""
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

  preCheck = ''
    patchShebangs cvise.py
  '';

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
