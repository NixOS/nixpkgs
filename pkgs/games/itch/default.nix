{ stdenv
, fetchFromGitHub
, go
, nodejs
, pkg-config
, makeWrapper
, makeDesktopItem
, glib
}:
let
  lib = stdenv.lib;
in
stdenv.mkDerivation rec {
  pname = "itch-setup";
  version = "1.24.0";

  src = fetchFromGitHub {
    owner = "itchio";
    repo = "itch-setup";
    rev = "v${version}";
    sha256 = "1bsv6ifmcarzhnl76h0rzvgwyj6gm7ypnqb5qv2dkj50bgrrkwp3";
  };

  buildInputs = [
    makeWrapper nodejs go glib
  ];

  executableName = "$out/bin/itch";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    npm install
    go run main.go
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/vector-im/element-desktop/blob/develop/package.json
  # desktopItem = makeDesktopItem {
  #   name = "itch-desktop";
  #   exec = "${executableName} %u";
  #   icon = "element";
  #   desktopName = "Itch";
  #   genericName = "Itch.io desktop";
  #   comment = meta.description;
  #   categories = "Games;Game-client";
  #   extraEntries = ''
  #     StartupWMClass=element
  #   '';
  # };

  meta = with lib; {
    homepage = "https://itch.io";
    description =
      "A desktop application that you can download and run games from itch.io with.";
    license = licenses.mit;
    platforms = ["x86_64-linux"];
    maintainers = [];
  };
}
