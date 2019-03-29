{ stdenv
, lib
, iputils
, python3
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "gping";
  version = "1.1";

  propagatedBuildInputs = with python3Packages; [ colorama ];

  src = python3Packages.fetchPypi {
    inherit version;
    pname  = "pinggraph";
    sha256 = "0q5ma98457zb6vxsnhmrr3p38j1vg0gl155y0adzfg67wlniac92";
  };

  # Make path to ping explicit
  postFixup = ''
    substituteInPlace $out/${python3.sitePackages}/gping/pinger.py \
      --replace 'subprocess.getoutput("ping ' 'subprocess.getoutput("${iputils}/bin/ping ' \
      --replace 'args = ["ping"]' 'args = ["${iputils}/bin/ping"]'
  '';

  meta = with lib; {
    description = "Ping, but with a graph";
    homepage = https://github.com/orf/gping;
    license = licenses.gpl2;
    maintainers = with maintainers; [ andrew-d ];
  };
}
