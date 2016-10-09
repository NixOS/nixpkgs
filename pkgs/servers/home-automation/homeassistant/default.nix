{ stdenv, fetchurl, pythonPackages }:

let
  pypkgs = pythonPackages;

in pypkgs.buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "homeassistant";
  version = "0.30.2";

  src = fetchurl {
    url = "mirror://pypi/h/homeassistant/${name}.tar.gz";
    sha256 = "1w4ngbx5wg0qjhanwcfp49gkmpmhvlqk3xy4pjv55mpzxc3l6xhf";
  };

  # I cannot get the tests to run
  doCheck = false;

  buildInputs = with pypkgs; [ wrapPython ];

  propagatedBuildInputs = with pypkgs; [
    cherrypy
    jinja2
    netdisco
    pytz
    pyyaml
    requests2
    sqlalchemy
    static3
    voluptuous
    werkzeug
  ];

  preConfigure = ''
    # typing is part of stdlib in python 3.5+
    sed -i '/typing/d' setup.py
    # allow patch level updates to voluptuous
    sed -i -r "s/(voluptuous)==(.*)'/\1>=\2,<1'/" setup.py
  '';

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "A home automation platform";
    homepage = https://home-assistant.io;
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
