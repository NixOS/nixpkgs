{ stdenv, buildPythonPackage, fetchFromGitHub, python, pythonPackages
, sysstat, unzip, tornado, makeWrapper }:
let
  docker_1_10 = buildPythonPackage rec {
    name = "docker-${version}";
    version = "1.10.6";

    src = fetchFromGitHub {
      owner = "docker";
      repo = "docker-py";
      rev = version;
      sha256 = "1awzpbrkh4fympqzddz5i3ml81b7f0i0nwkvbpmyxjjfqx6l0m4m";
    };

    propagatedBuildInputs = with pythonPackages; [
      six
      requests2
      websocket_client
      ipaddress
      backports_ssl_match_hostname
      docker_pycreds
    ];

    # due to flake8
    doCheck = false;
  };

in stdenv.mkDerivation rec {
  version = "5.5.2";
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner  = "datadog";
    repo   = "dd-agent";
    rev    = version;
    sha256 = "0ga7h3rdg6q2pi4dxxkird5nf6s6hc13mj1xd9awwpli48gyvxn7";
  };

  buildInputs = [
    python
    unzip
    makeWrapper
    pythonPackages.requests2
    pythonPackages.psycopg2
    pythonPackages.psutil
    pythonPackages.ntplib
    pythonPackages.simplejson
    pythonPackages.pyyaml
    pythonPackages.pymongo
    pythonPackages.python-etcd
    pythonPackages.consul
    docker_1_10
  ];
  propagatedBuildInputs = [ python tornado ];

  buildCommand = ''
    mkdir -p $out/bin
    cp -R $src $out/agent
    chmod u+w -R $out
    PYTHONPATH=$out/agent:$PYTHONPATH
    ln -s $out/agent/agent.py $out/bin/dd-agent
    ln -s $out/agent/dogstatsd.py $out/bin/dogstatsd
    ln -s $out/agent/ddagent.py $out/bin/dd-forwarder

    cat > $out/bin/dd-jmxfetch <<EOF
    #!/usr/bin/env bash
    exec ${python}/bin/python $out/agent/jmxfetch.py $@
    EOF
    chmod a+x $out/bin/dd-jmxfetch

    wrapProgram $out/bin/dd-forwarder \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dd-agent \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dogstatsd \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dd-jmxfetch \
      --prefix PYTHONPATH : $PYTHONPATH

    patchShebangs $out
  '';

  meta = {
    description = "Event collector for the DataDog analysis service";
    homepage    = http://www.datadoghq.com;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice domenkozar ];
  };
}
