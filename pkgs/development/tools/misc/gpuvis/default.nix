{ fetchFromGitHub
, freetype
, gtk3
, lib
, meson
, ninja
, pkg-config
, SDL2
, stdenv
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gpuvis";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-a9eAYDsiwyzZc4FAPo0wANysisIT4qCHLh2PrYswJtw=";
  };

  # patch dlopen path for gtk3
  postPatch = ''
    substituteInPlace src/hook_gtk3.h \
      --replace "libgtk-3.so" "${lib.getLib gtk3}/lib/libgtk-3.so"
  '';

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook ];

  buildInputs = [ SDL2 gtk3 freetype ];

  meta = with lib; {
    description = "GPU Trace Visualizer";
    homepage = "https://github.com/mikesart/gpuvis";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.linux;
  };
}
