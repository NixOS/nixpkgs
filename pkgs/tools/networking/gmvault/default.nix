{ pkgs, fetchurl, pythonPackages }:

pythonPackages.buildPythonApplication rec {
  version = "1.9.1";
  name = "gmvault-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/gaubert/gmvault-official-download/downloads/gmvault-v${version}-src.tar.gz";
    name = "${name}.tar.bz";
    sha256 = "0ffp8df3gdf6lf3pj75hzsmxmvmscppb6bjda58my1n4ppxp1rji";
  };

  doCheck = false;

  propagatedBuildInputs = with pythonPackages; [ gdata IMAPClient Logbook chardet ];

  startScript = ./gmvault.py;

  patchPhase = ''
    cat ${startScript} > etc/scripts/gmvault
    chmod +x etc/scripts/gmvault
    substituteInPlace setup.py --replace "==" ">="
    substituteInPlace setup.py --replace "argparse" ""
  '';

  meta = {
    description = "Backup and restore your gmail account";
    homepage = http://gmvault.org;
    license = pkgs.lib.licenses.agpl3Plus;
  };
}
