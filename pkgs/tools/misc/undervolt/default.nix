{ stdenv, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication rec {
  pname = "undervolt";
  version = "0.2.5";

  src = fetchFromGitHub rec {
    owner = "georgewhewell";
    repo = pname;
    rev = version;
    sha256 = "0saqd8qs3c39bsjnm6yw1l90ns9jrvnbrgygw17bnylz2vcw1ml7";
  };

  meta = with stdenv.lib; {
    description = ''
      Undervolt Intel CPUs under Linux
    '';
    homepage = https://github.com/georgewhewell/undervolt;
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [
      eadwu
    ];
  };
}
