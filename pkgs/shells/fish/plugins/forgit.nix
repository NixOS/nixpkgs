{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "forgit";
  version = "26.08.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-VJiUXbArwe0oTQVznDMgPEIhzqvFZI7ciezbNuWH620=";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = {
    description = "Utility tool powered by fzf for using git interactively";
    homepage = "https://github.com/wfxr/forgit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
