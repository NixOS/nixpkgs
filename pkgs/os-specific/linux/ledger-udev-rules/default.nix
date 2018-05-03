{ stdenv, fetchFromGitHub, bash }:
stdenv.mkDerivation rec {
  name = "ledger-udev-rules";

  src = fetchFromGitHub {
    owner = "LedgerHQ";
    repo = "udev-rules";
    rev = "681cd1346f2dd5bc3ab19a7985caabbc97e1861b";
    sha256 = "0g9xb98mpv4rimqbcaqs3qcdqalf6v1h1wjcafgbx9vslz9x4a14";
  };

  installPhase = ''
    mkdir --parents "$out/lib/udev/rules.d"
    cat add_udev_rules.sh | grep echo | sed "s_/etc_$out/lib_" | sed "s_hw1_ledger_" | sed 's_MODE=\\"0660\\",__' | sed 's_GROUP=\\"plugdev\\"_TAG+=\\"uaccess\\"_' > install.sh
    ${bash}/bin/bash install.sh
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "udev rules to support Ledger devices";
    license = licenses.asl20;
    maintainers = with maintainers; [ chris-martin ];
    platforms = platforms.linux;
  };
}
