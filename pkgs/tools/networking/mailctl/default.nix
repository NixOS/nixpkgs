{ mkDerivation
, fetchFromSourcehut
, aeson
, base
, bytestring
, containers
, directory
, hsyslog
, http-conduit
, lib
, network-uri
, optparse-applicative
, pretty-simple
, process
, template-haskell
, text
, time
, twain
, utf8-string
, warp
, yaml
}:
mkDerivation rec {
  pname = "mailctl";
  version = "0.8.8";

  src = fetchFromSourcehut {
    owner = "~petrus";
    repo = "mailctl";
    rev = version;
    hash = "sha256-aFt6y2DzreROLcOLU8ynnSSVQW840T5wFqSRdSODQX4=";
  };

  isLibrary = true;
  isExecutable = true;

  libraryHaskellDepends = [
    aeson
    base
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    network-uri
    optparse-applicative
    pretty-simple
    process
    template-haskell
    text
    time
    twain
    utf8-string
    warp
    yaml
  ];

  executableHaskellDepends = [
    aeson
    base
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    network-uri
    optparse-applicative
    pretty-simple
    process
    template-haskell
    text
    time
    twain
    utf8-string
    warp
    yaml
  ];

  description = "OAuth2 tool for mail clients";
  homepage = "https://sr.ht/~petrus/mailctl/";
  changelog = "https://git.sr.ht/~petrus/mailctl/refs/${version}";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ aidalgol ];
  mainProgram = "mailctl";
}
