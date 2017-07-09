{
  mkDerivation, lib, fetchgit, fetchpatch,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts
}:

mkDerivation rec {
  name = "kdiff3-${version}";
  version = "1.7.0-2017-02-19";

  src = fetchgit {
    # gitlab is outdated
    url = https://anongit.kde.org/scratch/thomasfischer/kdiff3.git;
    sha256 = "0znlk9m844a6qsskbd898w4yk48dkg5bkqlkd5abvyrk1jipzyy8";
    rev = "0d2ac328164e3cbe2db35875d3df3a86187ae84f";
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

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts ];

  meta = with lib; {
    homepage = http://kdiff3.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ viric peterhoeg ];
    platforms = with platforms; linux;
  };
}
