{ lib
, stdenv
, fetchFromSourcehut
, meson
, ninja
, pkg-config
, scdoc
, wayland
, wayland-scanner
, libvarlink
, libscfg
}:

stdenv.mkDerivation rec {
  pname = "kanshi";
  version = "1.6.0";

  src = fetchFromSourcehut {
    owner = "~emersion";
    repo = "kanshi";
    rev = "v${version}";
    sha256 = "sha256-KjP7EdssaZwa1OupLQgzwJSAADKLsjHltEavPjsS1YM=";
  };

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland libvarlink libscfg ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=maybe-uninitialized"
  ];

  meta = with lib; {
    homepage = "https://sr.ht/~emersion/kanshi";
    description = "Dynamic display configuration tool";
    longDescription = ''
      kanshi allows you to define output profiles that are automatically enabled
      and disabled on hotplug. For instance, this can be used to turn a laptop's
      internal screen off when docked.

      kanshi can be used on Wayland compositors supporting the
      wlr-output-management protocol.
    '';
    license = licenses.mit;
    mainProgram = "kanshi";
    maintainers = with maintainers; [ balsoft danielbarter ];
    platforms = platforms.linux;
  };
}
