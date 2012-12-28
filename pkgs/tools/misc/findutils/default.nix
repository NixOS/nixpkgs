{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation rec {
  name = "findutils-4.4.2";

  src = fetchurl {
    url = "mirror://gnu/findutils/${name}.tar.gz";
    sha256 = "0amn0bbwqvsvvsh6drfwz20ydc2czk374lzw5kksbh6bf78k4ks3";
  };

  nativeBuildInputs = [coreutils];

  patches = [ ./findutils-path.patch ./change_echo_path.patch ];

  doCheck = true;

  crossAttrs = {
    # http://osdir.com/ml/bug-findutils-gnu/2009-08/msg00026.html
    configureFlags = [ "gl_cv_func_wcwidth_works=yes" ];
  };

  meta = {
    homepage = http://www.gnu.org/software/findutils/;
    description = "GNU Find Utilities, the basic directory searching utilities of the GNU operating system";

    longDescription = ''
      The GNU Find Utilities are the basic directory searching
      utilities of the GNU operating system.  These programs are
      typically used in conjunction with other programs to provide
      modular and powerful directory search and file locating
      capabilities to other commands.

      The tools supplied with this package are:

          * find - search for files in a directory hierarchy;
          * locate - list files in databases that match a pattern;
          * updatedb - update a file name database;
          * xargs - build and execute command lines from standard input.
    '';

    license = "GPLv3+";
  };
}
