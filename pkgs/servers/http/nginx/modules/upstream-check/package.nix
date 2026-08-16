{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "upstream-check";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "yaoweibin";
    repo = "nginx_upstream_check_module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UttWL83yG/QbMstfQwv2cK7mJTzR4G5rv7cktPpC6sI=";
  };

  meta = {
    description = "Support upstream health check";
    homepage = "https://github.com/yaoweibin/nginx_upstream_check_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
