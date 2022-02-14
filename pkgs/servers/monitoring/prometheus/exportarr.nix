{ lib
, buildGoModule
, fetchFromGitHub
}:

let
  pname = "exportarr";
  version = "1.0.0";
in
buildGoModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "onedr0p";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KpMHrAQQuUDS7+Am2JPV8PXFvyNOotDLBvhVWYokmFs=";
  };

  vendorSha256 ="sha256:08fqj9w265q9w7ns7ni85v7jjd4c763v7y2xyvlzrw8lff9rjdc8";

  meta = with lib; {
    description = "AIO Prometheus Exporter for Sonarr, Radarr or Lidarr";
    homepage = "https://github.com/onedr0p/exportarr";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.unix;
  };
}
