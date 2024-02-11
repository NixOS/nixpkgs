{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.01.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-WHhyllOr/PgR+vlrfMQs/3/d3xpmDylT6BlLCu50a2g=";
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
