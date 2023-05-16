<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchurl, libpcap, perl }:

stdenv.mkDerivation rec {
  pname = "dhcpdump";
  version = "1.8";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/d/dhcpdump/dhcpdump_${version}.orig.tar.gz";
    sha256 = "143iyzkqvhj4dscwqs75jvfr4wvzrs11ck3fqn5p7yv2h50vjpkd";
  };

  buildInputs = [libpcap perl];

  hardeningDisable = [ "fortify" ];

  installPhase = ''
    mkdir -pv $out/bin
    cp dhcpdump $out/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    description = "A tool for visualization of DHCP packets as recorded and output by tcpdump to analyze DHCP server responses";
<<<<<<< HEAD
    homepage = "https://github.com/bbonev/dhcpdump";
    changelog = "https://github.com/bbonev/dhcpdump/releases/tag/v${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ nickcao ];
=======
    homepage = "http://www.mavetju.org/unix/dhcpdump-man.php";
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd2;
  };
}
