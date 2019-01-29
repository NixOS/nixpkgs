{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "uftrace-${version}";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "0s7yfnf7kcqlfw3zzv4y8akkd12f8di69c4sranympnl7z5srfam";
  };

  postUnpack = ''
        patchShebangs .
  '';

  meta = {
    description = "Function (graph) tracer for user-space";
    homepage = https://github.com/namhyung/uftrace;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [stdenv.lib.maintainers.nthorne];
  };
}
