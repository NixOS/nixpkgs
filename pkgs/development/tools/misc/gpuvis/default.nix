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
  version = "20210220";

  src = fetchFromGitHub {
    owner = "mikesart";
    repo = pname;
    rev = "216f7d810e182a89fd96ab9fad2a5c2b1e425ea9";
    sha256 = "15pj7gy0irlp849a85z68n184jksjri0xhihgh56rs15kq333mwz";
  };

  # patch dlopen path for gtk3
  # python2 is wrongly added in the meson file, upstream PR: https://github.com/mikesart/gpuvis/pull/62
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
