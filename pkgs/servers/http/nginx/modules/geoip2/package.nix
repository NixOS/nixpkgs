{
  fetchFromGitHub,
  lib,
  libmaxminddb,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "geoip2";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "leev";
    repo = "ngx_http_geoip2_module";
    tag = finalAttrs.version;
    hash = "sha256-CAs1JZsHY7RymSBYbumC2BENsXtZP3p4ljH5QKwz5yg=";
  };

  buildInputs = [ libmaxminddb ];

  meta = {
    description = "Creates variables with values from the maxmind geoip2 databases";
    homepage = "https://github.com/leev/ngx_http_geoip2_module";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pinpox ];
  };
})
