{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "subsFilter";
  version = "0.6.4-unstable-2022-01-24";

  src = fetchFromGitHub {
    owner = "yaoweibin";
    repo = "ngx_http_substitutions_filter_module";
    rev = "e12e965ac1837ca709709f9a26f572a54d83430e";
    hash = "sha256-3sWgue6QZYwK69XSi9q8r3WYGVyMCIgfqqLvPBHqJKU=";
  };

  meta = {
    description = "Filter module which can do both regular expression and fixed string substitutions";
    homepage = "https://github.com/yaoweibin/ngx_http_substitutions_filter_module";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
