{ stdenv
, pythonPackages
, fetchurl
, plugins ? []
}:

pythonPackages.buildPythonApplication (rec {
  name = "${pname}-${version}";
  pname = "buildbot";
  version = "0.9.0rc2";
  src = fetchurl {
    url = "mirror://pypi/b/${pname}/${name}.tar.gz";
    sha256 = "06xzbjzji3by4hldwr850fc989ymsfl2s8nil21klv2g00dgmcmk";
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
  ];

  propagatedBuildInputs = with pythonPackages; [

    # core
    twisted
    jinja2
    zope_interface
    future
    sqlalchemy
    sqlalchemy_migrate
    future
    dateutil
    txaio
    autobahn

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

  preInstall = ''
    # buildbot tries to import 'buildslaves' but does not
    # include the module in it's package, so get rid of those references
    sed -i.bak -e '66,$d' buildbot/test/__init__.py
    sed -i.bak -e '506,$d' buildbot/test/unit/test_worker_base.py
    sed -i.bak -e '648,$d' buildbot/test/unit/test_worker_ec2.py
    sed -i.bak -e '289,$d' buildbot/test/unit/test_worker_libvirt.py
    sed -i.bak -e '190,$d' buildbot/test/unit/test_worker_openstack.py
    sed -i.bak -e '60,84d' buildbot/test/integration/test_configs.py

    # writes out a file that can't be read properly
    sed -i.bak -e '69,84d' buildbot/test/unit/test_www_config.py
  '';

  meta = with stdenv.lib; {
    homepage = http://buildbot.net/;
    description = "Continuous integration system that automates the build/test cycle";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    platforms = platforms.all;
  };
})
