{ stdenv, lib, fetchFromGitHub, fetchurl
, clang-tools, cmake, bzip2, zlib, expat, boost, git, pandoc
# Nominatim needs to be built with the same postgres version it will target
, postgresql
, python3, php
}:

let
  countryGrid = fetchurl {
    # Nominatim docs mention https://www.nominatim.org/data/country_grid.sql.gz but it's not a very good URL for pinning
    url = "https://web.archive.org/web/20220323041006/https://nominatim.org/data/country_grid.sql.gz";
    sha256 = "sha256-/mY5Oq9WF0klXOv0xh0TqEJeMmuM5QQJ2IxANRZd4Ek=";
  };
in
stdenv.mkDerivation rec {
  pname = "nominatim";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "osm-search";
    repo = "Nominatim";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-sKI/KBKveb5kAWJ7y1xw+ZF1thynr402rJhVjkIdFMo=";
  };

  nativeBuildInputs = [
    cmake
    clang-tools
    git
    pandoc
    php
  ];

  buildInputs = [
    bzip2
    zlib
    expat
    boost
    (python3.withPackages (ps: with ps; [
      pyyaml
      python-dotenv
      psycopg2
      psutil
      jinja2
      pyicu
      datrie
    ]))
    # python3Packages.pylint  # We don't want to run pylint because the package could break on pylint bumps which is really annoying.
    # python3Packages.pytest  # disabled since I can't get it to run tests anyway
    # python3Packages.behave  # disabled since I can't get it to run tests anyway
    postgresql
  ];

  postPatch = ''
    mkdir -p ./data
    ln -s ${countryGrid} ./data/country_osm_grid.sql.gz
  '';

  meta = with lib; {
    description = "Search engine for OpenStreetMap data";
    homepage = "https://nominatim.org/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.mausch ];
    mainProgram = "nominatim";
  };
}
