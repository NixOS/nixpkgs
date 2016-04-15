{ stdenv, fetchurl, nodejs, which, python27, utillinux }:

let version = "17.3"; in
stdenv.mkDerivation {
  name = "cjdns-"+version;

  src = fetchurl {
    url = "https://github.com/cjdelisle/cjdns/archive/cjdns-v${version}.tar.gz";
    sha256 = "00p62y7b89y3piirpj27crprji8nh0zv7zh4mcqhzh6r39jxz4ri";
  };

  buildInputs = [ which python27 nodejs ] ++
    # for flock
    stdenv.lib.optional stdenv.isLinux utillinux;

  buildPhase =
    stdenv.lib.optionalString stdenv.isArm "Seccomp_NO=1 "
    + "bash do";
  installPhase = ''
    install -Dt "$out/bin/" cjdroute makekeys privatetopublic publictoip6
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
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.unix;
  };
}
