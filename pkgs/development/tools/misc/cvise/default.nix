{ lib, buildPythonApplication, fetchFromGitHub, bash, cmake, flex
, libclang, llvm, unifdef
, pebble, psutil, pytestCheckHook, pytest-flake8
}:

buildPythonApplication rec {
  pname = "cvise";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "v${version}";
    sha256 = "1x2i8nv0nncgvr07znhh2slngbrg8qcsz2zqx76bcyq9hssn6yal";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  nativeBuildInputs = [ cmake flex llvm.dev ];
  buildInputs = [ bash libclang llvm llvm.dev unifdef ];
  propagatedBuildInputs = [ pebble psutil ];
  checkInputs = [ pytestCheckHook pytest-flake8 unifdef ];

  # 'cvise --command=...' generates a script with hardcoded shebang.
  postPatch = ''
    substituteInPlace cvise.py \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
  '';

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
