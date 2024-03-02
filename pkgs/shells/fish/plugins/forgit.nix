{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.03.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-E8zL5HPUHhb3V03yTIF6IQ83bmqrrRt0KHxYbmtzCQ4=";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "A utility tool powered by fzf for using git interactively.";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
