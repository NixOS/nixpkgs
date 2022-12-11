{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, wayland
, libinput
, libyamlcpp
}:

stdenv.mkDerivation rec {
  pname = "way-displays";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "alex-courtis";
    repo = "way-displays";
    rev = "${version}";
    sha256 = "sha256-MOzHhHHib1Q1ts2bUr7t0tB5a3ejWFKEQC81KnVYyFc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    wayland
  ];

  buildInputs = [
    wayland
    libyamlcpp
    libinput
  ];

  makeFlags = [ "DESTDIR=$(out) PREFIX= PREFIX_ETC= ROOT_ETC=$(out)/etc"];

  meta = with lib; {
    homepage = "https://github.com/alex-courtis/way-displays";
    description = "Auto Manage Your Wayland Displays";
    license = licenses.mit;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
  };
}
