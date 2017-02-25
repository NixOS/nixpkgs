{
  kdeDerivation, kdeWrapper, lib, fetchgit,
  ecm, kdoctools, kconfig, kinit, kparts
}:

let
  rev = "468652ce70b1214842cef0a021c81d056ec6aa01";

  unwrapped = kdeDerivation rec {
    name = "kdiff3-${version}";
    version = "1.7.0-${lib.strings.substring 0 7 rev}";

    src = fetchgit {
      url = "https://gitlab.com/tfischer/kdiff3";
      sha256 = "126xl7jbb26v2970ba1rw1d6clhd14p1f2avcwvj8wzqmniq5y5m";
      inherit rev;
    };

    preConfigure = "cd kdiff3";

    nativeBuildInputs = [ ecm kdoctools ];

    propagatedBuildInputs = [ kconfig kinit kparts ];

    meta = with lib; {
      homepage = http://kdiff3.sourceforge.net/;
      license = licenses.gpl2Plus;
      description = "Compares and merges 2 or 3 files or directories";
      maintainers = with maintainers; [ viric urkud peterhoeg ];
      platforms = with platforms; linux;
    };
  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kdiff3" ];
}
