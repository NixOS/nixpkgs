{ buildGoModule
, lib
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfs_exporter";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.2.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pdf";
    repo = pname;
    rev = "v" + version;
<<<<<<< HEAD
    hash = "sha256-EM7CHvpqPwCKgb5QU+jYmMaovHp12hJD1zVxcYygHdU=";
  };

  vendorHash = "sha256-AgZo+5gYJ2EaxSI+Jxl7ldu6iZ+uSncYR0n+D2mMC4w=";
=======
    hash = "sha256-NTlYMznUfDfLftvuR5YWOW4Zu0rWfLkKPHPTrD/62+Q=";
  };

  vendorHash = "sha256-ZJRxH9RhNSnVmcsonaakbvvjQ+3ovnyMny1Pe/vyQxE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} *.md
  '';

  meta = with lib; {
    description = "ZFS Exporter for the Prometheus monitoring system";
    homepage = "https://github.com/pdf/zfs_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
