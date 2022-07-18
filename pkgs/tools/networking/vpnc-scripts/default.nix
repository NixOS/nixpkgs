{ lib
, stdenv
, fetchgit
, coreutils
, gawk
, gnugrep
, iproute2
, makeWrapper
, nettools
, openresolv
, systemd
}:

stdenv.mkDerivation {
  pname = "vpnc-scripts";
  version = "unstable-2021-09-24";

  src = fetchgit {
    url = "https://gitlab.com/openconnect/vpnc-scripts.git";
    rev = "b749c2cadc2f32e2efffa69302861f9a7d4a4e5f";
    sha256 = "sha256-DDGpxzQBaOOG+MYDXnVEB6/Q4qmdNM+86XNRNl01UqU=";
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
    homepage = "https://www.infradead.org/openconnect/";
    description = "Script for vpnc to configure the network routing and name service";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jerith666 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
