{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "valgrind-3.3.0";
  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.3.0.tar.bz2;
    sha256 = "0yllx5a2f5bx18gqz74aikr27zxwpblswn65lqvm9rbzswlq5w2s";
  };

  configureFlags =
    if stdenv.system == "x86_64-linux" then ["--enable-only64bit"] else [];

  meta = {
    homepage = http://www.valgrind.org/;
    description = "Award-winning suite of tools for debugging and profiling Linux programs";
  };
}
