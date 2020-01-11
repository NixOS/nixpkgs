{stdenv, fetchFromGitHub, autoreconfHook, pandoc, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "jo";
  version = "1.3";

  src = fetchFromGitHub {
    owner  = "jpmens";
    repo = "jo";
    rev = version;
    sha256 ="11miqg0i83drwkn66b4333vhfdw62al11dyfgp30alg6pcab3icl";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pandoc pkgconfig ];

  meta = with stdenv.lib; {
    description = "A small utility to create JSON objects";
    homepage = https://github.com/jpmens/jo;
    license = licenses.gpl2Plus;
    maintainers = [maintainers.markus1189];
    platforms = platforms.all;
  };
}
