{ stdenv, fetchgit, cmake, expat, proj, bzip2, zlib, boost, postgresql, lua}:

let
  version = "0.92.1-unstable";
in
stdenv.mkDerivation rec {
  name = "osm2pgsql-${version}";

  src = fetchgit {
    url = "https://github.com/openstreetmap/osm2pgsql.git";
    rev = "2b72b2121e91b72b0db6911d65c5165ca46d9d66";
    # Still waiting on release after:
    # https://github.com/openstreetmap/osm2pgsql/pull/684
    # https://github.com/openstreetmap/osm2pgsql/issues/634
    #rev = "refs/tags/${version}";
    sha256 = "1v6s863zsv9p2mni35gfamawj0xr2cv2p8a31z7sijf8m6fn0vpy";
  };
  nativeBuildInputs = [cmake];
  buildInputs = [expat proj bzip2 zlib boost postgresql lua];

  meta = {
    description = "OpenStreetMap data to PostgreSQL converter";
    version = "0.92.1-unstable";
    homepage = https://github.com/openstreetmap/osm2pgsql;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
}
