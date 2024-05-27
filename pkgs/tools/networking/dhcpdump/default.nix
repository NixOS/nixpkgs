{ lib
, stdenv
, fetchFromGitHub
, perl
, installShellFiles
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "dhcpdump";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ck6DLsLQ00unNqPLBKkxaJLDCaPFjTFJcQjTbKSq0U8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    perl # pod2man
    installShellFiles
  ];

  buildInputs = [
    libpcap
  ];

  installPhase = ''
    runHook preBuild

    install -Dm555 dhcpdump "$out/bin/dhcpdump"
    installManPage dhcpdump.8

    runHook postBuild
  '';

  meta = with lib; {
    description = "A tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
    homepage = "https://github.com/bbonev/dhcpdump";
    changelog = "https://github.com/bbonev/dhcpdump/releases/tag/v${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
    license = licenses.bsd2;
    mainProgram = "dhcpdump";
  };
}
