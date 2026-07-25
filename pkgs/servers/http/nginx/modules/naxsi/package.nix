{
  fetchFromGitHub,
  lib,
  mkNginxPlugin,
}:

mkNginxPlugin (finalAttrs: {
  pname = "naxsi";
  version = "1.0-unstable-2020-09-10";

  src = fetchFromGitHub {
    owner = "nbs-system";
    repo = "naxsi";
    rev = "95ac520eed2ea04098a76305fd0ad7e9158840b7";
    sha256 = "0b5pnqkgg18kbw5rf2ifiq7lsx5rqmpqsql6hx5ycxjzxj6acfb3";
  };

  sourceRoot = "${finalAttrs.src.name}/naxsi_src";

  meta = {
    description = "Open-source, high performance, low rules maintenance WAF";
    homepage = "https://github.com/nbs-system/naxsi";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
})
