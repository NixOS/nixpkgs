{ lib, fetchFromGitHub, python3Packages, nix-update-script, gnupg }:

python3Packages.buildPythonApplication rec {
  pname = "apt-offline";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "v${version}";
    sha256 = "RBf/QG0ewLS6gnQTBXi0I18z8QrxoBAqEXZ7dro9z5A=";
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

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    homepage = "https://github.com/rickysarraf/apt-offline";
    description = "Offline APT package manager";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
