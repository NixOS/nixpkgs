{ lib
, python
, fetchFromGitHub
, installShellFiles
, pyudev
, python-linux-procfs
, pyperf
, pygobject3
, configobj
, dbus-python
, gtk3
, wrapGAppsHook
, ethtool
, gawk
, hdparm
}:
python.pkgs.buildPythonApplication rec{
  pname = "tuned";
  version = "2.16.0";
  src = fetchFromGitHub {
    owner = "redhat-performance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v4U4GtTJnINmd390T0H1Bh4v7uw+SYWHpOdnML9lE3I=";
  };

  outputs = [ "out" "man" ]; #TODO:separate GUI output

  propagatedBuildInputs = [
    gawk
    hdparm
    ethtool
    dbus-python
    pyudev
    python-linux-procfs
    pyperf
    pygobject3
    configobj
    gtk3
    wrapGAppsHook
  ];

  nativeBuildInputs = [ installShellFiles ];

  binNames = [ "tuned" "tuned-adm" "powertop2tuned" ];
  libexecNames = [ "defirqaffinity.py" "pmqos-static.py" ]; #TODO: tuned-gui
  postPatch = ''
    cp ${./setup.py} setup.py
    scripts='${builtins.toJSON
      ((map (e: "bin/${e}") binNames)
      ++ (map (e: "libexec/${e}") libexecNames))}' \
      substituteAllInPlace setup.py
    cp experiments/powertop2tuned.py .
    for i in $binNames
    do
      install -D $i.py bin/$i
      chmod a+x bin/$i
    done
  '';

  postInstall = ''
    installShellCompletion tuned-adm.bash
    installManPage man/*

    install -Dt $out/lib/systemd/system tuned.service
    sed -i "s:/usr/sbin:$out/bin:g" $out/lib/systemd/system/tuned.service
    install -Dt $out/lib/tmpfiles.d tuned.tmpfiles
    install -Dt $out/share/polkit-1/actions com.redhat.tuned.policy
    install -Dt $out/share/icons/hicolor/scalable/apps icons/tuned.svg
    install -D dbus.conf $out/share/dbus-1/system.d/tuned.conf
    install -D modules.conf $out/etc/modprobe.d/tuned.conf

    mkdir -p $out/libexec/tuned
    for i in $libexecNames
    do
      mv $out/bin/$i $out/libexec/tuned
    done

    etcTuned=$out/etc/tuned
    install -Dt $etcTuned bootcmdline

    libTuned=$out/lib/tuned
    mv profiles $libTuned
    mv $libTuned/{realtime/realtime,realtime-virtual-guest/realtime-virtual-guest,realtime-virtual-host/realtime-virtual-host,cpu-partitioning/cpu-partitioning}-variables.conf $etcTuned
    install -D recommend.conf $libTuned/recommend.d/50-tuned.conf

    #RHEL renamed pyperf to python-perf
    ln -s ${pyperf}/${python.sitePackages}/pyperf $out/${python.sitePackages}/perf
  '';

  doCheck = false; # cannot import gimport.GTK

  meta = with lib; {
    description = " Tuning Profile Delivery Mechanism for Linux ";
    homepage = "https://tuned-project.org/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.pasqui23 ];
    platforms = platforms.linux;
  };

}
