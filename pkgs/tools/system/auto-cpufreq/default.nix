{ lib, python3Packages, fetchFromGitHub, substituteAll }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
<<<<<<< HEAD
  version = "1.9.9";
=======
  version = "1.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-D/5pwE2V+yXj92ECOUcl/dajMDbvVdz9YNJrl2Pzvts=";
  };

  propagatedBuildInputs = with python3Packages; [ setuptools-git-versioning click distro psutil ];
=======
    sha256 = "1r27ydv258c6pc82za0wq8q8fj0j3r50c8wxc6r7dwr6wx8q3asx";
  };

  propagatedBuildInputs = with python3Packages; [ click distro psutil ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    # patch to prevent update
    ./prevent-update.patch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # systemd service
    mkdir -p $out/lib/systemd/system
    cp ${src}/scripts/auto-cpufreq.service $out/lib/systemd/system
<<<<<<< HEAD
  '';

  meta = with lib; {
    mainProgram = "${pname}";
=======
    substituteInPlace $out/lib/systemd/system/auto-cpufreq.service --replace "/usr/local" $out
  '';

  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/AdnanHodzic/auto-cpufreq";
    description = "Automatic CPU speed & power optimizer for Linux";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.Technical27 ];
  };
}
