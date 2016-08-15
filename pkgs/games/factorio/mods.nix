# This file is here for demo purposes only, populated with a small sampling of
# mods. It will eventually be replaced by a nixos-channel that will provide
# derivations for most or all of the mods tracked through the official mod
# manager site.
{ stdenv, fetchurl
, factorio-utils
, allRecommendedMods ? true
, allOptionalMods ? false
}:
with stdenv.lib;
let
  modDrv = factorio-utils.modDrv { inherit allRecommendedMods allOptionalMods; };
in
rec {

  bobassembly = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobassembly_0.13.0.zip
      ];
      sha256 = "0c0m7sb45r37g882x0aq8mc82yhfh9j9h8g018d4s5pf93vzr6d1";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobconfig = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobconfig_0.13.1.zip
      ];
      sha256 = "0z4kmggm1slbr3qiy5xahc9nhdffllp21n9nv5gh1zbzv72sb1rp";
    };
  };

  bobelectronics = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobelectronics_0.13.1.zip
      ];
      sha256 = "16sn5w33s0ckiwqxx7b2pcsqmhxbxjm2w4h4vd99hwpvdpjyav52";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobenemies = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobenemies_0.13.1.zip
      ];
      sha256 = "1wnb5wsvh9aa3i9mj17f36ybbd13qima3iwshw60i6xkzzqfk44d";
    };
    optionalDeps = [ bobconfig ];
  };

  bobgreenhouse = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobgreenhouse_0.13.2.zip
      ];
      sha256 = "1ql26875dvz2lqln289jg1w6yjzsd0x0pqmd570jffwi5m320rrw";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobinserters = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobinserters_0.13.3.zip
      ];
      sha256 = "0nys9zhaw0v3w2xzrhawr8g2hcxkzdmyqd4s8xm5bnbrgrq86g9z";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ ];
  };

  boblibrary = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/boblibrary_0.13.1.zip
      ];
      sha256 = "04fybs626lzxf0p21jl8kakh2mddah7l9m57srk7a87jw5bj1zx8";
    };
  };

  boblogistics = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/boblogistics_0.13.7.zip
      ];
      sha256 = "0c91zmyxwsmyv6vm6gp498vb7flqlcyzkbp9s5q1651hpyd378hx";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobmining = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobmining_0.13.1.zip
      ];
      sha256 = "1l7k3v4aizihppgi802fr5b8zbnq2h05c2bbsk5hds239qgxy80m";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig bobores bobplates ];
  };

  bobmodules = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobmodules_0.13.0.zip
      ];
      sha256 = "0ggd2gc4s5sbld7gyncbzdgq8gc00mvxjcfv7i2dchcrdzrlr556";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates bobassembly bobelectronics ];
  };

  bobores = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobores_0.13.1.zip
      ];
      sha256 = "1rri70655kj77sdr3zgp56whmcl0gfjmw90jm7lj1jp8l1pdfzb9";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
  };

  bobplates = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobplates_0.13.2.zip
      ];
      sha256 = "0iczpa26hflj17k84p4n6wz0pwhbbrfk86dgac4bfz28kqg58nj1";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig bobenemies ];
    recommendedDeps = [ bobores bobtech ];
  };

  bobpower = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobpower_0.13.1.zip
      ];
      sha256 = "18sblnlvprrm2vzlczlki09yj9lr4y64808zrwmcasf7470skar3";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobrevamp = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobrevamp_0.13.0.zip
      ];
      sha256 = "0rkyf61clh8fjg72z9i7r4skvdzgd49ky6s0486xxljhbil4nxb7";
    };
    deps = [ boblibrary ];
  };

  bobtech = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobtech_0.13.0.zip
      ];
      sha256 = "0arc9kilxzdpapn3gh5h8269ssgsjxib4ny0qissq2sg95gxlsn0";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobenemies ];
  };

  bobtechsave = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobtechsave_0.13.0.zip
      ];
      sha256 = "1vlv4sgdfd9ldjm8y79n95ms5k6x2i7khjc422lp9080m03v1hcl";
    };
  };

  bobwarfare = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/bobwarfare_0.13.4.zip
      ];
      sha256 = "07wzn16i4r0qjm41wfyl17rrhry2vrph08a0kq8w5iy6qcbqqfd3";
    };
    deps = [ boblibrary ];
    optionalDeps = [ boblibrary bobplates ];
    recommendedDeps = [ bobtech ];
  };

  clock = modDrv {
    src = fetchurl {
      urls = [
        https://f.xor.us/factorio-mods/clock_0.13.0.zip
      ];
      sha256 = "0nflywbj6p2kz2w9wff78vskzljrzaf32ib56k3z456d9y8mlxfd";
    };
  };

}
