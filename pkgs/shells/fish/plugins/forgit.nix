{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.03.2";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-DnGQHWx3uFHFEI1kMTB6hfmaE4tY4O/hesPKj5s4uwQ=";
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
