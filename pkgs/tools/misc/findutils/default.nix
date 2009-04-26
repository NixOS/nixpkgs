{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation rec {
  name = "findutils-4.4.1";

  src = fetchurl {
    url = "mirror://gnu/findutils/${name}.tar.gz";
    sha256 = "0f61phan4q8w5i1lz768q973c1spfqgvc470jc89rpg0gxfvi9bp";
  };

  buildInputs = [coreutils];

  patches = [ ./findutils-path.patch ./change_echo_path.patch ]
    # Note: the dietlibc patch is just to get findutils to compile.
    # The locate command probably won't work though.
    ++ stdenv.lib.optional (stdenv ? isDietLibC) ./dietlibc-hack.patch;

  doCheck = true;

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
