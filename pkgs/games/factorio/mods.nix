{ stdenv, fetchurl
, allRecommendedMods ? true
, allOptionalMods ? false
}:
with stdenv.lib;
let
  modDrv = { src
           , name ? null
           , deps ? []
           , optionalDeps ? []
           , recommendedDeps ? []
           }: stdenv.mkDerivation {

    inherit src;

    # Use the name of the zip, but endstrip ".zip" and possibly the querystring that gets left in by fetchurl
    name = replaceStrings ["_"] ["-"] (if name != null then name else removeSuffix ".zip" (head (splitString "?" src.name)));

    deps = deps ++ optionals allOptionalMods optionalDeps
                ++ optionals allRecommendedMods recommendedDeps;

    preferLocalBuild = true;
    buildCommand = ''
      mkdir -p $out
      srcBase=$(basename $src)
      ln -sf $src $out/''${srcBase%\?*} # strip querystring from zip name
      for dep in $deps; do
        for zip in $dep/*.zip; do
          ln -sf $zip $out
        done
      done
    '';
  };
in
rec {

  bobassembly = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AAA6z_UxF8lT4Uw-QjMT5xiXa/bobassembly_0.12.9.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/assembly/bobassembly_0.12.9.zip
      ];
      sha256 = "06b31p4k9p8mqixfr68ki2chjrgwyg1q9x24kbrrhsgjxgsqrz99";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobconfig = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/2me6hx6bi6xemzm/bobconfig_0.12.3.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/config/bobconfig_0.12.3.zip
      ];
      sha256 = "14hnzk9rgf7svzznrmjdafcyvx1r23377msw1lmps7zkhr0l37ny";
    };
  };

  bobelectronics = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AADpCapfewuSytmxHCl-ieZ_a/bobelectronics_0.12.6.zip?dl=1d
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/electronics/bobelectronics_0.12.6.zip
      ];
      sha256 = "1g5ak288hsv2hmwd36j5pkgkl656chy7w6zzbryki5kqmlwvn7ih";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig dytech-core ];
    recommendedDeps = [ bobplates ];
  };

  bobenemies = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/2rznoot6db7djjp/bobenemies_0.12.7.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/enemies/bobenemies_0.12.7.zip
      ];
      sha256 = "0f3znrfhr75fnpq1rjr9a296qdxnn6z4qrm11xxx67adq8v54pwl";
    };
    optionalDeps = [ bobconfig ];
  };

  bobgreenhouse = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/msklepudr883bc4/bobgreenhouse_0.12.1.zip?dl=1
      ];
      sha256 = "108n2bz121ran29f4k5laqrnnfkm5ck9jsxc2802q46dxk0g2a79";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  boblibrary = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/n2gcc8pduaae8fv/boblibrary_0.12.4.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/library/boblibrary_0.12.4.zip
      ];
      sha256 = "04wwsx3b2k8l0zig2c5g8f33yl2qj4wdfgfcil748l8zl90sp15c";
    };
  };

  boblocale = modDrv {
    src = fetchurl {
      urls = [
        https://github.com/Karosieben/boblocale/releases/download/0.12.8/boblocale_0.12.8.zip
      ];
      sha256 = "1pfzb23kp1d4wd5v4g255ip568s4f7yq84hzcd6njm7dzyq9vqmv";
    };
  };

  boblogistics = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/ah5ofkva2r7ed39/boblogistics_0.12.9.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/logistics/boblogistics_0.12.9.zip
      ];
      sha256 = "083ki9qh7191m5gdpb596lr9rgv053ic1jkx4s0b8c7kz5zyfjn9";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobmining = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AABUmWbySyRbGaYul5gH6Slxa/bobmining_0.12.3.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/mining/bobmining_0.12.3.zip
      ];
      sha256 = "1l0x9rvwpjvq4b72pffnrck383a63zqjqvhk5ny681vvx0wkrm8m";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig bobores bobplates ];
  };

  bobmodules = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AAAcgy3tQzr9q0l7O67KWbtCa/bobmodules_0.12.9.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/modules/bobmodules_0.12.9.zip
      ];
      sha256 = "05ibgri9wnxpj51j157idlvdfxpx20d2nh0pbm8zsm7iisngwmh7";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates bobassembly bobelectronics ];
  };

  bobores = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AAABAkwItB5zVqGHjdUmG6p2a/bobores_0.12.7.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/ores/bobores_0.12.7.zip
      ];
      sha256 = "19qclb6xddym1mj4129vm0wvpszqa92hx4hd3rsclynhv36ziqb6";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig dytech-core ];
  };

  bobplates = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/6txelcf8lk87jbr/bobplates_0.12.11.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/plates/bobplates_0.12.11.zip
      ];
      sha256 = "054jxpsanfbfb3js2jlbr71pkx390a24zkkgaakg7n00cizca9ij";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig bobenemies dytech-core ];
    recommendedDeps = [ bobores bobtech ];
  };

  bobpower = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AACs8aEhOzkNlv9Y9Zz7Xw_sa/bobpower_0.12.7.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/power/bobpower_0.12.7.zip
      ];
      sha256 = "0n9qbm5myr9fmzfg6gqkwfkm6dp54yfr0x51vlkf71d8r74vfn4d";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobconfig ];
    recommendedDeps = [ bobplates ];
  };

  bobtech = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AAC8vL387era72VGW3_CmmHZa/bobtech_0.12.4.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/tech/bobtech_0.12.4.zip
      ];
      sha256 = "1fm0mgrxqbxz11i3idx3xyncxxfb016n1nzxpaqajmccm0ngqjaz";
    };
    deps = [ boblibrary ];
    optionalDeps = [ bobenemies ];
  };

  bobtechsave = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/xx9pylbnwo1u76x/bobtechsave_0.12.2.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/techsave/bobtechsave_0.12.2.zip
      ];
      sha256 = "0d6xhxhpl9d7svlav0i6jzkqi7s7ij2iwnigyj6xnmywr4l9b7xc";
    };
  };

  bobwarfare = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/s/xfj8knsw921pcg4/bobwarfare_0.12.10.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/warfare/bobwarfare_0.12.10.zip
      ];
      sha256 = "1xn83446swr5blk314xfalknyg10n5rdyrpk71l1a8lwl47p17mg";
    };
    deps = [ boblibrary ];
    optionalDeps = [ boblibrary bobplates ];
    recommendedDeps = [ bobtech ];
  };

  clock = modDrv {
    src = fetchurl {
      urls = [
        https://www.dropbox.com/sh/6exc0yxdzu2ngyy/AAANp5G5N20uMpiSvqfTnBCea/clock_0.12.2.zip?dl=1
        http://bobingabout.gamemod.net/Factorio/Mods/0.12/clock/clock_0.12.1.zip
      ];
      sha256 = "1kn2w6nki6q8nqkcw3dg222zs0kppd4bkjd96ksk56g8m04xgsqr";
    };
  };

  dytech-core = modDrv {
    src = fetchurl {
      url = https://github.com/Dysoch/DyTech/releases/download/v0.12-factorio-3/CORE-DyTech-Core_1.3.0.zip;
      sha256 = "0ss1x2mi45clyabc97p7ismhrc43a18cdcy26716kmd3hbwhhny5";
    };
    optionalDeps = [ treefarm-lite ];
  };

  dytech-machine = modDrv {
    src = fetchurl {
      url = https://github.com/Dysoch/DyTech/releases/download/v0.12-factorio-1/MAIN-DyTech-Machine_1.1.1.zip;
      sha256 = "116jn1dgya5gwv79df0k4h76y9whnyjrza91mvkadh125k6mrdzp";
    };
    deps = [ dytech-core ];
  };

  dytech-power = modDrv {
    src = fetchurl {
      url = https://github.com/Dysoch/DyTech/releases/download/v0.12-power-4/MAIN-DyTech-Power_1.1.3.zip;
      sha256 = "113m7syglgrlrv3cnphld0isz12wgjhkk2xksqa2y4vah3npy7ar";
    };
    deps = [ dytech-core ];
  };

  dytech-war = modDrv {
    src = fetchurl {
      url = https://github.com/Dysoch/DyTech/releases/download/v0.12-factorio-1/MAIN-DyTech-War_1.1.1.zip;
      sha256 = "0xr2bwjp2y4nak3mr04gjk04kidaslpfm6yg1j5qwgwm6rxmfdj2";
    };
    deps = [ dytech-core ];
  };

  treefarm-lite = modDrv {
    src = fetchurl {
      url = https://github.com/Blu3wolf/Treefarm-Lite/releases/download/0.4.1.1/Treefarm-Lite_0.4.1.zip;
      sha256 = "0kmcd94hr7i2wkyvvnd6p5r97sfz8pdr4dgx4q54h8x61a9lv85x";
    };
  };

}
