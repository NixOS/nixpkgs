{ mkDerivation, ansi-wl-pprint, base, binary, bytestring, bzlib
, Cabal, cli-setup, composition-prelude, containers, cpphs
, dependency, dhall, directory, file-embed, filemanip, filepath
, http-client, http-client-tls, lzma, microlens, mtl
, optparse-applicative, parallel-io, process, shake, shake-ats
, shake-c, shake-ext, stdenv, tar, temporary, text, unix
, zip-archive, zlib
}:
mkDerivation {
  pname = "ats-pkg";
  version = "3.2.1.8";
  src = fetchFromGitHub {
    owner = "vmchale";
    repo = "atspkg";
    rev = "${version}";
    sha256 = "10ncx90dd4z0hsb0rfr5lvsp8293s8h90k6q0xrfjs67gy0v20c7";
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
  description = "A build tool for ATS";
  license = stdenv.lib.licenses.bsd3;
  maintainers = with maintainers; [ vmchale bbarker ];
}
