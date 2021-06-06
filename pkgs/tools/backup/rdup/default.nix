{ lib, stdenv, fetchFromGitHub, pkg-config, autoreconfHook, glib, pcre }:

stdenv.mkDerivation {
  pname = "rdup";
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "miekg";
    repo = "rdup";
    rev = "d66e4320cd0bbcc83253baddafe87f9e0e83caa6";
    sha256 = "0bzyv6qmnivxnv9nw7lnfn46k0m1dlxcjj53zcva6v8y8084l1iw";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ glib pcre ];

  meta = {
    description = "The only backup program that doesn't make backups";
    homepage    = "https://github.com/miekg/rdup";
    license    = lib.licenses.gpl3;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
}
