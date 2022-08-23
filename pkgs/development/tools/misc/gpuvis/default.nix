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
  version = "20211204";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = pname;
    rev = "7f47419470687c7ecbdf086b81f5bafdb05d1bef";
    sha256 = "sha256-29Bv+y0zWzn7QtpsjRV6hr19bCeyVJusPcYiAIEIluk=";
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
    platforms = with platforms; linux;
  };
}
