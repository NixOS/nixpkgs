{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.9.7";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SOkPQmKf4OLZnfwR36PG9t74gIip+QvTzb5LQC5b9ZY=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    distro
    psutil
    setuptools
  ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  postPatch = ''
    sed -i setup.py \
      -e 's|"setuptools-git-versioning"||'

    sed -i auto_cpufreq/core.py \
      -e 's|/usr/local/share/auto-cpufreq/scripts/|/run/current-system/sw/bin/|' \
      -e 's|def cpufreqctl():|def cpufreqctl():\n    pass\n    return|' \
      -e 's|def cpufreqctl_restore():|def cpufreqctl_restore():\n    pass\n    return|' \
      -e 's|def deploy_daemon():|def deploy_daemon():\n    pass\n    return|' \
      -e 's|def deploy_daemon_performance():|def deploy_daemon_performance():\n    pass\n    return|' \
      -e 's|def remove():|def remove():\n    pass\n    return|' \
      -e 's|def app_version():|def app_version():\n    print("auto-cpufreq version: @version@")\n    print("Git commit: v@version@")\n    pass\n    return|'

    sed -i scripts/auto-cpufreq.service \
      -e '/^WorkingDirectory=/d' \
      -e '/^Environment=/d' \
      -e 's|ExecStart=.*/bin|ExecStart='$out'/bin|'
  '';

  postInstall = ''
    # copy script manually
    cp scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp scripts/auto-cpufreq.service $out/lib/systemd/system/auto-cpufreq.service
  '';

  meta = with lib; {
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Technical27 ];
  };
}
