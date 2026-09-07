{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "aws-auth";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "anomalizer";
    repo = "ngx_aws_auth";
    tag = finalAttrs.version;
    hash = "sha256-CRofdhJ5HQGp4R1tEoOx0Nzx1rTTd+5GaJcfDsg75oM=";
  };

  meta = {
    description = "Proxy to authenticated AWS services";
    homepage = "https://github.com/anomalizer/ngx_aws_auth";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    broken = true;
  };
})
