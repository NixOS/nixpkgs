{ stdenv, fetchurl, unzip, patchelf, xlibs, openal }:

assert stdenv.isLinux;
assert stdenv.isx86_64;

let
  buildDemo = { name, src }:
    stdenv.mkDerivation rec {
      inherit name src;

      buildInputs = [ unzip patchelf ];

      rtdeps = stdenv.lib.makeLibraryPath
        [ xlibs.libXxf86vm xlibs.libXext openal ]
        + ":" + stdenv.lib.makeSearchPath "lib64" [ stdenv.cc.gcc ];

      buildCommand =
      ''
        mkdir -p "$out"
        cd $out
        unzip $src

        interpreter=$(echo ${stdenv.glibc}/lib/ld-linux*.so.2)
        binary=$(find . -executable -type f)
        patchelf \
          --set-interpreter $interpreter \
          --set-rpath ${rtdeps} \
          "$binary"

        # Workaround on
        # LogLinuxPlatformFile:Warning: open('/nix/store/hash-ue4demos-demo/demo/demo/Saved/Config/CleanSourceConfigs/Engine.ini', Flags=0x00080241) failed: errno=2 (No such file or directory)
        # for Vehicle, Shooter and Strategy games.
        ls | grep ' ' && $(
          haxname=$(ls | grep ' ' | sed 's/ //g'); \
          haxpath=$(ls | grep ' ')/$haxname/Saved; \
          mkdir -p "$haxpath"/Config/CleanSourceConfigs; \
          ln -s /dev/null "$haxpath"/Config/CleanSourceConfigs/Engine.ini; \
          mkdir -p "$haxpath"/Logs; \
          ln -s /dev/null "$haxpath"/Logs/$haxname.log)

        # Executables are buried under a varied paths across demos.
        mkdir bin
        cd bin
        ln -s "$out/$binary" $(basename "$out/$binary")
      '';

      meta = {
        description = "Unreal Engine 4 Linux demos";
        homepage = https://wiki.unrealengine.com/Linux_Demos;
        platforms = stdenv.lib.platforms.linux;
        license = stdenv.lib.licenses.unfree;
      };
    };

in {
  tappy_chicken = buildDemo rec {
    name = "ue4demos-tappy_chicken";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/tappy_chicken.zip";
      sha256 = "0lwhvk3lpb2r5ng2cnzk7fpjj5lwhy2sch1a8v154x1xfhfb3h4v";
    };
  };

  swing_ninja = buildDemo rec {
    name = "ue4demos-swing_ninja";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/swing_ninja.zip";
      sha256 = "1bmgqqk3lda5h7nnqi59jgyrsn0clr3xs0k1jclnqf9fk0m8hjcv";
    };
  };

  card_game = buildDemo rec {
    name = "ue4demos-card_game";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/card_game.zip";
      sha256 = "154baqias5q7kad0c89k35jbmnmlm865sll02mi7bk1yllcckz5z";
    };
  };

  vehicle_game = buildDemo rec {
    name = "ue4demos-vehicle_game";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/vehicle_game.zip";
      sha256 = "03dlacf1iv7sgn7pl3sx9r6243wy8fsi2kd858syfm9slg0190bs";
    };
  };

  shooter_game = buildDemo rec {
    name = "ue4demos-shooter_game";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/shooter_game.zip";
      sha256 = "1bk32k349iqbqk8x8jffnqq0pjiqmvrvv675xxmlvkkr8qrlhz98";
    };
  };

  strategy_game = buildDemo rec {
    name = "ue4demos-strategy_game";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/strategy_game.zip";
      sha256 = "1p7i966v1ssm20y12g4wsccpgnky3szy19qyjlacynk7bgbk6lg7";
    };
  };

  black_jack = buildDemo rec {
    name = "ue4demos-black_jack";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/black_jack.zip";
      sha256 = "0g52wkzn5isa3az32y25yx5b56wxks97pajqwkmm6gf4qpkfksxv";
    };
  };

  landscape_mountains = buildDemo rec {
    name = "ue4demos-landscape_mountains";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/landscape_mountains.zip";
      sha256 = "14jzajhs3cpydvf3ag7lpj4hkpbjpwnn3xkdvdx92fi0pcl8cwym";
    };
  };

  matinee_demo = buildDemo rec {
    name = "ue4demos-matinee_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/matinee_demo.zip";
      sha256 = "0ib8k6fl15cxzdarar2sqq5v3g3c7p2jidkdjd00nym6cvkibb4d";
    };
  };

  elemental_demo = buildDemo rec {
    name = "ue4demos-elemental_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/elemental_demo.zip";
      sha256 = "1v4jdsy8jvv8wgc8dx17q17xigfrya5q0nfdzw4md7fzm3bg9z0v";
    };
  };

  effects_cave_demo = buildDemo rec {
    name = "ue4demos-effects_cave_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/effects_cave_demo.zip";
      sha256 = "0lvd3aaha2x9pnpkdmrzi6nf7hymr95834z3l8shygjf9kbbzsz4";
    };
  };

  realistic_rendering = buildDemo rec {
    name = "ue4demos-realistic_rendering";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/realistic_rendering_demo.zip";
      sha256 = "0r16nznkv475hkw5rnngqsc69ch8vh86dppyyyr9nn43dkr2110a";
    };
  };

  reflections_subway = buildDemo rec {
    name = "ue4demos-reflections_subway";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/reflections_subway_demo.zip";
      sha256 = "0dw5sm7405gxw9iqz0vpnhdprrb4wl5i14pvzl1381k973m8bd00";
    };
  };

  scifi_hallway_demo = buildDemo rec {
    name = "ue4demos-scifi_hallway_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/sci-fi_hallway_demo.zip";
      sha256 = "14qp9iwm47awn8d9j6ijh6cnds308x60xs4vi2fvz2666jlz1pq2";
    };
  };

  mobile_temple_demo = buildDemo rec {
    name = "ue4demos-mobile_temple_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/mobile_temple_demo.zip";
      sha256 = "12bz4h1b9lhmqglwsa6r8q48ijqbjdha9fql31540d01kigaka75";
    };
  };

  stylized_demo = buildDemo rec {
    name = "ue4demos-stylized_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/stylized_demo.zip";
      sha256 = "1676ridmj8rk4y4hbdscfnnka5l636av1xxl0qwvk236kq9j7v0l";
    };
  };

  blueprint_examples_demo = buildDemo rec {
    name = "ue4demos-blueprint_examples_demo";
    src = fetchurl {
      url = "http://ue4linux.raxxy.com/blueprint_examples_demo.zip";
      sha256 = "076q33h2hy965fvr805hsprkpcmizf638lj2ik8k923v86b15nbv";
    };
  };
}

