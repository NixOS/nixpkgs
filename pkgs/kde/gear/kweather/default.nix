{
  mkKdeDerivation,
  qtsvg,
  qtcharts,
  qqc2-desktop-style,
  kholidays,
  python3,
}:
mkKdeDerivation {
  pname = "kweather";

  extraBuildInputs = [qtsvg qtcharts qqc2-desktop-style kholidays python3];
  meta.mainProgram = "kweather";
}
