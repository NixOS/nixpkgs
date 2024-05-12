{ fetchFromGitHub
, freetype
, gtk3
, lib
, meson
, ninja
, pkg-config
, SDL2
, stdenv
, wrapGAppsHook3
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

  nativeBuildInputs = [ pkg-config meson ninja wrapGAppsHook3 ];

  buildInputs = [ SDL2 gtk3 freetype ];

  CXXFLAGS = [
    # GCC 13: error: 'uint32_t' has not been declared
    "-include cstdint"
  ];

  meta = with lib; {
    description = "GPU Trace Visualizer";
    mainProgram = "gpuvis";
    homepage = "https://github.com/mikesart/gpuvis";
    license = licenses.mit;
    maintainers = with maintainers; [ emantor ];
    platforms = platforms.linux;
  };
}
