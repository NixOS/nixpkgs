{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
  pam,
}:

mkNginxPlugin (finalAttrs: {
  pname = "pam";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "sto";
    repo = "ngx_http_auth_pam_module";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ESlrWZwpLE0bVS1MwTc2Zcu7892HsaCQ7APGsmdbIuU=";
  };

  buildInputs = [ pam ];

  meta = {
    description = "Use PAM for simple http authentication";
    homepage = "https://github.com/sto/ngx_http_auth_pam_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
