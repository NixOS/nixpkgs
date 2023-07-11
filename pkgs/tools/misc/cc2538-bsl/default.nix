{ lib, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "cc2538-bsl";
  version = "unstable-2022-08-03";

  src = fetchFromGitHub rec {
    owner = "JelmerT";
    repo = pname;
    rev = "538ea0deb99530e28fdf1b454e9c9d79d85a3970";
    hash = "sha256-fPY12kValxbJORi9xNyxzwkGpD9F9u3M1+aa9IlSiaE=";
  };

  nativeBuildInputs = [ python3Packages.setuptools-scm ];

  propagatedBuildInputs = with python3Packages; [
    intelhex
    pyserial
    python-magic
  ];

  env.SETUPTOOLS_SCM_PRETEND_VERSION = "0.1.dev0+g${lib.substring 0 7 src.rev}";

  postInstall = ''
    # Remove .py from binary
    mv $out/bin/cc2538-bsl.py $out/bin/cc2538-bsl
  '';

  meta = with lib; {
    homepage = "https://github.com/JelmerT/cc2538-bsl";
    description = "Flash TI SimpleLink chips (CC2538, CC13xx, CC26xx) over serial";
    license = licenses.bsd3;
    maintainers = with maintainers; [ lorenz ];
  };
}

