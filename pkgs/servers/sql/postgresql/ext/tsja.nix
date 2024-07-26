{ lib
, fetchzip
, nixosTests
, stdenv

, mecab
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "tsja";
  version = "0.5.0";

  src = fetchzip {
    url = "https://www.amris.jp/tsja/tsja-${version}.tar.xz";
    hash = "sha256-h59UhUG/7biN8NaDiGK6kXDqfhR9uMzt8CpwbJ+PpEM=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local/pgsql ${postgresql} \
      --replace -L/usr/local/lib "" \
      --replace -I/usr/local/include ""
    substituteInPlace tsja.c --replace /usr/local/lib/mecab ${mecab}/lib/mecab
  '';

  buildInputs = [ mecab postgresql ];

  installPhase = ''
    mkdir -p $out/lib $out/share/postgresql/extension
    mv libtsja.so $out/lib
    mv dbinit_libtsja.txt $out/share/postgresql/extension/libtsja_dbinit.sql
  '';

  passthru.tests.tsja = nixosTests.tsja;

  meta = with lib; {
    description = "PostgreSQL extension implementing Japanese text search";
    homepage = "https://www.amris.jp/tsja/index.html";
    maintainers = with maintainers; [ chayleaf ];
    # GNU-specific linker options are used
    platforms = platforms.gnu;
    license = licenses.gpl2Only;
  };
}
