{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.04.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-fvhlN2N3u++rfAeiwRRUX+Cv5expyA6aEUB6/TvV5+4=";
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
