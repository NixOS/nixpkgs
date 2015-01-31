{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux }:

let
  version = "15"; # see ${src}/util/version/Version.h
  date = "20150130";
in
stdenv.mkDerivation {
  name = "cjdns-${version}-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "b7681f601dc0ba84c6c710061089f9898247ba4e";
    sha256 = "0r59j9x5i1nkd6k8172l9iq95f6c22ymmkrm9nxwxr5dp2bj0qn5";
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
    cp -R contrib tools node_build node_modules $out/share/cjdns/
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/cjdelisle/cjdns;
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric emery ];
    platforms = platforms.unix;
  };
}
