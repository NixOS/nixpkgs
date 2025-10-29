{
  stdenv,
  lib,
  buildPythonApplication,
  fetchPypi,
  fusepy,
  pyserial,
}:

buildPythonApplication rec {
  pname = "mpy-utils";
  version = "0.1.13";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-die8hseaidhs9X7mfFvV8C8zn0uyw08gcHNqmjl+2Z4=";
  };

  propagatedBuildInputs = [
    fusepy
    pyserial
  ];

  meta = {
    description = "MicroPython development utility programs";
    homepage = "https://github.com/nickzoic/mpy-utils";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
