{ stdenv, lib, buildPythonApplication, fetchPypi, fusepy, pyserial }:

buildPythonApplication rec {
  pname = "mpy-utils";
  version = "0.1.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-die8hseaidhs9X7mfFvV8C8zn0uyw08gcHNqmjl+2Z4=";
  };

  propagatedBuildInputs = [ fusepy pyserial ];

  meta = with lib; {
    description = "MicroPython development utility programs";
    homepage = "https://github.com/nickzoic/mpy-utils";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
