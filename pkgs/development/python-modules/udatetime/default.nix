{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "udatetime";
  version = "0.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09vlcskvaxnfk73l9w5xgl2ks9l62g1b24yrm0xxb7gn93qxglw2";
  };

  patches = [
    # fix build with python 3.9
    (fetchpatch {
      url = "https://github.com/freach/udatetime/pull/33.patch";
      sha256 = "02wm7ivkv1viqn2wflgd10dgpddfqfrwacmrldigb1mwb79n554j";
    })
  ];

  # tests not included on pypi
  doCheck = false;

  pythonImportsCheck = [ "udatetime" ];

  meta = with lib; {
    description = "Fast RFC3339 compliant Python date-time library";
    homepage = "https://github.com/freach/udatetime";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin ];
  };
}
