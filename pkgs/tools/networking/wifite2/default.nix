{ stdenv, lib, fetchFromGitHub, python3, aircrack-ng, wireshark-cli, reaverwps-t6x, cowpatty, hashcat, hcxtools, which }:

python3.pkgs.buildPythonApplication rec {
  version = "2.2.5";
  pname = "wifite2";

  src = fetchFromGitHub {
    owner = "derv82";
    repo = "wifite2";
    rev = version;
    sha256 = "1hfy90wf2bjg0z8rbs8cfhhvz78pzg2c6nj0zksal42mb6b5cjdp";
  };

  propagatedBuildInputs = [
    aircrack-ng
    wireshark-cli
    reaverwps-t6x
    cowpatty
    hashcat
    hcxtools
    which
  ];

  postFixup = let
    sitePackagesDir = "$out/lib/python3.${lib.versions.minor python3.version}/site-packages";
  in ''
    mv ${sitePackagesDir}/wifite/__main__.py ${sitePackagesDir}/wifite/wifite.py
  '';

  # which is not found
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/derv82/wifite2";
    description = "Rewrite of the popular wireless network auditor, wifite";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lassulus ];
  };
}
