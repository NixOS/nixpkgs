{ lib
, buildPythonPackage
, fetchPypi
, six
, pytest
, fetchpatch
}:

buildPythonPackage rec {
  pname = "w3lib";
  version = "1.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pv02lvvmgz2qb61vz1jkjc04fgm4hpfvaj5zm4i3mjp64hd1mha";
  };

  patches = [
    # Remove test broken by Python CVE-2021-23336 fix
    (fetchpatch {
      url = "https://github.com/scrapy/w3lib/pull/165/commits/78054f19bfe20555792b0f336b423921fe88b994.patch";
      sha256 = "1fb40gk2dk6rlap7nxm5sii3id054plx0yq2gkzcs10gpv1a8vpc";
    })
  ];

  buildInputs = [ six pytest ];

  meta = with lib; {
    description = "A library of web-related functions";
    homepage = "https://github.com/scrapy/w3lib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
  };

}
