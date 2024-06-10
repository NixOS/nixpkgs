{
  mkKdeDerivation,
  python3,
  libxml2,
}:
mkKdeDerivation {
  pname = "breeze-icons";

  extraNativeBuildInputs = [
    (python3.withPackages (ps: [ps.lxml]))
    libxml2
  ];

  # lots of icons, takes forever, does absolutely nothing
  dontStrip = true;
}
