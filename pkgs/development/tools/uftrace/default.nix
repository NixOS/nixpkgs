{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-hpEExyvazCH+lNTK0Ej0zbnWyX0gVLPjM9XfOuAueis=";
  };

  postUnpack = ''
        patchShebangs .
  '';

  meta = {
    description = "Function (graph) tracer for user-space";
    homepage = "https://github.com/namhyung/uftrace";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [lib.maintainers.nthorne];
  };
}
