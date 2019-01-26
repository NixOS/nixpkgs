{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
  name = "uftrace-${version}";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "namhyung";
    repo = "uftrace";
    rev = "v${version}";
    sha256 = "1jb4dp6crvfzxzmi5iflc7p13b7p2v1djyj6smbf9ns4wr515y6b";
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
