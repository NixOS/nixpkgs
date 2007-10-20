{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "which-2.16";
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/which/which-2.17.tar.gz;
    sha256 = "1nnnbn83da8481blmcyv96gm15ccsilr93fmgmwdlzj8a72fjvqp";
  };
}



