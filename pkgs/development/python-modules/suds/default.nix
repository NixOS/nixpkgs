{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "suds";
  version = "0.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w4s9051iv90c0gs73k80c3d51y2wbx1xgfdgg2hk7mv4gjlllnm";
  };

  patches = [ ./suds-0.4-CVE-2013-2217.patch ];

  meta = with stdenv.lib; {
    # Broken for security issues:
    # - https://github.com/NixOS/nixpkgs/issues/19678
    # - https://lwn.net/Vulnerabilities/559200/
    broken = true;
    description = "Lightweight SOAP client";
    homepage = https://fedorahosted.org/suds;
    license = licenses.lgpl3Plus;
  };

}
