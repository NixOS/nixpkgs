{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux }:

let
  version = "15"; # see ${src}/util/version/Version.h
  date = "20150207";
in
stdenv.mkDerivation {
  name = "cjdns-${version}-${date}";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "0fc585e15e25b1bd39be24a534f47bb966485a4a";
    sha256 = "090zx30bgfk6wyh10wbjqpkvjq9l30jc7fh2iagajsmpjs9iipqm";
  };

  buildInputs = [ which python27 nodejs ] ++
    # for flock
    stdenv.lib.optional stdenv.isLinux [ utillinux ];

  buildPhase =
    stdenv.lib.optionalString stdenv.isArm "Seccomp_NO=1 "
    + "bash do";
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
