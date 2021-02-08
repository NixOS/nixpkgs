{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NDIdQ4gUN2jG+VWXsv3fdUogZxOOiNtnbekD30+jx6M=";
  };

  propagatedBuildInputs = with python3Packages; [ click distro psutil ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  # patch to prevent script copying and to disable install
  patches = [ ./prevent-install-and-copy.patch ];

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp ${src}/scripts/auto-cpufreq.service $out/lib/systemd/system
    substituteInPlace $out/lib/systemd/system/auto-cpufreq.service --replace "/usr/local" $out
  '';

  meta = with lib; {
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Technical27 ];
  };
}
