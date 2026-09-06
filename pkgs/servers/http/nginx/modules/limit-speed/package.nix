{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "limit-speed";
  version = "0.1-unstable-2014-03-21";

  src = fetchFromGitHub {
    owner = "yaoweibin";
    repo = "nginx_limit_speed_module";
    rev = "f77ad4a56fbb134878e75827b40cf801990ed936";
    hash = "sha256-6Mr6dlzoq08eWEr+fpLdU75r8D5ARxHRSJ2z+xFoeU4=";
  };

  meta = {
    description = "Limit the total speed from the specific user";
    homepage = "https://github.com/yaoweibin/nginx_limit_speed_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
