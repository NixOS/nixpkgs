{ lib, stdenv, fetchgit
, makeWrapper
, nettools, gawk, openresolv, coreutils, gnugrep
}:

stdenv.mkDerivation {
  pname = "vpnc-scripts";
  version = "unstable-2020-02-21";
  src = fetchgit {
    url = "git://git.infradead.org/users/dwmw2/vpnc-scripts.git";
    rev = "c0122e891f7e033f35f047dad963702199d5cb9e";
    sha256 = "11b1ls012mb704jphqxjmqrfbbhkdjb64j2q4k8wb5jmja8jnd14";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp vpnc-script $out/bin
  '';

  preFixup = ''
    substituteInPlace $out/bin/vpnc-script \
      --replace "which" "type -P"
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace $out/bin/vpnc-script \
      --replace "/sbin/resolvconf" "${openresolv}/bin/resolvconf"
  '' + ''
    wrapProgram $out/bin/vpnc-script \
      --prefix PATH : "${lib.makeBinPath ([ nettools gawk coreutils gnugrep ] ++ lib.optionals stdenv.isLinux [ openresolv ])}"
  '';

  meta = with lib; {
    description = "script for vpnc to configure the network routing and name service";
    homepage = "https://www.infradead.org/openconnect/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jerith666 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
