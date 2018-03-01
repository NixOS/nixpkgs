{ lib, buildPythonPackage, fetchurl, pyyaml, nose, jinja2, mock, pytest }:

buildPythonPackage rec {
  name = "webassets-${version}";
  version = "0.12.1";

  src = fetchurl {
    url = "mirror://pypi/w/webassets/${name}.tar.gz";
    sha256 = "1nrqkpb7z46h2b77xafxihqv3322cwqv6293ngaky4j3ff4cing7";
  };

  propagatedBuildInputs = [ pyyaml ];
  checkInputs = [ nose jinja2 mock pytest ];

  # Needs Babel CLI tool
  doCheck = false;
  checkPhase = "py.test";

  meta = with lib; {
    description = "Media asset management for Python, with glue code for various web frameworks";
    homepage = http://github.com/miracle2k/webassets/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
  };
}
