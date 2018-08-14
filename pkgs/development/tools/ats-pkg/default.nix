{ ansi-wl-pprint, base, binary, bytestring, bzlib
, Cabal, cli-setup, composition-prelude, containers, cpphs
, dependency, dhall, directory, fetchFromGitHub, file-embed, filemanip
, filepath, http-client, http-client-tls, lzma, microlens, mtl
, optparse-applicative, parallel-io, process, shake, shake-ats
, shake-c, shake-ext, stdenv, tar, temporary, text, unix
, zip-archive, zlib
}:
let
  ats-pkg-version = "3.2.1.9";
in
stdenv.mkDerivation rec {
  name = "ats-pkg";
  version = "${ats-pkg-version}";
  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "atspkg";
    rev = "${ats-pkg-version}";
    sha256 = "0yzvnrnrdxyfx4h6r77qfb4vkzmx6x16p77bpfx1vr67z64krbaf";
  };
  isLibrary = true;
  isExecutable = true;
  enableSeparateDataOutput = true;
  libraryHaskellDepends = [
    ansi-wl-pprint base binary bytestring bzlib Cabal
    composition-prelude containers dependency dhall directory
    file-embed filemanip filepath http-client http-client-tls lzma
    microlens mtl parallel-io process shake shake-ats shake-c shake-ext
    tar text unix zip-archive zlib
  ];
  libraryToolDepends = [ cpphs ];
  executableHaskellDepends = [
    base bytestring cli-setup dependency directory microlens
    optparse-applicative parallel-io shake shake-ats temporary text
  ];
  doHaddock = false;
  meta = with stdenv.lib; {
    description = "A build tool for ATS";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vmchale bbarker ];
    homepage = "https://hackage.haskell.org/package/ats-pkg";
  };
}
