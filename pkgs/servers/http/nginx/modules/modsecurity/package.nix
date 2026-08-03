{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  curl,
  geoip,
  libmodsecurity,
  libxml2,
  lmdb,
  yajl,
}:

mkNginxPlugin (finalAttrs: {
  pname = "modsecurity";
  version = "1.0.3-unstable-2025-02-17";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "ModSecurity-nginx";
    rev = "0b4f0cf38502f34a30c8543039f345cfc075670d";
    hash = "sha256-P3IwKFR4NbaMXYY+O9OHfZWzka4M/wr8sJpX94LzQTU=";
  };

  buildInputs = [
    curl
    geoip
    libmodsecurity
    libxml2
    lmdb
    yajl
  ];

  meta = {
    description = "Open source, cross platform web application firewall (WAF)";
    homepage = "https://github.com/owasp-modsecurity/ModSecurity";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
