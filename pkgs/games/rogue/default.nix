{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "rogue-5.4.4";

  src = fetchurl {
    urls = [
      "http://src.fedoraproject.org/repo/pkgs/rogue/rogue5.4.4-src.tar.gz/033288f46444b06814c81ea69d96e075/rogue5.4.4-src.tar.gz"
      "http://ftp.vim.org/ftp/pub/ftp/os/Linux/distr/slitaz/sources/packages-cooking/r/rogue5.4.4-src.tar.gz"
      "http://rogue.rogueforge.net/files/rogue5.4/rogue5.4.4-src.tar.gz"
    ];
    sha256 = "18g81274d0f7sr04p7h7irz0d53j6kd9j1y3zbka1gcqq0gscdvx";
  };

  buildInputs = [ ncurses ];

  meta = {
    homepage = http://rogue.rogueforge.net/rogue-5-4/;
    description = "The final version of the original Rogue game developed for the UNIX operating system";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.eelco ];
  };
}
