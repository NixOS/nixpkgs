args @ {stdenv, fetchurl, erlang, spidermonkey, 
	icu, getopt, curl, ...}:

let s = import ./src-for-default.nix; in

stdenv.mkDerivation rec {
  inherit (s) name;
  src = fetchurl {
    inherit (s) url;
    sha256 = s.hash;
  };

  buildInputs = [erlang spidermonkey icu curl];

  postInstall = ''
    sed -i -e "s|\`getopt|\`${getopt}/bin/getopt|" $out/bin/couchdb
  '';
 
  configureFlags = "--with-erlang=${erlang}/lib/erlang/usr/include"; 

}
