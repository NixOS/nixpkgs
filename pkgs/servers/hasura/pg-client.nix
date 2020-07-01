{ mkDerivation, aeson, aeson-casing, attoparsec, base, bytestring
, criterion, fetchgit, file-embed, hashable, hashtables, hasql
, hasql-pool, hasql-transaction, monad-control, mtl
, postgresql-binary, postgresql-libpq, resource-pool, retry
, scientific, stdenv, template-haskell, text, text-builder, th-lift
, th-lift-instances, time, transformers-base, uuid, vector
}:
mkDerivation {
  pname = "pg-client";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/hasura/pg-client-hs.git";
    sha256 = "1941gj5yp24kx0xb1nd774nwp5vnpsp6m83isqkwpyz9spl4sq7l";
    rev = "70a849d09bea9461e72c5a5bbde06df65aab61c0";
    fetchSubmodules = true;
  };
  libraryHaskellDepends = [
    aeson aeson-casing attoparsec base bytestring hashable hashtables
    monad-control mtl postgresql-binary postgresql-libpq resource-pool
    retry scientific template-haskell text text-builder th-lift
    th-lift-instances time transformers-base uuid vector
  ];
  testHaskellDepends = [ base ];
  benchmarkHaskellDepends = [
    base bytestring criterion file-embed hashable hasql hasql-pool
    hasql-transaction mtl postgresql-libpq text text-builder
  ];
  homepage = "https://github.com/hasura/platform";
  license = stdenv.lib.licenses.bsd3;
}
