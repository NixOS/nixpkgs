{
  mkDerivation,
  fetchFromGitHub,
  aeson,
  base,
  base64,
  bytestring,
  containers,
  directory,
  hsyslog,
  http-conduit,
  lib,
  network-uri,
  optparse-applicative,
  pretty-simple,
  process,
  random,
  strings,
  template-haskell,
  text,
  time,
  twain,
  unix,
  utf8-string,
  warp,
  yaml,
}:
mkDerivation rec {
  pname = "mailctl";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "pdobsan";
    repo = "mailctl";
    rev = version;
    hash = "sha256-frT+fRJpixSvpb2+C34Z47zbMqvmDHdESItXb9YVbfU=";
  };

  isLibrary = true;
  isExecutable = true;

  libraryHaskellDepends = [
    aeson
    base
    base64
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    network-uri
    optparse-applicative
    pretty-simple
    process
    random
    strings
    template-haskell
    text
    time
    twain
    unix
    utf8-string
    warp
    yaml
  ];

  executableHaskellDepends = [
    aeson
    base
    base64
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    network-uri
    optparse-applicative
    pretty-simple
    process
    random
    strings
    template-haskell
    text
    time
    twain
    unix
    utf8-string
    warp
    yaml
  ];

  description = "OAuth2 tool for mail clients";
  homepage = "https://github.com/pdobsan/mailctl";
  changelog = "https://github.com/pdobsan/mailctl/releases/tag/${version}";
  license = lib.licenses.bsd3;
  maintainers = with lib.maintainers; [ aidalgol ];
  mainProgram = "mailctl";
}
