{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "rogue";
  version = "5.4.4";

  src = fetchurl {
    urls = [
      "https://src.fedoraproject.org/repo/pkgs/rogue/rogue${version}-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue${version}-src.tar.gz"
      "http://ftp.vim.org/ftp/pub/ftp/os/Linux/distr/slitaz/sources/packages-cooking/r/rogue${version}-src.tar.gz"
      "http://rogue.rogueforge.net/files/rogue${lib.versions.majorMinor version}/rogue${version}-src.tar.gz"
    ];
    sha256 = "18g81274d0f7sr04p7h7irz0d53j6kd9j1y3zbka1gcqq0gscdvx";
  };

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "http://rogue.rogueforge.net/rogue-5-4/";
    description = "Final version of the original Rogue game developed for the UNIX operating system";
    mainProgram = "rogue";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
