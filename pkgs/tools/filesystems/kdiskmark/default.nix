{ stdenv
, lib
, wrapQtAppsHook
, qtbase
, qttools
, fio
, cmake
, kauth
, extra-cmake-modules
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  name = "kdiskmark";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "jonmagon";
    repo = "kdiskmark";
    rev = version;
    sha256 = "sha256-fDimH0BX0zxGuOMNLhNbMGMr2pS+qbZhflSpoLFK+Ng=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    qtbase
    qttools
    extra-cmake-modules
    kauth
  ];

  postInstall = ''
    # so that kdiskmark can be used as unpriviledged user even on non-kde
    # (where kauth is not in environment.systemPackages)
    ln -s ${kauth}/share/dbus-1/system.d/org.kde.kf5auth.conf $out/share/dbus-1/system.d/00-kdiskmark-needs-org.kde.kf5auth.conf
  '';

  qtWrapperArgs =
    [ "--prefix" "PATH" ":" (lib.makeBinPath [ fio ]) ];

  meta = with lib; {
    description = "HDD and SSD benchmark tool with a friendly graphical user interface";
    longDescription = ''
      If kdiskmark is not run as root it can rely on polkit to get the necessary
      privileges. In this case you must install it with `environment.systemPackages`
      on NixOS, nix-env will not work.
    '';
    homepage = "https://github.com/JonMagon/KDiskMark";
    maintainers = [ maintainers.symphorien ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}

