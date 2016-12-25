{
stdenv, pkgs, python, wrapPython, buildPythonPackage,
pyyaml, six, nose
}:

buildPythonPackage rec {
  pname = "scruffington";
  name = "${pname}-${version}";
  version = "0.3.7";
  src = pkgs.fetchurl {
    # github release not PyPI so we have tests
    url = "https://github.com/snare/scruffy/archive/v${version}.tar.gz";
    sha256 = "1585xpvdyz85nmxhdgfvb8hdv8jlbv2yx41lfxl3wlr8ck61yrs3";
  };
  # fails when run multiple times as different users
  # https://github.com/snare/scruffy/issues/15
  doCheck = false;
  checkPhase = ''
    nosetests
  '';
  meta = with stdenv.lib; {
    description = "Scruffy. The janitor";
    homepage    = "https://github.com/snare/scruffy";
    license     = licenses.mit;
    platforms   = platforms.linux;
  };
  propagatedBuildInputs = [ pyyaml six nose ];
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
