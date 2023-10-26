{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "udatetime";
  version = "0.0.17";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sQvFVwaZpDinLitaZOdr2MKO4779FvIJOHpVB/oLgwE=";
  };

  patches = [
    # fix build with python 3.9
    # https://github.com/freach/udatetime/pull/33
    (fetchpatch {
      name = "freach-udatetime-pull-33.patch";
      url = "https://github.com/freach/udatetime/compare/75a07891426364f8bf0b44305b00bb1dd90534ae...2cfbc92cb274a80476a45c6c0d387c19e77a9f6e.patch";
      sha256 = "pPskJnie+9H3qKqf8X37sxB+CH3lpkj7IYl8HfiuV/4=";
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
