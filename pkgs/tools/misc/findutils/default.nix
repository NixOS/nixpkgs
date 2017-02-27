{ stdenv, fetchurl, coreutils }:

stdenv.mkDerivation rec {
  name = "findutils-4.6.0";

  src = fetchurl {
    url = "mirror://gnu/findutils/${name}.tar.gz";
    sha256 = "178nn4dl7wbcw499czikirnkniwnx36argdnqgz4ik9i6zvwkm6y";
  };

  patches = [ ./memory-leak.patch ./no-install-statedir.patch ];

  buildInputs = [ coreutils ]; # bin/updatedb script needs to call sort

  # Since glibc-2.25 the i686 tests hang reliably right after test-sleep.
  doCheck = !stdenv.isDarwin && (stdenv.system != "i686-linux");

  outputs = [ "out" "info" ];

  configureFlags = [ "--localstatedir=/var/cache" ];

  crossAttrs = {
    # Fix the 'buildInputs = [ coreutils ]' above - that adds the cross coreutils to PATH :(
    propagatedBuildInputs = [ ];
  };

  enableParallelBuilding = true;

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

    platforms = stdenv.lib.platforms.all;

    license = stdenv.lib.licenses.gpl3Plus;
  };
}
