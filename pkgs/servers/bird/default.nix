{ lib, stdenv, fetchurl, fetchpatch, flex, bison, readline }:

with lib;

let

  generic = { version, sha256, enableIPv6 ? false }:
    stdenv.mkDerivation rec {
      name = "bird-${version}";

      src = fetchurl {
        inherit sha256;
        url = "ftp://bird.network.cz/pub/bird/${name}.tar.gz";
      };

      nativeBuildInputs = [ flex bison ];
      buildInputs = [ readline ];

      patches = [
        (./. + "/dont-create-sysconfdir-${builtins.substring 0 1 version}.patch")
      ]
      ++ optional (lib.versionOlder version "2")
        # https://github.com/BIRD/bird/pull/4
        (fetchpatch {
          url = "https://github.com/BIRD/bird/commit/fca9ab48e3823c734886f47156a92f6b804c16e9.patch";
          sha256 = "1pnndc3n56lqqcy74ln0w5kn3i9rbzsm2dqiyp1qw7j33dpkln1b";
        })
        ;

      CPP="${stdenv.cc.targetPrefix}cpp -E";

      configureFlags = [
        "--localstatedir=/var"
      ] ++ optional enableIPv6 "--enable-ipv6";

      meta = {
        description = "BIRD Internet Routing Daemon";
        homepage = http://bird.network.cz;
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ fpletz ];
        platforms = platforms.linux;
      };
    };

in

{
  bird = generic {
    version = "1.6.3";
    sha256 = "0z3yrxqb0p7f8b7r2gk4mvrwfzk45zx7yr9aifbvba1vgksiri9r";
  };

  bird6 = generic {
    version = "1.6.3";
    sha256 = "0z3yrxqb0p7f8b7r2gk4mvrwfzk45zx7yr9aifbvba1vgksiri9r";
    enableIPv6 = true;
  };

  bird2 = generic {
    version = "2.0.2";
    sha256 = "03s8hcl761y3489j1krarm3r3iy5qid26508i91yvy38ypb92pq3";
  };
}
