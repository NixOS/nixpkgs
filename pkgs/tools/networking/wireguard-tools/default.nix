{
  stdenv, fetchzip,

  iptables ? null,
  iproute ? null,
  libmnl ? null,
  makeWrapper ? null,
  openresolv ? null,
  procps ? null,
  wireguard-go ? null,
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "wireguard-tools";
  version = "1.0.20200121";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${version}.tar.xz";
    sha256 = "0s82i8ibf0zj2wka625vh4rihdwmvlkv1v3bilrlcscwgfvzjfhf";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = optional stdenv.isLinux libmnl;

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
