{ stdenv, fetchFromGitHub, python, pythonPackages, sysstat, unzip, tornado
, makeWrapper }:

stdenv.mkDerivation rec {
  version = "5.4.3";
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner  = "datadog";
    repo   = "dd-agent";
    rev    = version;
    sha256 = "07cign0ydxf1h6xsyi3iviywlm9x6d6rcaz46f3wipby6mv1s5dc";
  };

  buildInputs = [
    python
    unzip
    makeWrapper
    pythonPackages.psycopg2
    pythonPackages.psutil
    pythonPackages.ntplib
    pythonPackages.simplejson
    pythonPackages.pyyaml
    pythonPackages.requests
    pythonPackages.pymongo
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

    wrapProgram $out/bin/dd-forwarder \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dd-agent \
      --prefix PYTHONPATH : $PYTHONPATH
    wrapProgram $out/bin/dogstatsd \
      --prefix PYTHONPATH : $PYTHONPATH

    patchShebangs $out
  '';

  meta = {
    description = "Event collector for the DataDog analysis service";
    homepage    = http://www.datadoghq.com;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice iElectric ];
  };
}
