{
  kdeDerivation, kdeWrapper, lib, fetchgit, fetchpatch,
  extra-cmake-modules, kdoctools, kconfig, kinit, kparts
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

    setSourceRoot = ''sourceRoot="$(echo */kdiff3/)"'';

    patches = [
      (fetchpatch {
        name = "git-mergetool.diff"; # see https://gitlab.com/tfischer/kdiff3/merge_requests/2
        url = "https://gitlab.com/vcunat/kdiff3/commit/6106126216.patch";
        sha256 = "16xqc24y8bg8gzkdbwapiwi68rzqnkpz4hgn586mi01ngig2fd7y";
      })
    ];
    patchFlags = "-p 2";

    postPatch = ''
      sed -re "s/(p\\[[^]]+] *== *)('([^']|\\\\')+')/\\1QChar(\\2)/g" -i src/diff.cpp
    '';

    nativeBuildInputs = [ extra-cmake-modules kdoctools ];

    propagatedBuildInputs = [ kconfig kinit kparts ];

    enableParallelBuilding = true;

    meta = with lib; {
      homepage = http://kdiff3.sourceforge.net/;
      license = licenses.gpl2Plus;
      description = "Compares and merges 2 or 3 files or directories";
      maintainers = with maintainers; [ viric peterhoeg ];
      platforms = with platforms; linux;
    };
  };

in kdeWrapper {
  inherit unwrapped;
  targets = [ "bin/kdiff3" ];
}
