{ lib
, stdenv
, fetchurl
, installShellFiles
}:

stdenv.mkDerivation rec {
  pname = "nuttcp";
  version = "8.2.2";

  src = fetchurl {
    url = "http://nuttcp.net/nuttcp/nuttcp-${version}.tar.bz2";
    sha256 = "sha256-fq16ieeqoFnSDjQELFihmMKYHK1ylVDROI3fyQNtOYM=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp nuttcp-${version} $out/bin/nuttcp
  '';

  postInstall = ''
    installManPage nuttcp.8
  '';

  meta = with lib; {
    description = "Network performance measurement tool";
    longDescription = ''
      nuttcp is a network performance measurement tool intended for use by
      network and system managers. Its most basic usage is to determine the raw
      TCP (or UDP) network layer throughput by transferring memory buffers from
      a source system across an interconnecting network to a destination
      system, either transferring data for a specified time interval, or
      alternatively transferring a specified number of bytes. In addition to
      reporting the achieved network throughput in Mbps, nuttcp also provides
      additional useful information related to the data transfer such as user,
      system, and wall-clock time, transmitter and receiver CPU utilization,
      and loss percentage (for UDP transfers).
    '';
    license = licenses.gpl2Only;
    homepage = "http://nuttcp.net/";
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
