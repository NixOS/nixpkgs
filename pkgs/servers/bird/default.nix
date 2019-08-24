{ lib, stdenv, fetchurl, fetchpatch, flex, bison, readline }:

with lib;

let

  generic = { version, sha256, enableIPv6 ? false }:
    stdenv.mkDerivation rec {
      pname = "bird";
      inherit version;

      src = fetchurl {
        inherit sha256;
        url = "ftp://bird.network.cz/pub/bird/${pname}-${version}.tar.gz";
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
        maintainers = with maintainers; [ fpletz globin ];
        platforms = platforms.linux;
      };
    };

in

{
  bird = generic {
    version = "1.6.6";
    sha256 = "0w1dmwx89g3qdy92wkjl3p52rn521izm2m8yq74hs7myxxx3nnwp";
  };

  bird6 = generic {
    version = "1.6.6";
    sha256 = "0w1dmwx89g3qdy92wkjl3p52rn521izm2m8yq74hs7myxxx3nnwp";
    enableIPv6 = true;
  };

  bird2 = generic {
    version = "2.0.5";
    sha256 = "1lr963ywy0mkrhgs5969wc354lizddsagrlbf8x84yb5s9pp6jsf";
  };
}
