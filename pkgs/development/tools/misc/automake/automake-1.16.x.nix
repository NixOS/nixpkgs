{
  lib,
  stdenv,
  fetchurl,
  perl,
  autoconf,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "automake";
  version = "1.16.5";

  src = fetchurl {
    url = "mirror://gnu/automake/automake-${finalAttrs.version}.tar.xz";
    hash = "sha256-8B1YzW2dd/vcqetLvV6tGYgij9tz1veiAfX41rEYtGk=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    autoconf
    perl
  ];
  buildInputs = [ autoconf ];

  setupHook = ./setup-hook.sh;

  doCheck = false; # takes _a lot_ of time, fails 3 out of 2698 tests, all seem to be related to paths
  doInstallCheck = false; # runs the same thing, fails the same tests

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  __structuredAttrs = true;

  meta = {
    branch = "1.16";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";
    license = lib.licenses.gpl2Plus;
    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';
    platforms = lib.platforms.all;
  };
})
