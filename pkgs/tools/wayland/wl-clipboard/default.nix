{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-protocols
, wayland-scanner
, xdg-utils
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "wl-clipboard";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "bugaevc";
    repo = "wl-clipboard";
    rev = "v${version}";
    hash = "sha256-BYRXqVpGt9FrEBYQpi2kHPSZyeMk9o1SXkxjjcduhiY=";
  };

  strictDeps = true;
  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner makeWrapper ];
  buildInputs = [ wayland wayland-protocols ];

  mesonFlags = [
    "-Dfishcompletiondir=share/fish/vendor_completions.d"
  ];

  # Fix for https://github.com/NixOS/nixpkgs/issues/251261
  postInstall = lib.optionalString (!xdg-utils.meta.broken) ''
    wrapProgram $out/bin/wl-copy \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}
  '';

  meta = with lib; {
    homepage = "https://github.com/bugaevc/wl-clipboard";
    description = "Command-line copy/paste utilities for Wayland";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dywedir kashw2 ];
    platforms = platforms.unix;
  };
}
