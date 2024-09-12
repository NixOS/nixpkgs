{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "ledger-udev-rules";
  version = "0-unstable-2024-02-12";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "udev-rules";
    rev = "f474382e370c9fa2a2207e6e675b9b364441aed7";
    sha256 = "sha256-5jN9xy3+kk540PAyfsxIqck9hdI3t2CNpgqKxLbAsDg=";
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
    maintainers = with maintainers; [ asymmetric toasteruwu ];
    platforms = platforms.linux;
    homepage = "https://github.com/LedgerHQ/udev-rules";
  };
}
