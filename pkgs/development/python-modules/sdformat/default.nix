{
  buildPythonPackage,
  python,
  pkgs,
  gz-math,
}:

let
  sdformat = pkgs.sdformat.override { python3Packages = python.pkgs; };
in
buildPythonPackage {
  pname = "sdformat";
  inherit (sdformat) version;
  pyproject = false;

  # The bindings are built by the C++ package; this just places them in
  # site-packages for the selected interpreter.
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/${python.sitePackages}"
    cp -r ${sdformat}/lib/python/. "$out/${python.sitePackages}/"
    runHook postInstall
  '';

  dependencies = [
    gz-math
  ];

  pythonImportsCheck = [
    "sdformat"
  ];

  meta = sdformat.meta // {
    description = "Python bindings for sdformat";
  };
}
