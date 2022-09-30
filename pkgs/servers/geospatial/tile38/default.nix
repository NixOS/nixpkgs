{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tile38";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-/C4gCFLeI12ZrNG8ZY0H7mvojm9ekxqs2x0fKl4dgPU=";
  };

  vendorSha256 = "sha256-/7dDPUXutyzkWq6EVVINFKzhuaiBCv5GrAF5pWG3ikc=";

  subPackages = [ "cmd/tile38-cli" "cmd/tile38-server" ];

  ldflags = [ "-s" "-w" "-X github.com/tidwall/tile38/core.Version=${version}" ];

  meta = with lib; {
    description = "Real-time Geospatial and Geofencing";
    longDescription = ''
      Tile38 is an in-memory geolocation data store, spatial index, and realtime geofence.
      It supports a variety of object types including lat/lon points, bounding boxes, XYZ tiles, Geohashes, and GeoJSON.
    '';
    homepage = "https://tile38.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
