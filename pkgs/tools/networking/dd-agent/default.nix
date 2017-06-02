{ stdenv, fetchFromGitHub, pythonPackages
, sysstat, unzip, makeWrapper
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
    pythonPackages.tornado
    pythonPackages.uptime
  ] ++ extraBuildInputs;
  propagatedBuildInputs = with pythonPackages; [ python tornado ];

  buildCommand = ''
    mkdir -p $out/bin
    cp -R $src $out/agent
    chmod u+w -R $out
    PYTHONPATH=$out/agent:$PYTHONPATH
    ln -s $out/agent/agent.py $out/bin/dd-agent
    ln -s $out/agent/dogstatsd.py $out/bin/dogstatsd
    ln -s $out/agent/ddagent.py $out/bin/dd-forwarder

    # Move out default conf.d so that /etc/dd-agent/conf.d is used
    mv $out/agent/conf.d $out/agent/conf.d-system

    # Sometime between 5.11.2 and 5.13.2 datadog moved out all its
    # checks into separate repository. Copy them back in so dd-agent
    # service can easily pick and choose by copying out configs into
    # its etc files.
    mkdir -p $out/agent/checks.d
    for i in ${toString integrations}/* # */
    do
      if [ -f "$i/check.py" ]; then
        if [ -f "$i/conf.yaml.default" -o -f "$i/conf.yaml.example" ]; then
          local name=$(basename $i)
          cp $i/check.py $out/agent/checks.d/$name.py
          # Copy .default file first unless it doesn't exist then copy .default
          cp $i/conf.yaml.default $out/agent/conf.d-system/$name.yaml &> /dev/null || \
            cp $i/conf.yaml.example $out/agent/conf.d-system/$name.yaml
        fi
      fi
    done

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
