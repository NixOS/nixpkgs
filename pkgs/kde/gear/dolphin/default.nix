{
  mkKdeDerivation,
  fetchpatch,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "dolphin";
  patches = [
    # https://kde.org/info/security/advisory-20260427-2.txt
    (fetchpatch {
      url = "https://invent.kde.org/system/dolphin/-/commit/42f099a5ba10e8948cae8f7e364c94129131326c.diff";
      hash = "sha256-DethSnRpjD2rado9/Isdod6fl4hfH3rvL7Pfr+mZ5QU=";
    })
    # backported fix for https://bugs.kde.org/show_bug.cgi?id=451050
    ./dolphin-samba-crash-fix.patch
  ];
  extraBuildInputs = [ qtmultimedia ];
}
