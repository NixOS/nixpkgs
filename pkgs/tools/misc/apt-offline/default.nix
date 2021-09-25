{ lib, fetchFromGitHub, python3Packages, unstableGitUpdater, gnupg }:

python3Packages.buildPythonApplication rec {
  pname = "apt-offline";
  version = "unstable-2021-07-25";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "7cfa5fc2736be2c832d0ddfa9255175a1f33158d";
    sha256 = "xX2wcvqoPdgqBAWvQmSd//YWMC4pPmrq0vQjhDUKwEA=";
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
