{ lib, fetchFromGitHub, python3Packages, unstableGitUpdater, gnupg }:

python3Packages.buildPythonApplication rec {
  pname = "apt-offline";
  version = "unstable-2021-04-11";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "4e4b3281d004d1ece4833b7680e2b5b091402a03";
    sha256 = "1lk4186h2wc8fphd592rhq7yj4kgc7jjawx4pjrs6pg4n0q32pl6";
  };

  postPatch = ''
    substituteInPlace org.debian.apt.aptoffline.policy \
      --replace /usr/bin/ "$out/bin"

    substituteInPlace apt_offline_core/AptOfflineCoreLib.py \
      --replace /usr/bin/gpgv "${gnupg}/bin/gpgv"
  '';

  preFixup = ''
    rm "$out/bin/apt-offline-gui"
    rm "$out/bin/apt-offline-gui-pkexec"
  '';

  doCheck = false;

  pythonimportsCheck = [ "apt-offline" ];

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/rickysarraf/apt-offline.git";
  };

  meta = with lib; {
    homepage = "https://github.com/rickysarraf/apt-offline";
    description = "Offline APT package manager";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
