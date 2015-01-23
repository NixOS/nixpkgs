{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux }:

let
  version = "14"; # see ${src}/util/version/Version.h
  date = "20150123";
in
stdenv.mkDerivation {
  name = "cjdns-${version}-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "601b6cd234713ff217def29cf509d2d537bb0989";
    sha256 = "1m98nplzi6lirrlgzbkpjgxzv6x38dxsl1ac44xala2rqf6xklpq";
  };

  buildInputs = [ which python27 nodejs ] ++
    # for flock
    stdenv.lib.optional stdenv.isLinux [ utillinux ];

  buildPhase = "bash do";
  installPhase = ''
    installBin cjdroute makekeys privatetopublic publictoip6
    sed -i 's,/usr/bin/env node,'$(type -P node), \
      $(find contrib -name "*.js")
    sed -i 's,/usr/bin/env python,'$(type -P python), \
      $(find contrib -type f)
    mkdir -p $out/share/cjdns
    cp -R contrib node_build node_modules $out/share/cjdns/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric emery ];
    platforms = platforms.unix;
  };
}
