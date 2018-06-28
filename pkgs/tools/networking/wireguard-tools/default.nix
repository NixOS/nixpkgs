{ stdenv, fetchzip, libmnl ? null, makeWrapper ? null, wireguard-go ? null }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "wireguard-tools-${version}";
  version = "0.0.20180625";

  src = fetchzip {
    url = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "1z7iibydj59nzx0jcxabb9k7b6djjz6yi032n66mqr98dh4dlkb7";
  };

  sourceRoot = "source/src/tools";

  nativeBuildInputs = [ (optional stdenv.isDarwin makeWrapper) ];
  buildInputs = [ (optional stdenv.isLinux libmnl) ];

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
    "WITH_BASHCOMPLETION=yes"
    "WITH_SYSTEMDUNITS=yes"
    "WITH_WGQUICK=yes"
  ];

  postFixup = ''
    substituteInPlace $out/lib/systemd/system/wg-quick@.service \
      --replace /usr/bin $out/bin
  '' + optionalString stdenv.isDarwin ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${wireguard-go}/bin
    done
  '';

  meta = with stdenv.lib; {
    description = "Tools for the WireGuard secure network tunnel";
    downloadPage = https://git.zx2c4.com/WireGuard/refs/;
    homepage = https://www.wireguard.com/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ericsagnes mic92 zx2c4 ];
    platforms = platforms.unix;
  };
}
