{
  lib,
  stdenv,
  fetchFromSavannah,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "gnulib";
  version = "20231109";

  src = fetchFromSavannah {
    repo = "gnulib";
    rev = "2dd1a7984c6b3e6056cef7e3f9933e0039c21634";
    hash = "sha256-QtWf3mljEnr0TTogkoKN63Y5HTm14A2e/sIXX3xe2SE=";
  };

  postPatch = ''
    patchShebangs gnulib-tool.py
  '';

  buildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # do not change headers to not update all vendored build files
  dontFixup = true;

  passthru = {
    # This patch is used by multiple other packages (currently:
    # gnused, gettext) which contain vendored copies of gnulib.
    # Without it, compilation will fail with error messages about
    # "__LDBL_REDIR1_DECL" or similar on platforms with longdouble
    # redirects (currently powerpc64).  Once all of those other
    # packages make a release with a newer gnulib we can drop this
    # patch.
    longdouble-redirect-patch = ./gnulib-longdouble-redirect.patch;
  };

  meta = with lib; {
    description = "Central location for code to be shared among GNU packages";
    homepage = "https://www.gnu.org/software/gnulib/";
    changelog = "https://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=blob;f=ChangeLog";
    license = licenses.gpl3Plus;
    mainProgram = "gnulib-tool";
    platforms = platforms.unix;
  };
}
