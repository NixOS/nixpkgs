{
  stdenv, fetchzip,

  iptables ? null,
  iproute ? null,
  makeWrapper ? null,
  openresolv ? null,
  procps ? null,
  wireguard-go ? null,
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "wireguard-tools";
  version = "1.0.20200206";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${version}.tar.xz";
    sha256 = "0ivc08lds5w39a6f2xdfih9wlk5g724hl3kpdvxvh5yff4l84qb7";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ makeWrapper ];

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
  '' + optionalString stdenv.isLinux ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${makeBinPath [procps iproute iptables openresolv]}
    done
  '' + optionalString stdenv.isDarwin ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${wireguard-go}/bin
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Tools for the WireGuard secure network tunnel";
    downloadPage = "https://git.zx2c4.com/wireguard-tools/refs/";
    homepage = "https://www.wireguard.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym ericsagnes mic92 zx2c4 globin ma27 xwvvvvwx ];
    platforms = platforms.unix;
  };
}
