{stdenv, fetchurl, m4, perl, lzma}:

stdenv.mkDerivation rec {
  name = "autoconf-2.13";

  src = fetchurl {
    url = "mirror://gnu/autoconf/${name}.tar.gz";
    sha256 = "07krzl4czczdsgzrrw9fiqx35xcf32naf751khg821g5pqv12qgh";
  };

  nativebuildInputs = [ lzma ];
  buildInputs = [ m4 perl ];

  doCheck = true;

  # Don't fixup "#! /bin/sh" in Autoconf, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  postInstall = ''ln -s autoconf "$out"/bin/autoconf-2.13'';

  meta = {
    homepage = https://www.gnu.org/software/autoconf/;
    description = "Part of the GNU Build System";
    branch = "2.13";

    longDescription = ''
      GNU Autoconf is an extensible package of M4 macros that produce
      shell scripts to automatically configure software source code
      packages.  These scripts can adapt the packages to many kinds of
      UNIX-like systems without manual user intervention.  Autoconf
      creates a configuration script for a package from a template
      file that lists the operating system features that the package
      can use, in the form of M4 macro calls.
    '';

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
