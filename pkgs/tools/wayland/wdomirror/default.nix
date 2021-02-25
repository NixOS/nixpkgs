{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
}:

stdenv.mkDerivation {
  pname = "wdomirror";
  version = "unstable-2021-01-08";

  src = fetchFromGitHub {
    owner = "progandy";
    repo = "wdomirror";
    rev = "e4a4934e6f739909fbf346cbc001c72690b5c906";
    sha256 = "1fz0sajhdjqas3l6mpik8w1k15wbv65hgh9r9vdgfqvw5l6cx7jv";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland-protocols ];

  buildInputs = [ wayland ];

  installPhase = ''
    runHook preInstall
    install -m755 -D wdomirror $out/bin/wdomirror
    runHook postInstall
  '';

  meta = with lib; {
    description = "Mirrors an output of a wlroots compositor to a window";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jpas ];
  };
}
