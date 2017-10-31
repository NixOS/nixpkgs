{ lib
, fetchurl
, python2Packages
}:

python2Packages.buildPythonApplication rec {
  name = "salt-pepper-${version}";
  version = "0.5.0";
  src = fetchurl {
    url = "https://github.com/saltstack/pepper/releases/download/${version}/${name}.tar.gz";
    sha256 = "0gf4v5y1kp16i1na4c9qw7cgrpsh21p8ldv9r6b8gdwcxzadxbck";
  };

  doCheck = false; # no tests available

  meta = with lib; {
    description = "A CLI front-end to a running salt-api system";
    homepage = https://github.com/saltstack/pepper;
    maintainers = [ maintainers.pierrer ];
    license = licenses.asl20;
  };
}
