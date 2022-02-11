{ lib, fetchFromGitHub, python3Packages, unstableGitUpdater, gnupg }:

python3Packages.buildPythonApplication rec {
  pname = "apt-offline";
  version = "unstable-2022-02-06";

  src = fetchFromGitHub {
    owner = "rickysarraf";
    repo = pname;
    rev = "2b9929773ff2b6e53d30c50c31fb3a1605631f5f";
    sha256 = "mf2NM39ql6KR/YTWPYNyVe+bvWmUFYfxt5BGmU5WFpQ=";
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
