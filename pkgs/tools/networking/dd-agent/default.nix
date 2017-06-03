{ stdenv, fetchFromGitHub, pythonPackages
, sysstat, unzip, makeWrapper, datadog-trace-agent
, fetchurl
# We need extraBuildInputs as we want to be able to override this
# package with python packages _and_ have the produced binaries
# wrapper with their PYTHONPATH. This means overrideAttrs is not
# strong enough (it overrides too late), we need to call it
# beforehand.
, extraBuildInputs ? [ ] }:
let
  inherit (pythonPackages) python;
  docker_1_10 = pythonPackages.buildPythonPackage rec {
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
      requests
      websocket_client
      ipaddress
      backports_ssl_match_hostname
      docker_pycreds
      uptime
    ];

    # due to flake8
    doCheck = false;
  };
  version = "5.13.2";

  integrations = fetchFromGitHub {
    owner = "datadog";
    repo = "integrations-core";
    rev = version;
    sha256 = "1nbjmkq0wdfndmx0qap69h2rkwkkb0632j87h9d3j99bykyav3y3";
  };

  jmxArtifact = fetchurl
    { url = "http://dd-jmxfetch.s3.amazonaws.com/jmxfetch-0.13.0-jar-with-dependencies.jar";
      sha256 = "02rfn17q42kxiv2sv306ibdhvi8l4sbjdwhh1nwdlxw46pqh4ks1";
    };

in stdenv.mkDerivation rec {
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner  = "datadog";
    repo   = "dd-agent";
    rev    = version;
    sha256 = "0x2bxi70l2yf0wi232qksvcscjdpjg8l7dmgg1286vqryyfazfjb";
  };

  buildInputs = [
    python
    unzip
    makeWrapper
    pythonPackages.boto
    docker_1_10
    pythonPackages.kazoo
    pythonPackages.ntplib
    pythonPackages.consul
    pythonPackages.python-etcd
    pythonPackages.pyyaml
    pythonPackages.requests
    pythonPackages.simplejson
    pythonPackages.supervisor
    pythonPackages.tornado_3_2_2
    pythonPackages.uptime
  ] ++ extraBuildInputs;
  propagatedBuildInputs = with pythonPackages; [ python tornado_3_2_2 ];

  buildCommand = ''
    mkdir -p $out/bin
    cp -R $src $out/agent
    chmod u+w -R $out
    PYTHONPATH=$out/agent:$PYTHONPATH

    mkdir -p $out/agent/checks.d
    mkdir -p $out/agent/conf.d
    mkdir -p $out/agent/conf.d/auto_conf

    # Copy every available integration. Official script downloads the
    # Python dependencies in this stage for each one but we defer that
    # to the user through extraBuildInputs.
    for INT in $(ls ${integrations}); do
      INT_DIR="${integrations}/$INT"
      if [ -f "$INT_DIR/check.py" ]; then
        cp "$INT_DIR/check.py" "$out/agent/checks.d/$INT.py"
      fi
      if [ -f "$INT_DIR/conf.yaml.example" ]; then
        cp "$INT_DIR/conf.yaml.example" "$out/agent/conf.d/$INT.yaml"
      fi
      if [ -f "$INT_DIR/auto_conf.yaml" ]; then
        cp "$INT_DIR/auto_conf.yaml" "$out/agent/conf.d/auto_conf/$INT.yaml"
      fi
      if [ -f "$INT_DIR/conf.yaml.default" ]; then
        cp "$INT_DIR/conf.yaml.default" "$out/agent/conf.d/$INT.yaml"
      fi
    done

    # Get the JMX artifact.
    mkdir -p $out/agent/checks/libs
    ln -s ${jmxArtifact} $out/agent/checks/libs/

    # Move out default conf.d so that /etc/dd-agent/conf.d is used
    # which is configured through dd-agent NixOS service.
    mv $out/agent/conf.d $out/agent/conf.d-system

    # Supervisor
    ln -s $out/agent/packaging/datadog-agent/source/supervisor.conf $out/agent/

    # Link main agent script for user convenience: the user might
    # want to run things like 'dd-agent flare' or 'dd-agent info'.
    mkdir -p $out/bin
    ln -s $out/agent/agent.py $out/bin/dd-agent
    wrapProgram $out/bin/dd-agent --prefix PYTHONPATH : $PYTHONPATH

    # Write our own supervisor.conf as we need to include trace-agent
    # which doesn't come in source distribution file, modify, add
    # PYTHONPATH... It's easier to just write whole config than to try
    # and edit the existing one.
    cat <<EOF > $out/agent/supervisor.conf
    [supervisord]
    logfile = /var/log/datadog/supervisord.log
    logfile_maxbytes = 50MB
    loglevel = info
    nodaemon = true
    identifier = supervisord
    nocleanup = true
    pidfile = /tmp/supervisord.pid

    [rpcinterface:supervisor]
    supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

    [unix_http_server]
    file = /tmp/agent-supervisor.sock

    [supervisorctl]
    prompt = datadog
    serverurl = unix:///tmp/agent-supervisor.sock

    [program:collector]
    command=${python}/bin/python agent/agent.py foreground --use-local-forwarder
    redirect_stderr=true
    priority=999
    startsecs=2
    environment=LANG=POSIX,PYTHONPATH='agent/checks/libs:$PYTHONPATH'

    [program:forwarder]
    command=${python}/bin/python agent/ddagent.py --use_simple_http_client=1
    redirect_stderr=true
    priority=998
    startsecs=3
    environment=PYTHONPATH='$PYTHONPATH'

    [program:dogstatsd]
    command=${python}/bin/python agent/dogstatsd.py --use-local-forwarder
    redirect_stderr=true
    priority=998
    startsecs=3
    environment=PYTHONPATH='$PYTHONPATH'

    [program:jmxfetch]
    command=${python}/bin/python agent/jmxfetch.py
    redirect_stderr=true
    priority=999
    startsecs=3
    environment=PYTHONPATH='$PYTHONPATH'

    [program:trace-agent]
    command=${datadog-trace-agent}/bin/agent
    redirect_stderr=true
    priority=998
    startsecs=5
    startretries=3
    exitcodes=0

    [group:datadog-agent]
    programs=forwarder,collector,dogstatsd,jmxfetch,trace-agent
    EOF

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
