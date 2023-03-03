{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "sslmate-agent";
  version = "1.99.11";

  src = fetchurl {
    url = "https://packages.sslmate.com/debian/pool/sslmate2/s/sslmate-client/${pname}_${version}-1_amd64.deb";
    sha256 = "sha256-LBiZI0pGAFWnvTigEhtkhHq4FGdbYiMzjLheMuP0YTU=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackCmd = ''
    dpkg-deb -x ${src} ./sslmate-agent-${pname}
  '';

  installPhase = ''
    runHook preInstall

    # Not moving etc because it only contains init.rd setttings
    mv usr $out
    mv lib $out

    substituteInPlace $out/lib/systemd/system/sslmate-agent.service \
      --replace "/usr/s" "$out/"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Daemon for managing SSL/TLS certificates on a server";
    homepage = "https://sslmate.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
  };
}
