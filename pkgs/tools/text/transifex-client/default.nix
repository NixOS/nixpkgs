{ stdenv, buildPythonApplication, fetchPypi
, python-slugify, requests, urllib3 }:

buildPythonApplication rec {
  pname = "transifex-client";
  version = "0.13.5";

  propagatedBuildInputs = [
    urllib3 requests python-slugify
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "00igk35nyzqp1slj7lbhiv4lc42k87ix43ipx2zcrsjf6xxv6l7v";
  };

  prePatch = ''
    substituteInPlace requirements.txt --replace "urllib3<1.24" "urllib3<2.0"
  '';

  # Requires external resources
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://www.transifex.com/;
    license = licenses.gpl2;
    description = "Transifex translation service client";
    maintainers = [ maintainers.etu ];
  };
}
