{ lib, stdenv, fetchFromSourcehut, meson, pkg-config, ninja, wayland
, wayland-protocols
}:

stdenv.mkDerivation rec {
  pname = "wlsunset";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "12snizvf49y40cirhr2brgyldhsykv4k2gnln2sdrajqzhrc98v6";
  };

  nativeBuildInputs = [ meson pkg-config ninja wayland ];
  buildInputs = [ wayland wayland-protocols ];

  meta = with lib; {
    description = "Day/night gamma adjustments for Wayland";
    longDescription = ''
      Day/night gamma adjustments for Wayland compositors supporting
      wlr-gamma-control-unstable-v1.
    '';
    homepage = "https://sr.ht/~kennylevinsen/wlsunset/";
    changelog = "https://git.sr.ht/~kennylevinsen/wlsunset/refs/${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ primeos ];
  };
}
