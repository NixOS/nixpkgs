{ stdenv, fetchFromGitHub, python
, unzip, makeWrapper }:
let
  python' = python.override {
    packageOverrides = self: super: {
      docker = self.buildPythonPackage rec {
        name = "docker-${version}";
        version = "1.10.6";

        src = fetchFromGitHub {
          owner = "docker";
          repo = "docker-py";
          rev = version;
          sha256 = "1awzpbrkh4fympqzddz5i3ml81b7f0i0nwkvbpmyxjjfqx6l0m4m";
        };

        propagatedBuildInputs = with self; [
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

      pymongo = super.pymongo.overridePythonAttrs (oldAttrs: rec {
        version = "2.9.5";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "912516ac6a355d7624374a38337b8587afe3eb535c0a5456b3bd12df637a6e70";
        };
      });
    };
  };

in stdenv.mkDerivation rec {
  version = "5.11.2";
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner  = "datadog";
    repo   = "dd-agent";
    rev    = version;
    sha256 = "1iqxvgpsqibqw3vk79158l2pnb6y4pjhjp2d6724lm5rpz4825lx";
  };

  patches = [ ./40103-iostat-fix.patch ];

  buildInputs = [
    unzip
    makeWrapper
  ] ++ (with python'.pkgs; [
    requests
    psycopg2
    psutil
    ntplib
    simplejson
    pyyaml
    pymongo
    python-etcd
    consul
    docker
  ]);
  propagatedBuildInputs = with python'.pkgs; [ python tornado ];

  buildCommand = ''
    mkdir -p $out/bin
    cp -R $src $out/agent
    chmod u+w -R $out
    (cd $out/agent; patchPhase)
    PYTHONPATH=$out/agent:$PYTHONPATH
    ln -s $out/agent/agent.py $out/bin/dd-agent
    ln -s $out/agent/dogstatsd.py $out/bin/dogstatsd
    ln -s $out/agent/ddagent.py $out/bin/dd-forwarder

    # Move out default conf.d so that /etc/dd-agent/conf.d is used
    mv $out/agent/conf.d $out/agent/conf.d-system

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
    description = ''
      Event collector for the DataDog analysis service
      -- v5 Python implementation
    '';
    homepage    = https://www.datadoghq.com;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice domenkozar ];
  };
}
