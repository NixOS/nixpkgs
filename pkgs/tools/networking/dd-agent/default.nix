{ stdenv, curl, fetchFromGitHub, makeWrapper, pythonPackages, sysstat }:

stdenv.mkDerivation rec {
  version = "5.0.4";
  name = "dd-agent-${version}";

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "dd-agent";
    rev = version;
    sha256 = "1hnz6g366gnbn4d9v413jz7m91b2rvi4rqn4ngcfzmm6abmfr497";
  };

  buildInputs = [ curl makeWrapper pythonPackages.virtualenv ];

  dontBuild = true;

  installPhase = ''
    # copy source
    SRC="$out/share/datadog/agent/"
    mkdir -p "$SRC"
    cp -r ./checks "$SRC"
    cp -r ./checks.d "$SRC"
    cp -r ./dogstream "$SRC"
    cp -r ./pup "$SRC"
    cp -r ./resources "$SRC"
    cp -r ./*.py "$SRC"
    cp -r ./LICENSE* "$SRC"
    cp -r ./datadog-cert.pem "$SRC"
    ETC="$out/etc/dd-agent"
    mkdir -p "$ETC"
    cp -r ./conf.d "$ETC"
    cp -r ./datadog.conf.example "$ETC"
    BIN="$out/bin"
    mkdir -p "$BIN"
    ln -sf ../share/datadog/agent/dogstatsd.py  "$BIN/dogstatsd"
    ln -sf ../share/datadog/agent/agent.py      "$BIN/dd-agent"
    ln -sf ../share/datadog/agent/ddagent.py    "$BIN/dd-forwarder"
    chmod 755 "$BIN/dogstatsd"
    chmod 755 "$BIN/dd-agent"
    chmod 755 "$BIN/dd-forwarder"
    # apply virtualenv requirements
    virtualenv $out/virtualenv
    source $out/virtualenv/bin/activate
    HOME=$out pip install -r ${src}/requirements.txt
    # patch sysstat calls
    substituteInPlace "$SRC/checks/system/unix.py" --replace "Popen(['iostat'" "Popen(['${sysstat}/${sysstat}/bin/iostat'"
    substituteInPlace "$SRC/checks/system/unix.py" --replace 'Popen(["iostat"' 'Popen(["${sysstat}/${sysstat}/bin/iostat"'
    substituteInPlace "$SRC/checks/system/unix.py" --replace "Popen(['mpstat'" "Popen(['${sysstat}/${sysstat}/bin/mpstat'"
    # wrap virtualenv
    wrapProgram $out/bin/dd-forwarder \
      --run "source $out/virtualenv/bin/activate" \
    wrapProgram $out/bin/dd-agent \
      --run "source $out/virtualenv/bin/activate" \
    wrapProgram $out/bin/dogstatsd \
      --run "source $out/virtualenv/bin/activate" \
  '';

  meta = {
    description = "Event collector for the DataDog analysis service";
    homepage    = http://www.datadoghq.com;
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice iElectric ];
  };
}
