{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux }:

let
  version = "13"; # see ${src}/util/version/Version.h
  date = "20150102";
in
stdenv.mkDerivation {
  name = "cjdns-${version}-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "da108a24c958b6b8f592bcc6f89990923af0099e";
    sha256 = "0x4161bl4wii4530ja8i1b8qsab9var8yggj7ipvcijd7v3hfvx7";
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
