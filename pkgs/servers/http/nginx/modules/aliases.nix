# Removed or renamed nginx modules

self: {
  # keep-sorted start case=no numeric=yes block=yes

  fastcgi-cache-purge = throw "fastcgi-cache-purge was renamed to cache-purge";
  http_proxy_connect_module_v24 = throw "http_proxy_connect_module_v24 was removed because it was not compatible with any supported nginx version"; # Added 2026-07-29
  http_proxy_connect_module_v25 = throw "http_proxy_connect_module_v25 was removed because it was not compatible with any supported nginx version"; # Added 2026-07-29
  modsecurity-nginx = self.modsecurity;
  ngx_aws_auth = throw "ngx_aws_auth was renamed to aws-auth";
  opentracing = throw "opentracing-cpp was removed because opentracing as been archived upstream"; # Added 2025-10-19
  statsd = throw "statsd was removed because its upstream source vanished"; # Added 2026-07-28
  # keep-sorted end
}
