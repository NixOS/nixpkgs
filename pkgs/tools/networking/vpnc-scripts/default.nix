{ lib, stdenv, fetchgit
, makeWrapper
, nettools, gawk, systemd, openresolv, coreutils, gnugrep, iproute2
}:

stdenv.mkDerivation {
  pname = "vpnc-scripts";
  version = "unstable-2021-03-21";
  src = fetchgit {
    url = "git://git.infradead.org/users/dwmw2/vpnc-scripts.git";
    rev = "8fff06090ed193c4a7285e9a10b42e6679e8ecf3";
    sha256 = "14bzzpwz7kdmlbx825h6s4jjdml9q6ziyrq8311lp8caql68qdq1";
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
      --replace "/sbin/resolvconf" "${openresolv}/bin/resolvconf" \
      --replace "/usr/bin/resolvectl" "${systemd}/bin/resolvectl"
  '' + ''
    wrapProgram $out/bin/vpnc-script \
      --prefix PATH : "${lib.makeBinPath ([ nettools gawk coreutils gnugrep ] ++ lib.optionals stdenv.isLinux [ openresolv iproute2 ])}"
  '';

  meta = with lib; {
    description = "script for vpnc to configure the network routing and name service";
    homepage = "https://www.infradead.org/openconnect/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jerith666 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
