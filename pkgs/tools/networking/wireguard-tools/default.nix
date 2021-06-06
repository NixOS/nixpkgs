{ stdenv
, fetchzip
, nixosTests
, iptables ? null
, iproute ? null
, makeWrapper ? null
, openresolv ? null
, procps ? null
, wireguard-go ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "wireguard-tools";
  version = "1.0.20210424";

  src = fetchzip {
    url = "https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${version}.tar.xz";
    sha256 = "sha256-0aGaE4EBb4wb5g32Wugakt7w41sb97Hqqkac7qE641M=";
  };

  outputs = [ "out" "man" ];

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

  passthru = {
    updateScript = ./update.sh;
    tests = nixosTests.wireguard;
  };

  meta = {
    description = "Tools for the WireGuard secure network tunnel";
    downloadPage = "https://git.zx2c4.com/wireguard-tools/refs/";
    homepage = "https://www.wireguard.com/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ elseym ericsagnes mic92 zx2c4 globin ma27 xwvvvvwx ];
    platforms = platforms.unix;
  };
}
