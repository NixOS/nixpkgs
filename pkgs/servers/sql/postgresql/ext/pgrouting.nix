{ lib, stdenv, fetchFromGitHub, fetchpatch, postgresql, perl, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "pgrouting";
  version = "3.6.0";

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ postgresql boost ];

  src = fetchFromGitHub {
    owner  = "pgRouting";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-FOHIQzL8tmSWllCTzQkuGOiqk47S+HTB8aEpAC30YNk=";
  };

  patches = [
    # Fix issues with size_t vs uint64_ on Darwin. Remove with the next release.
    (fetchpatch {
      url = "https://github.com/pgRouting/pgrouting/commit/b16e9da748e9d78c8b19d2b1db3baeb19c33c6aa.patch";
      hash = "sha256-CJmuVxZ3zIJTa6KXhM2cvynAE6Vmff7XBDfSGg4W9dE=";
    })
  ];

  installPhase = ''
    install -D lib/*.so                        -t $out/lib
    install -D sql/pgrouting--${version}.sql   -t $out/share/postgresql/extension
    install -D sql/common/pgrouting.control    -t $out/share/postgresql/extension
  '';

  meta = with lib; {
    description = "A PostgreSQL/PostGIS extension that provides geospatial routing functionality";
    homepage    = "https://pgrouting.org/";
    changelog   = "https://github.com/pgRouting/pgrouting/releases/tag/v${version}";
    maintainers = with maintainers; teams.geospatial.members ++ [ steve-chavez ];
    platforms   = postgresql.meta.platforms;
    license     = licenses.gpl2Plus;
  };
}
