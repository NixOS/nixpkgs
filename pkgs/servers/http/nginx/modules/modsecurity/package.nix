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
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "owasp-modsecurity";
    repo = "ModSecurity-nginx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pOHn4lHISqRspbRxtB4XpbEydeKVlXpvEVHzSbuLp/s=";
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
    homepage = "https://github.com/owasp-modsecurity/ModSecurity-nginx";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
