{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tile38";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "tidwall";
    repo = pname;
    rev = version;
    sha256 = "sha256-aGt5iBVT5MTbnuoZ4zd5r6sIwmNKPo1J7UjDAefKfPo=";
  };

  vendorHash = "sha256-9KK1IRwERcJtVnK4y5l3Nr87I3hg7E8nJuJjRiCMCZk=";

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
