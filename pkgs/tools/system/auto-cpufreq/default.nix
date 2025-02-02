{ lib, python3Packages, fetchFromGitHub, substituteAll }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "1.9.9";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-D/5pwE2V+yXj92ECOUcl/dajMDbvVdz9YNJrl2Pzvts=";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools-git-versioning click distro psutil ];

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
    # patch to prevent update
    ./prevent-update.patch
  ];

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp ${src}/scripts/auto-cpufreq.service $out/lib/systemd/system
  '';

  meta = with lib; {
    mainProgram = "${pname}";
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Technical27 ];
  };
}
