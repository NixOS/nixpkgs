{ stdenv, fetchFromGitHub, nodejs, which, python27, utillinux, nixosTests }:

let version = "20.6"; in
stdenv.mkDerivation {
  name = "cjdns-"+version;

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "cjdns-v${version}";
    sha256 = "1d5rrnqb5dcmm5cg2ky1cgxz6ncb23n1j797j9zzw6xxdvkf3kgi";
  };

  buildInputs = [ which python27 nodejs ] ++
    # for flock
    stdenv.lib.optional stdenv.isLinux utillinux;

  CFLAGS = "-O2 -Wno-error=stringop-truncation";
  buildPhase =
    stdenv.lib.optionalString stdenv.isAarch32 "Seccomp_NO=1 "
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

  passthru.tests.basic = nixosTests.cjdns;

  meta = with stdenv.lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Encrypted networking for regular people";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
