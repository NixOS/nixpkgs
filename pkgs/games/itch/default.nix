{ stdenv
, fetchurl
, go
, nodejs
, pkg-config
, makeWrapper
, makeDesktopItem
, glib
}:

stdenv.mkDerivation rec {
  pname = "itch-setup";
  version = "1.24.0";

  src = fetchurl {
    url = "https://github.com/itchio/itch-setup/archive/${version}.tar.gz";
    sha256 = "1fwjg5wiyf0rjnwcxabyk05q1k8k6hj53vh1q2xz49y4fwq9sv1i";
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

  meta = with stdenv.lib; {
    homepage = "https://itch.io";
    description =
      "A desktop application that you can download and run games from itch.io with.";
    license = licenses.mit;
  };
}
