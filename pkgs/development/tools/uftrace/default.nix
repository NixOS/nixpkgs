{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-VK2lERzwsdXVOxgxRAA2RxeqBtOeINJDnsafnn461VQ=";
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
