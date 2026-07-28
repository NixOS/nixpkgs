# Removed or renamed nginx modules

self: {
  modsecurity-nginx = self.modsecurity;
  fastcgi-cache-purge = throw "fastcgi-cache-purge was renamed to cache-purge";
  ngx_aws_auth = throw "ngx_aws_auth was renamed to aws-auth";
  opentracing = throw "opentracing-cpp was removed because opentracing as been archived upstream"; # Added 2025-10-19
  statsd = throw "statsd was removed because its upstream source vanished"; # Added 2026-07-28
}
