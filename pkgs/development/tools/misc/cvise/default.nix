{ lib, buildPythonApplication, fetchFromGitHub, bash, cmake, flex
, libclang, llvm, unifdef
, chardet, pebble, psutil
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

  nativeBuildInputs = [ cmake flex llvm.dev ];
  buildInputs = [ bash libclang llvm llvm.dev unifdef ];
  propagatedBuildInputs = [ chardet pebble psutil ];

  # 'cvise --command=...' generates a script with hardcoded shebang.
  postPatch = ''
    substituteInPlace cvise.py \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
  '';

  # pytest-flake8 is broken in nixpkgs: https://github.com/tholo/pytest-flake8/issues/87
  doCheck = false;
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
