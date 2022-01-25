{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-uRtMJIZJKGQTGqs8QX60FCeXg3j5hv/V/qw4m8eGYD4=";
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
