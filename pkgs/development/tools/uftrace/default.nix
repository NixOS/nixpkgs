{lib, stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "uftrace";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "sha256-czVKliF9qvA9TG4KJKs2X0VDfJi4vHwbVeuLZViwpdg=";
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
