{ lib, python3Packages, fetchFromGitHub, substituteAll, wrapGAppsHook, gobject-introspection, gtk3 }:

python3Packages.buildPythonPackage rec {
  pname = "auto-cpufreq";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "AdnanHodzic";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-164Gi1Oo9Tfd58aDq/3UjsWeS4rAZ39xCEhBgqv+GtI=";
  };

  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];

  buildInputs = with pkgs; [ gtk3 ];

  propagatedBuildInputs = with python3Packages; [ setuptools-git-versioning click distro psutil pygobject3 ];

  doCheck = false;
  pythonImportsCheck = [ "auto_cpufreq" ];

  patches = [
    # hardcodes version output
    (substituteAll {
      src = ./fix-version-output.patch;
      inherit version;
    })

     # patch to prevent update
    ./prevent-update.patch

    # patch to prevent script copying and to disable install
    ./prevent-install-and-copy.patch
 ];

  postPatch = ''
    substituteInPlace auto_cpufreq/core.py --replace '/opt/auto-cpufreq/override.pickle' /var/run/override.pickle
    substituteInPlace scripts/org.auto-cpufreq.pkexec.policy --replace "/opt/auto-cpufreq/venv/bin/auto-cpufreq" $out/bin/auto-cpufreq

    substituteInPlace auto_cpufreq/gui/app.py auto_cpufreq/gui/objects.py --replace "/usr/local/share/auto-cpufreq/images/icon.png" $out/share/pixmaps/auto-cpufreq.png
    substituteInPlace auto_cpufreq/gui/app.py --replace "/usr/local/share/auto-cpufreq/scripts/style.css" $out/share/auto-cpufreq/scripts/style.css

    '';

  postInstall = ''
    # copy script manually
    cp ${src}/scripts/cpufreqctl.sh $out/bin/cpufreqctl.auto-cpufreq

    # copy css file
    mkdir -p $out/share/auto-cpufreq/scripts
    cp scripts/style.css $out/share/auto-cpufreq/scripts/style.css


    # systemd service
    mkdir -p $out/lib/systemd/system
    cp ${src}/scripts/auto-cpufreq.service $out/lib/systemd/system

    # desktop icon
    mkdir -p $out/share/applications
    mkdir $out/share/pixmaps
    cp scripts/auto-cpufreq-gtk.desktop $out/share/applications
    cp images/icon.png $out/share/pixmaps/auto-cpufreq.png

    # polkit policy
    mkdir -p $out/share/polkit-1/actions
    cp scripts/org.auto-cpufreq.pkexec.policy $out/share/polkit-1/actions
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
