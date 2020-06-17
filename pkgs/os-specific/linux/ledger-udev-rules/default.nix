{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "ledger-udev-rules";
  version = "unstable-2019-05-30";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "udev-rules";
    rev = "765b7fdf57b20fd9326cedf48ee52e905024ab4f";
    sha256 = "10a42al020zpkx918y6b1l9az45vk3921b2l1mx87w3m0ad9qvif";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp 20-hw1.rules $out/lib/udev/rules.d/20-ledger.rules
  '';

  meta = with stdenv.lib; {
    description = "udev rules for Ledger devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ asymmetric ];
    platforms = platforms.linux;
    homepage = "https://github.com/LedgerHQ/udev-rules";
  };
}
