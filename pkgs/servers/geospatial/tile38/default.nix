{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tile38";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-sb/DKfQ9dmItxKqICVjG5cslpf8lHzLcs5gd6ue/Zn8=";
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
