{ lib, stdenv, fetchFromSourcehut, nixos, wayland }:

stdenv.mkDerivation rec {
  pname = "lswt";
  version = "1.0.4";

  src = fetchFromSourcehut {
    owner = "~leon_plickat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Orwa7sV56AeznEcq/Xj5qj4PALMxq0CI+ZnXuY4JYE0=";
  };

  buildInputs = [ wayland ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = with lib; {
    description = "A command that lists Wayland toplevels";
    homepage = "https://sr.ht/~leon_plickat/lswt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ edrex ];
    platforms = platforms.linux;
  };
}
