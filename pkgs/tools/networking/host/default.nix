{ fetchurl, stdenv }:

let version = "20000331"; in
  stdenv.mkDerivation {
    name = "host-${version}";

    src = fetchurl {
      url = "mirror://debian/pool/main/h/host/host_${version}.orig.tar.gz";
      sha256 = "1g352k80arhwyidsa95nk28xjvzyypmwv3kga2451m3g7fmdqki1";
    };

    preConfigure = ''
      makeFlagsArray=(DESTBIN=$out/bin DESTMAN=$out/share/man OWNER=$(id -u) GROUP=$(id -g))
      ensureDir "$out/bin"
      ensureDir "$out/share/man"
    '';

    installTargets = "install man";

    meta = {
      description = "`host', a DNS resolution utility";
      license = "BSD-style";
    };
  }
