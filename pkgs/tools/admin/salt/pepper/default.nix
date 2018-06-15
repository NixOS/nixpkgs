{ lib
, fetchurl
, python2Packages
}:

python2Packages.buildPythonApplication rec {
  name = "salt-pepper-${version}";
  version = "0.5.5";
  src = fetchurl {
    url = "https://github.com/saltstack/pepper/releases/download/${version}/${name}.tar.gz";
    sha256 = "1wj1k64ly6af6qsmiizlx32jxh23a37smd9wb57l5zl0x8sfqq1n";
  };

  doCheck = false; # no tests available

  meta = with lib; {
    description = "A CLI front-end to a running salt-api system";
    homepage = https://github.com/saltstack/pepper;
    maintainers = [ maintainers.pierrer ];
    license = licenses.asl20;
  };
}
