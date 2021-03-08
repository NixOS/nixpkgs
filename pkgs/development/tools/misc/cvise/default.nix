{ lib, buildPythonApplication, fetchFromGitHub, cmake, flex
, clang-unwrapped, llvm, unifdef
, pebble, psutil, pytestCheckHook, pytest-flake8
}:

buildPythonApplication rec {
  pname = "cvise";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    rev = "v${version}";
    sha256 = "116cicz4d506ds3m9bmnb7f9nkp07hyzcrw29ljhznh1i620msim";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  nativeBuildInputs = [ cmake flex ];
  buildInputs = [ clang-unwrapped llvm unifdef ];
  propagatedBuildInputs = [ pebble psutil ];
  checkInputs = [ pytestCheckHook pytest-flake8 unifdef ];

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
