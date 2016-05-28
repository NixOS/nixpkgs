{ stdenv, fetchFromGitHub, python, pythonPackages, sysstat, unzip, tornado
, makeWrapper, rsync }:

stdenv.mkDerivation rec {
  version = "5.7.4";
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner  = "datadog";
    repo   = "dd-agent";
    rev    = version;
    sha256 = "1shjc6d68m725fmpy2fjn4vam23g1wq8z9a0kxsk746ivvnd32fb";
  };

  buildInputs = [
    python
    unzip
    makeWrapper
    rsync
    pythonPackages.psycopg2
    pythonPackages.psutil
    pythonPackages.ntplib
    pythonPackages.simplejson
    pythonPackages.pyyaml
    pythonPackages.requests
    pythonPackages.pymongo
    pythonPackages.docker
    pythonPackages.dns
    pythonPackages.pyvmomi
    pythonPackages.boto
  ];
  propagatedBuildInputs = [ python tornado ];

  buildCommand = ''
    mkdir -p $out/bin
    # https://github.com/DataDog/dd-agent/pull/2013
    rsync -rv --exclude=conf.d $src/ $out/agent/
    chmod u+w -R $out
    PYTHONPATH=$out/agent:$PYTHONPATH
    ln -s $out/agent/agent.py $out/bin/dd-agent
    ln -s $out/agent/dogstatsd.py $out/bin/dogstatsd
    ln -s $out/agent/ddagent.py $out/bin/dd-forwarder
    (echo '#!/usr/bin/env python'; cat $out/agent/jmxfetch.py) > $out/agent/jmxfetch
    chmod 755 $out/agent/jmxfetch
    ln -s $out/agent/jmxfetch $out/bin/jmxfetch

    wrapProgram $out/bin/dd-forwarder \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dd-agent \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dogstatsd \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/jmxfetch \
      --prefix PYTHONPATH : $PYTHONPATH \
      --prefix CLASSPATH : $out/agent

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
