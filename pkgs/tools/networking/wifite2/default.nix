{ lib, fetchFromGitHub, fetchpatch, python3, wirelesstools
, aircrack-ng, wireshark-cli, reaverwps-t6x, cowpatty, hashcat, hcxtools
, hcxdumptool, which, bully, pixiewps }:

python3.pkgs.buildPythonApplication rec {
  version = "2.6.0";
  pname = "wifite2";

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    sha256 = "sha256-q8aECegyIoAtYFsm8QEr8OnX+GTqjEeWfYQyESk27SA=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.5.8-2/debian/patches/Disable-aircrack-failing-test.patch";
      sha256 = "1kj2m973l067fdg9dj61vbjf4ym9x1m9kn0q8ci9r6bb30yg6sv2";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.5.8-2/debian/patches/Disable-two-failing-tests.patch";
      sha256 = "15vas7zvpdk2lr1pzv8hli6jhdib0dibp7cmikiai53idjxay56z";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/2.5.8-2/debian/patches/fix-for-new-which.patch";
      sha256 = "0p6sa09qpq9qarkjrai2ksx9nz2v2hs6dk1y01qnfbsmc4hhm30g";
    })
  ];

  propagatedBuildInputs = [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    cowpatty
    hashcat
    hcxtools
    hcxdumptool
    wirelesstools
    which
    bully
    pixiewps
  ];

  checkInputs = propagatedBuildInputs ++ [ python3.pkgs.unittestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/kimocoder/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus danielfullmer ];
  };
}
