{ mkDerivation
, lib
, fetchFromGitHub
, aeson
, base
, bytestring
, containers
, directory
, hsyslog
, http-conduit
, http2
, network-uri
, optparse-applicative
, pretty-simple
, process
, string-qq
, strings
, text
, time
, unix
, utf8-string
, twain
, warp
, yaml
}:
mkDerivation rec {
  pname = "oama";
  version = "0.13.3";

  src = fetchFromGitHub {
    owner = "pdobsan";
    repo = pname;
    rev = version;
    hash = "sha256-6/Bx8CwBhpjHBVWT5XqrPDVIKAq/hNwo2oildl513UI=";
  };

  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    aeson
    base
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    http2
    network-uri
    optparse-applicative
    pretty-simple
    process
    string-qq
    strings
    text
    time
    unix
    utf8-string
    twain
    warp
    yaml
  ];

  mainProgram = "oama";
  license = lib.licenses.bsd3;
  description = "OAuth credential Manager";
  homepage = "https://github.com/pdobsan/oama";
  maintainers = with lib.maintainers; [ melkor333 ];
  platforms = lib.platforms.linux;
}
