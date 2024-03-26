{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-FfTt1S7X7FakKXWbmJJ1HMYcu/tG/UFknz8XmEPbPUo=";
  };

  postUnpack = ''
        patchShebangs .
  '';

  meta = {
    description = "Function (graph) tracer for user-space";
    mainProgram = "uftrace";
    homepage = "https://github.com/namhyung/uftrace";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [lib.maintainers.nthorne];
  };
}
