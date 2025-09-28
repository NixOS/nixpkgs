{
  lib,
  buildPythonPackage,
  python,
  sssd,

  # tests
  pytestCheckHook,
}:

let
  sssdForPython = sssd.override {
    python3 = python;
  };
in
buildPythonPackage rec {
  pname = "sss";
  inherit (sssdForPython) version;

  format = "other";
  dontUnpack = true;
  dontBuild = true;

  dependencies = [
    sssdForPython
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}

    cp -r ${sssdForPython}/${python.sitePackages}/SSSDConfig $out/${python.sitePackages}/
    install -m 755 ${sssdForPython}/${python.sitePackages}/*.so $out/${python.sitePackages}/

    runHook postInstall
  '';

  pythonImportsCheck = [
    "sssd"
    "pysss"
    "pysss_murmur"
    "pysss_nss_idmap"
    "pyhbac"
    "SSSDConfig"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python bindings for SSSD (System Security Services Daemon)";
    longDescription = ''
      This package provides Python bindings for SSSD including:
      - sssd: SSSD Python utilities module
      - pysss: Core Python module for SSSD operations
      - pysss_murmur: MurmurHash implementation
      - pysss_nss_idmap: NSS ID mapping functionality
      - pyhbac: HBAC (Host-Based Access Control) module
      - SSSDConfig: Configuration management module
    '';
    inherit (sssd.meta)
      homepage
      changelog
      platforms
      maintainers
      ;
  };
}
