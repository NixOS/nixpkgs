{ lib, fetchFromGitHub, fetchpatch, python3, wirelesstools
, aircrack-ng, wireshark-cli, reaverwps-t6x, cowpatty, hashcat, hcxtools
, hcxdumptool, which, bully, pixiewps }:

python3.pkgs.buildPythonApplication rec {
  version = "2.5.7";
  pname = "wifite2";

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    sha256 = "sha256-dJ+UOSIR48m8nGoci/6iblLsX296ZGL1hZ74RUsa9lw=";
  };

  patches = [
    # Fix issue when missing optional pyrit dependency: https://github.com/kimocoder/wifite2/pull/76
    (fetchpatch {
      url = "https://github.com/kimocoder/wifite2/commit/2e5d76c794f2e5493cf5048384d6564727ae2c19.patch";
      sha256 = "0lawk8s1md98g061xg6ma37wqyqc4j2ag0gmf7insf4kvlgg3l9z";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-aircrack-failing-test.patch";
      sha256 = "04qql8w27c1lqk59ghkr1n6r08jwdrb1dcam5k88szkk2bxv8yx1";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-two-failing-tests.patch";
      sha256 = "1sixcqz1kbkhxf38yq55pwycm54adjx22bq46dfnl44mg69nx356";
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

  postFixup = let
    sitePackagesDir = "$out/lib/python3.${lib.versions.minor python3.version}/site-packages";
  in ''
    mv ${sitePackagesDir}/wifite/__main__.py ${sitePackagesDir}/wifite/wifite.py
  '';

  checkInputs = propagatedBuildInputs;
  checkPhase = "python -m unittest discover tests -v";

  meta = with lib; {
    homepage = "https://github.com/derv82/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus danielfullmer ];
  };
}
