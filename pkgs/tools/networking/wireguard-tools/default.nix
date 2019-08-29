{
  stdenv, fetchzip,

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
  version = "0.0.20190702";

  src = fetchzip {
    url = "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-${version}.tar.xz";
    sha256 = "1xl4hzqrny3855s7h1k24py81gdjyfv0mhv6y528f6p0h38r89s3";
  };

  sourceRoot = "source/src/tools";

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
      wrapProgram $f --prefix PATH : ${makeBinPath [procps iproute openresolv]}
    done
  '' + optionalString stdenv.isDarwin ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${wireguard-go}/bin
    done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Tools for the WireGuard secure network tunnel";
    downloadPage = "https://git.zx2c4.com/WireGuard/refs/";
    homepage = "https://www.wireguard.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym ericsagnes mic92 zx2c4 globin ];
    platforms = platforms.unix;
  };
}
