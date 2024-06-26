{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk3,
  playerctl,
  libsoup,
}:

stdenv.mkDerivation rec {
  pname = "gtklock-playerctl-module";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jovanlanik";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eN4E3+jv8IyRvV8pvfCjCc6pl8y7qSLRlj7tYkX0JrE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    gtk3
    playerctl
    libsoup
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Gtklock module adding power controls to the lockscreen";
    homepage = "https://github.com/jovanlanik/gtklock-powerbar-module";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
