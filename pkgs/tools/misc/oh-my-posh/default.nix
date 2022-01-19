{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "JanDeDobbeleer";
    repo = "oh-my-posh";
    rev = "v${version}";
    sha256 = "b8+G7LOHHz65rfhBL+IxwJhvA2JJc49gfEJboK0cFpc=";
  };
  modRoot = "./src";

  vendorSha256 = "u5rpXEEKCq+FLyM9/LnjfGH5cYDdhYkkGeesNmk5c1U=";

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://ohmyposh.dev/";
    description = "Cross platform, highly customizable and extensible prompt theme engine for any shell";
    longDescription = ''
      Features:

      - Shell independent
      - Git status indications
      - Failed command indication
      - Admin indication
      - Current session indications
      - Language info
      - Shell info
      - Configurable
      - Fast
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ x3ro ];
    platforms = platforms.linux;
  };
}
