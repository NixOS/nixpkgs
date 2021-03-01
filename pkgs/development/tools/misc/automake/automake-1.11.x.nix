{ lib, stdenv, fetchurl, perl, autoconf }:

stdenv.mkDerivation rec {
  name = "automake-1.11.6";

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "1ffbc6cc41f0ea6c864fbe9485b981679dc5e350f6c4bc6c3512f5a4226936b5";
  };

  patches = [ ./fix-test-autoconf-2.69.patch ./fix-perl-5.26.patch ];

  buildInputs = [ perl autoconf ];

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";
  doCheck = false; # takes _a lot_ of time, fails 11 of 782 tests

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # Run the test suite in parallel.
  enableParallelBuilding = true;

  # Wrap the given `aclocal' program, appending extra `-I' flags
  # corresponding to the directories listed in $ACLOCAL_PATH.  (Note
  # that `wrapProgram' can't be used for that purpose since it can only
  # prepend flags, not append them.)
  postInstall = ''
    wrapAclocal() {
      local program="$1"
      local wrapped="$(dirname $program)/.$(basename $program)-wrapped"

      mv "$program" "$wrapped"
      cat > "$program"<<EOF
#! $SHELL -e

unset extraFlagsArray
declare -a extraFlagsArray

oldIFS=\$IFS
IFS=:
for dir in \$ACLOCAL_PATH; do
    if test -n "\$dir" -a -d "\$dir"; then
        extraFlagsArray=("\''${extraFlagsArray[@]}" "-I" "\$dir")
    fi
done
IFS=\$oldIFS

exec "$wrapped" "\$@" "\''${extraFlagsArray[@]}"
EOF
      chmod +x "$program"
    }
  '' +
  # Create a wrapper around `aclocal' that converts every element in
  # `ACLOCAL_PATH' into a `-I dir' option.  This way `aclocal'
  # becomes modular; M4 macros do not need to be stored in a single
  # global directory, while callers of `aclocal' do not need to pass
  # `-I' options explicitly.
  ''
    for prog in $out/bin/aclocal*; do
        wrapAclocal "$prog"
    done

    ln -s aclocal-1.11 $out/share/aclocal
    ln -s automake-1.11 $out/share/automake
  '';

  meta = {
    branch = "1.11";
    homepage = "https://www.gnu.org/software/automake/";
    description = "GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.all;
  };
}
