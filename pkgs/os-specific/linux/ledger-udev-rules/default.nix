{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "ledger-udev-rules";
  version = "unstable-2021-09-10";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "udev-rules";
    rev = "2776324af6df36c2af4d2e8e92a1c98c281117c9";
    sha256 = "sha256-yTYI81PXMc32lMfI5uhD14nP20zAI7ZF33V1LRDWg2Y=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp 20-hw1.rules $out/lib/udev/rules.d/20-ledger.rules
  '';

  meta = with lib; {
    description = "udev rules for Ledger devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ asymmetric ];
    platforms = platforms.linux;
    homepage = "https://github.com/LedgerHQ/udev-rules";
  };
}
