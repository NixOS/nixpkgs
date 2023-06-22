{ lib
, stdenv
, fetchurl
, perl
, installShellFiles
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "dhcpdump";
  version = "1.8";

  src = fetchurl {
    url = "http://www.mavetju.org/download/dhcpdump-${version}.tar.gz";
    hash = "sha256-bV65QYFi+3OLxW5MFoLOf3OS3ZblaMyZbkTCjef3cZA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    perl # pod2man
    installShellFiles
  ];

  buildInputs = [
    libpcap
  ];

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    runHook preBuild

    install -Dm555 dhcpdump "$out/bin/dhcpdump"
    installManPage dhcpdump.8

    runHook postBuild
  '';

  meta = with lib; {
    description = "A tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = "http://www.mavetju.org/unix/dhcpdump-man.php";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
    license = licenses.bsd2;
  };
}
