{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "diffstat";
  version = "1.66";

  src = fetchurl {
    urls = [
      "ftp://ftp.invisible-island.net/diffstat/diffstat-${version}.tgz"
      "https://invisible-mirror.net/archives/diffstat/diffstat-${version}.tgz"
    ];
    sha256 = "sha256-9UUxu+Mujg+kYfAYtB469Ra2MggBcvNh8F5QNn7Ltp4=";
  };

  meta = with lib; {
    description = "Read output of diff and display a histogram of the changes";
    mainProgram = "diffstat";
    longDescription = ''
      diffstat reads the output of diff and displays a histogram of the
      insertions, deletions, and modifications per-file. It is useful for
      reviewing large, complex patch files.
    '';
    homepage = "https://invisible-island.net/diffstat/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
