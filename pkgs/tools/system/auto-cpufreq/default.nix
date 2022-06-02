{ lib, python3Packages, fetchFromGitHub, substituteAll }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r27ydv258c6pc82za0wq8q8fj0j3r50c8wxc6r7dwr6wx8q3asx";
  };

  propagatedBuildInputs = with python3Packages; [ click distro psutil ];

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
  ];

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
