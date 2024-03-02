{ buildGoModule, fetchFromGitLab, lib }:
buildGoModule rec {
  pname = "gnss-share";
  version = "0.7.2";
  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "gnss-share";
    rev = version;
    hash = "sha256-0osXA+t+trm41ekcDiJwq0IAB+6ibrlwP/c2JNAXRpU=";
  };
  vendorHash = "sha256-a5CZxh92MW3yP/ZhwGI9UWUT8hwJ0/zeTyPNC+c2R9U=";
  meta = with lib; {
    description = "share GNSS data between multiple clients";
    longDescription = ''
      gnss-share is an app that facilitates sharing GNSS location data with multiple
      clients, while providing a way to perform device-specific setup beforehand. For
      some devices, it can also manage loading and storing A-GPS data.

      This is meant to replace things like gpsd, and gps-share, and work together
      with geoclue* or other clients that support fetching NMEA location data over
      sockets.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ balsoft ];
    mainProgram = "gnss-share";
  };
}
