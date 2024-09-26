{
  mkKdeDerivation,
  shared-mime-info,
  libxslt,
}:
mkKdeDerivation {
  pname = "akonadi-mime";

  extraNativeBuildInputs = [
    shared-mime-info
    libxslt
  ];
}
