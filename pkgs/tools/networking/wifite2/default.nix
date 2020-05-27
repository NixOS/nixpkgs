{ stdenv, lib, fetchFromGitHub, fetchpatch, python3, wirelesstools
, aircrack-ng, wireshark-cli, reaverwps-t6x, cowpatty, hashcat, hcxtools
, hcxdumptool, pyrit, which }:

python3.pkgs.buildPythonApplication rec {
  version = "2.5.3";
  pname = "wifite2";

  src = fetchFromGitHub {
    owner = "kimocoder";
    repo = "wifite2";
    rev = version;
    sha256 = "080hbjpbgdnzr6jkmg5cb8dvzxm57zpi4c9x0y92yy472vqll3ax";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-aircrack-failing-test.patch";
      sha256 = "04qql8w27c1lqk59ghkr1n6r08jwdrb1dcam5k88szkk2bxv8yx1";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/wifite/raw/debian/${version}-1/debian/patches/Disable-two-failing-tests.patch";
      sha256 = "1sixcqz1kbkhxf38yq55pwycm54adjx22bq46dfnl44mg69nx356";
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
    pyrit
    which
  ];

  postFixup = let
    sitePackagesDir = "$out/lib/python3.${lib.versions.minor python3.version}/site-packages";
  in ''
    mv ${sitePackagesDir}/wifite/__main__.py ${sitePackagesDir}/wifite/wifite.py
  '';

  checkInputs = propagatedBuildInputs;
  checkPhase = "python -m unittest discover tests -v";

  meta = with stdenv.lib; {
    homepage = "https://github.com/derv82/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus danielfullmer ];
  };
}
