{ buildPythonPackage, lib, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "torrent_parser";
  version = "0.4.1";

  # No tarballs on Pypi
  src = fetchFromGitHub {
    owner  = "7sDream";
    repo   = "torrent_parser";
    rev    = "v${version}";
    sha256 = "sha256-zM738r3o9dGZYoWLN7fM4E06m6YPcAODEkgDS6wU/Sc=";
  };

  meta = {
    description = "A .torrent file parser and creator for both Python 2 and 3";
    homepage    = "https://github.com/7sDream/torrent_parser";
    license     = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
