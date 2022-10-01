{ lib, python3Packages, fetchFromGitHub, substituteAll }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rT6OFM9hc9cx62xDV5aPebYgrZdWRkofL27l2HRSqTU=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    distro
    psutil
    setuptools
  ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  patches = [
    # hardcodes version output
    (substituteAll {
      src = ./fix-version-output.patch;
      inherit version;
    })

    # patch to prevent script copying and to disable install
    ./prevent-install-and-copy.patch

    # patch to remove venvs from the service file
    ./remove-service-venv.patch
  ];

  postInstall = ''
    # copy script manually
    cp scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp scripts/auto-cpufreq.service $out/lib/systemd/system
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
