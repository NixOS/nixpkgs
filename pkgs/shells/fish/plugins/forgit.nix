{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "forgit";
  version = "24.11.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = "forgit";
    rev = version;
    hash = "sha256-8BMFL3WktkkB8m6asbNeb9swnLWi3jHo012fBXGa8ls=";
  };

  postInstall = ''
    cp -r bin $out/share/fish/vendor_conf.d/
  '';

  meta = with lib; {
    description = "Utility tool powered by fzf for using git interactively";
    homepage = "https://github.com/wfxr/forgit";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
