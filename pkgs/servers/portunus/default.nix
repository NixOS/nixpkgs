{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "portunus";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "portunus";
    rev = "v${version}";
    sha256 = "sha256-+sq5Wja0tVkPZ0Z++K2A6my9LfLJ4twxtoEAS6LHqzE=";
  };

  vendorSha256 = null;

  postInstall = ''
    mv $out/bin/{,portunus-}orchestrator
    mv $out/bin/{,portunus-}server
  '';

  meta = with lib; {
    description = "Self-contained user/group management and authentication service";
    homepage = "https://github.com/majewsky/portunus";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ majewsky ] ++ teams.c3d2.members;
  };
}
