{
  lib,
  mkTclDerivation,
  fetchfossil,
}:

mkTclDerivation rec {
  pname = "tcludp";
  version = "1.0.11";

  src = fetchfossil {
    url = "https://core.tcl-lang.org/tcludp";
    rev = "ver_" + lib.replaceStrings [ "." ] [ "_" ] version;
    hash = "sha256-PckGwUqL2r5KJEet8sS4U504G63flX84EkQEkQdMifY=";
  };

  # Add missing pkgIndex.tcl.in
  postPatch = ''
    test ! -e pkgIndex.tcl.in
    cat > pkgIndex.tcl.in <<EOF
    package ifneeded @PACKAGE_NAME@ @PACKAGE_VERSION@ \
    [list load [file join $dir @PKG_LIB_FILE@] @PACKAGE_NAME@]
    EOF
  '';

  # Some tests fail because of the sandbox.
  # However, tcltest always returns exit code 0, so this always succeeds.
  # https://wuhrr.wordpress.com/2013/09/13/tcltest-part-9-provides-exit-code/
  doInstallCheck = true;

  installCheckTarget = "test";

  meta = {
    description = "UDP socket support for Tcl";
    homepage = "https://core.tcl-lang.org/tcludp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
