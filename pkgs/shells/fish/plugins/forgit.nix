{ lib, buildFishPlugin, fetchFromGitHub }:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.02.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-DoOtrnEJwSxkCZtsVek+3w9RZH7j7LTvdleBC88xyfI=";
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
