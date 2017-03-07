{ stdenv, lib, fetchurl, coreutils, openssh, buildbot-worker, makeWrapper,
  pythonPackages, gnused, plugins ? [] }:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot";
  version = "0.9.4";
  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "0wklrn4fszac9wi8zw3vbsznwyff6y57cz0i81zvh46skb6n3086";
  };

  buildInputs = with pythonPackages; [
    lz4
    txrequests
    pyjade
    boto3
    moto
    txgithub
    mock
    setuptoolsTrial
    isort
    pylint
    astroid
    pyflakes
    openssh
    buildbot-worker
    makeWrapper
    treq
  ];

  propagatedBuildInputs = with pythonPackages; [

    # core
    twisted
    jinja2
    zope_interface
    sqlalchemy
    sqlalchemy_migrate
    future
    dateutil
    txaio
    autobahn
    pyjwt

    # tls
    pyopenssl
    service-identity
    idna

    # docs
    sphinx
    sphinxcontrib-blockdiag
    sphinxcontrib-spelling
    pyenchant
    docutils
    ramlfications
    sphinx-jinja

  ] ++ plugins;

  postPatch = ''
    ${gnused}/bin/sed -i 's|/usr/bin/tail|${coreutils}/bin/tail|' buildbot/scripts/logwatcher.py
  '';

  postFixup = ''
    makeWrapper $out/bin/.buildbot-wrapped $out/bin/buildbot --set PYTHONPATH "$PYTHONPATH"
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    license = licenses.gpl2;
  };
})
