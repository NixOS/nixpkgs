{ stdenv, systemd }:

stdenv.mkDerivation {
  name = "libudev-${systemd.version}";

  unpackPhase = ":";
  outputs = [ "out" "dev" ];
  installPhase = ''
    mkdir -p "$out/lib" "$dev/lib/pkgconfig" "$dev/include"
    cp -P "${systemd}"/lib/libudev.* "$out/lib/"
    cp -P "${systemd}"/lib/pkgconfig/libudev.pc "$dev/lib/pkgconfig/"
    cp -P "${systemd}"/include/libudev.h "$dev/include/"

    substituteInPlace "$dev"/lib/pkgconfig/*.pc \
      --replace "${systemd}" "$out"
    sed "/^includedir=/cincludedir=$dev/include" -i "$dev"/lib/pkgconfig/*.pc
  '';

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
