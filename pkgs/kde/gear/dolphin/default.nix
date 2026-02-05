{
  mkKdeDerivation,
  qtmultimedia,
}:
mkKdeDerivation {
  pname = "dolphin";
  patches = [
    # backported fix for https://bugs.kde.org/show_bug.cgi?id=451050
    ./dolphin-samba-crash-fix.patch
  ];
  extraBuildInputs = [ qtmultimedia ];
}
