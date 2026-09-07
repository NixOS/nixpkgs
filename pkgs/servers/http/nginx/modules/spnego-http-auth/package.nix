{
  fetchFromGitHub,
  lib,
  libkrb5,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "spnego-http-auth";
  version = "1.1.1-unstable-2023-04-14";

  src = fetchFromGitHub {
    owner = "stnoonan";
    repo = "spnego-http-auth-nginx-module";
    rev = "3575542b3147bd03a6c68a750c3662b0d72ed94e";
    hash = "sha256-s0m5h7m7dsPD5o2SvBb9L2kB57jwXZK5SkdkGuOmlgs=";
  };

  buildInputs = [ libkrb5 ];

  meta = {
    description = "SPNEGO HTTP Authentication Module";
    homepage = "https://github.com/stnoonan/spnego-http-auth-nginx-module";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      de11n
      despsyched
    ];
  };
})
