
# Automatically generated with maintainers/scripts/update-minetest-packages.tcl
# DO NOT EDIT

{ lib, buildMinetestPackage, fetchFromContentDB }:

let spdx = lib.listToAttrs
  (lib.filter (attr: attr.name != null)
    (lib.mapAttrsToList (n: l: lib.nameValuePair (l.spdxId or null) l)
      lib.licenses));

in {

    "-SX-"."metatool" = buildMinetestPackage rec {
      type = "mod";
      pname = "metatool";
      version = "v2.0-RC1";
      src = fetchFromContentDB {
        author = "-SX-";
        technicalName = "metatool";
        release = 10414;
        versionName = "v2.0-RC1";
        sha256 = "0k86qa2j3b3gxd72qr7f2r0zc2vws6ljklgn9xrn4irxq4nv86zx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides API to register node metadata tools along with few useful tools";

      };
    };

    "-SX-"."qos" = buildMinetestPackage rec {
      type = "mod";
      pname = "qos";
      version = "2021-10-16";
      src = fetchFromContentDB {
        author = "-SX-";
        technicalName = "qos";
        release = 9498;
        versionName = "2021-10-16";
        sha256 = "1cdidmbgxv9a1108v14hgyqvpx0g1cnrxamzj6w9l9wdpi0h7r1i";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Improve quality of important HTTP requests by grouping requests into service quality buckets.";

      };
    };

    "0siribix"."blink" = buildMinetestPackage rec {
      type = "mod";
      pname = "blink";
      version = "Blink_v1.2";
      src = fetchFromContentDB {
        author = "0siribix";
        technicalName = "blink";
        release = 9437;
        versionName = "Blink v1.2";
        sha256 = "1zv1f9aq7bydn2qgvar3pdsca385hr3zfdnw9wf9vv7h6wy0ax32";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-or-later" ];
        description = "Short distance teleport";

      };
    };

    "1248"."agon" = buildMinetestPackage rec {
      type = "game";
      pname = "agon";
      version = "3.0.5";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "agon";
        release = 9177;
        versionName = "3.0.5";
        sha256 = "0pk0nsmddyq29fq0dnbdw1p2hd3dadhdym55sw4sf2pngjr02ikf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Fight against some monsters!";

      };
    };

    "1248"."castrum" = buildMinetestPackage rec {
      type = "game";
      pname = "castrum";
      version = "1.11.2";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "castrum";
        release = 4788;
        versionName = "1.11.2";
        sha256 = "1csn2zmf8nyv822c86jk7xmxfr7waxsh8q84j8x05hz3jp3jd8gz";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "You are on a floor plan of a castle. Collect resources and rebuild the old castle ";

      };
    };

    "1248"."labyrinthus" = buildMinetestPackage rec {
      type = "game";
      pname = "labyrinthus";
      version = "2.10.1";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "labyrinthus";
        release = 12203;
        versionName = "2.10.1";
        sha256 = "184hbiaf19cfhc2mc48khds5lpgfq6a7gnwqffv68kq7p9c62c4v";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Can you help the nyancat to find her rainbow block??";

      };
    };

    "1248"."regnum" = buildMinetestPackage rec {
      type = "game";
      pname = "regnum";
      version = "3.6.2";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "regnum";
        release = 12150;
        versionName = "3.6.2";
        sha256 = "1v9hswag3p7k6x9qpidz68i67gr6pbk4dakwjgkax2a44y9rxyar";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Fight monsters, collect XP, craft battleaxes, armor, guns and lots more.";

      };
    };

    "1248"."regnum2" = buildMinetestPackage rec {
      type = "game";
      pname = "regnum2";
      version = "1.3.6";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "regnum2";
        release = 12158;
        versionName = "1.3.6";
        sha256 = "1mp3a658zwhijfg4jm7d4a0blw04yfgskzqzns4ih4jv858k44dr";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This is the second part of Regnum";

      };
    };

    "1248"."stella" = buildMinetestPackage rec {
      type = "game";
      pname = "stella";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "stella";
        release = 10125;
        versionName = "1.0.0";
        sha256 = "0flvgj62hxvdrjyj0yqijhc0c82c691k1zz40b374dagirhsl6na";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "You start on a small island and your goal is to enlarge it.";

      };
    };

    "1248"."sudoku" = buildMinetestPackage rec {
      type = "game";
      pname = "sudoku";
      version = "1.9.5";
      src = fetchFromContentDB {
        author = "1248";
        technicalName = "sudoku";
        release = 6653;
        versionName = "1.9.5";
        sha256 = "1hn56qs4lb02ll1avz5k8b65w39m51j6ipyrgyrihcnbyzb6nxp8";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Can you solve the Sudoku??";

      };
    };

    "12Me21"."place_rotated" = buildMinetestPackage rec {
      type = "mod";
      pname = "place_rotated";
      version = "2020-08-14";
      src = fetchFromContentDB {
        author = "12Me21";
        technicalName = "place_rotated";
        release = 4861;
        versionName = "2020-08-14";
        sha256 = "0ns0mzln536n73zpaz3lmcr3zzxdc7hj557ldvfv4x5gb5jwaz5s";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Better slab/log placement";

      };
    };

    "12Me21"."screwdriver2" = buildMinetestPackage rec {
      type = "mod";
      pname = "screwdriver2";
      version = "2018-10-07";
      src = fetchFromContentDB {
        author = "12Me21";
        technicalName = "screwdriver2";
        release = 6370;
        versionName = "2018-10-07";
        sha256 = "1d2jp80i6z67zswgmmjspnbcd4qi91a8x84v3lknnxqvlzlr769b";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A more intuitive node rotation tool";

      };
    };

    "1faco"."beautiflowers" = buildMinetestPackage rec {
      type = "mod";
      pname = "beautiflowers";
      version = "2022-02-13";
      src = fetchFromContentDB {
        author = "1faco";
        technicalName = "beautiflowers";
        release = 11268;
        versionName = "2022-02-13";
        sha256 = "0i9rxm46pl62am0y247frlq8daybh599d5158svfr8y8yp6j40sv";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-only" ];
        description = "Adds many flowers to MT";

      };
    };

    "1faco"."customiserver" = buildMinetestPackage rec {
      type = "mod";
      pname = "customiserver";
      version = "Customiserver_1.1";
      src = fetchFromContentDB {
        author = "1faco";
        technicalName = "customiserver";
        release = 9859;
        versionName = "Customiserver 1.1";
        sha256 = "0x6ndhkc1qbqvz4z0b1m7jmw3dbsa0l4yvx9vx9max87v0jp8m0j";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds colored chat and custom nametags";

      };
    };

    "1faco"."death_cetro" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_cetro";
      version = "Death_cetro";
      src = fetchFromContentDB {
        author = "1faco";
        technicalName = "death_cetro";
        release = 11335;
        versionName = "Death cetro";
        sha256 = "173sa0287s7njsc95vv1zqm0ag5wj0bz94mn59ggn3s62lapi25m";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds a Staff thats teleports you to your last death position.";

      };
    };

    "1faco"."stripped_tree" = buildMinetestPackage rec {
      type = "mod";
      pname = "stripped_tree";
      version = "2022-02-13";
      src = fetchFromContentDB {
        author = "1faco";
        technicalName = "stripped_tree";
        release = 11292;
        versionName = "2022-02-13";
        sha256 = "0g1y16qhancvhvdgjirjn5xrzrfz4an8wda0cki6w5y9x67lbzw4";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Stripped tree trunks.";

      };
    };

    "56independent"."britsignals" = buildMinetestPackage rec {
      type = "mod";
      pname = "britsignals";
      version = "1.1";
      src = fetchFromContentDB {
        author = "56independent";
        technicalName = "britsignals";
        release = 13004;
        versionName = "1.1";
        sha256 = "0kjsz35ifw74zjf9bgl7vfs7vs0r3n4xf3m6p3vl8lpw0k32kkha";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds british-inspired signs and signals";

      };
    };

    "AFCM"."db_manager" = buildMinetestPackage rec {
      type = "mod";
      pname = "db_manager";
      version = "0.9";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "db_manager";
        release = 9217;
        versionName = "0.9";
        sha256 = "0193g3wvk16cy9kkppyndb0fs4imxklr98vwjhrkwr909s1s6yxa";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Database Manager API";

      };
    };

    "AFCM"."farming_flood" = buildMinetestPackage rec {
      type = "mod";
      pname = "farming_flood";
      version = "1.1";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "farming_flood";
        release = 6869;
        versionName = "1.1";
        sha256 = "0q1zxyim385r8pqzx78wvgmfsd1w9x95fbsj51iwdmcgaycdr9aq";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Makes all plants floodable";

      };
    };

    "AFCM"."global_market" = buildMinetestPackage rec {
      type = "mod";
      pname = "global_market";
      version = "0.2";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "global_market";
        release = 7620;
        versionName = "0.2";
        sha256 = "0anpdhvnd6zf9vy2958svxh2n63jgxwxlq4r5sl2g2mq9s5vrw8b";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Market command";

      };
    };

    "AFCM"."mcl_build_limit" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_build_limit";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "mcl_build_limit";
        release = 6737;
        versionName = "1.1.0";
        sha256 = "0m31c88z874cadkn6kgywjjqqmcvfnifpxrkfdw946n3dvrkp0n2";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Add a build limit to MineClone2";

      };
    };

    "AFCM"."mcl_speedrun" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_speedrun";
      version = "0.6";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "mcl_speedrun";
        release = 11927;
        versionName = "0.6";
        sha256 = "1h268rn4q9l85aair53233gf757s5jb95z9s07vf2sh3g86k9fmb";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-or-later" ];
        description = "Speedrun features for MineClone2";

      };
    };

    "AFCM"."mcl_uhc" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_uhc";
      version = "1.0";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "mcl_uhc";
        release = 8559;
        versionName = "1.0";
        sha256 = "0m3lz0h6rivzic0vx1djb82msljivibgjzbskcm6p7pv56lvwngh";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "UHC aditions to MineClone2";

      };
    };

    "AFCM"."mcl_welcome_hud" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_welcome_hud";
      version = "1.4";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "mcl_welcome_hud";
        release = 8582;
        versionName = "1.4";
        sha256 = "15wnx42p5gay31rj086l4if93d01ss6fb5rmz69f53ya4s0z0vj7";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Show welcome bossbar in the HUD";

      };
    };

    "AFCM"."mesecons_onlinedetector" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_onlinedetector";
      version = "1.1";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "mesecons_onlinedetector";
        release = 8043;
        versionName = "1.1";
        sha256 = "14g4bchzxhbbsvbd0k6qdl98ns50cp4m8qwflk14qi6wkcrx4rbv";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Add online detector to mesecons";

      };
    };

    "AFCM"."subway_miner" = buildMinetestPackage rec {
      type = "game";
      pname = "subway_miner";
      version = "1.6";
      src = fetchFromContentDB {
        author = "AFCM";
        technicalName = "subway_miner";
        release = 10900;
        versionName = "1.6";
        sha256 = "0m1lcjspwwckhp0ybz7aki0vx7lrqv2fk0xwpnv58svlx0k3dzbz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."GPL-3.0-or-later" ];
        description = "A Subway Surfer inspired game";

      };
    };

    "ANAND"."blacklist_name" = buildMinetestPackage rec {
      type = "mod";
      pname = "blacklist_name";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "ANAND";
        technicalName = "blacklist_name";
        release = 256;
        versionName = "v1.0";
        sha256 = "1vwvbbp6apbkkrpd3p920570xfcd8i73d3kxbp67v2kgzk7d2dc2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Blacklist offensive names, forcing players to join with different names.";

      };
    };

    "ANAND"."callbacks_api" = buildMinetestPackage rec {
      type = "mod";
      pname = "callbacks_api";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "ANAND";
        technicalName = "callbacks_api";
        release = 1405;
        versionName = "v1.0";
        sha256 = "18dflw5ydpy66ahyl93mnh1b6v3cbr5k6234n4b20wjmfz9635xp";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "callbacks_api is a framework for registering callbacks if the callback registration function exists, else returns gracefully.";

      };
    };

    "ANAND"."caps_alert" = buildMinetestPackage rec {
      type = "mod";
      pname = "caps_alert";
      version = "v1.2.1";
      src = fetchFromContentDB {
        author = "ANAND";
        technicalName = "caps_alert";
        release = 503;
        versionName = "v1.2.1";
        sha256 = "1gb2fyyh2jii729n3rlcd9f4q7f9c1k2safiv2s6k2vmzwdcqzbg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Catches chat messages with all-caps and warns / kicks players.";

      };
    };

    "ANAND"."hud_notify" = buildMinetestPackage rec {
      type = "mod";
      pname = "hud_notify";
      version = "v1.1.2";
      src = fetchFromContentDB {
        author = "ANAND";
        technicalName = "hud_notify";
        release = 13325;
        versionName = "v1.1.2";
        sha256 = "0qwvl7z514g892l3zs3a8q517q1c8dz94aspmip955dz24zcw64a";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Shows a message to a player in-game, by means of an HUD element.";

      };
    };

    "ANAND"."mid_measure" = buildMinetestPackage rec {
      type = "mod";
      pname = "mid_measure";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "ANAND";
        technicalName = "mid_measure";
        release = 168;
        versionName = "v1.0";
        sha256 = "144i41kgxivxsr8jssawgdijl3qfa82iiksla881msycry84mgrm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Quickly get the distance between two nodes and calculate their mid-point";

      };
    };

    "AccidentallyRhine"."pooper" = buildMinetestPackage rec {
      type = "mod";
      pname = "pooper";
      version = "Update_1.4";
      src = fetchFromContentDB {
        author = "AccidentallyRhine";
        technicalName = "pooper";
        release = 10022;
        versionName = "Update 1.4";
        sha256 = "0z30aivf12chgak770jpr5kjwnhdw3q39ah9hczvc9dd3fvjypnv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds poop, feces piles with area denial effect and defecation.";

      };
    };

    "AiTechEye"."afterearth" = buildMinetestPackage rec {
      type = "mod";
      pname = "afterearth";
      version = "2u2";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "afterearth";
        release = 3439;
        versionName = "2u2";
        sha256 = "1inxhy1kaqvspxkf667m98rjkjgbd0kknl528am8f26axxqvd8q3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "The earth's ecosystem has collapsed, and there are no biologically environment left.";

      };
    };

    "AiTechEye"."agreerules" = buildMinetestPackage rec {
      type = "mod";
      pname = "agreerules";
      version = "4.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "agreerules";
        release = 891;
        versionName = "4.0";
        sha256 = "1s0jmx24pvri781s7gp4ij3krxshgnaw5hd9y3ln4nm3mqqzqd3p";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Agree rules or be kicked";

      };
    };

    "AiTechEye"."aliveai" = buildMinetestPackage rec {
      type = "mod";
      pname = "aliveai";
      version = "26.32__bug_fixes_";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "aliveai";
        release = 5331;
        versionName = "26.32 (bug fixes)";
        sha256 = "0ipc4w9y4a70n6b1qfsf8jpvfln9flkinyn84lfmfvr9wikb1w2f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Advanced survivor ai mobs (npc, monsters and more)";

      };
    };

    "AiTechEye"."bows" = buildMinetestPackage rec {
      type = "mod";
      pname = "bows";
      version = "2.0_fire_arrow_crash_fix";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "bows";
        release = 4806;
        versionName = "2.0 fire arrow crash fix";
        sha256 = "1i1ngmm1hz15y1zg7x5h6lykrmx2lc1zwbh4bix73yir6rhj0gp8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A easy bow mod with arrows";

      };
    };

    "AiTechEye"."chakram" = buildMinetestPackage rec {
      type = "mod";
      pname = "chakram";
      version = "4.2.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "chakram";
        release = 894;
        versionName = "4.2.0";
        sha256 = "0mkk98gfyfcmpy9vnd17s07902i7f8mangmz86j3cy58pwjr65fm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Chakram: weapon & tool at same time";

      };
    };

    "AiTechEye"."fsg" = buildMinetestPackage rec {
      type = "mod";
      pname = "fsg";
      version = "1.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "fsg";
        release = 905;
        versionName = "1.0";
        sha256 = "0y0fisa12s9ivmkz5i5pqnwhm6gi0zfqx936pbkabafjhjpagk5r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "junk has never been so coveted!";

      };
    };

    "AiTechEye"."gravitygun" = buildMinetestPackage rec {
      type = "mod";
      pname = "gravitygun";
      version = "2";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "gravitygun";
        release = 1002;
        versionName = "2";
        sha256 = "0g2gr3psf45a5ic76f81ksi4rrr8il838046qjg1f43qr1qlmx03";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Gravitygun";

      };
    };

    "AiTechEye"."hook" = buildMinetestPackage rec {
      type = "mod";
      pname = "hook";
      version = "13";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "hook";
        release = 1891;
        versionName = "13";
        sha256 = "0nwf4i9l2qn99fjpx77vwkn58a40353sb00a98s0cdk29kqbdjvh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Survive & climbing tools";

      };
    };

    "AiTechEye"."invisible" = buildMinetestPackage rec {
      type = "mod";
      pname = "invisible";
      version = "4";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "invisible";
        release = 5962;
        versionName = "4";
        sha256 = "092qlkhd5czzcvmp00xjzz3pk99grx7qkf16r502nk202hs69fvh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Hide nametag while sneaking, or invisible";

      };
    };

    "AiTechEye"."livetools" = buildMinetestPackage rec {
      type = "mod";
      pname = "livetools";
      version = "2.5.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "livetools";
        release = 897;
        versionName = "2.5.0";
        sha256 = "196rw2a3429ns705blixsi044q4503bm5fmq3wr09nwhza4jrms3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Craft tools which have a life of their own - they can fight, dig, or place for you";

      };
    };

    "AiTechEye"."mesetec" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesetec";
      version = "3.11.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "mesetec";
        release = 898;
        versionName = "3.11.0";
        sha256 = "0s4z51gsgq44i7vnn87q3h31am9qi16r08var4kjb787zjw3ayrn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds some extra and usefull mesecons stuff";

      };
    };

    "AiTechEye"."mt2d" = buildMinetestPackage rec {
      type = "mod";
      pname = "mt2d";
      version = "2.7";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "mt2d";
        release = 4803;
        versionName = "2.7";
        sha256 = "07jcbfk0jmd8yagc8l4q66ldisfbgabvchqqqr38w8pbc2gy0m3x";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Transforms the minetest world into 2d dimension";

      };
    };

    "AiTechEye"."multidimensions" = buildMinetestPackage rec {
      type = "mod";
      pname = "multidimensions";
      version = "2.3";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "multidimensions";
        release = 1726;
        versionName = "2.3";
        sha256 = "00a3bz93glqc48dr66ly2m04wd6s7ak993xii5ii1k7zm3jsn7h1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds a few dimensions/worlds";

      };
    };

    "AiTechEye"."parkoursurvive" = buildMinetestPackage rec {
      type = "mod";
      pname = "parkoursurvive";
      version = "1";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "parkoursurvive";
        release = 908;
        versionName = "1";
        sha256 = "1h2j6rvy5fjq5zhjm5abz52drzj9y4r9waaqiwch18b12g9b8146";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Parkour ability!";

      };
    };

    "AiTechEye"."portalgun" = buildMinetestPackage rec {
      type = "mod";
      pname = "portalgun";
      version = "2020-06-19";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "portalgun";
        release = 6371;
        versionName = "2020-06-19";
        sha256 = "00p08c82rlwrvy0b9k9q4by05qy4s90yijpmyckyigix1h32m00c";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Portals and stuff";

      };
    };

    "AiTechEye"."servercleaner" = buildMinetestPackage rec {
      type = "mod";
      pname = "servercleaner";
      version = "1";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "servercleaner";
        release = 909;
        versionName = "1";
        sha256 = "1vr6b6vyg814w77ipsg81xdrn5wid7ldclrrh7qr22vm87ljp1qw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Keep the server clean and simple";

      };
    };

    "AiTechEye"."serverguide" = buildMinetestPackage rec {
      type = "mod";
      pname = "serverguide";
      version = "1.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "serverguide";
        release = 901;
        versionName = "1.0";
        sha256 = "0ld23fccal5gv7n4xcq69jm6lr70qdb4s5mz0vipg18za73g1iq5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "The serverguide";

      };
    };

    "AiTechEye"."setpgrav" = buildMinetestPackage rec {
      type = "mod";
      pname = "setpgrav";
      version = "2";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "setpgrav";
        release = 3977;
        versionName = "2";
        sha256 = "0jmp7vn3cfnap3sf3vs16rxy4rvdd0ds0v71hlb1v4a95x4kxbhf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Change players gravity exactly how you'd like using a command";

      };
    };

    "AiTechEye"."smartrenting" = buildMinetestPackage rec {
      type = "mod";
      pname = "smartrenting";
      version = "4.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "smartrenting";
        release = 902;
        versionName = "4.0";
        sha256 = "1764g4cvlcr9hqdfi6w4a0ga583cj7bvlgig3m62jqp5kksjk2pd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Smart renting: Rent out your locked things and earn money!";

      };
    };

    "AiTechEye"."smartshop" = buildMinetestPackage rec {
      type = "mod";
      pname = "smartshop";
      version = "7.12.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "smartshop";
        release = 903;
        versionName = "7.12.0";
        sha256 = "16cqq1amv83ir8m07m983g2klw35pvczllxkv0zh7czh3qdcbk31";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Smart and easy shop";

      };
    };

    "AiTechEye"."tempsurvive" = buildMinetestPackage rec {
      type = "mod";
      pname = "tempsurvive";
      version = "2.01";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "tempsurvive";
        release = 6117;
        versionName = "2.01";
        sha256 = "17232x2i9i1ib4vhqj7xr1409h47n6825ffi6c1nfrm6crlqmjjc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Makes you feel temperatures";

      };
    };

    "AiTechEye"."tpgate" = buildMinetestPackage rec {
      type = "mod";
      pname = "tpgate";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "tpgate";
        release = 906;
        versionName = "1.1.0";
        sha256 = "0qb2lqmii4ralimgqrypilgmac9vdpml5707vdl5l40z4dmzqnr4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Teleport through the gate";

      };
    };

    "AiTechEye"."vexcazer" = buildMinetestPackage rec {
      type = "mod";
      pname = "vexcazer";
      version = "10.0";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "vexcazer";
        release = 1468;
        versionName = "10.0";
        sha256 = "0k8y5idpd6via5gyiy2jvy0yb9f5pxmhmlrj4vsgq164vxwzlmaq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Ultimate build+mine & admin tool";

      };
    };

    "AiTechEye"."was" = buildMinetestPackage rec {
      type = "mod";
      pname = "was";
      version = "1";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "was";
        release = 1001;
        versionName = "1";
        sha256 = "1zi9vyrsg8fx7kp78p2rrn5pdakaxgzxcjanc85bsh7r69ycgms4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Programming+ electronics";

      };
    };

    "AiTechEye"."xaenvironment" = buildMinetestPackage rec {
      type = "game";
      pname = "xaenvironment";
      version = "2022-10-20";
      src = fetchFromContentDB {
        author = "AiTechEye";
        technicalName = "xaenvironment";
        release = 14510;
        versionName = "2022-10-20";
        sha256 = "0690fkn6b8x939al30rwr0a2qvach353szp1543nkan535222b6k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A game that aims to contain lots of environments and things.";

      };
    };

    "AidanLCB"."overpowered" = buildMinetestPackage rec {
      type = "mod";
      pname = "overpowered";
      version = "1.1";
      src = fetchFromContentDB {
        author = "AidanLCB";
        technicalName = "overpowered";
        release = 7096;
        versionName = "1.1";
        sha256 = "0nfjinqpfirfnnkc16spsrj660ppccvz70p8wjm5n7vsvj9ix81f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds super overpowered and expensive endgame tools, armor, weapons, and blocks";

      };
    };

    "AliasAlreadyTaken"."yl_matterbridge" = buildMinetestPackage rec {
      type = "mod";
      pname = "yl_matterbridge";
      version = "v1.0.3";
      src = fetchFromContentDB {
        author = "AliasAlreadyTaken";
        technicalName = "yl_matterbridge";
        release = 11759;
        versionName = "v1.0.3";
        sha256 = "1dwj3k0h27i3brkkaraghxrv4azg8g4dhj72551kqaj447nllcyn";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Handles chat between Minetest and Matterbridge";

          homepage = "https://gitea.your-land.de/AliasAlreadyTaken/yl_matterbridge";

      };
    };

    "Alib234"."coloredstrings" = buildMinetestPackage rec {
      type = "mod";
      pname = "coloredstrings";
      version = "2022-08-25";
      src = fetchFromContentDB {
        author = "Alib234";
        technicalName = "coloredstrings";
        release = 13542;
        versionName = "2022-08-25";
        sha256 = "0h5rwap6gf2bywrmz323flp0l7imvsk1pb3linc0sqayqn55zggc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds colored strings and allows to create wool from 4 strings and viceversa";

      };
    };

    "Alib234"."justzoom" = buildMinetestPackage rec {
      type = "mod";
      pname = "justzoom";
      version = "2022-08-25";
      src = fetchFromContentDB {
        author = "Alib234";
        technicalName = "justzoom";
        release = 13544;
        versionName = "2022-08-25";
        sha256 = "0583scpcfpcrhhmzxw5rw9ch8ir7qxyy5gyx1nk1iqka0l2izc47";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows you to just zoom at any time";

      };
    };

    "Amaz"."flight" = buildMinetestPackage rec {
      type = "mod";
      pname = "flight";
      version = "2015-08-30";
      src = fetchFromContentDB {
        author = "Amaz";
        technicalName = "flight";
        release = 8106;
        versionName = "2015-08-30";
        sha256 = "0nh42svkdx3dw2bgjj29bnphg5frv2gkfia9cmcha9v5px900kzj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds three different methods of flying, wings, jetpacks and flying carpets.";

      };
    };

    "Amaz"."interact" = buildMinetestPackage rec {
      type = "mod";
      pname = "interact";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "Amaz";
        technicalName = "interact";
        release = 208;
        versionName = "v1.0";
        sha256 = "0hcq1faadf97bfv15rzbdb0621ppsj4zr65b07pn6am5npwair1r";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod that gives the interact priv to players who want it and who have agreed to the rules.";

      };
    };

    "Amaz"."letters" = buildMinetestPackage rec {
      type = "mod";
      pname = "letters";
      version = "2022-08-21";
      src = fetchFromContentDB {
        author = "Amaz";
        technicalName = "letters";
        release = 13455;
        versionName = "2022-08-21";
        sha256 = "1bh5z11jmryfpl8s113cip8r8xkjnz21vsmk4kdmf5hvy0mmfmbv";
      };
      meta = src.meta // {
        license = [ spdx."Zlib" ];
        description = "Adds a letter cutting tool with letter \"signlike\" nodes.";

      };
    };

    "Amaz"."lordofthetest" = buildMinetestPackage rec {
      type = "game";
      pname = "lordofthetest";
      version = "v1.2.6";
      src = fetchFromContentDB {
        author = "Amaz";
        technicalName = "lordofthetest";
        release = 12831;
        versionName = "v1.2.6";
        sha256 = "1zia6km5gyjw41ggixb3cy8jsymipmv97szrip1il26ja3sswyab";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "LOTR-inspired subgame. Explore the world of Middle-Earth, the one subgame to rule them all!";

      };
    };

    "AndrOn"."artelhum" = buildMinetestPackage rec {
      type = "txp";
      pname = "artelhum";
      version = "Artelhum_001";
      src = fetchFromContentDB {
        author = "AndrOn";
        technicalName = "artelhum";
        release = 5200;
        versionName = "Artelhum_001";
        sha256 = "0knrx0fvxwsql0yfwp4y784gxq5gq4k1mgadmkflvzgs9mzvbk7m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Cartoon-style and vibrant colors, with extended support!";

      };
    };

    "Andrey01"."luxury_decor" = buildMinetestPackage rec {
      type = "mod";
      pname = "luxury_decor";
      version = "1.1.5";
      src = fetchFromContentDB {
        author = "Andrey01";
        technicalName = "luxury_decor";
        release = 4623;
        versionName = "1.1.5";
        sha256 = "1va1vn90wxfvd1i5rcrf4drd6jybmmjanhixm019vb29zajfab1f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This mod has a goal to add large amount of luxurious various furniture elements, decorations and exterior stuff.";

      };
    };

    "Andrey01"."multidecor" = buildMinetestPackage rec {
      type = "mod";
      pname = "multidecor";
      version = "_30.08.22__1.0.3.";
      src = fetchFromContentDB {
        author = "Andrey01";
        technicalName = "multidecor";
        release = 13646;
        versionName = "[30.08.22] 1.0.3.";
        sha256 = "1bpnhhdkb1l0xn1p0vqswy3nkvzgahi066c6jzajncqjrpbyzanv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various detailed furniture components, decorations and exterior stuff with various designs and styles of each epoch.";

      };
    };

    "Andrey01"."real_elevators" = buildMinetestPackage rec {
      type = "mod";
      pname = "real_elevators";
      version = "2022-05-11";
      src = fetchFromContentDB {
        author = "Andrey01";
        technicalName = "real_elevators";
        release = 12205;
        versionName = "2022-05-11";
        sha256 = "0abgbsdpa4n7n6irbv4zb7ys1dg6kldd81ng9ipvxwgavipy45ab";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds realistic elevators with smooth moving.";

      };
    };

    "Annalysa"."cheese" = buildMinetestPackage rec {
      type = "mod";
      pname = "cheese";
      version = "1.3";
      src = fetchFromContentDB {
        author = "Annalysa";
        technicalName = "cheese";
        release = 13012;
        versionName = "1.3";
        sha256 = "1xjlf536qzriph9hb83g7dcn3nd3nkc02d5hiix0bhfqs79f1gfy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-only" ];
        description = "Boil milk and then let the curd age to get cheese!";

      };
    };

    "Annalysa"."sandwiches" = buildMinetestPackage rec {
      type = "mod";
      pname = "sandwiches";
      version = "1.9";
      src = fetchFromContentDB {
        author = "Annalysa";
        technicalName = "sandwiches";
        release = 12480;
        versionName = "1.9";
        sha256 = "1mrhswa20jdnlykqgwdri8lmhx5dnkina7yr7xj610nqdj8hgd8y";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Add Sandwiches to your game! Choose between meat, vegetarian, jam and many more!";

      };
    };

    "Anonymous_moose"."banner" = buildMinetestPackage rec {
      type = "mod";
      pname = "banner";
      version = "0.3";
      src = fetchFromContentDB {
        author = "Anonymous_moose";
        technicalName = "banner";
        release = 8105;
        versionName = "0.3";
        sha256 = "14ygy2m5b2dsylshz0zmmkm9577hi231xwb6l24c005s3x086iwk";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds decorative banners in all colours of wool.";

      };
    };

    "Ant_92"."mcl_glass_doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_glass_doors";
      version = "2022-06-18";
      src = fetchFromContentDB {
        author = "Ant_92";
        technicalName = "mcl_glass_doors";
        release = 12548;
        versionName = "2022-06-18";
        sha256 = "0j5nwk7l59x5hvxhg3f3v9kcgljyn63jr07fm0mmvk6pda0xhgjk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds coloured Glass Doors to Minetest subgame (MineClone2).";

      };
    };

    "AntumDeluge"."3d_armor_light" = buildMinetestPackage rec {
      type = "mod";
      pname = "3d_armor_light";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "3d_armor_light";
        release = 8519;
        versionName = "v1.0";
        sha256 = "0v3ypyxdljccmsd0kvzi0b2l0dswhr07xvk0dw8gcjq9n6rnw446";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Wielded Light for 3d_armor";

      };
    };

    "AntumDeluge"."alternode" = buildMinetestPackage rec {
      type = "mod";
      pname = "alternode";
      version = "v1.3.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "alternode";
        release = 8977;
        versionName = "v1.3.1";
        sha256 = "1pa32vy31sfgak7zq3lvvmpgm06mzxnfa4w1f19vlzh3h5jxy03i";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Manage node meta data";

      };
    };

    "AntumDeluge"."asm_spawneggs" = buildMinetestPackage rec {
      type = "mod";
      pname = "asm_spawneggs";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "asm_spawneggs";
        release = 8756;
        versionName = "v1.2";
        sha256 = "1sgrzg3rdpyxi3zgli267mbkvfh2nh1jjpxrxnwh019pq8mgyn0w";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Spawneggs for adding entities to game.";

      };
    };

    "AntumDeluge"."chatlog" = buildMinetestPackage rec {
      type = "mod";
      pname = "chatlog";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "chatlog";
        release = 7886;
        versionName = "v1.1";
        sha256 = "1ggbsiv6faha28dp5lhpfxgack9njdvkwsdcy7p1lpwr8yqa0v72";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Save chat history.";

      };
    };

    "AntumDeluge"."cleaner" = buildMinetestPackage rec {
      type = "mod";
      pname = "cleaner";
      version = "v1.2.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "cleaner";
        release = 8925;
        versionName = "v1.2.1";
        sha256 = "0f97wmzhfzj5hz2zaw8k96aha6h07ni0ykg2vh1gh7blrvhsi3xj";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Remove/Replace unknown entities, nodes, & items.";

      };
    };

    "AntumDeluge"."equip_exam" = buildMinetestPackage rec {
      type = "mod";
      pname = "equip_exam";
      version = "v1.7";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "equip_exam";
        release = 8926;
        versionName = "v1.7";
        sha256 = "15hkajj2dxn96frs3lixaq7ggpy465ipa31njrjz8ccv51psiw79";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A node that will examine the specs of equipment.";

      };
    };

    "AntumDeluge"."equip_wear" = buildMinetestPackage rec {
      type = "mod";
      pname = "equip_wear";
      version = "v0.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "equip_wear";
        release = 8496;
        versionName = "v0.1";
        sha256 = "0724056332zbh1j5sp5z2pcphg17rd81sczk4dblljqyrj0vgls4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows tool & equipment wear to be disabled.";

      };
    };

    "AntumDeluge"."glass" = buildMinetestPackage rec {
      type = "mod";
      pname = "glass";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "glass";
        release = 7847;
        versionName = "v1.1";
        sha256 = "15fwx4knyy5zzxpwb1awdkrkx4d98drdl0ycd8d3barx82d6b6n7";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Enhances default glass to make it colorable.";

      };
    };

    "AntumDeluge"."hidename" = buildMinetestPackage rec {
      type = "mod";
      pname = "hidename";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "hidename";
        release = 8773;
        versionName = "v1.2";
        sha256 = "1yznwlh3gfrlwsw72pgrybd2sn71sz68wdnx628sn1vpx2770y8p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Hide nametag from view.";

      };
    };

    "AntumDeluge"."hovercraft_ad" = buildMinetestPackage rec {
      type = "mod";
      pname = "hovercraft_ad";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "hovercraft_ad";
        release = 9106;
        versionName = "v1.1";
        sha256 = "12rnxvir4609dfjg10vj71c64hc504rc97ml4jian3k9yzkv8lck";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-or-later" ];
        description = "A fun alternative mode of transport.";

      };
    };

    "AntumDeluge"."lighted_helmets" = buildMinetestPackage rec {
      type = "mod";
      pname = "lighted_helmets";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "lighted_helmets";
        release = 8755;
        versionName = "v1.1";
        sha256 = "02afx0ygy508m19prb1vgm67l519904cqwh9pjsyq69jh1n0yb7m";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Light-emitting helmets.";

      };
    };

    "AntumDeluge"."listitems" = buildMinetestPackage rec {
      type = "mod";
      pname = "listitems";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "listitems";
        release = 8760;
        versionName = "v1.1";
        sha256 = "1lc1pf9051hyqk5y8xa9fllb4qxqzpzwjxi0pqd2v9r3hrvclah8";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Chat command that lists registered items & entities.";

      };
    };

    "AntumDeluge"."pbmarks" = buildMinetestPackage rec {
      type = "mod";
      pname = "pbmarks";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "pbmarks";
        release = 8978;
        versionName = "v1.2";
        sha256 = "0r334jc4dyqy831v0fchaaaidy59q2insp14lq0699jw7wk38vsp";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Allows players to create a limited number of personal bookmarks to where they can teleport.";

      };
    };

    "AntumDeluge"."server_shop" = buildMinetestPackage rec {
      type = "mod";
      pname = "server_shop";
      version = "v1.6.2";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "server_shop";
        release = 9125;
        versionName = "v1.6.2";
        sha256 = "13grvn9ip19kil834xpl8as43s2nwwwccjs10jn27rsbacsmj06b";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Shops intended to be set up by server administrators.";

      };
    };

    "AntumDeluge"."simple_models" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_models";
      version = "2021-08-26";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "simple_models";
        release = 9124;
        versionName = "2021-08-26";
        sha256 = "08pdmwrh1hz7kd8qdcsf50j4729jasl9xbv5acmq1ngmca8p1ml9";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Very simple models.";

      };
    };

    "AntumDeluge"."skeleton" = buildMinetestPackage rec {
      type = "mod";
      pname = "skeleton";
      version = "v1.1.1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "skeleton";
        release = 9000;
        versionName = "v1.1.1";
        sha256 = "1r43qa9h1v16kaxqfd4r0q3f0wvqgdspbdvihgw5g0n3b873gb5f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A skeleton mob.";

      };
    };

    "AntumDeluge"."slingshot" = buildMinetestPackage rec {
      type = "mod";
      pname = "slingshot";
      version = "v0.4";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "slingshot";
        release = 8896;
        versionName = "v0.4";
        sha256 = "11dgjsh5rci1jxv1mkpql2yzpw9w086kc96abz630hzf38snk6v6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Slingshots that can throw inventory items as ammunition.";

      };
    };

    "AntumDeluge"."sneeker" = buildMinetestPackage rec {
      type = "mod";
      pname = "sneeker";
      version = "v1.1-1";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "sneeker";
        release = 8554;
        versionName = "v1.1-1";
        sha256 = "02xqbr29pidd9d636pl2mjkmp9dv0pbynsyd1xhxypcy6l363gxr";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "An explosive nuisance.";

      };
    };

    "AntumDeluge"."sounds" = buildMinetestPackage rec {
      type = "mod";
      pname = "sounds";
      version = "v1.12";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "sounds";
        release = 13779;
        versionName = "v1.12";
        sha256 = "0021b55in47ghmw76gk2hh5zfcx6zgz2k1c40kk4w6r7rhdw39w5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A set of free sounds & API.";

      };
    };

    "AntumDeluge"."wardrobe_ad" = buildMinetestPackage rec {
      type = "mod";
      pname = "wardrobe_ad";
      version = "v1.5";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "wardrobe_ad";
        release = 8897;
        versionName = "v1.5";
        sha256 = "0iybvyfzczn09c0fs7vhqmvhlmr7c4zhrg8pzxgzhp6kv2y84gzk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A wardrobe that can be used to register & set new player skins.";

      };
    };

    "AntumDeluge"."wardrobe_outfits" = buildMinetestPackage rec {
      type = "mod";
      pname = "wardrobe_outfits";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "wardrobe_outfits";
        release = 8892;
        versionName = "v1.0";
        sha256 = "0vy43dgqxsbyszx1rz9wjfi2akz70k84qfhckfapiibs5qifvaq4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Some select skins for the wardrobe.";

      };
    };

    "AntumDeluge"."wdata" = buildMinetestPackage rec {
      type = "mod";
      pname = "wdata";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "wdata";
        release = 9169;
        versionName = "v1.2";
        sha256 = "0d0cd26bk7x0zlk9vzcafh62bnvl4jj8dxf19xlndh9k34i5ims4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A library for managing data files in the world directory.";

      };
    };

    "AntumDeluge"."whitelist" = buildMinetestPackage rec {
      type = "mod";
      pname = "whitelist";
      version = "v1.3";
      src = fetchFromContentDB {
        author = "AntumDeluge";
        technicalName = "whitelist";
        release = 14093;
        versionName = "v1.3";
        sha256 = "0wb3g98pyjfw047gpk728w40k56j3mg520fk1vk0ywsljwsi3w9b";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Restrict server access to only whitelisted players";

      };
    };

    "ApolloX"."chest2" = buildMinetestPackage rec {
      type = "mod";
      pname = "chest2";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "chest2";
        release = 11546;
        versionName = "v1.0.2";
        sha256 = "12w3g33giaa5s02w3mn2067gy0prfl33kbv07yv2l3xs2jb859kg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The Advanced Chest";

      };
    };

    "ApolloX"."chunkkeeper" = buildMinetestPackage rec {
      type = "mod";
      pname = "chunkkeeper";
      version = "V1.2__Cleanup";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "chunkkeeper";
        release = 13627;
        versionName = "V1.2: Cleanup";
        sha256 = "0frl04xh39ngj79dwbcz1nrgq4d19bsal6vx57riw36fapr6a3k7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Keep sections of nodes loaded/running code and growing";

      };
    };

    "ApolloX"."climb_glove" = buildMinetestPackage rec {
      type = "mod";
      pname = "climb_glove";
      version = "v1.2.1";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "climb_glove";
        release = 10885;
        versionName = "v1.2.1";
        sha256 = "0fprdkvf5cm1zp4n39ykxzw743fjh7fmcknkna91w36fw18i0rw5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "A magic glove which allows you to punch nodes to travel vertically.";

      };
    };

    "ApolloX"."credits" = buildMinetestPackage rec {
      type = "mod";
      pname = "credits";
      version = "V1.3__Bank_note_credits";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "credits";
        release = 12302;
        versionName = "V1.3: Bank note credits";
        sha256 = "1x5s5hfhydj4lb4cn8rhb5lsrkz2j86i6cn40diccd2qvpmv6hj0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A currency which can be digital or physical";

      };
    };

    "ApolloX"."feather_fall" = buildMinetestPackage rec {
      type = "mod";
      pname = "feather_fall";
      version = "Server-end_patched";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "feather_fall";
        release = 10895;
        versionName = "Server-end patched";
        sha256 = "1p65g8rz6yz1qyly7mjnklaqwpikqd94m2fs7v43ilh1cph75p5l";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Holding this feather makes you light as it";

      };
    };

    "ApolloX"."home_point" = buildMinetestPackage rec {
      type = "mod";
      pname = "home_point";
      version = "V2.1__Full_Configuration";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "home_point";
        release = 12863;
        versionName = "V2.1: Full Configuration";
        sha256 = "1p0vbk3g4hv0sn9y13ynrs543gj39705a4ydn016a6pr6zs4g7wn";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A /sethome and /home";

      };
    };

    "ApolloX"."inotify" = buildMinetestPackage rec {
      type = "mod";
      pname = "inotify";
      version = "V1.4__Settings";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "inotify";
        release = 10932;
        versionName = "V1.4: Settings";
        sha256 = "16n1ks45rrjpngns2qknb4z1fkz9f10b8sizbk2y1adymkxkda5y";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A notification tool for players in-game.";

      };
    };

    "ApolloX"."item_repair" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_repair";
      version = "V1.0__Inital";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "item_repair";
        release = 9449;
        versionName = "V1.0: Inital";
        sha256 = "17xzk4wbzrzhngfnpn5rxx8r9xwyx3z770zx0nzgx7w036my1k2c";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Repair many items with ease.";

      };
    };

    "ApolloX"."item_replicator" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_replicator";
      version = "V2.1__Currency_Support";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "item_replicator";
        release = 12458;
        versionName = "V2.1: Currency Support";
        sha256 = "1q6fcbciixj5scad6mpx75hh0fyzmnd55y5q6h4804rx6jq4pand";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Replicate items with ease.";

      };
    };

    "ApolloX"."knives" = buildMinetestPackage rec {
      type = "mod";
      pname = "knives";
      version = "V1.1__Powered_Buff";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "knives";
        release = 11497;
        versionName = "V1.1: Powered Buff";
        sha256 = "1kkd6dj6ajq62za1v3179i8flbcp2xdfpaa0h0cmyg7jms8kf0gl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds various knives with extreme damage";

      };
    };

    "ApolloX"."lockout" = buildMinetestPackage rec {
      type = "mod";
      pname = "lockout";
      version = "0.0.1_-_Secure_Servers";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "lockout";
        release = 11220;
        versionName = "0.0.1 - Secure Servers";
        sha256 = "1k2fzy40p614s1ciqkyr3xk2vzhbq1zmn5h19hs3l9xjj8ffy734";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Late-stage Security for Servers";

      };
    };

    "ApolloX"."mcl_stackpotions" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_stackpotions";
      version = "2022-10-12_V1.2__Hotfix_1_";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "mcl_stackpotions";
        release = 14339;
        versionName = "2022-10-12 V1.2 (Hotfix 1)";
        sha256 = "0xgvxbqw7j7i8lmlha1nzr75pswdv0rqzbzsrlfw3lissjflpjd8";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Stackable Potions";

      };
    };

    "ApolloX"."medblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "medblocks";
      version = "v1.2.2";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "medblocks";
        release = 11725;
        versionName = "v1.2.2";
        sha256 = "1c4qwras7zsw9cliklnjwpc0cnzfn164wz7hkb8xy7czqg1d0707";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Provides a block which provides healing and feeding";

      };
    };

    "ApolloX"."nutra_paste" = buildMinetestPackage rec {
      type = "mod";
      pname = "nutra_paste";
      version = "V1.1__Nutra_Block";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "nutra_paste";
        release = 13460;
        versionName = "V1.1: Nutra Block";
        sha256 = "1czaywfpalcvhwc78x9dh0gv11l2crc0dc0xhwn9x6y2la1qa60a";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Low quality, but free, food source.";

      };
    };

    "ApolloX"."oretracker" = buildMinetestPackage rec {
      type = "mod";
      pname = "oretracker";
      version = "v1.5";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "oretracker";
        release = 10384;
        versionName = "v1.5";
        sha256 = "1735jpzfd9gf0c6kxw5fnrpk0827sn2jns2ygz83a391894mhyj7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "For tracking what ores are around the player.";

      };
    };

    "ApolloX"."oreveins" = buildMinetestPackage rec {
      type = "mod";
      pname = "oreveins";
      version = "v1.4";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "oreveins";
        release = 10385;
        versionName = "v1.4";
        sha256 = "11ryhqa127x1ss93lk2n7fp1als6qyaajd61l8lfj2g9w0pifl4d";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A node which produces ores";

      };
    };

    "ApolloX"."rebreather" = buildMinetestPackage rec {
      type = "mod";
      pname = "rebreather";
      version = "V1.1__Fixed_Setting_Usage";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "rebreather";
        release = 12319;
        versionName = "V1.1: Fixed Setting Usage";
        sha256 = "1nmk1wki93agkh2qfygl4isxwzkzxwmbfjljbqi929cg083s7i76";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Breath underwater with this item in hand";

      };
    };

    "ApolloX"."renew_pack" = buildMinetestPackage rec {
      type = "mod";
      pname = "renew_pack";
      version = "V1.4__Pick_Speedup";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "renew_pack";
        release = 12879;
        versionName = "V1.4: Pick Speedup";
        sha256 = "0kj9jmz0hdk7dvw5m50jkawpvl70mfk3f2cmsarymlyd03jhgvgk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Self Repairing tools and armor";

      };
    };

    "ApolloX"."teleporter_tool" = buildMinetestPackage rec {
      type = "mod";
      pname = "teleporter_tool";
      version = "V1.2__Teleport_Dest_Update";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "teleporter_tool";
        release = 8754;
        versionName = "V1.2: Teleport Dest Update";
        sha256 = "1p02pq1manwpxrna9zagky3ffyrcvnh22n5zvdkx3nrnkzyn1cw3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a tool for moving nodes via teleportation";

      };
    };

    "ApolloX"."unbreaking" = buildMinetestPackage rec {
      type = "mod";
      pname = "unbreaking";
      version = "Version_1.0__Inital";
      src = fetchFromContentDB {
        author = "ApolloX";
        technicalName = "unbreaking";
        release = 8281;
        versionName = "Version 1.0: Inital";
        sha256 = "1pk61wsbglp6sq9pvnn2qdbnqbjjzw2ld93jmbmwkndmrkjpgz0g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Be more forgiving for those who are tired of their tools and/or armor breaking.";

      };
    };

    "Argos"."rotate" = buildMinetestPackage rec {
      type = "mod";
      pname = "rotate";
      version = "2015-05-01";
      src = fetchFromContentDB {
        author = "Argos";
        technicalName = "rotate";
        release = 8104;
        versionName = "2015-05-01";
        sha256 = "10z8xwscbf4x1w6rnvs3p05d47wk3iq5q1fl8vzrrgw0kz4z0g04";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A better screwdriver.";

      };
    };

    "AshleighTheCutie"."deathback" = buildMinetestPackage rec {
      type = "mod";
      pname = "deathback";
      version = "1.0_0";
      src = fetchFromContentDB {
        author = "AshleighTheCutie";
        technicalName = "deathback";
        release = 12980;
        versionName = "1.0_0";
        sha256 = "0h6cr8f8lpqddik3zqwq4775wcq35gxbm2kwm015rjzc4wv9c0vw";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Command to warp you to your death point instantly.";

      };
    };

    "Astrobe"."minefall" = buildMinetestPackage rec {
      type = "game";
      pname = "minefall";
      version = "2022-10-18";
      src = fetchFromContentDB {
        author = "Astrobe";
        technicalName = "minefall";
        release = 14443;
        versionName = "2022-10-18";
        sha256 = "17wznxbp5z4nh58pf6h4jnsql2lsvfzlqfg3yspcsysylynglwby";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Fight, farm, explore, build. Solo or multiplayer.";

      };
    };

    "Astrobe"."resistoranthems" = buildMinetestPackage rec {
      type = "mod";
      pname = "resistoranthems";
      version = "2022-10-16";
      src = fetchFromContentDB {
        author = "Astrobe";
        technicalName = "resistoranthems";
        release = 14399;
        versionName = "2022-10-16";
        sha256 = "0k8v8dz8kw9qxqbldzc17wfvzaxq283v9haqc8dqh67jm62p8m52";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Background music (chiptune/8bit-like)";

      };
    };

    "Atlante"."better_farming" = buildMinetestPackage rec {
      type = "mod";
      pname = "better_farming";
      version = "Better_Farming";
      src = fetchFromContentDB {
        author = "Atlante";
        technicalName = "better_farming";
        release = 13840;
        versionName = "Better Farming";
        sha256 = "0zqk5d0kx6piym40mavlvmz8rmp9qlbmvl73kj0cyv2vaidg9k3p";
      };
      meta = src.meta // {
        license = [ spdx."AFL-1.1" ];
        description = "A simple mod, not too complicated, that adds agriculture. https://discord.gg/jhmaPq7j";

      };
    };

    "Atlante"."biomes" = buildMinetestPackage rec {
      type = "mod";
      pname = "biomes";
      version = "Biomes_V6";
      src = fetchFromContentDB {
        author = "Atlante";
        technicalName = "biomes";
        release = 13432;
        versionName = "Biomes V6";
        sha256 = "0k1bv9jf2qcsprw9x30y5jspqd47k4b5lvf324jzzjhxsxs4419l";
      };
      meta = src.meta // {
        license = [ spdx."AFL-1.1" ];
        description = "Adds 8 new Biomes as well as more type of wood and tree etc... https://discord.gg/jhmaPq7j";

      };
    };

    "Aurailus"."aurora_tech" = buildMinetestPackage rec {
      type = "mod";
      pname = "aurora_tech";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "Aurailus";
        technicalName = "aurora_tech";
        release = 9839;
        versionName = "1.0.4";
        sha256 = "0wa4a9pjcl2vw3sqgnhlk325si7mz05zvq5bmhwihbgh95c0dk52";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Unique and powerful gadgets and utilites.";

      };
    };

    "Aurailus"."lexa" = buildMinetestPackage rec {
      type = "game";
      pname = "lexa";
      version = "2021-12-23";
      src = fetchFromContentDB {
        author = "Aurailus";
        technicalName = "lexa";
        release = 10216;
        versionName = "2021-12-23";
        sha256 = "1x6b1fq0f6rb1h3icb74aiv7kwcmsg59x41wbr1126pghgy6176y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "WIP Tower Defense Game";

      };
    };

    "Aurailus"."nodecoreimproved" = buildMinetestPackage rec {
      type = "txp";
      pname = "nodecoreimproved";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Aurailus";
        technicalName = "nodecoreimproved";
        release = 10038;
        versionName = "2021-01-29";
        sha256 = "1xwzfjp2ysxqvgjfq0s3hqfza8zj0a761gdp81j2c1jc8x25x0kq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Improved textures for the Nodecore game!";

      };
    };

    "Avicennia_g"."euthamia" = buildMinetestPackage rec {
      type = "mod";
      pname = "euthamia";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "euthamia";
        release = 7376;
        versionName = "1.0.4";
        sha256 = "0raq3w9rb00dm03qyvpi9gvdpxp2cdw1mrzsh5j8033q15dmwx18";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Grassy Goldenrod plant for Nodecore";

      };
    };

    "Avicennia_g"."mudsling" = buildMinetestPackage rec {
      type = "mod";
      pname = "mudsling";
      version = "1.1.4";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "mudsling";
        release = 8659;
        versionName = "1.1.4";
        sha256 = "0ldm65nzdvcxj15162dfxa6075r46nr0326lvk2fh4zx7ldq6cxr";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Inverted-direction player slingshot";

      };
    };

    "Avicennia_g"."nc_luxgate" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_luxgate";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "nc_luxgate";
        release = 3214;
        versionName = "1.0.0";
        sha256 = "079a1lddjjn57m3j98zsg4w2zgyi046w3ppqclfbwfax2zc0sdgf";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A simple attempt at adding craftable portals called \"Luxgates\" to nodecore.";

      };
    };

    "Avicennia_g"."nc_stucco" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_stucco";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "nc_stucco";
        release = 2624;
        versionName = "1.1.1";
        sha256 = "1xv557qs874k4q7dpybh4p5rw89fglxkz83iqi74a9bmcp18vady";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a few decorative building nodes to Nodecore through simple and crude masonry.";

      };
    };

    "Avicennia_g"."satchel" = buildMinetestPackage rec {
      type = "mod";
      pname = "satchel";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "satchel";
        release = 5960;
        versionName = "1.0";
        sha256 = "0hla5cxkyf8y9r50vqddqn8qmv0zn4lx9ki6l02zrw7l6la17xq3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Attempt at adding a formspec-less inventory interface.";

      };
    };

    "Avicennia_g"."wac" = buildMinetestPackage rec {
      type = "mod";
      pname = "wac";
      version = "2019-10-21";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "wac";
        release = 2229;
        versionName = "2019-10-21";
        sha256 = "0i419jk28ljaw8j5pyr9bmw6cl01msr95g4xdkcq6r07h5n6vmdl";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Use vaguely familiar tools, weapons and other items to smash \"eggcorns\" in this frantic, Nodecore-flavoured, smash-and-dash styled minigame.";

      };
    };

    "Avicennia_g"."yctie" = buildMinetestPackage rec {
      type = "mod";
      pname = "yctie";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Avicennia_g";
        technicalName = "yctie";
        release = 6559;
        versionName = "1.1";
        sha256 = "1b143gb2hha7g33sj218yapijr5flx60s8bzl07hzh8jpmkbhsgb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Simple mod adding lockable storage shelves to Nodecore.";

      };
    };

    "BRNSystems"."blocky_portaling" = buildMinetestPackage rec {
      type = "game";
      pname = "blocky_portaling";
      version = "0.0.5";
      src = fetchFromContentDB {
        author = "BRNSystems";
        technicalName = "blocky_portaling";
        release = 13394;
        versionName = "0.0.5";
        sha256 = "1sx1bf6yjwk9kgj442v0x060nxq4y8gs8y04j0b71j79pq4s6skm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A WIP game based on AiTechEye's portalgun";

          homepage = "https://git.brn.systems/blocky_portaling/blocky_portaling";

      };
    };

    "Bas080"."pathogen" = buildMinetestPackage rec {
      type = "mod";
      pname = "pathogen";
      version = "2015-02-20";
      src = fetchFromContentDB {
        author = "Bas080";
        technicalName = "pathogen";
        release = 8103;
        versionName = "2015-02-20";
        sha256 = "1xnvv9m34ksd11gb8qwqphr6j6s78lm3zfpl26558fi98dwdwzw1";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Anables users to get a pathogen.";

      };
    };

    "Beerholder"."painted_3d_armor" = buildMinetestPackage rec {
      type = "mod";
      pname = "painted_3d_armor";
      version = "Apr_7__2019";
      src = fetchFromContentDB {
        author = "Beerholder";
        technicalName = "painted_3d_armor";
        release = 1313;
        versionName = "Apr 7, 2019";
        sha256 = "17nihc0hq4krmsi5ycx69lvjalpdwg5jk5ib91djwb1mcfcsvmk0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-only" ];
        description = "Adds banners to your armor, either painted using the painting mod or created using the banners mod";

      };
    };

    "Ben"."bewarethedark" = buildMinetestPackage rec {
      type = "mod";
      pname = "bewarethedark";
      version = "2016-01-18";
      src = fetchFromContentDB {
        author = "Ben";
        technicalName = "bewarethedark";
        release = 12991;
        versionName = "2016-01-18";
        sha256 = "1sn9gw68h1xagld6b8xcbljq4siijf6sa04wgkhc76aihb260aji";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Darkness hurts.";

      };
    };

    "BigBear"."portal_rail" = buildMinetestPackage rec {
      type = "mod";
      pname = "portal_rail";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "BigBear";
        technicalName = "portal_rail";
        release = 9353;
        versionName = "1.0.0";
        sha256 = "1rg8fvcdv4jmhsrgq093bxg2jh5acb2racf47rdy6s8h0vsyd2yg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Minecart rail that teleports exactly 500m in direction of travel";

      };
    };

    "BigBear"."simple_armor" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_armor";
      version = "Version_1.0.0";
      src = fetchFromContentDB {
        author = "BigBear";
        technicalName = "simple_armor";
        release = 12065;
        versionName = "Version 1.0.0";
        sha256 = "02327k36lkffkvi8nlx55gafcgb2wvlnjf64vspb3zvwrccgvnb5";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Simple, flexible, easy to use armor with no dependancies";

      };
    };

    "Big_Caballito"."no_mans_land" = buildMinetestPackage rec {
      type = "game";
      pname = "no_mans_land";
      version = "0.1.1";
      src = fetchFromContentDB {
        author = "Big_Caballito";
        technicalName = "no_mans_land";
        release = 8685;
        versionName = "0.1.1";
        sha256 = "1i02bc86rrfjs1n21f582z4bsx8rk7l5a8sikrchjsz6vk6llvky";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Survive No Man's Land, where TNT rains from the sky, and destroys everything. This is a Work in Progress, I wanna add more features & lore";

      };
    };

    "BirgitLachner"."turtleminer" = buildMinetestPackage rec {
      type = "mod";
      pname = "turtleminer";
      version = "0.1";
      src = fetchFromContentDB {
        author = "BirgitLachner";
        technicalName = "turtleminer";
        release = 135;
        versionName = "0.1";
        sha256 = "04n833ri3aa2dnydhlpk0f4yzjrlngffwc7fm5kymjwydp3ql0z2";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A Mod to let Kids start programming with a turtle that can move around in the world, and dig and build what the user wants.";

          homepage = "https://wiki.minetest.net/Mods/TurtleMiner";

      };
    };

    "Blockhead"."foodblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "foodblocks";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "Blockhead";
        technicalName = "foodblocks";
        release = 13105;
        versionName = "1.2.1";
        sha256 = "1qmi1c8higl6z54n7sm5jn1d1zvk2537x4krfhq6i0zy5v4k7xd4";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Solid cubes of food for mass storage or building.";

      };
    };

    "Blocky_Player"."bloodbane" = buildMinetestPackage rec {
      type = "mod";
      pname = "bloodbane";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "bloodbane";
        release = 10253;
        versionName = "1.0.0";
        sha256 = "13mwng539jpk6qb4yvzlyjdwjs9557yjl4q7ml2p17i73j7ib6as";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Can one-shot any player wearing armor under diamond";

      };
    };

    "Blocky_Player"."ghost_block" = buildMinetestPackage rec {
      type = "mod";
      pname = "ghost_block";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "ghost_block";
        release = 14263;
        versionName = "1.0.2";
        sha256 = "01afw2bsqpdqgdb4m69nfid7g7y6hhww0vz5drpids8yyjq94mr4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds blocks that you can walk through. Build traps, hidden rooms and more!";

      };
    };

    "Blocky_Player"."happy_land" = buildMinetestPackage rec {
      type = "txp";
      pname = "happy_land";
      version = "5.0.0";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "happy_land";
        release = 13084;
        versionName = "5.0.0";
        sha256 = "0cbp5ly9gilhg69j1a6hgd7qjncxf4b9im6i5cpg0rvxd7n8cg20";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" ];
        description = "Bright, colourful and awsome!";

      };
    };

    "Blocky_Player"."map_cursor" = buildMinetestPackage rec {
      type = "mod";
      pname = "map_cursor";
      version = "2.0.0";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "map_cursor";
        release = 12785;
        versionName = "2.0.0";
        sha256 = "1fyaj19i94yhh22rwz0hhdkr207w03wngw22wwmbwq41ikmq2znv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds blocks like arrows, pointers and signals. For mapmakers who need to point players somewhere.";

      };
    };

    "Blocky_Player"."more_stones" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_stones";
      version = "5.1.0";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "more_stones";
        release = 14447;
        versionName = "5.1.0";
        sha256 = "1r31rlcl0ri0w3pmixvmz5h8hn0i7xjsjb1wyap6nn1019q0nb83";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds some different rocks and stones, and building blocks. ";

      };
    };

    "Blocky_Player"."mud" = buildMinetestPackage rec {
      type = "mod";
      pname = "mud";
      version = "1.9.0";
      src = fetchFromContentDB {
        author = "Blocky_Player";
        technicalName = "mud";
        release = 13091;
        versionName = "1.9.0";
        sha256 = "05dq32rw3yp3zbpjfliqjhp045r48zc0yychp362v6mawspfilsg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" ];
        description = "Adds stylish mud blocks and even blocks you can walk through. Setup traps, secret rooms and much more!";

      };
    };

    "BlueR23"."anti_join" = buildMinetestPackage rec {
      type = "mod";
      pname = "anti_join";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "BlueR23";
        technicalName = "anti_join";
        release = 9400;
        versionName = "1.0.1";
        sha256 = "1c7a1qlbxhf708vr2l5dnh2h54qfn4654h5325ab55rqbrharmph";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Stops players from joining";

      };
    };

    "BlueR23"."death_pos" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_pos";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "BlueR23";
        technicalName = "death_pos";
        release = 9841;
        versionName = "1.0.2";
        sha256 = "1vcmpg6317wr1vdwbqs2iijm91ds7n7jchrnknp7cvx5zlzvlvhk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a command to return back to position where you died";

      };
    };

    "BlueR23"."h_windows" = buildMinetestPackage rec {
      type = "mod";
      pname = "h_windows";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "BlueR23";
        technicalName = "h_windows";
        release = 9559;
        versionName = "1.0.0";
        sha256 = "098237lfz3c7wk3fl9vxqrb112brmsf3vi0ip558wzmpyfc4fxmf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds windows for your house";

      };
    };

    "BlueR23"."playermute" = buildMinetestPackage rec {
      type = "mod";
      pname = "playermute";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "BlueR23";
        technicalName = "playermute";
        release = 9560;
        versionName = "1.0.1";
        sha256 = "0f7kr5rsjcr6wai8fw4czla0bmp574qymyqh2975h6l3s9c1b3sw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Allows to mute players";

      };
    };

    "BlueR23"."welcome_newplayers" = buildMinetestPackage rec {
      type = "mod";
      pname = "welcome_newplayers";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "BlueR23";
        technicalName = "welcome_newplayers";
        release = 9410;
        versionName = "1.0.2";
        sha256 = "0prl9g4afndnyb3wsca55pykrrzc5xf5bdckm8yczfb4rxpwbf9k";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Sends a welcome message to new players";

      };
    };

    "BrandonReese"."landrush" = buildMinetestPackage rec {
      type = "mod";
      pname = "landrush";
      version = "2016-09-28";
      src = fetchFromContentDB {
        author = "BrandonReese";
        technicalName = "landrush";
        release = 2153;
        versionName = "2016-09-28";
        sha256 = "1ljkpw5fvlp9kzicp9zmligr79jknl6r8v430mn19zpbb6wyhq2g";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Chunk-based protection.";

      };
    };

    "BrandonReese"."stairpick" = buildMinetestPackage rec {
      type = "mod";
      pname = "stairpick";
      version = "2013-02-24";
      src = fetchFromContentDB {
        author = "BrandonReese";
        technicalName = "stairpick";
        release = 2154;
        versionName = "2013-02-24";
        sha256 = "0kl6p1nij0yz0qyxvzlm5aa365258n8ch5yavm1py7v2fh0bvwaa";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This is a specialized pick for making stairs.";

      };
    };

    "BrunoMine"."craft_table" = buildMinetestPackage rec {
      type = "mod";
      pname = "craft_table";
      version = "2020-10-27";
      src = fetchFromContentDB {
        author = "BrunoMine";
        technicalName = "craft_table";
        release = 6373;
        versionName = "2020-10-27";
        sha256 = "1v93s54a6hpzxkn0jj3b0psmnbjyjdins03s1hg37cyi3vjmnskj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Add Craft Table";

      };
    };

    "BuckarooBanzay"."basic_streets" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_streets";
      version = "2022-01-07";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "basic_streets";
        release = 10495;
        versionName = "2022-01-07";
        sha256 = "1dpivb4np9r43qn4y0bpbz4b135q7f0wy2c7c70gjbfp82nfs0c1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Simple tar-based street nodes with markings for straight,corner,crossing and t-junction";

      };
    };

    "BuckarooBanzay"."blockexchange" = buildMinetestPackage rec {
      type = "mod";
      pname = "blockexchange";
      version = "2022-10-08";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "blockexchange";
        release = 14248;
        versionName = "2022-10-08";
        sha256 = "0v702mpzsns35lsb166qavlngwnl870nxw5qx98z8ahxjlligzf8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Cloud worldedit schema exchanger";

      };
    };

    "BuckarooBanzay"."citygen" = buildMinetestPackage rec {
      type = "mod";
      pname = "citygen";
      version = "2022-05-15";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "citygen";
        release = 12286;
        versionName = "2022-05-15";
        sha256 = "0z3z80pg33c8a9vzrz2v7k8wwknd0gyw72cgm61jpqnwyajgr9nw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "city mapgenerator";

      };
    };

    "BuckarooBanzay"."controls" = buildMinetestPackage rec {
      type = "mod";
      pname = "controls";
      version = "2020-12-16";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "controls";
        release = 5748;
        versionName = "2020-12-16";
        sha256 = "05y8gcabc13wgnzvn7x15fs1myss9nqc3xy1x3v2n609xa44jnga";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Utility library for control press/hold/release events";

      };
    };

    "BuckarooBanzay"."digibuilder" = buildMinetestPackage rec {
      type = "mod";
      pname = "digibuilder";
      version = "2021-04-20";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "digibuilder";
        release = 7564;
        versionName = "2021-04-20";
        sha256 = "1nz5zqpfvkc1vmkj67vw55vq58fwg8srv6b2dzqdmpy8p2sp400c";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Build nodes with digiline commands";

      };
    };

    "BuckarooBanzay"."epic" = buildMinetestPackage rec {
      type = "mod";
      pname = "epic";
      version = "2022-01-02";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "epic";
        release = 10383;
        versionName = "2022-01-02";
        sha256 = "1h52ys8gxz4hracrs5znpm4n1ggxwj1582ihd9204by9ix8q5rgy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-2.0-only" ];
        description = "Enhanced Programmer for Ingame Control";

      };
    };

    "BuckarooBanzay"."holoemitter" = buildMinetestPackage rec {
      type = "mod";
      pname = "holoemitter";
      version = "2021-02-13";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "holoemitter";
        release = 6519;
        versionName = "2021-02-13";
        sha256 = "1p6kbf25g0lim5mp5jzb3azaasfypsqgdcq7qrrmxghvm3c8wy8l";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Holo emitter mod";

      };
    };

    "BuckarooBanzay"."jumpdrive" = buildMinetestPackage rec {
      type = "mod";
      pname = "jumpdrive";
      version = "2022-03-06";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "jumpdrive";
        release = 11501;
        versionName = "2022-03-06";
        sha256 = "0xr9vy8naj2gmr0n7mwlnc3xp2r5v6bp6khga2rz71n90rmyjisg";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Take your buildings with you on your journey.";

      };
    };

    "BuckarooBanzay"."mapblock_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "mapblock_lib";
      version = "2022-10-14";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "mapblock_lib";
        release = 14363;
        versionName = "2022-10-14";
        sha256 = "004ig32jvm7q59rl9xivkk08kr753gsqrxfs0mn15x2n50by7d0f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "mapblock serialization functions";

      };
    };

    "BuckarooBanzay"."mapserver" = buildMinetestPackage rec {
      type = "mod";
      pname = "mapserver";
      version = "2022-08-19";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "mapserver";
        release = 13407;
        versionName = "2022-08-19";
        sha256 = "03ym1q0nqxcqa0hzdsc0vsh2d62vcz699qwd4zzkv5w7c6b79zcv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "mod for the mapserver";

      };
    };

    "BuckarooBanzay"."mesecons_lab" = buildMinetestPackage rec {
      type = "game";
      pname = "mesecons_lab";
      version = "2022-10-07";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "mesecons_lab";
        release = 14229;
        versionName = "2022-10-07";
        sha256 = "0izmnn5g7c15dyif8jx2j7rirkm238avafmifd9dskldhfa2zrx1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Mesecons laboratory and tutorials";

      };
    };

    "BuckarooBanzay"."missions" = buildMinetestPackage rec {
      type = "mod";
      pname = "missions";
      version = "2022-08-15";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "missions";
        release = 13282;
        versionName = "2022-08-15";
        sha256 = "0393v4hm4vz01j2x8rfpw38m46xz3nhw1hmad9bgdjp8b6bd4svv";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds blocks to create missions with rewards, timeout and penalties.";

      };
    };

    "BuckarooBanzay"."modgen" = buildMinetestPackage rec {
      type = "mod";
      pname = "modgen";
      version = "2022-06-11";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "modgen";
        release = 12503;
        versionName = "2022-06-11";
        sha256 = "0k4jqixfxryrf7zpbrzwfkmgv34awziipd2gyc8mi358yrp7ai2l";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "mapgen mod creator";

      };
    };

    "BuckarooBanzay"."mtt" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtt";
      version = "2022-10-11";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "mtt";
        release = 14303;
        versionName = "2022-10-11";
        sha256 = "19kdryqiiil7akj6m4j6k607vj9z3rpn63k3a75dhwqv9b02glqs";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides an api to register test functions for integration-tests.";

          homepage = "https://github.com/buckarooBanzay/mtt";

      };
    };

    "BuckarooBanzay"."mtzip" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtzip";
      version = "2022-10-11";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "mtzip";
        release = 14302;
        versionName = "2022-10-11";
        sha256 = "0v8gg5n2kmbzkahy5j2sbr2jmrxjwn0lvlxhlylbxmqn1dy9m5zz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = " zip-library";

          homepage = "https://github.com/BuckarooBanzay/mtzip/blob/master/README.md";

      };
    };

    "BuckarooBanzay"."particlefountain" = buildMinetestPackage rec {
      type = "mod";
      pname = "particlefountain";
      version = "2021-02-13";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "particlefountain";
        release = 6517;
        versionName = "2021-02-13";
        sha256 = "0nw9wks0n33cswpiwqhg94za9bwr7ggq903h27zh91vjzwgi0qgw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "decorative and configurable particle spawner";

      };
    };

    "BuckarooBanzay"."spacecannon" = buildMinetestPackage rec {
      type = "mod";
      pname = "spacecannon";
      version = "2021-03-09";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "spacecannon";
        release = 6899;
        versionName = "2021-03-09";
        sha256 = "0jzsq1b9f1ra1ks72hl9bc5bs3hgk7cp2i6ppwbbixgf7rm47fa7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds three scifi/space cannons with various projectile-speed and explosion-strength";

      };
    };

    "BuckarooBanzay"."super_sam" = buildMinetestPackage rec {
      type = "game";
      pname = "super_sam";
      version = "2022-10-15";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "super_sam";
        release = 14373;
        versionName = "2022-10-15";
        sha256 = "03z831bfg2w9ps883hy2ydaj6jm9b5v3zg2rnbzi55fh5y5lkkq8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Super sam adventures";

      };
    };

    "BuckarooBanzay"."xp_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "xp_redo";
      version = "2021-12-12";
      src = fetchFromContentDB {
        author = "BuckarooBanzay";
        technicalName = "xp_redo";
        release = 9990;
        versionName = "2021-12-12";
        sha256 = "0bps5r6ff2hkhr2llx4d2h0b0pgl7k57hmm4248iwj24p50xkgjs";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds experience, ranks, and doors only accessible to those above a certain rank. Not actually a redo of any mod.";

      };
    };

    "Byakuren"."armor_monoid" = buildMinetestPackage rec {
      type = "mod";
      pname = "armor_monoid";
      version = "0.3.0.0";
      src = fetchFromContentDB {
        author = "Byakuren";
        technicalName = "armor_monoid";
        release = 613;
        versionName = "0.3.0.0";
        sha256 = "02c504d9zqrax62khbjr0hh0rlx6kf2g0hjhy2fvqxham9d0ymf1";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A player_monoids monoid for armor";

      };
    };

    "Byakuren"."cmi" = buildMinetestPackage rec {
      type = "mod";
      pname = "cmi";
      version = "0.1.0.1";
      src = fetchFromContentDB {
        author = "Byakuren";
        technicalName = "cmi";
        release = 612;
        versionName = "0.1.0.1";
        sha256 = "1ihrzf78baddsbb2rmyfi5ir5qpkiww6ff26giapx9nicgp9k1nf";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "A standard modding interface for interacting with mobs";

          homepage = "https://cmi-minetest.github.io/";

      };
    };

    "Byakuren"."player_monoids" = buildMinetestPackage rec {
      type = "mod";
      pname = "player_monoids";
      version = "2022-03-07";
      src = fetchFromContentDB {
        author = "Byakuren";
        technicalName = "player_monoids";
        release = 13162;
        versionName = "2022-03-07";
        sha256 = "0ljhl07h3mi6lx37rvcm5rqys8ilpaqasm2xhm3skh75acmm7sm5";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "player_monoids is a library for managing global player state, such as physicsoverrides or player visual size.";

      };
    };

    "CBugDCoder"."glider" = buildMinetestPackage rec {
      type = "mod";
      pname = "glider";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "CBugDCoder";
        technicalName = "glider";
        release = 8507;
        versionName = "1.1.0";
        sha256 = "1fsa7730npr860ng359qnz9xz4sg40bj1490pv4zwqqbp010hif9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Add realistic moving hang gliders";

      };
    };

    "CBugDCoder"."tower_defense" = buildMinetestPackage rec {
      type = "mod";
      pname = "tower_defense";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "CBugDCoder";
        technicalName = "tower_defense";
        release = 3473;
        versionName = "v1.0.2";
        sha256 = "1zn7cb7x03h091bvm2bpcw7x34bc8ymcbhp0smhdvfpqvahdcxb1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "The Tanks are coming. Are you ready?";

      };
    };

    "CalebJ"."fireworks" = buildMinetestPackage rec {
      type = "mod";
      pname = "fireworks";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "CalebJ";
        technicalName = "fireworks";
        release = 3844;
        versionName = "1.1.0";
        sha256 = "0pxp9np5m6jia3f6ix268g190x3shxm28xisri30h16cdl8fqnw9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Particle driven fireworks.";

      };
    };

    "CalebJ"."morebricks" = buildMinetestPackage rec {
      type = "mod";
      pname = "morebricks";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "CalebJ";
        technicalName = "morebricks";
        release = 2250;
        versionName = "1.0.1";
        sha256 = "06ns7adbnind3hyxxxrsh0w1rn4ayqwimhwv22d3xd36qgy1dn6s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an assortment of new bricks to build with.";

      };
    };

    "CalebJ"."staffs" = buildMinetestPackage rec {
      type = "mod";
      pname = "staffs";
      version = "1.2";
      src = fetchFromContentDB {
        author = "CalebJ";
        technicalName = "staffs";
        release = 3705;
        versionName = "1.2";
        sha256 = "1rfndcd3mpxhs3zfky30a33h1r4chsngndplpry008412f1py4p4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Staffs with various uses";

      };
    };

    "Calinou"."gauges" = buildMinetestPackage rec {
      type = "mod";
      pname = "gauges";
      version = "2021-10-19";
      src = fetchFromContentDB {
        author = "Calinou";
        technicalName = "gauges";
        release = 13156;
        versionName = "2021-10-19";
        sha256 = "02c0bbhjs9y813fj7c15hlsjbggv61rrdm1mr8qwnpwqgy7r2z8q";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds health and breath gauges above players.";

      };
    };

    "Calinou"."maptools" = buildMinetestPackage rec {
      type = "mod";
      pname = "maptools";
      version = "2.0.0";
      src = fetchFromContentDB {
        author = "Calinou";
        technicalName = "maptools";
        release = 2396;
        versionName = "2.0.0";
        sha256 = "12ny1djjc89hw8xg7a0d96ky9zc9pg6ksjlab5va8rp51dhxwc3h";
      };
      meta = src.meta // {
        license = [ spdx."Zlib" ];
        description = "Adds various special versions of normal blocks, tools, and other map maintainer tools.";

      };
    };

    "Calinou"."meze" = buildMinetestPackage rec {
      type = "mod";
      pname = "meze";
      version = "2015-05-14";
      src = fetchFromContentDB {
        author = "Calinou";
        technicalName = "meze";
        release = 12987;
        versionName = "2015-05-14";
        sha256 = "1qxbjzkrq3bghxip89018hhccx6wspncblp3n9ny2yszviq2j6p5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."Zlib" ];
        description = "A special ore that kills you when mined.";

      };
    };

    "Calinou"."moreblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "moreblocks";
      version = "2022-08-03";
      src = fetchFromContentDB {
        author = "Calinou";
        technicalName = "moreblocks";
        release = 13045;
        versionName = "2022-08-03";
        sha256 = "0sx0s7scxas86g09qpa0dzprn656c4ys0qn4hr9r56h3ajvlz1v1";
      };
      meta = src.meta // {
        license = [ spdx."Zlib" ];
        description = "Adds various miscellaneous blocks to the game.";

      };
    };

    "Calinou"."moreores" = buildMinetestPackage rec {
      type = "mod";
      pname = "moreores";
      version = "2021-09-22";
      src = fetchFromContentDB {
        author = "Calinou";
        technicalName = "moreores";
        release = 13155;
        versionName = "2021-09-22";
        sha256 = "1sy12smlfbqcps4p6dfhdiqd8pd8v9ix1nf6528rik0xrl421jhg";
      };
      meta = src.meta // {
        license = [ spdx."Zlib" ];
        description = "Adds new ore types.";

      };
    };

    "Can202"."bank_accounts_receipt" = buildMinetestPackage rec {
      type = "mod";
      pname = "bank_accounts_receipt";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "bank_accounts_receipt";
        release = 7362;
        versionName = "v1.1";
        sha256 = "1lqc030ikqa380mc6k6wpkvx3qr9q1g023ks7azpkq0a21v4h902";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Receipt = TRASH";

      };
    };

    "Can202"."icecream" = buildMinetestPackage rec {
      type = "mod";
      pname = "icecream";
      version = "v2.2";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "icecream";
        release = 13949;
        versionName = "v2.2";
        sha256 = "015315xs02x3ny1xsw0i19r6vyii6xqmfhfcm9irw2pjxw083xwy";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Add some Ice Creams";

      };
    };

    "Can202"."mgc_base" = buildMinetestPackage rec {
      type = "txp";
      pname = "mgc_base";
      version = "2021-06-18";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "mgc_base";
        release = 8089;
        versionName = "2021-06-18";
        sha256 = "1wy7r7lh9lly4lmpy0dm0vs78mgd7hw05yvpqdd666hiypvw6sya";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Base to Texture Packs";

      };
    };

    "Can202"."mob_crab" = buildMinetestPackage rec {
      type = "mod";
      pname = "mob_crab";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "mob_crab";
        release = 7529;
        versionName = "v1.2";
        sha256 = "0pvmrin14qac593y6r7jk0xjfla9g7bbcrqizggs4gk881srknwi";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Crabs.";

      };
    };

    "Can202"."mtc_burger" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtc_burger";
      version = "v0.3";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "mtc_burger";
        release = 7357;
        versionName = "v0.3";
        sha256 = "06x9qyaz0pfwri90ash3ka82z651h26hq1p086lxnafza1k6lcz5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Burgers.";

      };
    };

    "Can202"."mtc_chisel" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtc_chisel";
      version = "v0.5";
      src = fetchFromContentDB {
        author = "Can202";
        technicalName = "mtc_chisel";
        release = 10622;
        versionName = "v0.5";
        sha256 = "1pnjxd5439rylsdv0d1w7b20l5j5pv7lnjkhfi5qbkg951q0fdkz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Add Chisel and new decorative blocks.";

      };
    };

    "Casimir"."spawnarea" = buildMinetestPackage rec {
      type = "mod";
      pname = "spawnarea";
      version = "2022-01-15";
      src = fetchFromContentDB {
        author = "Casimir";
        technicalName = "spawnarea";
        release = 14454;
        versionName = "2022-01-15";
        sha256 = "068c4mpcs2ws8pgr8i6d5w5l9ssk2yf672jvr8c60qkicab9xyrw";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Players spawn and respawn within an area around the center of active players.";

      };
    };

    "Casimir"."unternull" = buildMinetestPackage rec {
      type = "mod";
      pname = "unternull";
      version = "2018-06-23";
      src = fetchFromContentDB {
        author = "Casimir";
        technicalName = "unternull";
        release = 296;
        versionName = "2018-06-23";
        sha256 = "08vjzhjlrils45p0miywhikgy389aym64li4mryna9vckfcq6ary";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "You start swimming in the middle of an infinite ocean. Take your time and build.";

      };
    };

    "Casimir"."voxelgarden" = buildMinetestPackage rec {
      type = "game";
      pname = "voxelgarden";
      version = "5.6.0";
      src = fetchFromContentDB {
        author = "Casimir";
        technicalName = "voxelgarden";
        release = 13273;
        versionName = "5.6.0";
        sha256 = "1zl480px80vayr106y8scwb95q5aqvaqlhafm082sm80av4p3ndf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A classic game for exploring, survival and building";

      };
    };

    "ChimneySwift"."better_fences" = buildMinetestPackage rec {
      type = "mod";
      pname = "better_fences";
      version = "1.1";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "better_fences";
        release = 888;
        versionName = "1.1";
        sha256 = "1npp2172akk7amy5gyizaaslmknmb0f778gxya9ywchfh4ald7y1";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A Minetest mod which improves the usability of fences by making fences which connect to less than 2 other fences connect to all nodes.";

      };
    };

    "ChimneySwift"."fancy_vend" = buildMinetestPackage rec {
      type = "mod";
      pname = "fancy_vend";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "fancy_vend";
        release = 4781;
        versionName = "1.1.1";
        sha256 = "1xnsxwkirfkndxkijjsvpxkkzmp6ydj6gsggqr72pr5pfmqwd2kp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A full-featured, fully-integrated vendor mod for Minetest";

      };
    };

    "ChimneySwift"."mover" = buildMinetestPackage rec {
      type = "mod";
      pname = "mover";
      version = "1.0";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "mover";
        release = 676;
        versionName = "1.0";
        sha256 = "06rqgqa776i3iva048wybyyha35n20p2kb22gij1xkxwidn2lm8x";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a tool that makes moving nodes containing metadata such as chests and protection blocks extremely simple.";

      };
    };

    "ChimneySwift"."multitools" = buildMinetestPackage rec {
      type = "mod";
      pname = "multitools";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "multitools";
        release = 4782;
        versionName = "1.2.1";
        sha256 = "0qzn3lnw6r1q1zdn4nyj2w6chl5qj548z3d8x4q3c2l63m9gx28l";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds a series of multi-purpose tools to Minetest";

      };
    };

    "ChimneySwift"."sendstack" = buildMinetestPackage rec {
      type = "mod";
      pname = "sendstack";
      version = "1.0";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "sendstack";
        release = 677;
        versionName = "1.0";
        sha256 = "0vz54i5wz8l8g33lhi2ri8v9wzhba1c704w87fajmlq3yd0265cg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a command to send the stack you are holding to another player (requires ban priv)";

      };
    };

    "ChimneySwift"."temp_privs" = buildMinetestPackage rec {
      type = "mod";
      pname = "temp_privs";
      version = "1.1";
      src = fetchFromContentDB {
        author = "ChimneySwift";
        technicalName = "temp_privs";
        release = 679;
        versionName = "1.1";
        sha256 = "0hqvddm5y97hvr9kv1ixr122dcnyh8ph16ii0kh9bpfb7zhswnp7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Overwrites the default grant, grantme and revoke chatcommands to add revoke or grant expiration.";

      };
    };

    "Chrithon"."laptop_extend_pack_2" = buildMinetestPackage rec {
      type = "mod";
      pname = "laptop_extend_pack_2";
      version = "1.0_2020-8_";
      src = fetchFromContentDB {
        author = "Chrithon";
        technicalName = "laptop_extend_pack_2";
        release = 4899;
        versionName = "1.0(2020-8)";
        sha256 = "0sjkwfa5h5kabnpzcl1yy8qwfaw9i96s686yamw68b4dajqkzba8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."GPL-3.0-only" ];
        description = "Extend Pack for Laptop Mod with 4 computers and a theme.";

      };
    };

    "ClothierEdward"."speed_boots" = buildMinetestPackage rec {
      type = "mod";
      pname = "speed_boots";
      version = "Boots_of_Swiftness_Mod__V.1_";
      src = fetchFromContentDB {
        author = "ClothierEdward";
        technicalName = "speed_boots";
        release = 6801;
        versionName = "Boots of Swiftness Mod (V.1)";
        sha256 = "16lqmf9c01df5sxsr4hj4gwcgrg47bp7q0vfgcs4532qi1g934hb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds a new pair of boots called the Boots of Swiftness.";

      };
    };

    "Clyde"."aqua_farming" = buildMinetestPackage rec {
      type = "mod";
      pname = "aqua_farming";
      version = "Harvest_with_Seeds";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "aqua_farming";
        release = 3212;
        versionName = "Harvest with Seeds";
        sha256 = "1bc9jvb3f5cp87gkfdsf0s49g1zmd96vfqr5d5wwiahbja2sf6z6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "Farming under Water, now it's possible.";

      };
    };

    "Clyde"."barchairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "barchairs";
      version = "Interface_added.";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "barchairs";
        release = 868;
        versionName = "Interface added.";
        sha256 = "17g4k8vhx1xw0b9fzaa3zd5s4y1smrw4djb8cw6nqxc2dwprgl56";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds some Barchairs.";

      };
    };

    "Clyde"."coins" = buildMinetestPackage rec {
      type = "mod";
      pname = "coins";
      version = "1.1_Localisation";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "coins";
        release = 2602;
        versionName = "1.1 Localisation";
        sha256 = "0s4b46w2wc11mkbcnnkj7zb3xdnm6adjngb0g86q6rp01gk05jrr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds 3 kind of Coins to your game";

      };
    };

    "Clyde"."cucina_vegana" = buildMinetestPackage rec {
      type = "mod";
      pname = "cucina_vegana";
      version = "V_3.0_more_crops_added.";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "cucina_vegana";
        release = 11325;
        versionName = "V 3.0 more crops added.";
        sha256 = "1b0pzy3kxfr56d8myd0yypimaj8l4ba8nyird26905wz6576prcc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Adds plants and spices for a vegan kitchen";

      };
    };

    "Clyde"."herbs" = buildMinetestPackage rec {
      type = "mod";
      pname = "herbs";
      version = "Thank_you_Annalysa";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "herbs";
        release = 11477;
        versionName = "Thank you Annalysa";
        sha256 = "17za8w70l80jy26gx85mqi8la588z18jxmjx5ansyxbz2hi3cj4r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "Adds 15 flowers and 6 mushrooms.";

      };
    };

    "Clyde"."mesecons_stealthnode" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_stealthnode";
      version = "1.4";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "mesecons_stealthnode";
        release = 2603;
        versionName = "1.4";
        sha256 = "0cxny8nfa326yi5mf00gyr1xg5cm2hzg4p60y1crl9228q34dbg9";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Register your own Ghoststones.";

      };
    };

    "Clyde"."poi" = buildMinetestPackage rec {
      type = "mod";
      pname = "poi";
      version = "2022-05-19";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "poi";
        release = 12359;
        versionName = "2022-05-19";
        sha256 = "16hmy2sfrb58cnwwza8q00v4rmb8q50vi6mndm5kmiadxa2zbgkm";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Mod to create or visit Points of Interest";

      };
    };

    "Clyde"."remove_unknowns" = buildMinetestPackage rec {
      type = "mod";
      pname = "remove_unknowns";
      version = "v1.0-Agent";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "remove_unknowns";
        release = 11734;
        versionName = "v1.0-Agent";
        sha256 = "1mxl8hn5j35kbx52rdlzpfm2bh40l6a03s4ns24xbfck0q83c822";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "A small tool to help you clean up your world of unknown-blocks.";

      };
    };

    "Clyde"."smart_chat" = buildMinetestPackage rec {
      type = "mod";
      pname = "smart_chat";
      version = "Join_IRC-Channels_with_a_PW.";
      src = fetchFromContentDB {
        author = "Clyde";
        technicalName = "smart_chat";
        release = 11338;
        versionName = "Join IRC-Channels with a PW.";
        sha256 = "0jydkf5lpx2zkg89gbbcpsrr5majw7gz7dm85c8j1jznlsvkxcf0";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A new, lightweight, simple and modular Chatsystem";

      };
    };

    "CocoMarck"."128pxdefault" = buildMinetestPackage rec {
      type = "txp";
      pname = "128pxdefault";
      version = "up2022-Stones";
      src = fetchFromContentDB {
        author = "CocoMarck";
        technicalName = "128pxdefault";
        release = 10392;
        versionName = "up2022-Stones";
        sha256 = "0dl05kdv687620pqnc401kdmcp7pkwrr98b8i7knv2w1yc7rffcb";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "replace the textures (16px) with more realistic ones (128px) and try to keep the original style. ";

      };
    };

    "CodeMiner"."atm" = buildMinetestPackage rec {
      type = "mod";
      pname = "atm";
      version = "ATM_Redo_v1.0.4";
      src = fetchFromContentDB {
        author = "CodeMiner";
        technicalName = "atm";
        release = 7630;
        versionName = "ATM Redo v1.0.4";
        sha256 = "1lkv8n3z7xb4zjjaldgrdv72kk4jliw1q96qrs2ma9j25va4bgbx";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds an ATM (Automatic Teller Machine) and MWT (Money Wire Transfer) designed to work with the currency mod and its minegeld banknotes.";

      };
    };

    "Coder12"."death_timer" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_timer";
      version = "2020-3-3";
      src = fetchFromContentDB {
        author = "Coder12";
        technicalName = "death_timer";
        release = 3120;
        versionName = "2020-3-3";
        sha256 = "0zh5dn4zi08ycyaighv53iqs6w9cqfpkl2is8ffnzdcq7yh4x29p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This will force players to wait a specified amount of time on death.";

      };
    };

    "Coder12"."explodingchest" = buildMinetestPackage rec {
      type = "mod";
      pname = "explodingchest";
      version = "2021-11-17";
      src = fetchFromContentDB {
        author = "Coder12";
        technicalName = "explodingchest";
        release = 9682;
        versionName = "2021-11-17";
        sha256 = "0w8vb8kqcr98sdmianr39ks8g79hxc70nhg23bd005w092xc4y61";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Api-mod to allow containers like chest to explode if it contains explosive materials.";

      };
    };

    "Coder12"."latency_protection" = buildMinetestPackage rec {
      type = "mod";
      pname = "latency_protection";
      version = "2021-11-17";
      src = fetchFromContentDB {
        author = "Coder12";
        technicalName = "latency_protection";
        release = 14466;
        versionName = "2021-11-17";
        sha256 = "0nlkjl0hclnw0kcqnd25v7d97rb0ji6l0ir24hav2l37g2qdscq7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Latency protection attempts to prevent players from glitching through protected nodes. By either teleporting the player or damaging them.";

      };
    };

    "Coder12"."lava_ore_gen" = buildMinetestPackage rec {
      type = "mod";
      pname = "lava_ore_gen";
      version = "2021-11-17";
      src = fetchFromContentDB {
        author = "Coder12";
        technicalName = "lava_ore_gen";
        release = 9684;
        versionName = "2021-11-17";
        sha256 = "1jgpvnqbxbsks9dk862b4xrb8iiz73p9zsdxa2bpd6lypahp6i0w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Makes the lava turn stone into ore over time.";

      };
    };

    "Coder12"."tnt_revamped" = buildMinetestPackage rec {
      type = "mod";
      pname = "tnt_revamped";
      version = "2021-11-17";
      src = fetchFromContentDB {
        author = "Coder12";
        technicalName = "tnt_revamped";
        release = 9685;
        versionName = "2021-11-17";
        sha256 = "09mk8lpwc4a9ah0601c7am4rp7pqgx53jggijn5mprgfg6crwcn3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Overrides the TNT mod to make it more like mc TNT.";

      };
    };

    "ComputeGraphics"."snowball" = buildMinetestPackage rec {
      type = "mod";
      pname = "snowball";
      version = "Throwable_Snowball_1.4";
      src = fetchFromContentDB {
        author = "ComputeGraphics";
        technicalName = "snowball";
        release = 5395;
        versionName = "Throwable Snowball 1.4";
        sha256 = "0i672as8900w60dzc6rry8bzmx8706xkkgczgsjva52qn69qx79f";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Adds a throwable Snowball";

      };
    };

    "CowboyLv"."ebiomes" = buildMinetestPackage rec {
      type = "mod";
      pname = "ebiomes";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "CowboyLv";
        technicalName = "ebiomes";
        release = 14391;
        versionName = "1.1.1";
        sha256 = "1ws53zr2k1vqfrqi2mf0664q89rc4cvhlavk6wkv0asrfxxz91y1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-or-later" ];
        description = "Adds extra biomes, while keeping its looks close to the vanilla MTG";

      };
    };

    "Crystalwarrior"."armor_expanded" = buildMinetestPackage rec {
      type = "mod";
      pname = "armor_expanded";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Crystalwarrior";
        technicalName = "armor_expanded";
        release = 13634;
        versionName = "1.0.1";
        sha256 = "112njky8kvymy7dkjw6g9cv712dxz750mnfrs0g0y3yf0lbk2njk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Expanded armors for 3d armors";

      };
    };

    "Crystalwarrior"."simplecoins" = buildMinetestPackage rec {
      type = "mod";
      pname = "simplecoins";
      version = "2022-09-12";
      src = fetchFromContentDB {
        author = "Crystalwarrior";
        technicalName = "simplecoins";
        release = 13823;
        versionName = "2022-09-12";
        sha256 = "0m57hx7qpf0888azyra4rww0v6ygz25ja32p16qasxb2kdnzlbnh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Mod for simple, extremely stackable coins to be used by other mods for trading, currency and inventory management.";

      };
    };

    "D00Med"."mini8x" = buildMinetestPackage rec {
      type = "txp";
      pname = "mini8x";
      version = "2017-06-08";
      src = fetchFromContentDB {
        author = "D00Med";
        technicalName = "mini8x";
        release = 88;
        versionName = "2017-06-08";
        sha256 = "1dvz16jxy932p596zxrqrml57kgga06nq9xhhxdc9v3yr8zhdrmy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "8x texturepack.";

      };
    };

    "D00Med"."scifi_nodes" = buildMinetestPackage rec {
      type = "mod";
      pname = "scifi_nodes";
      version = "2022-05-29";
      src = fetchFromContentDB {
        author = "D00Med";
        technicalName = "scifi_nodes";
        release = 12404;
        versionName = "2022-05-29";
        sha256 = "1k9k0vrk9s9m3kv62f7f36py3jq0s693j92ar7fr10kfxwc9n7l6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds some nodes for building futuristic/sci-fi themed constructions";

      };
    };

    "D00Med"."vehicles" = buildMinetestPackage rec {
      type = "mod";
      pname = "vehicles";
      version = "2022-09-02";
      src = fetchFromContentDB {
        author = "D00Med";
        technicalName = "vehicles";
        release = 13681;
        versionName = "2022-09-02";
        sha256 = "16jx7j80zgws9wnck9n2wx1g2vbjx7f5xpxkqnng93d59sksiw7x";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A mod that adds an api for cars, planes, and other vehicles.";

      };
    };

    "DELTA_FORCE"."colorscreens" = buildMinetestPackage rec {
      type = "mod";
      pname = "colorscreens";
      version = "colorscreens";
      src = fetchFromContentDB {
        author = "DELTA_FORCE";
        technicalName = "colorscreens";
        release = 914;
        versionName = "colorscreens";
        sha256 = "0jyfn2qqfdi248zxjm5zbbgcxizigdhhmnvk8vx1na254knsqil5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Decorations that can also be used as an actual greenscreen or other colorscreen.";

      };
    };

    "DS-minetest"."keyevent" = buildMinetestPackage rec {
      type = "mod";
      pname = "keyevent";
      version = "2019-05-31";
      src = fetchFromContentDB {
        author = "DS-minetest";
        technicalName = "keyevent";
        release = 4860;
        versionName = "2019-05-31";
        sha256 = "0km7clmgw4y09bj4l22frysbkkpzl3vxhlp4qpvb7ryjlal4v21b";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds an event for when player presses a key.";

      };
    };

    "Deadlock"."thelowerroad" = buildMinetestPackage rec {
      type = "mod";
      pname = "thelowerroad";
      version = "initial_import";
      src = fetchFromContentDB {
        author = "Deadlock";
        technicalName = "thelowerroad";
        release = 13102;
        versionName = "initial_import";
        sha256 = "1f1z0nla3w4v97dc1f31rh18bpdni5px70qnkab8j60ad9l7qpm2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a long road from -Z to +Z to the world, during world-generation.";

      };
    };

    "Don"."mydoors" = buildMinetestPackage rec {
      type = "mod";
      pname = "mydoors";
      version = "2021-10-23";
      src = fetchFromContentDB {
        author = "Don";
        technicalName = "mydoors";
        release = 13157;
        versionName = "2021-10-23";
        sha256 = "1bqw22xvdwnf9hzy028ymdzb2dlh5rsf2gxmmns0fjyn0yhxpafi";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds several different style doors.";

      };
    };

    "Don"."mymillwork" = buildMinetestPackage rec {
      type = "mod";
      pname = "mymillwork";
      version = "2019-05-16";
      src = fetchFromContentDB {
        author = "Don";
        technicalName = "mymillwork";
        release = 8097;
        versionName = "2019-05-16";
        sha256 = "023acilldxlm5322sb5w633p0a811yh2z64ib6fkmnh4zkhr3vbk";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Crown molding, columns and baseboards of different styles.";

      };
    };

    "Don"."mywalls" = buildMinetestPackage rec {
      type = "mod";
      pname = "mywalls";
      version = "2018-06-05";
      src = fetchFromContentDB {
        author = "Don";
        technicalName = "mywalls";
        release = 223;
        versionName = "2018-06-05";
        sha256 = "04abh8f17avipkfq0c8fjq4z084p1vrwjswppp26cw2rkf5zxlsh";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds more wall types for walls mod.";

      };
    };

    "Don"."worldedge" = buildMinetestPackage rec {
      type = "mod";
      pname = "worldedge";
      version = "2017-07-14";
      src = fetchFromContentDB {
        author = "Don";
        technicalName = "worldedge";
        release = 8100;
        versionName = "2017-07-14";
        sha256 = "1nkhq5zgba4sy3szzfxaynh9wi1csy8g2zbiar27cpfb3qx43m2b";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = " Teleports the player to the other side of the world when they reach the edge.";

      };
    };

    "DrFrankenstone"."cloudlands" = buildMinetestPackage rec {
      type = "mod";
      pname = "cloudlands";
      version = "v1.54_Maintenance";
      src = fetchFromContentDB {
        author = "DrFrankenstone";
        technicalName = "cloudlands";
        release = 4680;
        versionName = "v1.54 Maintenance";
        sha256 = "14cghfd6jw2y3sdbbjrsgz1ad3wh6yr677q6ky3axi5lkwxh45gs";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Giant rocks floating suspended in magnetic eddies. (skylands, islands, fantasy, giant trees)";

      };
    };

    "DrFrankenstone"."lessdirt" = buildMinetestPackage rec {
      type = "txp";
      pname = "lessdirt";
      version = "v1.4_MineClone_2___5___more";
      src = fetchFromContentDB {
        author = "DrFrankenstone";
        technicalName = "lessdirt";
        release = 13232;
        versionName = "v1.4 MineClone 2 & 5 + more";
        sha256 = "02sysacf8dbir95i1p74inaqnv1kfxgd9wiayjikw3g3aipz22sw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adjusts textures so rolling hills have less exposed bare dirt.";

      };
    };

    "DrPlamsa"."flower_cow" = buildMinetestPackage rec {
      type = "mod";
      pname = "flower_cow";
      version = "New_inventory_icon";
      src = fetchFromContentDB {
        author = "DrPlamsa";
        technicalName = "flower_cow";
        release = 5998;
        versionName = "New inventory icon";
        sha256 = "0g26p0p8kbd0iw6j8mijrdyig3kj9bq1qbljiqiqrskyqwinczwz";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds a flower cow.";

      };
    };

    "DrPlamsa"."guinea_pig" = buildMinetestPackage rec {
      type = "mod";
      pname = "guinea_pig";
      version = "New_inventory_icon_and_sounds";
      src = fetchFromContentDB {
        author = "DrPlamsa";
        technicalName = "guinea_pig";
        release = 5997;
        versionName = "New inventory icon and sounds";
        sha256 = "050ffp72h60hxq1r47rdf5724jc9v4nzmymgxxkhp33r3lqqc89q";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds guinea pigs.";

      };
    };

    "Dragonop"."claycrafter" = buildMinetestPackage rec {
      type = "mod";
      pname = "claycrafter";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Dragonop";
        technicalName = "claycrafter";
        release = 6271;
        versionName = "2021-01-29";
        sha256 = "14hzhk01l63y4jy01xb3iyq937iw4873mglpi4wgavcjhjpkf4fm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Introduces the Claycrafter, which converts Compressed Dirt to Clay using Glasses of Water.";

      };
    };

    "Dragonop"."tools_obsidian" = buildMinetestPackage rec {
      type = "mod";
      pname = "tools_obsidian";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Dragonop";
        technicalName = "tools_obsidian";
        release = 6102;
        versionName = "1.0";
        sha256 = "0r3h4s0zx3c980a0c2vk8sspq9hamflwzw4qm627ing549dlrwpj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds the Obsidian Dagger, Sword, and Longsword. Also Obsidian tools, for completeness.";

      };
    };

    "Droog71"."chat_translator" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_translator";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Droog71";
        technicalName = "chat_translator";
        release = 10203;
        versionName = "1.0.1";
        sha256 = "09i2f5fqlzwsiqn0f7y65p3wg9jvjdabh85mhqipd0i04bvwi2dp";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Translates chat messages in Minetest using LibreTranslate.";

      };
    };

    "Droog71"."moontest" = buildMinetestPackage rec {
      type = "game";
      pname = "moontest";
      version = "2022-02-05";
      src = fetchFromContentDB {
        author = "Droog71";
        technicalName = "moontest";
        release = 11101;
        versionName = "2022-02-05";
        sha256 = "09jj25aka9ngk3a7hfxywmwavma86j37k9fx297wkx8pfkdgwxrj";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-4.0" ];
        description = "Moon Habitat Simulator";

          homepage = "https://youtu.be/LazQEzAa1qM";

      };
    };

    "Droog71"."moontest_32x32" = buildMinetestPackage rec {
      type = "txp";
      pname = "moontest_32x32";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Droog71";
        technicalName = "moontest_32x32";
        release = 10626;
        versionName = "1.0.0";
        sha256 = "0vm62xsmgr4ymjv36cb9vjfzdmd29ic2sf4bs935s0sa0hyv5ad7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A 32x32 texture pack made specifically for the game \"Moontest: Moon Habitat Simulator\".";

      };
    };

    "Droog71"."random_teleport" = buildMinetestPackage rec {
      type = "mod";
      pname = "random_teleport";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "Droog71";
        technicalName = "random_teleport";
        release = 8420;
        versionName = "1.0.2";
        sha256 = "1v8f3hpnfz6hc9sin0cin1629yfzsmjmnd0qixp2px28qjjdaa5j";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Allows players to teleport to a random location using the /rtp command.";

      };
    };

    "Duvalon"."maple" = buildMinetestPackage rec {
      type = "mod";
      pname = "maple";
      version = "Maple_Tree_0.6";
      src = fetchFromContentDB {
        author = "Duvalon";
        technicalName = "maple";
        release = 13418;
        versionName = "Maple Tree 0.6";
        sha256 = "1xfpgni1d748nnmnv6l9cznsml52da0qqssj4qggwbkl0kzdkph4";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds a maple tree placed during world generation.";

      };
    };

    "Duvalon"."moarmour" = buildMinetestPackage rec {
      type = "mod";
      pname = "moarmour";
      version = "MOAR__ARMOUR__version_0.4";
      src = fetchFromContentDB {
        author = "Duvalon";
        technicalName = "moarmour";
        release = 11124;
        versionName = "MOAR! ARMOUR! version 0.4";
        sha256 = "1xdddl01h8i6ss57l78mg6fqgfi2n1mkhysnm86cjrapnh7pin4h";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Additional armours to build and wear";

      };
    };

    "Duvalon"."sfcraftguide" = buildMinetestPackage rec {
      type = "mod";
      pname = "sfcraftguide";
      version = "0.2.0";
      src = fetchFromContentDB {
        author = "Duvalon";
        technicalName = "sfcraftguide";
        release = 11941;
        versionName = "0.2.0";
        sha256 = "03szq80j1ww87nq31szm1971rlnxd6j8fspp5dq286jlr1qf0qsb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "An augmented mtg_craftguide. Supports a progressive reveal system that follows doc items help.";

      };
    };

    "DynamaxPikachu"."legendary_armor" = buildMinetestPackage rec {
      type = "mod";
      pname = "legendary_armor";
      version = "2.2.1";
      src = fetchFromContentDB {
        author = "DynamaxPikachu";
        technicalName = "legendary_armor";
        release = 7192;
        versionName = "2.2.1";
        sha256 = "0dp7rik5zs11qq28mff9g8z4z5f8vnb6rx04v4vbbpqyifmbjjbj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds legendary tools and armor";

      };
    };

    "DynamaxPikachu"."legendary_ore" = buildMinetestPackage rec {
      type = "mod";
      pname = "legendary_ore";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "DynamaxPikachu";
        technicalName = "legendary_ore";
        release = 7191;
        versionName = "1.2.1";
        sha256 = "1ndhbjm89gbl16nzam1vjjcrb2bizywzds7dfbppl5h5inhkvp0s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds legendary ore and blocks";

      };
    };

    "Echoes91"."spears" = buildMinetestPackage rec {
      type = "mod";
      pname = "spears";
      version = "Version_2.4";
      src = fetchFromContentDB {
        author = "Echoes91";
        technicalName = "spears";
        release = 14355;
        versionName = "Version 2.4";
        sha256 = "1b9nx3l3fs63qnzji7046wccvn34637k4hd3q3mw3i5ymbrljn35";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds spears, versatile weapons that can be thrown.";

      };
    };

    "ElCeejo"."adv_lightsabers" = buildMinetestPackage rec {
      type = "mod";
      pname = "adv_lightsabers";
      version = "Advanced_Lightsabers_1.1";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "adv_lightsabers";
        release = 3436;
        versionName = "Advanced Lightsabers 1.1";
        sha256 = "1cjndys4ldl460c4rvq55gixv5k50ddawa6k60s2wr9h6c602gcl";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Relatively Advanced Lightsabers for Minetest Game.";

      };
    };

    "ElCeejo"."animalia" = buildMinetestPackage rec {
      type = "mod";
      pname = "animalia";
      version = "0.5-b";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "animalia";
        release = 14446;
        versionName = "0.5-b";
        sha256 = "0zd8xp0i47kzvsk9y7ganq1544ccrq72fyzgcpdixkjg9zcf7z8z";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a range of real world Animals";

      };
    };

    "ElCeejo"."banshee" = buildMinetestPackage rec {
      type = "mod";
      pname = "banshee";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "banshee";
        release = 6890;
        versionName = "1.0.1";
        sha256 = "0w4x6amdf49s0n6kmljrz2bfqjw9ddvigp427xy4r2c5i0r4xl1m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds Banshees, a ghostly mob that haunts pine forests";

      };
    };

    "ElCeejo"."creatura" = buildMinetestPackage rec {
      type = "mod";
      pname = "creatura";
      version = "0.2.5";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "creatura";
        release = 14436;
        versionName = "0.2.5";
        sha256 = "1xlcas2dl7yr74md9fmhgf1c4xnd3g3pfsdqaj9jqfc3ccawxsjw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A performant, semi-modular, Animal focused mob API";

      };
    };

    "ElCeejo"."draconis" = buildMinetestPackage rec {
      type = "mod";
      pname = "draconis";
      version = "2.0.5";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "draconis";
        release = 14438;
        versionName = "2.0.5";
        sha256 = "0jw3apg707a3syylar7a5spl120jqpz25hmf2xkxks6p0c5nx7ka";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds terrifying Dragons and powerful equipment.";

      };
    };

    "ElCeejo"."grave" = buildMinetestPackage rec {
      type = "mod";
      pname = "grave";
      version = "0.2";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "grave";
        release = 5399;
        versionName = "0.2";
        sha256 = "1mm7py3kg8nvvcgnbgv3niygv071d1a8pgzhvmyc9h57838a8mjm";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds an eerie biome with multiple mobs.";

      };
    };

    "ElCeejo"."loot_crates" = buildMinetestPackage rec {
      type = "mod";
      pname = "loot_crates";
      version = "0.1";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "loot_crates";
        release = 8201;
        versionName = "0.1";
        sha256 = "0a9wsvm9r4sk06ybydc64v8c8fisadmvhb86jck8mjplmj7apw17";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds randomly spawning loot crates.";

      };
    };

    "ElCeejo"."mob_core" = buildMinetestPackage rec {
      type = "mod";
      pname = "mob_core";
      version = "alpha.patch.9b";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "mob_core";
        release = 8939;
        versionName = "alpha.patch.9b";
        sha256 = "07i0gqaniizd6ni6ylqr48s6rpkz042q35yl88d3xdbhv26kx6q0";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A Mob API meant to expand upon mobkit and bring easy to use features for creating new Mobs.";

      };
    };

    "ElCeejo"."paleotest" = buildMinetestPackage rec {
      type = "mod";
      pname = "paleotest";
      version = "2.1.2";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "paleotest";
        release = 6612;
        versionName = "2.1.2";
        sha256 = "0nhycnj4zn8nc2qa7714a4qs9wqs0bkpcjykqknp1i0150zall2i";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Prehistoric Fauna and Flora to Minetest Game";

      };
    };

    "ElCeejo"."spiradilus" = buildMinetestPackage rec {
      type = "mod";
      pname = "spiradilus";
      version = "0.1-beta";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "spiradilus";
        release = 12352;
        versionName = "0.1-beta";
        sha256 = "01kzqynigf7rq6a8glga3gr3h6kbhln5ggcyjbinc2nprcvk3r1x";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a ghostly Crocodilian mini-boss";

      };
    };

    "ElCeejo"."wisp" = buildMinetestPackage rec {
      type = "mod";
      pname = "wisp";
      version = "0.21";
      src = fetchFromContentDB {
        author = "ElCeejo";
        technicalName = "wisp";
        release = 8770;
        versionName = "0.21";
        sha256 = "0z3jwq4541z9658wvzrr1mmhjgkb4rkv4pzwldihbkgi02ry8jc5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds non-entity mobs called Wisps";

      };
    };

    "ElryTommasso"."8x8simpleworld" = buildMinetestPackage rec {
      type = "txp";
      pname = "8x8simpleworld";
      version = "8x8_Simple_World";
      src = fetchFromContentDB {
        author = "ElryTommasso";
        technicalName = "8x8simpleworld";
        release = 2163;
        versionName = "8x8 Simple World";
        sha256 = "1xxq0djiz9wc2y8mgbdasywbillk5z1x0lc8l015xg7bp1hbsdj2";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "A simple, beauty and 8x8 texture pack.";

      };
    };

    "Elvis26"."short_swords" = buildMinetestPackage rec {
      type = "txp";
      pname = "short_swords";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Elvis26";
        technicalName = "short_swords";
        release = 9387;
        versionName = "1.0.0";
        sha256 = "1q1hg0mnlj6k3s473hfwff5q38cadn5ci2cp324xx91sx6lxpfm6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "A texture pack that makes swords short.";

      };
    };

    "Emojiminetest"."3d_apple" = buildMinetestPackage rec {
      type = "mod";
      pname = "3d_apple";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "3d_apple";
        release = 13787;
        versionName = "init";
        sha256 = "1a16x29nm4zrscvghpsqk90a1cknanvm0ni4prc3rn2qydrrsgvq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Apple isn't flat!";

      };
    };

    "Emojiminetest"."afk_indicator" = buildMinetestPackage rec {
      type = "mod";
      pname = "afk_indicator";
      version = ".get_name_";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "afk_indicator";
        release = 13929;
        versionName = ".get(name)";
        sha256 = "0bim61ky9ihwpd4knvfijhqr1hf0pjr74awa43c3i51dw1nabv4p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "API to check player AFK status";

      };
    };

    "Emojiminetest"."afk_indicator_kick" = buildMinetestPackage rec {
      type = "mod";
      pname = "afk_indicator_kick";
      version = "afk_priv";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "afk_indicator_kick";
        release = 13930;
        versionName = "afk priv";
        sha256 = "1bxi7wgxvzphglyxzgxf63brpcr4w6xkn1y6j5cc1w2hqxs7xwg6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Kick inactive players";

      };
    };

    "Emojiminetest"."anti_lava_area" = buildMinetestPackage rec {
      type = "mod";
      pname = "anti_lava_area";
      version = "v1.0-stable-minor4";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "anti_lava_area";
        release = 4858;
        versionName = "v1.0-stable-minor4";
        sha256 = "1vqnxxika8if65z4zz5ngww383zp54pcv3aprnfjpjiyxp5jg42s";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "give admin power to anti lava in some region.";

      };
    };

    "Emojiminetest"."area_locked_chests" = buildMinetestPackage rec {
      type = "mod";
      pname = "area_locked_chests";
      version = "supported_games";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "area_locked_chests";
        release = 13219;
        versionName = "supported_games";
        sha256 = "0fjnr26vi1pcwk3qhp9ms0w17fx0kc36v1snjpp1ybzv8qm0dvnb";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Locked chest that check protections";

      };
    };

    "Emojiminetest"."ban_hacker" = buildMinetestPackage rec {
      type = "mod";
      pname = "ban_hacker";
      version = "2021-08-01";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "ban_hacker";
        release = 14457;
        versionName = "2021-08-01";
        sha256 = "0m5ja9h928b141qdf12ky0yqw8x7sh18npfhnhvfp4p1p178p9hh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Temporary ban players or IPs with 5 wrong password attempts";

      };
    };

    "Emojiminetest"."basket" = buildMinetestPackage rec {
      type = "mod";
      pname = "basket";
      version = "fix_the_friendly_mod.conf";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "basket";
        release = 13774;
        versionName = "fix the friendly mod.conf";
        sha256 = "0glh2d492sqlsidc0zmicii0bcbx48zlfqazn196s4dqn7zvfjhb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A portable basket for carrying large amount of items (= Shulker Boxes)";

      };
    };

    "Emojiminetest"."bouncy_leaves" = buildMinetestPackage rec {
      type = "mod";
      pname = "bouncy_leaves";
      version = "name_right";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "bouncy_leaves";
        release = 13579;
        versionName = "name right";
        sha256 = "02nl81ijissgjkjxab7avpy5fm9j4m30z5x428nivks80pazxaq6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds bouncy and fall damage reduce effect to leaves";

      };
    };

    "Emojiminetest"."chat_record" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_record";
      version = "v1.1-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "chat_record";
        release = 6723;
        versionName = "v1.1-stable";
        sha256 = "16cc2m9avd90bhx5dr54smd1bmi863ayzf6yvrqh7anpq2093x74";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Record chat messages in a file";

      };
    };

    "Emojiminetest"."copier" = buildMinetestPackage rec {
      type = "mod";
      pname = "copier";
      version = "v1.4-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "copier";
        release = 9661;
        versionName = "v1.4-stable";
        sha256 = "0mqn1dfspddyz7b9icnpwbgzyyw561ijrzzdfglv5slch480m1d1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A tool to copy and paste nodes from a file or from a tool";

          homepage = "https://mtccs.miraheze.org/wiki/Special:mylanguage/Copier";

      };
    };

    "Emojiminetest"."datacard" = buildMinetestPackage rec {
      type = "mod";
      pname = "datacard";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "datacard";
        release = 13786;
        versionName = "init";
        sha256 = "0y09z77pwmmdxcdrmljzhhw0f1hg7d2m7i09g9gy4j2xmnwl2j25";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Portable data storage for Digilines";

      };
    };

    "Emojiminetest"."gettime" = buildMinetestPackage rec {
      type = "mod";
      pname = "gettime";
      version = "v1.0-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "gettime";
        release = 4746;
        versionName = "v1.0-stable";
        sha256 = "1nmh2c82dbj4d7vfa1kada7vwvdd28mih8b5lwzghph6n00fmc8f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A api to get in-game hour/minute";

      };
    };

    "Emojiminetest"."infinity_color" = buildMinetestPackage rec {
      type = "mod";
      pname = "infinity_color";
      version = "v1.0-beta";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "infinity_color";
        release = 4857;
        versionName = "v1.0-beta";
        sha256 = "1sgyhksk47si6j156yvi7y2b2hbxq3fyw152150rakf18i3263f4";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Add color block that can change color freely";

      };
    };

    "Emojiminetest"."know_where_you_die" = buildMinetestPackage rec {
      type = "mod";
      pname = "know_where_you_die";
      version = "v0.1-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "know_where_you_die";
        release = 4765;
        versionName = "v0.1-stable";
        sha256 = "09rignnj68p0wshc134nzmi9bq8xp5kzpy76bvqap7xlj6h49i8a";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Send a message include death pos to you when you die";

      };
    };

    "Emojiminetest"."langton" = buildMinetestPackage rec {
      type = "game";
      pname = "langton";
      version = "20220803-1808";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "langton";
        release = 13037;
        versionName = "20220803-1808";
        sha256 = "014w39d9iappgaqwwbh9vchl2dhd9hg1szslijx6gycp2cmahw4m";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Langton's Ant!";

      };
    };

    "Emojiminetest"."make_sense" = buildMinetestPackage rec {
      type = "mod";
      pname = "make_sense";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "make_sense";
        release = 12949;
        versionName = "init";
        sha256 = "0vnj4s1g93d1jagf1z2vf2v70mni8fkxhhi578j2a6q9wqlvwq8c";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds missing crafting recipes that should exist";

      };
    };

    "Emojiminetest"."mcl_chest_for_mt_game" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_chest_for_mt_game";
      version = "v0.66.2.edit01.0-stable-minor1";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "mcl_chest_for_mt_game";
        release = 4828;
        versionName = "v0.66.2.edit01.0-stable-minor1";
        sha256 = "1bqdm7i39cllf7i1am4d8abb7zrvqbijffyp2dkvgvjgxxwms101";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Add useful chests (Linkable chest, Shulker box) to game";

      };
    };

    "Emojiminetest"."mesecon_node" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecon_node";
      version = "v1.0-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "mesecon_node";
        release = 4716;
        versionName = "v1.0-stable";
        sha256 = "1f7wigdbrz1jfi01afsd06s6w9d3qxkxlxkrp9j9vacd74n6l0gr";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Make all node have mesecon_wire version";

      };
    };

    "Emojiminetest"."more_mese_post_light" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_mese_post_light";
      version = "v3.0-stable-real";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "more_mese_post_light";
        release = 4930;
        versionName = "v3.0-stable-real";
        sha256 = "0z6j53dgg2515asqfhpsyvlisczdy29g34jfm455bj2w88hvzrqy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Add more mese post light";

      };
    };

    "Emojiminetest"."moretubes" = buildMinetestPackage rec {
      type = "mod";
      pname = "moretubes";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "moretubes";
        release = 13802;
        versionName = "init";
        sha256 = "1pra06kpsngmswqly3dwfdk0cwnzhq5gm76x0r31a66crf6984cz";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "More fun tubes for Pipeworks";

      };
    };

    "Emojiminetest"."newspaper" = buildMinetestPackage rec {
      type = "mod";
      pname = "newspaper";
      version = "v0.2-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "newspaper";
        release = 4717;
        versionName = "v0.2-stable";
        sha256 = "1lxknm7wkg01i6hmia7d4rdjlr89mpdk2w506lqcl3w1gvcg8043";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A Customizable newspaper";

      };
    };

    "Emojiminetest"."node_placer" = buildMinetestPackage rec {
      type = "mod";
      pname = "node_placer";
      version = "v1.0-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "node_placer";
        release = 8120;
        versionName = "v1.0-stable";
        sha256 = "0g0974z6g7wxw1cvzrxfdpfdqgi3m0cdl842asgv62awlzb5ch7m";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Let admin know who placed a node";

      };
    };

    "Emojiminetest"."parkour" = buildMinetestPackage rec {
      type = "game";
      pname = "parkour";
      version = "Restart_command_FAQ";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "parkour";
        release = 11037;
        versionName = "Restart command FAQ";
        sha256 = "1q3h9pafwj0d6zrbncq73ylplfpi2ijszvlsxqlayya3llxgqz8n";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Parkour game!";

      };
    };

    "Emojiminetest"."pathv7" = buildMinetestPackage rec {
      type = "mod";
      pname = "pathv7";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "pathv7";
        release = 8135;
        versionName = "init";
        sha256 = "1zff8rj4m5d8s42qgijmb9hljkg7l8k5p2l0x8jnphl7h0fzdvb5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Creates a worldwide network of paths, bridges and tunnels.";

      };
    };

    "Emojiminetest"."pencil_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "pencil_redo";
      version = "v2.1-stable-minor1";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "pencil_redo";
        release = 4839;
        versionName = "v2.1-stable-minor1";
        sha256 = "1sz3ijl3cp04kv1s51r8iibnr4677dwyj9m4zibfswnc4zk2pg2h";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds a pencil and a text edit table, to edit infotext";

      };
    };

    "Emojiminetest"."place_node" = buildMinetestPackage rec {
      type = "mod";
      pname = "place_node";
      version = "v0.2-beta";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "place_node";
        release = 4764;
        versionName = "v0.2-beta";
        sha256 = "0akpcn10g3drsdrcix3n4njdgnhlxpzrmghnmvcjc9z1qwwaiaky";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add `setblock` and `place` command";

      };
    };

    "Emojiminetest"."pos_marker" = buildMinetestPackage rec {
      type = "mod";
      pname = "pos_marker";
      version = "2021-09-12";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "pos_marker";
        release = 14464;
        versionName = "2021-09-12";
        sha256 = "0z2440cpq1hgyn0p887gxhjnsiah99jsf62ajjy5whni4hyrskb2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add markers that can set and get via chatcommand.";

      };
    };

    "Emojiminetest"."protect_block_area" = buildMinetestPackage rec {
      type = "mod";
      pname = "protect_block_area";
      version = "2022-08-01-0948";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "protect_block_area";
        release = 12978;
        versionName = "2022-08-01-0948";
        sha256 = "1bkf077zd6xplp5pxgv8v9k0blcax269n3b451x4z328a97df6m3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Protector Block, but using the Area Protect APIs";

      };
    };

    "Emojiminetest"."sausages" = buildMinetestPackage rec {
      type = "mod";
      pname = "sausages";
      version = "init";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "sausages";
        release = 13772;
        versionName = "init";
        sha256 = "0b0mc1jriv17waicj6qwj6q743gzfzyakrp07riqmxs4rbmdd4qf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Sausages! Yum!";

      };
    };

    "Emojiminetest"."smod_colored_chat" = buildMinetestPackage rec {
      type = "mod";
      pname = "smod_colored_chat";
      version = "v2.1-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "smod_colored_chat";
        release = 7781;
        versionName = "v2.1-stable";
        sha256 = "0263686i69ppyfq66d7hkka7kazh77cl4az1i5hmbbnikm83cla5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Color Your chat message";

      };
    };

    "Emojiminetest"."subcommands" = buildMinetestPackage rec {
      type = "mod";
      pname = "subcommands";
      version = "v1.3-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "subcommands";
        release = 7958;
        versionName = "v1.3-stable";
        sha256 = "18bm7yaq6r29zxwlzdv13ka3jbb6n53p64w1xq388h170agx5ngc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "API to make commands with subcommands";

      };
    };

    "Emojiminetest"."technic_cnc_improve" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_cnc_improve";
      version = "v1.0-stable-minor4";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "technic_cnc_improve";
        release = 5323;
        versionName = "v1.0-stable-minor4";
        sha256 = "0smsawz7n42a64s812i3rspivi7fx5w4266x5c9n7pkbnxpf2jx3";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Improve Technic CNCs";

      };
    };

    "Emojiminetest"."technic_grass_clean" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_grass_clean";
      version = "v0.1-stable-bugfix1";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "technic_grass_clean";
        release = 4825;
        versionName = "v0.1-stable-bugfix1";
        sha256 = "0i9xzy24pjijm8pvabaiz23c2wfkd3wivjfxhc3k80369acx6pjy";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A tool like chainsaw, but cut grass, not tree.";

      };
    };

    "Emojiminetest"."technic_hv_extend" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_hv_extend";
      version = "v1.0-stable-minor1";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "technic_hv_extend";
        release = 4840;
        versionName = "v1.0-stable-minor1";
        sha256 = "117j9cx2knbh32hccp7jjjkgqwpfwlwvlpga7riwp8sic103fx4v";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Extends technic HV to add basic machines";

      };
    };

    "Emojiminetest"."unknown_item" = buildMinetestPackage rec {
      type = "mod";
      pname = "unknown_item";
      version = "v1.0-stable";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "unknown_item";
        release = 4771;
        versionName = "v1.0-stable";
        sha256 = "0f4844zna6h13khjchl1fbkxdissfvcpfd083fc1q383j9805jia";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add a fake unknown item";

      };
    };

    "Emojiminetest"."unknown_object" = buildMinetestPackage rec {
      type = "mod";
      pname = "unknown_object";
      version = "v0.4-beta";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "unknown_object";
        release = 4799;
        versionName = "v0.4-beta";
        sha256 = "1fpz0ysf45cqh8qdnq3xqh0rk2ql7isd93iiqgfj59fxb40qhwxm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Bring spawnable unknown object to the game";

      };
    };

    "Emojiminetest"."usermgr" = buildMinetestPackage rec {
      type = "mod";
      pname = "usermgr";
      version = "missing_zhtw_string";
      src = fetchFromContentDB {
        author = "Emojiminetest";
        technicalName = "usermgr";
        release = 13932;
        versionName = "missing zhtw string";
        sha256 = "0cahsc6gh29g8fabbc1fc60bwiq8ngpj15hsnjad3fzi2dsm1yna";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "GUI to manage players";

      };
    };

    "EmptyStar"."aerial" = buildMinetestPackage rec {
      type = "mod";
      pname = "aerial";
      version = "v1.1.1";
      src = fetchFromContentDB {
        author = "EmptyStar";
        technicalName = "aerial";
        release = 13953;
        versionName = "v1.1.1";
        sha256 = "1pnacwvz37p8k3gvf2wr1szai488b27lab9i4vj4l8c6zw675g9g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds wings that allow players to fly and feather fall";

      };
    };

    "Epoxum"."uraniumstuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "uraniumstuff";
      version = "1.1.3";
      src = fetchFromContentDB {
        author = "Epoxum";
        technicalName = "uraniumstuff";
        release = 14477;
        versionName = "1.1.3";
        sha256 = "19ipa7hzsmah068f906cpk19xm170x2dvj16jlpha583hfz6ad35";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" spdx."Zlib" ];
        description = "Adds Uranium tools and armor, compatible with technic.";

      };
    };

    "Eran"."hot_air_balloons" = buildMinetestPackage rec {
      type = "mod";
      pname = "hot_air_balloons";
      version = "1.3";
      src = fetchFromContentDB {
        author = "Eran";
        technicalName = "hot_air_balloons";
        release = 1419;
        versionName = "1.3";
        sha256 = "1k7mc0pwqbgnc6jgy16qx05fsqcz1jvjck68zsg2n700gcn1va83";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds craftable and controllable hot air balloons.";

      };
    };

    "Eternal_plasma"."epf" = buildMinetestPackage rec {
      type = "mod";
      pname = "epf";
      version = "Pattern_Blocks_festive_Blocks";
      src = fetchFromContentDB {
        author = "Eternal_plasma";
        technicalName = "epf";
        release = 3982;
        versionName = "Pattern Blocks/festive Blocks";
        sha256 = "05fha0s7jy5bxic059aij8dyv1iyqyzh7q1pi4yfmvjmpcl354wc";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds New Bright Blocks";

      };
    };

    "Ethernia"."ethernal_dragonegglock" = buildMinetestPackage rec {
      type = "mod";
      pname = "ethernal_dragonegglock";
      version = "v1.0.0";
      src = fetchFromContentDB {
        author = "Ethernia";
        technicalName = "ethernal_dragonegglock";
        release = 12745;
        versionName = "v1.0.0";
        sha256 = "0xi0yyi845sfd6b111pywj5q4ckk0f8vz9y7k0i7f3p2jaz11r8m";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "You can Lock and unlock the Dragon Egg by placing it in your crafting grif. A Locked Dragon Egg will not teleport away/fall down and can be mined by hand.";

          homepage = "https://ethernia-root.github.io/ethernalmc";

      };
    };

    "Ethernia"."ethernal_nonuseless" = buildMinetestPackage rec {
      type = "mod";
      pname = "ethernal_nonuseless";
      version = "v0.1.0";
      src = fetchFromContentDB {
        author = "Ethernia";
        technicalName = "ethernal_nonuseless";
        release = 12747;
        versionName = "v0.1.0";
        sha256 = "1mw4ibi5pvvhas397hzxn6bs2iw15rash0hcl3vpy425z27hgv7f";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds more crafting Recipes to make useless Items useful";

          homepage = "https://ethernia-root.github.io/ethernalmc";

      };
    };

    "Evergreen"."death_messages" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_messages";
      version = "2016-01-15";
      src = fetchFromContentDB {
        author = "Evergreen";
        technicalName = "death_messages";
        release = 458;
        versionName = "2016-01-15";
        sha256 = "0pcklwyza71gxid9v8zn0qzf8chjxbbriycjdyjh140ix6qfchy3";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Sends a chat message when a player dies";

      };
    };

    "Evergreen"."quartz" = buildMinetestPackage rec {
      type = "mod";
      pname = "quartz";
      version = "2017-10-03";
      src = fetchFromContentDB {
        author = "Evergreen";
        technicalName = "quartz";
        release = 75;
        versionName = "2017-10-03";
        sha256 = "187pa0bq0qm00m472v252729y8fs792kjwymp61ihfwhhhpgkvsz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds quartz ore and some decorative quartz blocks";

      };
    };

    "Evergreen"."trash_can" = buildMinetestPackage rec {
      type = "mod";
      pname = "trash_can";
      version = "2022-08-14";
      src = fetchFromContentDB {
        author = "Evergreen";
        technicalName = "trash_can";
        release = 13247;
        versionName = "2022-08-14";
        sha256 = "00jrbpjvp3kyfvygxd6kil0kr47wq3fgbl892drrb7s19f8zag47";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a wooden trash can, and a dumpster to the game.";

      };
    };

    "Evil_Gabe"."electrica" = buildMinetestPackage rec {
      type = "mod";
      pname = "electrica";
      version = "2022-05-26";
      src = fetchFromContentDB {
        author = "Evil_Gabe";
        technicalName = "electrica";
        release = 14459;
        versionName = "2022-05-26";
        sha256 = "1z6mkp2zcjmv02zyh14v52bibkmcy7xiam9mgcv3h6diz26gmkij";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A mod that adds machines and tools also ores, items, etc";

      };
    };

    "ExeterDad"."christmastree" = buildMinetestPackage rec {
      type = "mod";
      pname = "christmastree";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "ExeterDad";
        technicalName = "christmastree";
        release = 8099;
        versionName = "1.0.2";
        sha256 = "0j38abyqgbq01aavb11yv9mm05l2xxisj054ify3z7ybcg9wjjnk";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds a decorated indoor Christmas tree with wrapped gifts.";

      };
    };

    "ExeterDad"."showbones" = buildMinetestPackage rec {
      type = "mod";
      pname = "showbones";
      version = "2016-09-20";
      src = fetchFromContentDB {
        author = "ExeterDad";
        technicalName = "showbones";
        release = 951;
        versionName = "2016-09-20";
        sha256 = "1wdrqss4abadw6kpidg3df5rbkc10h44zd2ryf6pprij5y69b42i";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Saves bones positions to a file";

      };
    };

    "Extex"."christmas" = buildMinetestPackage rec {
      type = "mod";
      pname = "christmas";
      version = "1.2";
      src = fetchFromContentDB {
        author = "Extex";
        technicalName = "christmas";
        release = 9448;
        versionName = "1.2";
        sha256 = "1yzhs0f1wzvkw9j6vjl6l6lkkpklxym0gzqsp45wnx0bbpsjxq33";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds festive christmas items and nodes";

      };
    };

    "Extex"."light_tool" = buildMinetestPackage rec {
      type = "mod";
      pname = "light_tool";
      version = "Light_tool_0.4.3";
      src = fetchFromContentDB {
        author = "Extex";
        technicalName = "light_tool";
        release = 9552;
        versionName = "Light tool 0.4.3";
        sha256 = "1prl1dbvx7lxkfb6gz4p2sd8a7hjlmygf3nfp74c22x00bf07nqz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a tool and api that creates beams of light";

      };
    };

    "Extex"."motorbike" = buildMinetestPackage rec {
      type = "mod";
      pname = "motorbike";
      version = "Motorbike_2.3.1";
      src = fetchFromContentDB {
        author = "Extex";
        technicalName = "motorbike";
        release = 9326;
        versionName = "Motorbike 2.3.1";
        sha256 = "1rc5y3san760d5ci53lhiaam1sm0vvqffp5zfmyahls4bhmv7z4q";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds various coloured motorbikes";

      };
    };

    "Extex"."plaster" = buildMinetestPackage rec {
      type = "mod";
      pname = "plaster";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Extex";
        technicalName = "plaster";
        release = 12351;
        versionName = "1.0";
        sha256 = "1gcmz1vq4lbpwpiqhihhh2vgwg81a2s8n327d8f19n7sca5c6mbc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds a variety of Plaster blocks for building.";

      };
    };

    "Extex"."real_names" = buildMinetestPackage rec {
      type = "mod";
      pname = "real_names";
      version = "Real_names_v1.0.3";
      src = fetchFromContentDB {
        author = "Extex";
        technicalName = "real_names";
        release = 2453;
        versionName = "Real names v1.0.3";
        sha256 = "1xjd3n1ww20zm8w9m6ddy5dgr1gk21jsz5anfacbr1y99p1p9cm8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Gives players realistic names when they join, great for role-playing servers!!";

      };
    };

    "FaceDeer"."airtanks" = buildMinetestPackage rec {
      type = "mod";
      pname = "airtanks";
      version = "v2.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "airtanks";
        release = 13920;
        versionName = "v2.0";
        sha256 = "1m35aw4wk1rdvyj8drb08fk8yvam68hlknzi7ajpqc977ala47s3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides pressurized air tanks for extended underwater excursions";

      };
    };

    "FaceDeer"."anvil" = buildMinetestPackage rec {
      type = "mod";
      pname = "anvil";
      version = "2022-06-20";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "anvil";
        release = 13166;
        versionName = "2022-06-20";
        sha256 = "1gvyxyf1d76qcs5b2ws021hj04j6f60s4jsxl0yc5f2agvlwc855";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Hammer and anvil for repairing tools";

      };
    };

    "FaceDeer"."breadcrumbs" = buildMinetestPackage rec {
      type = "mod";
      pname = "breadcrumbs";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "breadcrumbs";
        release = 13134;
        versionName = "2021-01-29";
        sha256 = "1wc9fs0ykdlmmzknaxfi7hhwbbs72rj1jv4b0wk1csmzbq5vp0l7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Path marker signs for use when exploring a twisty maze of passages that are all alike.";

      };
    };

    "FaceDeer"."bulletin_boards" = buildMinetestPackage rec {
      type = "mod";
      pname = "bulletin_boards";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "bulletin_boards";
        release = 13139;
        versionName = "2021-01-29";
        sha256 = "07y0npv4xx10bilsqgfscnw7ahm2gpxcw1qkcpiasjaslq1zb3l8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Allows creation of global bulletin boards where players can post public messages";

      };
    };

    "FaceDeer"."castle_farming" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_farming";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_farming";
        release = 13138;
        versionName = "2021-01-29";
        sha256 = "00x1bdvbdymyqjm9a4v3p73cxk1j7nn90d8zp1g5nq4pwqhch48f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Contains farming products useful for decorating a castle";

      };
    };

    "FaceDeer"."castle_gates" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_gates";
      version = "2021-03-15";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_gates";
        release = 13149;
        versionName = "2021-03-15";
        sha256 = "03zlm40h7yn0jjwfkci18h0vqr2ymnsc6yc43m00xh2grdvjb9ld";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This is a mod all about creating castle gates and dungeons";

      };
    };

    "FaceDeer"."castle_lighting" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_lighting";
      version = "1.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_lighting";
        release = 164;
        versionName = "1.0";
        sha256 = "0c39djkn1zczd1l9d249kh1jg3lw7ilwxxhcyrfi6s3qlfwmx3yv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This mod contains medieval castle lighting solutions";

      };
    };

    "FaceDeer"."castle_masonry" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_masonry";
      version = "2022-10-02";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_masonry";
        release = 14145;
        versionName = "2022-10-02";
        sha256 = "0f11qxzdwidss9vzl3wnh392fqnbrnd7cpq7mwfxmz6kiskb8hhp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This is a mod all about creating castles and castle dungeons.";

      };
    };

    "FaceDeer"."castle_shields" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_shields";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_shields";
        release = 2901;
        versionName = "v1.0";
        sha256 = "1ifzy9jgh1mn7f2d5wzx3mhr4f22ca1j5hrnim6zbj9fbn4zxwa9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds decorative wall shields";

      };
    };

    "FaceDeer"."castle_tapestries" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_tapestries";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_tapestries";
        release = 13146;
        versionName = "2021-01-29";
        sha256 = "03qw0wx7y7qc020l4bv9z2skfcfrwkpn8jcnjcc4qsw1vwa0php6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This is a mod for creating medieval tapestries, as found in castles";

      };
    };

    "FaceDeer"."castle_weapons" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle_weapons";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "castle_weapons";
        release = 13140;
        versionName = "2021-01-29";
        sha256 = "021kydmi600d99c98vlfd52rsrp1gvv27j8h3nr8r0iwcwh23l7v";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides several medieval weapons for use around castles";

      };
    };

    "FaceDeer"."commoditymarket" = buildMinetestPackage rec {
      type = "mod";
      pname = "commoditymarket";
      version = "2021-04-01";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "commoditymarket";
        release = 13150;
        versionName = "2021-04-01";
        sha256 = "0h6f6xiwcr1266kg5nkm5hcil27m0pxnnnf0fn2zjjd7i5798qp3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Provides API support for various in-world commodity markets";

      };
    };

    "FaceDeer"."commoditymarket_fantasy" = buildMinetestPackage rec {
      type = "mod";
      pname = "commoditymarket_fantasy";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "commoditymarket_fantasy";
        release = 13144;
        versionName = "2021-01-29";
        sha256 = "1d7bl6dysgn5k59c26p4443j26y3kirr1i6d3kkzcz7c0b4d6a95";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a number of fantasy-themed marketplaces using commoditymarket";

      };
    };

    "FaceDeer"."crafting_bench" = buildMinetestPackage rec {
      type = "mod";
      pname = "crafting_bench";
      version = "2021-08-22";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "crafting_bench";
        release = 13154;
        versionName = "2021-08-22";
        sha256 = "15mmincmmqxyn2l9k04p1dmvsa3crp9pqrkb9bbjsbk112fjmph5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "An auto-crafting bench";

      };
    };

    "FaceDeer"."death_compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_compass";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "death_compass";
        release = 13141;
        versionName = "2021-01-29";
        sha256 = "09sg933c80bs6rrh0w4gx1fy9kf12fns1r151ki7pj4k49f3xavb";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A compass that points to the last place you died";

      };
    };

    "FaceDeer"."dfcaverns" = buildMinetestPackage rec {
      type = "mod";
      pname = "dfcaverns";
      version = "v2.4.2";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "dfcaverns";
        release = 13917;
        versionName = "v2.4.2";
        sha256 = "0qyxsf0b3npdhd1gg8658cybh4cq7gsgj89jn91g36rd2767cksj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds vast underground caverns in the style of Dwarf Fortress, complete with underground flora in diverse biomes.";

      };
    };

    "FaceDeer"."digtron" = buildMinetestPackage rec {
      type = "mod";
      pname = "digtron";
      version = "2022-06-04";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "digtron";
        release = 12460;
        versionName = "2022-06-04";
        sha256 = "0xyl7g4rwknprcpzd0ap84w233c7cj4f3dzyp9vnw260m4nappki";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds components for building modular tunnel boring machines";

      };
    };

    "FaceDeer"."dynamic_liquid" = buildMinetestPackage rec {
      type = "mod";
      pname = "dynamic_liquid";
      version = "v2.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "dynamic_liquid";
        release = 13918;
        versionName = "v2.0";
        sha256 = "003ykwpzqlj1rzyd4s2qbxwk7sk5rpzg3gqisw5nal3zgy0hyajx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Flowing dynamic liquids and ocean-maintenance springs.";

      };
    };

    "FaceDeer"."footprints" = buildMinetestPackage rec {
      type = "mod";
      pname = "footprints";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "footprints";
        release = 5440;
        versionName = "v1.0.1";
        sha256 = "181dkyfa35nm1xvyav6sswlp3ac0w8p25kkyr17cs8fzi2m19d2n";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Players walking over various types of terrain will leave footprints, and optionally pack the soil down into trails";

      };
    };

    "FaceDeer"."hopper" = buildMinetestPackage rec {
      type = "mod";
      pname = "hopper";
      version = "v1.7.2";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "hopper";
        release = 12882;
        versionName = "v1.7.2";
        sha256 = "120rs4lr71ld8qvch4fs07wkcjazcp99729l9rnap0jd7j8g1kdp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds hoppers to transport items between chests/furnace etc.";

      };
    };

    "FaceDeer"."magma_conduits" = buildMinetestPackage rec {
      type = "mod";
      pname = "magma_conduits";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "magma_conduits";
        release = 7231;
        versionName = "v1.0.1";
        sha256 = "0ly8rp8fhiq0qn9nx5ckvwln8zwf150j7hiciwp9zaippms2vhjq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Removes default mapgen lava and adds widely-spaced vertical lava \"veins\".";

      };
    };

    "FaceDeer"."name_generator" = buildMinetestPackage rec {
      type = "mod";
      pname = "name_generator";
      version = "v1.2.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "name_generator";
        release = 5566;
        versionName = "v1.2.0";
        sha256 = "1q92ypk07nkm0gfw2p9sdnvhlqajw014bwnykpbz5qmabpk2f1sg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A lua library for generating random names based off of rulesets and syllable lists.";

      };
    };

    "FaceDeer"."named_waypoints" = buildMinetestPackage rec {
      type = "mod";
      pname = "named_waypoints";
      version = "v1.1.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "named_waypoints";
        release = 5601;
        versionName = "v1.1.1";
        sha256 = "0gxnnnjs7madx9mk204b393kdwnsn9vdn3a9msbw7164d2j3zhry";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A library for managing waypoints shown in player HUDs that can be discovered by exploration.";

      };
    };

    "FaceDeer"."orbs_of_time" = buildMinetestPackage rec {
      type = "mod";
      pname = "orbs_of_time";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "orbs_of_time";
        release = 13135;
        versionName = "2021-01-29";
        sha256 = "0imxnqg6bvfiqlznwa67z5vx8icmfc330djvyz57swxpbpvz2x42";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod containing magical orbs a player can use a limited number of times to change the time of day";

      };
    };

    "FaceDeer"."personal_log" = buildMinetestPackage rec {
      type = "mod";
      pname = "personal_log";
      version = "2021-04-06";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "personal_log";
        release = 13151;
        versionName = "2021-04-06";
        sha256 = "15malgw6chb9n8v2bbsgrkfyc0jzy5siiq3d4fkgqypdi27fxrqw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A personal log where players can track events and places";

      };
    };

    "FaceDeer"."pontoons" = buildMinetestPackage rec {
      type = "mod";
      pname = "pontoons";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "pontoons";
        release = 13145;
        versionName = "2021-01-29";
        sha256 = "1qmafvilimadlqd601yg4fdm48879g0v186fkkkj1yg7mcb2yyi0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A \"floating\" block that can be placed at the surface of a body of water without needing to build pilings first.";

      };
    };

    "FaceDeer"."radiant_damage" = buildMinetestPackage rec {
      type = "mod";
      pname = "radiant_damage";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "radiant_damage";
        release = 2911;
        versionName = "v1.0";
        sha256 = "09aigdks4a6z1raa0aw4x3ykixkvm29c3w4ld7pshh9k8xflfx9w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod that allows nodes to damage players at a distance";

      };
    };

    "FaceDeer"."ropes" = buildMinetestPackage rec {
      type = "mod";
      pname = "ropes";
      version = "2021-12-19";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "ropes";
        release = 13159;
        versionName = "2021-12-19";
        sha256 = "181vlihq18ma7i4iniwg1z38a22w3x74069zagq6055knayfz1jq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds rope boxes of various lengths and also rope ladders.";

      };
    };

    "FaceDeer"."sounding_line" = buildMinetestPackage rec {
      type = "mod";
      pname = "sounding_line";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "sounding_line";
        release = 7235;
        versionName = "v1.0.1";
        sha256 = "00srny1jfdrqfyw3jgw3ayzdr6lanzk75limxiqyqvvc56s0pyvf";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A tool for determining the depth of water or the depth of a hole.";

      };
    };

    "FaceDeer"."subterrane" = buildMinetestPackage rec {
      type = "mod";
      pname = "subterrane";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "subterrane";
        release = 7236;
        versionName = "v1.0.1";
        sha256 = "09735nsw4kkb0a51bvkinrx1yv9k5p8r85nqaldcdiyvvf5nh7da";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod that creates vast underground caverns and allows biomes to be defined for them";

      };
    };

    "FaceDeer"."torch_bomb" = buildMinetestPackage rec {
      type = "mod";
      pname = "torch_bomb";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "FaceDeer";
        technicalName = "torch_bomb";
        release = 5968;
        versionName = "v1.0.1";
        sha256 = "0lmj9c1giy3vxjkrsgy4alxkh7fax7p35bpjqwa8ns0x3fklzaw4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Place torches throughout your entire surroundings with a torch bomb";

      };
    };

    "FiftySix"."sponge" = buildMinetestPackage rec {
      type = "mod";
      pname = "sponge";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "FiftySix";
        technicalName = "sponge";
        release = 12936;
        versionName = "1.0.1";
        sha256 = "0kvgc84qcmfqpsv8b2rfj9fv988qzwxgxnxgkrnq55c1ldvbm44i";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Water-removing sponges.";

      };
    };

    "Firefall"."multiplant" = buildMinetestPackage rec {
      type = "mod";
      pname = "multiplant";
      version = "2022-10-09";
      src = fetchFromContentDB {
        author = "Firefall";
        technicalName = "multiplant";
        release = 14260;
        versionName = "2022-10-09";
        sha256 = "09b2dd8ibfdigiil74fpyaapml9vw483j6kdjf19s8pyxsan7ac1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Grow Multiplants and get a random seed or flower!";

      };
    };

    "Fleckenstein"."mcl_wither_spawning" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_wither_spawning";
      version = "v1";
      src = fetchFromContentDB {
        author = "Fleckenstein";
        technicalName = "mcl_wither_spawning";
        release = 4099;
        versionName = "v1";
        sha256 = "0g7znwj0jxj6l2di9ywr9117lcjhw8f3gqdb39yzs4fhq80dqxlk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Spawn a wither in MineClone2";

      };
    };

    "Fleckenstein"."playerlist" = buildMinetestPackage rec {
      type = "mod";
      pname = "playerlist";
      version = "2021-10-13";
      src = fetchFromContentDB {
        author = "Fleckenstein";
        technicalName = "playerlist";
        release = 9487;
        versionName = "2021-10-13";
        sha256 = "04rib75cdl22lqzsz8qkliw74wg07dvkxq2hbd829bi1m6ncdhv6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Show a list of all online players (similar to minecrafts tab-list) when a player is sneaking.";

      };
    };

    "Fluffgar"."fluffgardian" = buildMinetestPackage rec {
      type = "txp";
      pname = "fluffgardian";
      version = "001_-_Petallic_edition";
      src = fetchFromContentDB {
        author = "Fluffgar";
        technicalName = "fluffgardian";
        release = 441;
        versionName = "001 - Petallic edition";
        sha256 = "0v9ki4hwibsc353m199qz9rj7rfivvcd43bl082vhlmyqr6i04sg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-NC-SA-3.0" ];
        description = "HD 256x256 vector-style textures. ";

          homepage = "http://j.gs/Au02";

      };
    };

    "ForbiddenJ"."craft_lookup" = buildMinetestPackage rec {
      type = "mod";
      pname = "craft_lookup";
      version = "2019-05-02";
      src = fetchFromContentDB {
        author = "ForbiddenJ";
        technicalName = "craft_lookup";
        release = 1394;
        versionName = "2019-05-02";
        sha256 = "0qkndhjilcki070qwskhd4630vygz5k2fcs20ajh5qy2g0jwp0yq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Provides you with a way to lookup recipes to make items.";

      };
    };

    "ForbiddenJ"."meseport" = buildMinetestPackage rec {
      type = "mod";
      pname = "meseport";
      version = "2020-12-11";
      src = fetchFromContentDB {
        author = "ForbiddenJ";
        technicalName = "meseport";
        release = 5688;
        versionName = "2020-12-11";
        sha256 = "07dfwjyba1if52k1nrvh4f363435ja5hdancqgcrgvy21ksw30rv";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Allows for the creation of Meseportation systems.";

      };
    };

    "FreeBSD"."music" = buildMinetestPackage rec {
      type = "mod";
      pname = "music";
      version = "2022-8-26";
      src = fetchFromContentDB {
        author = "FreeBSD";
        technicalName = "music";
        release = 13568;
        versionName = "2022-8-26";
        sha256 = "028i6izlbpn01lrk9ligg20y99vk6i9qw0c92fdzyv5sinjmairi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A background music mod";

      };
    };

    "FreeBSD"."public_inventory" = buildMinetestPackage rec {
      type = "mod";
      pname = "public_inventory";
      version = "Public_Inventory_Revisited";
      src = fetchFromContentDB {
        author = "FreeBSD";
        technicalName = "public_inventory";
        release = 13051;
        versionName = "Public Inventory Revisited";
        sha256 = "17l5qz53qcfnqhndn9pbqwvadzj0hjndhg6qwq0xhr7b19hn9wr2";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Adds a public inventory.";

          homepage = "https://rvlt.gg/discover/search?query=minetest";

      };
    };

    "FreeLikeGNU"."goblins" = buildMinetestPackage rec {
      type = "mod";
      pname = "goblins";
      version = "replace_deprecated_setyaw__";
      src = fetchFromContentDB {
        author = "FreeLikeGNU";
        technicalName = "goblins";
        release = 13461;
        versionName = "replace deprecated setyaw()";
        sha256 = "1b029zivhln7fm8070vs07m1ic0mgl6kz0pvxp9ykfz8vp6pbhmh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "(Respectfully) Destructive! Goblin NPCs burrow underground, build lairs, set traps and cultivate foodstuffs. They like to steal torches! This is a Work In Progress, but quite playable!";

      };
    };

    "FreeLikeGNU"."witches" = buildMinetestPackage rec {
      type = "mod";
      pname = "witches";
      version = "2022-10-16_More_customizing_";
      src = fetchFromContentDB {
        author = "FreeLikeGNU";
        technicalName = "witches";
        release = 14420;
        versionName = "2022-10-16 More customizing!";
        sha256 = "1s4lx64aw2dgz4amxjyv7l7szlfp34y86hrb4x526gh7qmy3yi7i";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Helpful and unique witches inhabit the land adding a magical touch and interact with player! Work in progress, but playable!";

      };
    };

    "Furious_mat"."mcl_apocalypse" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_apocalypse";
      version = "mcl_apocalypse";
      src = fetchFromContentDB {
        author = "Furious_mat";
        technicalName = "mcl_apocalypse";
        release = 9441;
        versionName = "mcl_apocalypse";
        sha256 = "102aahqi98xk210708mdh44dbjb6k1mqk5bj7aimf94vd85x15hg";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "challenge mod for Mineclone";

      };
    };

    "Furious_mat"."mcl_dream" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_dream";
      version = "Dream_World";
      src = fetchFromContentDB {
        author = "Furious_mat";
        technicalName = "mcl_dream";
        release = 12932;
        versionName = "Dream World";
        sha256 = "1jxsh9lcbggzhdi4lhpbprrlm6hxiqr613i4m3iwm30smjg5y3i7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" spdx."Unlicense" ];
        description = "add Dream World in mineclone";

      };
    };

    "GamingAssociation39"."8x_tp" = buildMinetestPackage rec {
      type = "txp";
      pname = "8x_tp";
      version = "0.2_Update";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "8x_tp";
        release = 5664;
        versionName = "0.2 Update";
        sha256 = "1hyac1c769a7vhifrxlqii6c43b5aq27wv5zgnhbl5syca2i288a";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This is a 8x8 texture pack for MT.";

      };
    };

    "GamingAssociation39"."edible_swords" = buildMinetestPackage rec {
      type = "mod";
      pname = "edible_swords";
      version = "Added_Crafting.lua";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "edible_swords";
        release = 3409;
        versionName = "Added Crafting.lua";
        sha256 = "14qpy9d6d3lqciahk7chs1si2mw1xasx6c6s450lli811np5ccnd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Edible Swords ";

      };
    };

    "GamingAssociation39"."laptop" = buildMinetestPackage rec {
      type = "mod";
      pname = "laptop";
      version = "Added_a_painting_app";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "laptop";
        release = 12776;
        versionName = "Added a painting app";
        sha256 = "1kj76nfi9j9nscd7dyk7j1lsjli1xw331hmk3s174527wqyr9485";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Adds laptops/computers to your MT world. ";

      };
    };

    "GamingAssociation39"."laptop_pc1" = buildMinetestPackage rec {
      type = "mod";
      pname = "laptop_pc1";
      version = "Laptop_Mod";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "laptop_pc1";
        release = 962;
        versionName = "Laptop Mod";
        sha256 = "0llpk7wy5f1a68j3wqcpd85sadd3n9cnvf23dldayylzbh6pz472";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "This is an addition to the laptop mod.";

      };
    };

    "GamingAssociation39"."ma_pops_furniture" = buildMinetestPackage rec {
      type = "mod";
      pname = "ma_pops_furniture";
      version = "Recipe_Ultimate_Update";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "ma_pops_furniture";
        release = 2792;
        versionName = "Recipe Ultimate Update";
        sha256 = "1g5x6gl5l05kd8d6bwgbz4b3y2bhiap2c0aa669d9zm1fyhw4cwj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "This mod adds in functional furniture.";

      };
    };

    "GamingAssociation39"."mt_expansion" = buildMinetestPackage rec {
      type = "mod";
      pname = "mt_expansion";
      version = "Adds_License";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "mt_expansion";
        release = 5831;
        versionName = "Adds License";
        sha256 = "0kdindjyp3vbi3m8c8m14cn5gl5s0hy304pjg8x34gd25f292xzf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."LGPL-3.0-only" ];
        description = "An expansion for MTG";

      };
    };

    "GamingAssociation39"."mtuotp" = buildMinetestPackage rec {
      type = "txp";
      pname = "mtuotp";
      version = "MTUOTP";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "mtuotp";
        release = 963;
        versionName = "MTUOTP";
        sha256 = "1xp4nxxckf0igryrsgbcvq4i1d16p56yqy42dijziajghx5dspgy";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC-BY-SA-4.0" ];
        description = "A new fresh texture pack to replace the old one.";

      };
    };

    "GamingAssociation39"."xblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "xblocks";
      version = "Initial_Release";
      src = fetchFromContentDB {
        author = "GamingAssociation39";
        technicalName = "xblocks";
        release = 1212;
        versionName = "Initial Release";
        sha256 = "058i91zwkbkfcxy31qwmbivxdp8hjwm3953fzf6ypvf520wbkgcp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Additional blocks for decoration/building";

      };
    };

    "GenesisMT"."atium" = buildMinetestPackage rec {
      type = "mod";
      pname = "atium";
      version = "Atium";
      src = fetchFromContentDB {
        author = "GenesisMT";
        technicalName = "atium";
        release = 7606;
        versionName = "Atium";
        sha256 = "19z9d9mpw7hs781fknkqyb0r7izzfy6knd9wiybfj53sdjbnlg2y";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A strange a ore with tools.";

      };
    };

    "GenesisMT"."mask" = buildMinetestPackage rec {
      type = "mod";
      pname = "mask";
      version = "Mask";
      src = fetchFromContentDB {
        author = "GenesisMT";
        technicalName = "mask";
        release = 7399;
        versionName = "Mask";
        sha256 = "0x5hc1904p8mfqgf7f39c43gz8fxwwnp4f76bmni3v7v4f7j8kxy";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A simple mask you can wear.";

      };
    };

    "GenesisMT"."realm_lamp" = buildMinetestPackage rec {
      type = "mod";
      pname = "realm_lamp";
      version = "Realm_Lamp";
      src = fetchFromContentDB {
        author = "GenesisMT";
        technicalName = "realm_lamp";
        release = 7413;
        versionName = "Realm Lamp";
        sha256 = "0vxqb98q6va2fay6frhikns7dpsxw6rzhllqxxqan7jdlvgqn204";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A rainbow gradient block for decoration and with differents speeds.";

      };
    };

    "GethN7"."easycraft" = buildMinetestPackage rec {
      type = "mod";
      pname = "easycraft";
      version = "Easycraft_1.3";
      src = fetchFromContentDB {
        author = "GethN7";
        technicalName = "easycraft";
        release = 11198;
        versionName = "Easycraft 1.3";
        sha256 = "1c17w9516dzy5v3q27b1viy9smp1s9vwq4n79kpj4mxxayvilip6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides several easy recipes to make many craftable items. Fork of Easy Wool by Tim7";

      };
    };

    "GiulioLuizValcanaia"."mathblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "mathblocks";
      version = "v0.1";
      src = fetchFromContentDB {
        author = "GiulioLuizValcanaia";
        technicalName = "mathblocks";
        release = 12364;
        versionName = "v0.1";
        sha256 = "146w3gy20x2czbcj7a29pwp247mdksy6j98sv8h85yjb0scn0arz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds decorative math blocks to help in teaching";

      };
    };

    "GloopMaster"."glooptest" = buildMinetestPackage rec {
      type = "mod";
      pname = "glooptest";
      version = "2015-12-07";
      src = fetchFromContentDB {
        author = "GloopMaster";
        technicalName = "glooptest";
        release = 65;
        versionName = "2015-12-07";
        sha256 = "1zwxsi5hrdpnycz8d60y2gn3vv092z2vw6rf7h0fkgri9a9b5rav";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds a collection of things into minetest. As it stands, this adds three different modules.";

      };
    };

    "Glunggi"."columnia" = buildMinetestPackage rec {
      type = "mod";
      pname = "columnia";
      version = "2018-12-03";
      src = fetchFromContentDB {
        author = "Glunggi";
        technicalName = "columnia";
        release = 805;
        versionName = "2018-12-03";
        sha256 = "0xs7yds10dx4d5bjhzgn5j7zgxaivqmsi7gkk96qc9ny6yr458d8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds simple pillars and columns";

      };
    };

    "GoodClover"."cavegame" = buildMinetestPackage rec {
      type = "game";
      pname = "cavegame";
      version = "2022-09-29T20";
      src = fetchFromContentDB {
        author = "GoodClover";
        technicalName = "cavegame";
        release = 14112;
        versionName = "2022-09-29T20";
        sha256 = "109s39r8c9k9q7072nhlngrisy1zv5jf2ij9lf3srzld0w1p6l2r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."ISC" ];
        description = "Recreation of Notch's Cave Game.";

      };
    };

    "GoodClover"."texttext" = buildMinetestPackage rec {
      type = "mod";
      pname = "texttext";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "GoodClover";
        technicalName = "texttext";
        release = 12288;
        versionName = "1.2.1";
        sha256 = "0f7837kvd67k2yajzpw80jsvm5fxagqv4mg13qwwspsxqmza7rn3";
      };
      meta = src.meta // {
        license = [ spdx."ISC" ];
        description = "Replace textures of nodes with their names.";

      };
    };

    "Goops"."goops_exchange" = buildMinetestPackage rec {
      type = "mod";
      pname = "goops_exchange";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Goops";
        technicalName = "goops_exchange";
        release = 12805;
        versionName = "1.1";
        sha256 = "0ir27bqi63sn0gii4pn22d47m8p8zknvyl715xhznxyfhlzqhjs8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Inject currency into a server economy";

      };
    };

    "Goops"."goops_rings" = buildMinetestPackage rec {
      type = "mod";
      pname = "goops_rings";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "Goops";
        technicalName = "goops_rings";
        release = 12806;
        versionName = "1.2.1";
        sha256 = "1haqbvdbs5yl24h99k40163p26dd6bmlq92rsqlgz7lwa8cw4zbb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Add rings with temporary player effects";

      };
    };

    "Goops"."goops_scraps" = buildMinetestPackage rec {
      type = "mod";
      pname = "goops_scraps";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Goops";
        technicalName = "goops_scraps";
        release = 11614;
        versionName = "1.0";
        sha256 = "0zhqzgnacl8y0kykfhpam9spcynkvj4kr6phvgx8qmjljs2dbmlm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Allows to recycle metal tools";

      };
    };

    "GreenXenith"."christmas_decor" = buildMinetestPackage rec {
      type = "mod";
      pname = "christmas_decor";
      version = "2022-07-25";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "christmas_decor";
        release = 12915;
        versionName = "2022-07-25";
        sha256 = "1y8ya2l4nacrdmg7cjyi60vsirh9jrqixb8g1il2j0kp7b0fc37f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Christmas-themed decor";

      };
    };

    "GreenXenith"."greek" = buildMinetestPackage rec {
      type = "mod";
      pname = "greek";
      version = "2022-07-25";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "greek";
        release = 12917;
        versionName = "2022-07-25";
        sha256 = "1bllyvn3hjgxa3kylbyq9na1rf78g7n1lmmk2kjnwhiln8qw5wcv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A large assortment of Greek architecture blocks and materials.";

      };
    };

    "GreenXenith"."halloween" = buildMinetestPackage rec {
      type = "mod";
      pname = "halloween";
      version = "2018-10-05";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "halloween";
        release = 850;
        versionName = "2018-10-05";
        sha256 = "1r3r5g30rh6y73d7pi2vnfjfnz13c290y4gsk4a663mb95mpjin8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds Halloween candy and costumes.";

      };
    };

    "GreenXenith"."hexagonal" = buildMinetestPackage rec {
      type = "mod";
      pname = "hexagonal";
      version = "2019-03-21";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "hexagonal";
        release = 1213;
        versionName = "2019-03-21";
        sha256 = "0k6k13r64kfiy31pmxk40z9zixv0fj4q745gl3ql4ihcf86mv4xx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Proof of concept for hexagonal nodes";

      };
    };

    "GreenXenith"."mesecons_wireless" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_wireless";
      version = "2019-03-20";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "mesecons_wireless";
        release = 9141;
        versionName = "2019-03-20";
        sha256 = "0108ja5yn7gmv9ylli63f93l0513yhclbh4nrfkp52ql8cjwffnh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = " Wireless Mesecons and Digilines ";

      };
    };

    "GreenXenith"."mobile_crosshair" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobile_crosshair";
      version = "aa652c4";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "mobile_crosshair";
        release = 13110;
        versionName = "aa652c4";
        sha256 = "04ag53q32gg6hiy16k3kwqzm1pwzbvdw3dz4cfcrq748ikmcpwpx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "It's a crosshair for mobile.";

      };
    };

    "GreenXenith"."ncbells" = buildMinetestPackage rec {
      type = "mod";
      pname = "ncbells";
      version = "2021-08-20";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "ncbells";
        release = 9034;
        versionName = "2021-08-20";
        sha256 = "1wag3s5kg45absiqgk65vq45mn1l6yv5w6yyw29dzy6l058fabvc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Glass bells for NodeCore";

      };
    };

    "GreenXenith"."ncshark" = buildMinetestPackage rec {
      type = "mod";
      pname = "ncshark";
      version = "2020-09-18";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "ncshark";
        release = 5196;
        versionName = "2020-09-18";
        sha256 = "0m6gk5v0m71bcng3dfv23svxy4wca4sp46y0dapvlf10yfr3i165";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Hammerhead \"sharks\" for NodeCore";

      };
    };

    "GreenXenith"."proxchat" = buildMinetestPackage rec {
      type = "mod";
      pname = "proxchat";
      version = "2021-05-14";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "proxchat";
        release = 7751;
        versionName = "2021-05-14";
        sha256 = "0pvx40jadsx0alwiq1iwcplkjwf76q3imljil6w0wsry9q2gdqzd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Only hear chat from nearby players.";

      };
    };

    "GreenXenith"."pumpkinspice" = buildMinetestPackage rec {
      type = "mod";
      pname = "pumpkinspice";
      version = "2017-10-03";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "pumpkinspice";
        release = 46;
        versionName = "2017-10-03";
        sha256 = "1gpjk01pwp894nhpijfpqqpqxxra76hfgaw3p2yxbsw6n1cxpqjw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds pumpkinspice stuff.";

      };
    };

    "GreenXenith"."skinmaker" = buildMinetestPackage rec {
      type = "mod";
      pname = "skinmaker";
      version = "2021-02-05";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "skinmaker";
        release = 6435;
        versionName = "2021-02-05";
        sha256 = "03hikk14kmlj3xhmrhqc1hq853i5z4jw9x6qhv7jq4knixzcbx4w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "In-game live player skin editor.";

      };
    };

    "GreenXenith"."snowcone" = buildMinetestPackage rec {
      type = "mod";
      pname = "snowcone";
      version = "2019-07-20";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "snowcone";
        release = 1683;
        versionName = "2019-07-20";
        sha256 = "18n4ldlsd817mkcgmkp4fhgmrkxadjzxjppv8lcg5p03yjl22grc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Some simple flavored snow cones.";

      };
    };

    "GreenXenith"."tac_nayn" = buildMinetestPackage rec {
      type = "mod";
      pname = "tac_nayn";
      version = "2018-01-27";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "tac_nayn";
        release = 39;
        versionName = "2018-01-27";
        sha256 = "1qplvg199762dafl72j1hcp0n6k27md2i0jgjy29lwm67na1sl1g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds Nyan Cat's evil twin, Tac Nayn (and a gray-scale rainbow).";

      };
    };

    "GreenXenith"."waffles" = buildMinetestPackage rec {
      type = "mod";
      pname = "waffles";
      version = "2021-08-30";
      src = fetchFromContentDB {
        author = "GreenXenith";
        technicalName = "waffles";
        release = 9189;
        versionName = "2021-08-30";
        sha256 = "02rr2xhdqqsnx484w587sgzhkbssrb5p6fh5k8cfzh9g8ckwnbz0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Waffles. That's it.";

      };
    };

    "GunshipPenguin"."afkkick" = buildMinetestPackage rec {
      type = "mod";
      pname = "afkkick";
      version = "2018-06-20";
      src = fetchFromContentDB {
        author = "GunshipPenguin";
        technicalName = "afkkick";
        release = 455;
        versionName = "2018-06-20";
        sha256 = "1szj0lka1py0mfv8xng1h2gc68iqhfjcjib08fkfx20b7kdav4v0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Kick players who do not move for a while";

      };
    };

    "Hamlet"."fallen_nodes" = buildMinetestPackage rec {
      type = "mod";
      pname = "fallen_nodes";
      version = "v1.5.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "fallen_nodes";
        release = 2548;
        versionName = "v1.5.0";
        sha256 = "12j8s1syigjd4kpgn7lzy4r1j5dwpiy7li6n49dxdbv7pa2j2dj4";
      };
      meta = src.meta // {
        license = [ spdx."EUPL-1.2" ];
        description = "Adds dirt, cobble, snow, straw and cactus nodes to the falling_node group. Papyrus will fall too.";

      };
    };

    "Hamlet"."fallen_trees" = buildMinetestPackage rec {
      type = "mod";
      pname = "fallen_trees";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "fallen_trees";
        release = 330;
        versionName = "2018-07-08";
        sha256 = "1f32s46h3qpfnbnyx96iwb7qgp6s7f9axjdly5wbaim7k72rmvgl";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Helps preventing the \"floating treetops effect\".";

      };
    };

    "Hamlet"."hard_trees_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "hard_trees_redo";
      version = "v0.2.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "hard_trees_redo";
        release = 6408;
        versionName = "v0.2.0";
        sha256 = "1z1w6mi76ws2a0x4m86maqansrs19dqqf41p3gcamk85w8ci6ls5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Prevents digging trees by punching them.";

      };
    };

    "Hamlet"."hidden_doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "hidden_doors";
      version = "v1.12.1";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "hidden_doors";
        release = 3536;
        versionName = "v1.12.1";
        sha256 = "0bd2ph946y0nfig94090q4msky9ldapw709gyvb9b66c5dg8x7wh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds various wood, stone, etc.";

      };
    };

    "Hamlet"."mobs_balrog" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_balrog";
      version = "v0.4.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_balrog";
        release = 2198;
        versionName = "v0.4.0";
        sha256 = "0pf2jvrzqym61945y6a6lavbwsyawnqbhs8gz6yw5wvhr4dmmzyz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds balrogs.";

      };
    };

    "Hamlet"."mobs_banshee" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_banshee";
      version = "v0.3.4";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_banshee";
        release = 4653;
        versionName = "v0.3.4";
        sha256 = "01535gc2az8l5cxd101b00daz09bm46wajglyn2xawdiywsmd2m4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Adds banshees.";

      };
    };

    "Hamlet"."mobs_dwarves" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_dwarves";
      version = "v0.2.1";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_dwarves";
        release = 6407;
        versionName = "v0.2.1";
        sha256 = "1x5n037iw144i7p9c0s78ms724cncmrq42gis67knf3wi8k7jyax";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Adds dwarves.";

      };
    };

    "Hamlet"."mobs_gazer" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_gazer";
      version = "v0.1.3";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_gazer";
        release = 4742;
        versionName = "v0.1.3";
        sha256 = "0jw60xd0w1177xp7rg2vhaawh51x4s93m9yskxnbl1nl6kxpmyg1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds a gazing monster.";

      };
    };

    "Hamlet"."mobs_ghost_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_ghost_redo";
      version = "v0.7.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_ghost_redo";
        release = 2275;
        versionName = "v0.7.0";
        sha256 = "1a2m3g77w4i796nl625rc4sn2vjxj438k9iyyi7wd03pjvgl4i35";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Adds ghosts.";

      };
    };

    "Hamlet"."mobs_humans" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_humans";
      version = "v0.3.0-2";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_humans";
        release = 14385;
        versionName = "v0.3.0-2";
        sha256 = "1hl3xj60ib52gbzc3bc31d7ircxyswc7hf79zkbvz132rmhzi7ya";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Adds humans.";

      };
    };

    "Hamlet"."mobs_others" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_others";
      version = "v0.3.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_others";
        release = 4625;
        versionName = "v0.3.0";
        sha256 = "0sn7wdk7l5jg3bwrv12np5mwhnl95zjq6q82pp2x0iw6gfwpjgpx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds the Snow Walkers mobs, and an obsidian sword.";

      };
    };

    "Hamlet"."mobs_umbra" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_umbra";
      version = "v0.2.1";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_umbra";
        release = 4708;
        versionName = "v0.2.1";
        sha256 = "0pywx65hpbmfhbjvzih88jy3mmaikf7i4pb01jvpgg12s80gd2hk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds a shadow-looking Non Playing Character.";

      };
    };

    "Hamlet"."mobs_wolf" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_wolf";
      version = "v0.4.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "mobs_wolf";
        release = 6406;
        versionName = "v0.4.0";
        sha256 = "179ay6p4mjrhiwpzfd001pyx0dkxrykx7c3gddsh1sc1vw6rnbyq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Adds wolves.";

      };
    };

    "Hamlet"."ores_stats" = buildMinetestPackage rec {
      type = "mod";
      pname = "ores_stats";
      version = "v1.1.0";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "ores_stats";
        release = 4866;
        versionName = "v1.1.0";
        sha256 = "1vc1ydxwzqv6bkbc7gg6aqzwyv98024lbpz1rw6wrf1j5lgq40vd";
      };
      meta = src.meta // {
        license = [ spdx."EUPL-1.2" ];
        description = "Provides informations about ores' percentages collected on map generation.";

      };
    };

    "Hamlet"."recycleage" = buildMinetestPackage rec {
      type = "mod";
      pname = "recycleage";
      version = "v1.3.3";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "recycleage";
        release = 4575;
        versionName = "v1.3.3";
        sha256 = "1kyphr3dqfrvcm2ifdgaynymwgfw74znxb5nphxx7vsqcg9bpkpf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."EUPL-1.2" ];
        description = "Allows to recycle broken items.";

      };
    };

    "Hamlet"."round_trunks" = buildMinetestPackage rec {
      type = "mod";
      pname = "round_trunks";
      version = "v1.1.1";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "round_trunks";
        release = 14384;
        versionName = "v1.1.1";
        sha256 = "0yxk8ncagji0zf28zf0np6h3c55si084rxqks1j0bp8llxsvqc48";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Turns (default) cubic tree trunks to cylindrical.";

      };
    };

    "Hamlet"."smaller_steps" = buildMinetestPackage rec {
      type = "mod";
      pname = "smaller_steps";
      version = "v1.4.1";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "smaller_steps";
        release = 4269;
        versionName = "v1.4.1";
        sha256 = "0g0bvhgf69p69fy675d9li2shq6a6fy5nxz4h0nkxjmpvbz87lp7";
      };
      meta = src.meta // {
        license = [ spdx."EUPL-1.2" ];
        description = "Makes stairs and slabs use smaller shapes.";

      };
    };

    "Hamlet"."soft_leaves" = buildMinetestPackage rec {
      type = "mod";
      pname = "soft_leaves";
      version = "v0.2.2";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "soft_leaves";
        release = 14382;
        versionName = "v0.2.2";
        sha256 = "0jrfxcglnz29d4hzwjqdm8n6zz42a8fah975virl9crby3k0n25c";
      };
      meta = src.meta // {
        license = [ spdx."EUPL-1.2" spdx."GPL-2.0-only" ];
        description = "Allows to walk through and to climb on leaves.";

      };
    };

    "Hamlet"."stonebrick_dungeons" = buildMinetestPackage rec {
      type = "mod";
      pname = "stonebrick_dungeons";
      version = "v0.4.2";
      src = fetchFromContentDB {
        author = "Hamlet";
        technicalName = "stonebrick_dungeons";
        release = 14383;
        versionName = "v0.4.2";
        sha256 = "0hjbqy561x2zidb7x2qbizwmw6dd2x0bx5w894wpvbl72mbxdn6y";
      };
      meta = src.meta // {
        license = [ spdx."EUPL-1.2" ];
        description = "Turns newly generated cobblestone dungeons into stonebrick.";

      };
    };

    "Herkules"."elevators" = buildMinetestPackage rec {
      type = "mod";
      pname = "elevators";
      version = "Elevators__v0.9.0__";
      src = fetchFromContentDB {
        author = "Herkules";
        technicalName = "elevators";
        release = 2980;
        versionName = "Elevators [v0.9.0] ";
        sha256 = "0g8ga6x88z4dy428r0x17w45lc1a4vcjai5l1w4p3c68ynjx2wn6";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Adds an elevator and elevatorrails.";

      };
    };

    "HeroOfTheWinds"."caverealms" = buildMinetestPackage rec {
      type = "mod";
      pname = "caverealms";
      version = "2017-08-14";
      src = fetchFromContentDB {
        author = "HeroOfTheWinds";
        technicalName = "caverealms";
        release = 38;
        versionName = "2017-08-14";
        sha256 = "1shrglhljnqqw0g82b9alv3bn5vf0rs6wqvadhqfz0sx98g9x1ch";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A mod for Minetest to add underground realms.";

      };
    };

    "Hi_World"."newhorizons" = buildMinetestPackage rec {
      type = "mod";
      pname = "newhorizons";
      version = "NewHorizons_1.2";
      src = fetchFromContentDB {
        author = "Hi_World";
        technicalName = "newhorizons";
        release = 3860;
        versionName = "NewHorizons 1.2";
        sha256 = "103a9mdqm42phqi2zvgibl1wlj0jmiyvhc0j5inbgzgn5sp1yqzv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds 4 new biomes and TONS of new blocks!";

      };
    };

    "Hi_World"."newplanet" = buildMinetestPackage rec {
      type = "game";
      pname = "newplanet";
      version = "NewPlanet_1.2.1";
      src = fetchFromContentDB {
        author = "Hi_World";
        technicalName = "newplanet";
        release = 4041;
        versionName = "NewPlanet 1.2.1";
        sha256 = "1c9x6glvx5q21by0b9rnl585plskjgvx4mi0c3di9cy5ryl1ad2x";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "You're on a strange planet, with 8 exciting biomes and a perpetual night, but beware, there are monsters ready to hunt you!";

      };
    };

    "Hume2"."bike" = buildMinetestPackage rec {
      type = "mod";
      pname = "bike";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "bike";
        release = 8301;
        versionName = "1.2.1";
        sha256 = "0jn0fwgiprjws69mficxlv4rmpciswj21sr18gjq52ri34rppvcv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a rideable bike with animations and extensive colors.";

      };
    };

    "Hume2"."boxworld3d" = buildMinetestPackage rec {
      type = "game";
      pname = "boxworld3d";
      version = "1.-1";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "boxworld3d";
        release = 7435;
        versionName = "1.-1";
        sha256 = "1051w1vkdrnfrjl5lbnrsr0v8phwxsqjs36x8i8q54wshl5kyi0l";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "A puzzle game where you push boxes into marbles, whilst avoiding obstacles";

      };
    };

    "Hume2"."bucket_wooden" = buildMinetestPackage rec {
      type = "mod";
      pname = "bucket_wooden";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "bucket_wooden";
        release = 1136;
        versionName = "1.0.1";
        sha256 = "1k3a5r485m2ymv5y764j259qg4biw3k7ymlvh90362z18pb10l38";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A bucket made of wood for new farmers";

      };
    };

    "Hume2"."cave_explorer" = buildMinetestPackage rec {
      type = "mod";
      pname = "cave_explorer";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "cave_explorer";
        release = 987;
        versionName = "1.0";
        sha256 = "11z8l8axnk8jg75xq500r8yr85438q334qrq81cs9izdnr9wcyhl";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "An utility for cave exploring in creative";

      };
    };

    "Hume2"."diamonds_burn" = buildMinetestPackage rec {
      type = "mod";
      pname = "diamonds_burn";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "diamonds_burn";
        release = 1103;
        versionName = "1.0";
        sha256 = "1wxpzp917p4yksrfbravlfmb64zyi81x03pf8ls601s5p5wi4mxd";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Make diamonds useable as fuel";

      };
    };

    "Hume2"."discrete_player" = buildMinetestPackage rec {
      type = "mod";
      pname = "discrete_player";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "discrete_player";
        release = 7433;
        versionName = "1.0";
        sha256 = "0p6hpbfkwm2py6z8jc3ds5b9q9v3rd15w74fr0gcp5zq2r05kp18";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A library for games which attaches players to node grid";

      };
    };

    "Hume2"."hiking" = buildMinetestPackage rec {
      type = "mod";
      pname = "hiking";
      version = "2.0.1";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "hiking";
        release = 4362;
        versionName = "2.0.1";
        sha256 = "086jdwmqllfidqans444hbdivi91g8vdr3pycqgiz5mpywz1g2yx";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Complete set of hiking signs";

      };
    };

    "Hume2"."level" = buildMinetestPackage rec {
      type = "mod";
      pname = "level";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "level";
        release = 7434;
        versionName = "1.0";
        sha256 = "0zinrrn1nidm1m73qnp73by5xl56n4kq9ygb4wa885l08flnfa5f";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A library for games to load levels defined as schematics";

      };
    };

    "Hume2"."nettle" = buildMinetestPackage rec {
      type = "mod";
      pname = "nettle";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "nettle";
        release = 5441;
        versionName = "1.0.2";
        sha256 = "14yb38vf98wvf0x4p2s2zfzwk4va8y71kf4ajs6rdp615q8pa70f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Nettles spawning on junky plots";

      };
    };

    "Hume2"."signs_extra" = buildMinetestPackage rec {
      type = "mod";
      pname = "signs_extra";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "signs_extra";
        release = 7436;
        versionName = "1.0";
        sha256 = "1xhn88ygsaxhnlxvdq320cjzj6zp78rkzpciqybakksj2gflkhkh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Two new signs: blue banner and billboard";

      };
    };

    "Hume2"."uchu" = buildMinetestPackage rec {
      type = "mod";
      pname = "uchu";
      version = "1.2";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "uchu";
        release = 12092;
        versionName = "1.2";
        sha256 = "158gbl39mif4ifycaik7lnci9kqjvf6wnjl9akxxq8jnhgjifivk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Extend the Underground Challenge by miscelaneous utilities and change some recipes";

      };
    };

    "Hume2"."underch" = buildMinetestPackage rec {
      type = "mod";
      pname = "underch";
      version = "2022-08-13";
      src = fetchFromContentDB {
        author = "Hume2";
        technicalName = "underch";
        release = 14462;
        versionName = "2022-08-13";
        sha256 = "15nj4168qdsiz6sghamzxs6bsilfqrilr9xphwjcp79z1xhbhxd6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."CC0-1.0" ];
        description = "Explore all 62 underground biomes!";

      };
    };

    "IFRFSX"."bingfeng_maidroid" = buildMinetestPackage rec {
      type = "mod";
      pname = "bingfeng_maidroid";
      version = "20210503-repair";
      src = fetchFromContentDB {
        author = "IFRFSX";
        technicalName = "bingfeng_maidroid";
        release = 7661;
        versionName = "20210503-repair";
        sha256 = "0gcn4nv30ssbghwf5afazgmyb2xz6b7mi46p4w5l10k9pssld7ln";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "An improved version of Maidroid, providing maid robots.";

      };
    };

    "IFRFSX"."iceflametexture" = buildMinetestPackage rec {
      type = "txp";
      pname = "iceflametexture";
      version = "20200718";
      src = fetchFromContentDB {
        author = "IFRFSX";
        technicalName = "iceflametexture";
        release = 4609;
        versionName = "20200718";
        sha256 = "0nx38dgc7bs5k6s3dd6gibrf2msfzc52071a7kdafmp5mpiq8ix3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "A Magical Texture, Based PixelBox!";

      };
    };

    "IcyDiamond"."elepower" = buildMinetestPackage rec {
      type = "mod";
      pname = "elepower";
      version = "Alpha_22_-_Lights";
      src = fetchFromContentDB {
        author = "IcyDiamond";
        technicalName = "elepower";
        release = 8815;
        versionName = "Alpha 22 - Lights";
        sha256 = "1bbdjsdzypx7mxpn5wck587qmbxkxv004qkfrh7k266k2cihfwx4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A powerful modpack";

          homepage = "https://wiki.lunasqu.ee/Category:Elepower";

      };
    };

    "IcyDiamond"."fluid_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "fluid_lib";
      version = "5.4_MT_version_fix";
      src = fetchFromContentDB {
        author = "IcyDiamond";
        technicalName = "fluid_lib";
        release = 8297;
        versionName = "5.4 MT version fix";
        sha256 = "0vs3i6l9ydcpirg8x52pkc0j1brxwyj4mmh6x69q4wkqpgzdmcpg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Library for nodes containing fluids";

      };
    };

    "IcyDiamond"."magicalities" = buildMinetestPackage rec {
      type = "mod";
      pname = "magicalities";
      version = "2020-01-22";
      src = fetchFromContentDB {
        author = "IcyDiamond";
        technicalName = "magicalities";
        release = 2801;
        versionName = "2020-01-22";
        sha256 = "1brfmsmvyqbi223jvycj5hy7v75n82n29bd5al3fr9x3vglmpb2p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A work-in-progress magic mod";

      };
    };

    "IcyDiamond"."melterns" = buildMinetestPackage rec {
      type = "mod";
      pname = "melterns";
      version = "2019-02-08";
      src = fetchFromContentDB {
        author = "IcyDiamond";
        technicalName = "melterns";
        release = 955;
        versionName = "2019-02-08";
        sha256 = "14dm61y7l0hl3qxxq4k16i3z1fkhbq74ivhk1s6gb40a8b25mii9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Tinkers Construct in Minetest!";

      };
    };

    "Itz-Noah"."colourful_ladders" = buildMinetestPackage rec {
      type = "mod";
      pname = "colourful_ladders";
      version = "Colourful_Ladders_2021-11-06";
      src = fetchFromContentDB {
        author = "Itz-Noah";
        technicalName = "colourful_ladders";
        release = 9619;
        versionName = "Colourful Ladders 2021-11-06";
        sha256 = "1zp1r1jx02bka7g1vhp5yzikynvfhijnhzid7029g694b721v72m";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "40 colourful wooden ladders";

      };
    };

    "J05629"."lifesteal_mod" = buildMinetestPackage rec {
      type = "mod";
      pname = "lifesteal_mod";
      version = "2022-10-17_1.2.0";
      src = fetchFromContentDB {
        author = "J05629";
        technicalName = "lifesteal_mod";
        release = 14431;
        versionName = "2022-10-17 1.2.0";
        sha256 = "1ivnxsz2816kcfd7r57h4lx3iklnjyx4w6yw3pvq23x6691zhjrm";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-or-later" ];
        description = "Provides a lifesteal mod into Minetest.";

      };
    };

    "J05629"."vitality" = buildMinetestPackage rec {
      type = "mod";
      pname = "vitality";
      version = "2022-10-17_1.1.0";
      src = fetchFromContentDB {
        author = "J05629";
        technicalName = "vitality";
        release = 14433;
        versionName = "2022-10-17 1.1.0";
        sha256 = "156ffhym8h0l7i4qlhrcrmdrbrwp7mvjmsgm27xkcr7rp744yly9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Provides a Heartgiving Mod.";

      };
    };

    "JALdMIC"."assets_warehouse" = buildMinetestPackage rec {
      type = "mod";
      pname = "assets_warehouse";
      version = "assets_warehouseV0.9";
      src = fetchFromContentDB {
        author = "JALdMIC";
        technicalName = "assets_warehouse";
        release = 13905;
        versionName = "assets_warehouseV0.9";
        sha256 = "0scavnk2fy9qzj4vc905p7avj7w0lnrw2y3scc1b0zyfzpqypig9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-NC-SA-3.0" spdx."CC-BY-SA-3.0" ];
        description = "Some assets for decorative purpose";

      };
    };

    "JALdMIC"."survivethedays" = buildMinetestPackage rec {
      type = "game";
      pname = "survivethedays";
      version = "survivethedays0.4";
      src = fetchFromContentDB {
        author = "JALdMIC";
        technicalName = "survivethedays";
        release = 12774;
        versionName = "survivethedays0.4";
        sha256 = "0vz7c3x9wqy8ga7idp5hjbcksfzbpyk29db2b4920gm9bzylal0s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-NC-SA-3.0" spdx."CC-BY-SA-3.0" ];
        description = "A little experiment.Warning very early version,more a concept than a complete game.";

      };
    };

    "JAstudios"."moreswords" = buildMinetestPackage rec {
      type = "mod";
      pname = "moreswords";
      version = "Moreswords_1.1";
      src = fetchFromContentDB {
        author = "JAstudios";
        technicalName = "moreswords";
        release = 9585;
        versionName = "Moreswords_1.1";
        sha256 = "18ymjl5w9vhw4a8lb66vb976ifri31h205v532q6zbm7h12n0ym2";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds more powerfull swords that have various abilities.";

          homepage = "https://www.james-clarke.ynh.fr/";

      };
    };

    "Jackknife"."silver" = buildMinetestPackage rec {
      type = "mod";
      pname = "silver";
      version = "2021.12.27";
      src = fetchFromContentDB {
        author = "Jackknife";
        technicalName = "silver";
        release = 8952;
        versionName = "2021.12.27";
        sha256 = "0229i096r12s1yl72capfcni1xk194djkyw6kmjxiiymxv3wp68g";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "adds silver ore and tools";

      };
    };

    "JavaFXpert"."qiskitblocks" = buildMinetestPackage rec {
      type = "game";
      pname = "qiskitblocks";
      version = "2020-09-25";
      src = fetchFromContentDB {
        author = "JavaFXpert";
        technicalName = "qiskitblocks";
        release = 5212;
        versionName = "2020-09-25";
        sha256 = "03xa3n6ppvp3dfslb7784rpqwns9g38bayb0b5vpq8hs5w34vfgx";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."Apache-2.0" ];
        description = "Teaching Quantum Computing using Qiskit in a block world";

      };
    };

    "Jean3219"."jeans_economy" = buildMinetestPackage rec {
      type = "mod";
      pname = "jeans_economy";
      version = "2019-10-29-02";
      src = fetchFromContentDB {
        author = "Jean3219";
        technicalName = "jeans_economy";
        release = 2265;
        versionName = "2019-10-29-02";
        sha256 = "1a9kijx6rs9996znasv83r7x2c3lpdzvqpv5wzyfad3bnh4pl5qp";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Full Economy for Servers like, paying, individual bank statemants, daily rewards, easy api for modders, easy integration with other mods ...";

      };
    };

    "Jeija"."digilines" = buildMinetestPackage rec {
      type = "mod";
      pname = "digilines";
      version = "2022-08-14";
      src = fetchFromContentDB {
        author = "Jeija";
        technicalName = "digilines";
        release = 13248;
        versionName = "2022-08-14";
        sha256 = "0rpsfa3bpk1fas04gy18kgpqhwh23h13bj8v9i6v5zc2v23fdvgs";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "This mod adds digiline wires, an RTC (Real Time Clock), a light sensor as well as an LCD Screen.";

      };
    };

    "Jeija"."flamethrower" = buildMinetestPackage rec {
      type = "mod";
      pname = "flamethrower";
      version = "2013-03-24";
      src = fetchFromContentDB {
        author = "Jeija";
        technicalName = "flamethrower";
        release = 2158;
        versionName = "2013-03-24";
        sha256 = "189sxkplj0mczf25ydzy0r5lqdp9kx69v523fwzjj409w3xgv2w4";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" spdx."WTFPL" ];
        description = "Adds a flamethrower using particles. It makes things burn and scorches grass; does not cause damage to any object.";

      };
    };

    "Jeija"."mesecons" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons";
      version = "2022-10-08";
      src = fetchFromContentDB {
        author = "Jeija";
        technicalName = "mesecons";
        release = 14247;
        versionName = "2022-10-08";
        sha256 = "0ra2s5h8hx7nn55szp27zwslr2ymhj0wra0vygl7pvdglinraqpw";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Adds digital circuitry, including wires, buttons, lights, and even programmable controllers.";

      };
    };

    "Jolesh"."de_nenio" = buildMinetestPackage rec {
      type = "mod";
      pname = "de_nenio";
      version = "2022-09-28";
      src = fetchFromContentDB {
        author = "Jolesh";
        technicalName = "de_nenio";
        release = 14080;
        versionName = "2022-09-28";
        sha256 = "03byz4ml5gw4dqkbmpxrrjkwylq5hj79bmm2vgadzh6jg60flz56";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds possibilities to get items normally unobtainable in skyblock through new mechanics and objects";

      };
    };

    "Jolesh"."nuggets" = buildMinetestPackage rec {
      type = "mod";
      pname = "nuggets";
      version = "2022-10-15";
      src = fetchFromContentDB {
        author = "Jolesh";
        technicalName = "nuggets";
        release = 14376;
        versionName = "2022-10-15";
        sha256 = "1c099bhhak8vv1a0iddrh4s12l93mm62f9rylm3z49favxhg1fcc";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds nuggets and shards";

          homepage = "https://mt-nuggets-mod.fandom.com";

      };
    };

    "Jolesh"."simple_recycle" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_recycle";
      version = "2022-10-15";
      src = fetchFromContentDB {
        author = "Jolesh";
        technicalName = "simple_recycle";
        release = 14377;
        versionName = "2022-10-15";
        sha256 = "1xcmmdsnacvc09r1k155afbxsrk5ms135m2cqr434zvlyh75kybl";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "This adds the possibility to recycle items and nodes by smelting or decrafting them back to their original resources.";

      };
    };

    "Jordach"."invector" = buildMinetestPackage rec {
      type = "game";
      pname = "invector";
      version = "GameJam_Emergency_Crash_Fix";
      src = fetchFromContentDB {
        author = "Jordach";
        technicalName = "invector";
        release = 10219;
        versionName = "GameJam Emergency Crash Fix";
        sha256 = "1zzjnwbzp27m574rylnp2llwndqyqqgds8v5shy2669ym7ydfrml";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A karting game with built in track editor";

      };
    };

    "Josselin2"."decoshelves" = buildMinetestPackage rec {
      type = "mod";
      pname = "decoshelves";
      version = "2021-07-07";
      src = fetchFromContentDB {
        author = "Josselin2";
        technicalName = "decoshelves";
        release = 8378;
        versionName = "2021-07-07";
        sha256 = "0vsrl730kz9zmgc4c7h7yq0pn4rjm5cpmcj9rgyjbh6x4yzz51lx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Provides an expanded collection of bookshelves.";

      };
    };

    "Josselin2"."metrosigns" = buildMinetestPackage rec {
      type = "mod";
      pname = "metrosigns";
      version = "Update_line_sign_colours_to_match_basic_trains_mod";
      src = fetchFromContentDB {
        author = "Josselin2";
        technicalName = "metrosigns";
        release = 9485;
        versionName = "Update line sign colours to match basic_trains mod";
        sha256 = "1hy4p44hwhkzkf2x9w7z4n7vsdpvc7fs8wxg79gacr5drnjgin1p";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Provides an extended selection of signs for use in your train and metro networks.";

      };
    };

    "Josselin2"."real_names_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "real_names_redo";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Josselin2";
        technicalName = "real_names_redo";
        release = 7627;
        versionName = "1.1.0";
        sha256 = "08di5dy9g9pjq0lc5hr2swqk4wmrrmm27131d3v8f2gh1jr72p00";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Assigns realistic names to players when they join";

      };
    };

    "Josselin2"."schemconvert" = buildMinetestPackage rec {
      type = "mod";
      pname = "schemconvert";
      version = "2022-08-26";
      src = fetchFromContentDB {
        author = "Josselin2";
        technicalName = "schemconvert";
        release = 13558;
        versionName = "2022-08-26";
        sha256 = "1r7hk865ljy5mplwhwsc08wns2pan1qfcyxip9p3ba805z9r59ql";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Update node names when copying an MTS schematic from one mod to another";

      };
    };

    "Juri"."perfhud" = buildMinetestPackage rec {
      type = "mod";
      pname = "perfhud";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Juri";
        technicalName = "perfhud";
        release = 13894;
        versionName = "1.1.0";
        sha256 = "0mig1h2cbrxnx06hbny9ga95qsi4dncn2j11q8ycwmk6fknd2sqf";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Adds an HUD which shows some performance stats.";

      };
    };

    "Just_Visiting"."adventure_core" = buildMinetestPackage rec {
      type = "mod";
      pname = "adventure_core";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "adventure_core";
        release = 5935;
        versionName = "1.0";
        sha256 = "09q7fbc1xm2hc0kml8c0mfv7v3s5f7l6770kdz781k20wx1ci782";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adventuring Resource System";

      };
    };

    "Just_Visiting"."algae" = buildMinetestPackage rec {
      type = "mod";
      pname = "algae";
      version = "Version_1.0.1";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "algae";
        release = 5868;
        versionName = "Version 1.0.1";
        sha256 = "1nz1z8ka5y4p7pa59x4c14mm5yxp6ziv3fbcp0ppq2k9m3m4gzs4";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Algae mapgen addition to \"Minetest Game\"";

      };
    };

    "Just_Visiting"."autobox" = buildMinetestPackage rec {
      type = "mod";
      pname = "autobox";
      version = "1.01";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "autobox";
        release = 9186;
        versionName = "1.01";
        sha256 = "03b6nxp0lc0n13cnwqk0cknfadlz7lbqkx6szssbcbzq5raaa7w8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Auto Collision/Selection Loading Boxes";

      };
    };

    "Just_Visiting"."falls" = buildMinetestPackage rec {
      type = "mod";
      pname = "falls";
      version = "Falls_V1.0_Release";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "falls";
        release = 4514;
        versionName = "Falls V1.0 Release";
        sha256 = "17q9y9nrm8b4qk78nyrjbag776wzv7z42vf286jgwfcni7wjhhal";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A Particle-based Waterfalls/Lavafalls Mod";

      };
    };

    "Just_Visiting"."formspec_editor" = buildMinetestPackage rec {
      type = "game";
      pname = "formspec_editor";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "formspec_editor";
        release = 8551;
        versionName = "Version 1.1";
        sha256 = "0lb7kfn497ij9w7xzvkfr6nvs6qy5pl9px82daxx13i1878biw2d";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A Realtime in-game formspec viewer/editor";

      };
    };

    "Just_Visiting"."labyrinth" = buildMinetestPackage rec {
      type = "game";
      pname = "labyrinth";
      version = "Version_1.0.0";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "labyrinth";
        release = 9620;
        versionName = "Version 1.0.0";
        sha256 = "02llks2x27bk61gc6inijqjc9m4qgpw7yzxahgj4zdrif2mlgdbh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "An aMAZEing Game";

      };
    };

    "Just_Visiting"."littlelady" = buildMinetestPackage rec {
      type = "game";
      pname = "littlelady";
      version = "Fixed_Version_for_5.5";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "littlelady";
        release = 10980;
        versionName = "Fixed Version for 5.5";
        sha256 = "1z0wjzs8d4dqfhv3m1z6j0s2pyqqzfxzmflmhhrqlfjjhi8bxvsw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "A Little Ladybug in a Big World";

      };
    };

    "Just_Visiting"."markdown2formspec" = buildMinetestPackage rec {
      type = "mod";
      pname = "markdown2formspec";
      version = "Version_1.3";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "markdown2formspec";
        release = 11639;
        versionName = "Version 1.3";
        sha256 = "187sz1a6dv89z8i0kv2hrd3awkibjmnmp5vfqdbjb2rvh98jl3qx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A markdown to Formspec Utility ";

      };
    };

    "Just_Visiting"."rocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "rocks";
      version = "Rocks_V1_Release";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "rocks";
        release = 4375;
        versionName = "Rocks V1 Release";
        sha256 = "0ib7rv9av0q22mcwxqv8isn4xycna1wnil6b4y9c4n4hnkdfrfhz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds fun rocks to bring new life to your survival and creative creations!";

      };
    };

    "Just_Visiting"."smoke_signals" = buildMinetestPackage rec {
      type = "mod";
      pname = "smoke_signals";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Just_Visiting";
        technicalName = "smoke_signals";
        release = 7772;
        versionName = "1.0";
        sha256 = "130z9pg500lzvfmz3wrfqzijc1c7468533n7srfsz1mvcp714djz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Signal your friends, or warn your enemies!";

      };
    };

    "Kimapr"."diggable_chests" = buildMinetestPackage rec {
      type = "mod";
      pname = "diggable_chests";
      version = "yes";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "diggable_chests";
        release = 13859;
        versionName = "yes";
        sha256 = "0bbcfbja9d259gcqv46x91id18y8mx6diwiamv14mx2mnmb2fxs9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "makes chests, furnaces and such diggable even if not empty";

      };
    };

    "Kimapr"."glcraft" = buildMinetestPackage rec {
      type = "mod";
      pname = "glcraft";
      version = "2022-09-27";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "glcraft";
        release = 14070;
        versionName = "2022-09-27";
        sha256 = "0rkqh61whwf6cxg9mibc4mrwn1vmw9ac79rw6400nblncw5r6lk4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "crafting grid replacement and better craftguide";

      };
    };

    "Kimapr"."leaveghost" = buildMinetestPackage rec {
      type = "mod";
      pname = "leaveghost";
      version = "2022-09-28";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "leaveghost";
        release = 14078;
        versionName = "2022-09-28";
        sha256 = "1xl6n2j0mf56n43jnrjf91nvrjqc5v9xp9jjps9h4s99wzyvr13d";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Players leave \"phantoms\" when leaving; other players can take items from those";

      };
    };

    "Kimapr"."nc_ctf" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_ctf";
      version = "3";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nc_ctf";
        release = 2848;
        versionName = "3";
        sha256 = "1phqaxbxfbaxapk3c1lyk5bvxprgpd6sq5r6c8wfs3i1xzwjcmvl";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "(NOT IN DEVELOPMENT AND IS BAD - DO NOT USE) Capture The Flag for NodeCore";

      };
    };

    "Kimapr"."nc_paint" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_paint";
      version = "eceda633";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nc_paint";
        release = 9321;
        versionName = "eceda633";
        sha256 = "0lq18bnbwaq2vdwz10ad2q9m34s2249ylf594vzppgw3nqnkfpn3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Paint anything on node surfaces";

      };
    };

    "Kimapr"."nc_sky" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_sky";
      version = "2021-03-14";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nc_sky";
        release = 6987;
        versionName = "2021-03-14";
        sha256 = "03dpcf5592m9lsg18f2x1kk4kj16592amckgz66mlm5vxlmgz7j5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Play NodeCore on floating islands!";

      };
    };

    "Kimapr"."nc_sky_ultra_hard" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_sky_ultra_hard";
      version = "2022-01-21";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nc_sky_ultra_hard";
        release = 10733;
        versionName = "2022-01-21";
        sha256 = "1vp2n2701bxadjxxnqvjzngpap92fi0yvdyg3840wm1p1j4y12ma";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The ultimate skyblock challenge";

      };
    };

    "Kimapr"."nc_snakes" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_snakes";
      version = "fix";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nc_snakes";
        release = 6816;
        versionName = "fix";
        sha256 = "1ad95jgx52zmsl7ym8667ra25zbh27n02sca6vn891b7z0gav1wv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Sneaky snakes in NodeCore!";

      };
    };

    "Kimapr"."nodecore_playertags" = buildMinetestPackage rec {
      type = "mod";
      pname = "nodecore_playertags";
      version = "eeeeee";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nodecore_playertags";
        release = 13858;
        versionName = "eeeeee";
        sha256 = "1zfqr0q2v1z4s35hr3msmki8kpwlzvcg9s45ixrs1h9x00i9sh64";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "nodecore playertags ported to other games";

      };
    };

    "Kimapr"."nodeternal_darkness" = buildMinetestPackage rec {
      type = "mod";
      pname = "nodeternal_darkness";
      version = "cdb_debut";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nodeternal_darkness";
        release = 14402;
        versionName = "cdb debut";
        sha256 = "0kywz3nwx6s07i203c7h1nmx11rjzx5sxmfccijkp5vnh8i4xmgj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "make nodecore very dark";

      };
    };

    "Kimapr"."nonsensical_skyblock" = buildMinetestPackage rec {
      type = "game";
      pname = "nonsensical_skyblock";
      version = "2022-09-28";
      src = fetchFromContentDB {
        author = "Kimapr";
        technicalName = "nonsensical_skyblock";
        release = 14077;
        versionName = "2022-09-28";
        sha256 = "1bgv8z6c4053lvkymak14l3pk82lb3n72g6srpcsay9rqnzpsxxr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "bonemeal go brrrr";

      };
    };

    "KingSmarty"."rainbow_ore" = buildMinetestPackage rec {
      type = "mod";
      pname = "rainbow_ore";
      version = "2021-08-05";
      src = fetchFromContentDB {
        author = "KingSmarty";
        technicalName = "rainbow_ore";
        release = 8775;
        versionName = "2021-08-05";
        sha256 = "1bfmjncq27j115xdfhxbw7rscrc77xryysnqj12az05x0rlchf2m";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Rainbow materials & equipment.";

      };
    };

    "Koda_"."gemstones" = buildMinetestPackage rec {
      type = "mod";
      pname = "gemstones";
      version = "Gemstones";
      src = fetchFromContentDB {
        author = "Koda_";
        technicalName = "gemstones";
        release = 5671;
        versionName = "Gemstones";
        sha256 = "1mz7kdx7d9qx2iv9dv7ymqm2987p2fb6s6xpjp7l8cr96s2i8mbr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds Gemstones to the game";

      };
    };

    "Koda_"."more_pickaxes" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_pickaxes";
      version = "More_Pickaxes";
      src = fetchFromContentDB {
        author = "Koda_";
        technicalName = "more_pickaxes";
        release = 6434;
        versionName = "More Pickaxes";
        sha256 = "1sf7xfp9zqq5vshids9fkviim2v3hw2139vlmqr7nrdsxnpkl784";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds additional pickaxes to the game";

      };
    };

    "Krock"."bitchange" = buildMinetestPackage rec {
      type = "mod";
      pname = "bitchange";
      version = "2021-03-05";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "bitchange";
        release = 6810;
        versionName = "2021-03-05";
        sha256 = "0v51xydg0hymjf37k5pwkw035c5zlvfscj3kl5x9x9z7hb6ig8wj";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Money items for your world, based on Bitcoins";

      };
    };

    "Krock"."boost_cart" = buildMinetestPackage rec {
      type = "mod";
      pname = "boost_cart";
      version = "Import_two_my_MTG_commits_for_better_driving_experience";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "boost_cart";
        release = 12459;
        versionName = "Import two my MTG commits for better driving experience";
        sha256 = "0jcvlyzs750i6n1ffvfj49j5by2k5iha8dh51s6xzr9xh538hfsq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "This mod offers improved minecarts and a few more rail types.";

      };
    };

    "Krock"."exchange_shop" = buildMinetestPackage rec {
      type = "mod";
      pname = "exchange_shop";
      version = "2022-08-01";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "exchange_shop";
        release = 12994;
        versionName = "2022-08-01";
        sha256 = "14wm4dwc1iqni0jdq8zppp5ban2v60vkcm63k7pwr47pfyd24g3p";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Provides a simple exchange shop (currency compatible) ";

      };
    };

    "Krock"."simple_protection" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_protection";
      version = "Fix_translation_mistake_and_wrong_area_count";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "simple_protection";
        release = 14476;
        versionName = "Fix translation mistake and wrong area count";
        sha256 = "1qljgfgs4vgx2r4iqa4pfj45cqc6drmvcpcgri28fik9sz09l1zx";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Minetest fixed-grid quadratic area protection mod with graphical area \"minimap\"";

      };
    };

    "Krock"."sneak_glitch" = buildMinetestPackage rec {
      type = "mod";
      pname = "sneak_glitch";
      version = "Init";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "sneak_glitch";
        release = 3995;
        versionName = "Init";
        sha256 = "0nh6544vg5556apb0zqv6216liwmxfcfgc2zsj2hqr141kj7l3i1";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Enable the sneak glitch again! ";

      };
    };

    "Krock"."stapled_bread" = buildMinetestPackage rec {
      type = "mod";
      pname = "stapled_bread";
      version = "Init";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "stapled_bread";
        release = 3996;
        versionName = "Init";
        sha256 = "145b69735f08yadyz7dkf838ws10bxkq3qvls1bkr6a7jjbmkms3";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds the functionality to staple bread to trees";

      };
    };

    "Krock"."upgrade_packs" = buildMinetestPackage rec {
      type = "mod";
      pname = "upgrade_packs";
      version = "update";
      src = fetchFromContentDB {
        author = "Krock";
        technicalName = "upgrade_packs";
        release = 3438;
        versionName = "update";
        sha256 = "0xkjsmvzkmah7kc8szf79759y3jwah4fhfxhjgdznw4yjs9l4a98";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Provides craftable packs to players to increase their health and breath";

      };
    };

    "LMD"."adv_chat" = buildMinetestPackage rec {
      type = "mod";
      pname = "adv_chat";
      version = "rolling-28";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "adv_chat";
        release = 13739;
        versionName = "rolling-28";
        sha256 = "05p3xx7v08w4hg5xyhcq9ar1wqg90jyma9qv0ags6hh3njc417nk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A library for advanced chatting.";

      };
    };

    "LMD"."adv_weapons" = buildMinetestPackage rec {
      type = "mod";
      pname = "adv_weapons";
      version = "rolling-7";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "adv_weapons";
        release = 11363;
        versionName = "rolling-7";
        sha256 = "05jqrxqv9v69vwhwzzs6n7mvw68yx7fl3199xdwbdcp9dcg1fq0d";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds a variety of advanced weapons.";

      };
    };

    "LMD"."anti_exploit" = buildMinetestPackage rec {
      type = "mod";
      pname = "anti_exploit";
      version = "rolling-5";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "anti_exploit";
        release = 7051;
        versionName = "rolling-5";
        sha256 = "11dsjdf1s0b26ms4mxy5gnxkabxvc46xxbzpzfpwwm0k6hwl8n5p";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Protects against exploits";

      };
    };

    "LMD"."cellestial" = buildMinetestPackage rec {
      type = "mod";
      pname = "cellestial";
      version = "rolling-9";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "cellestial";
        release = 13737;
        versionName = "rolling-9";
        sha256 = "0fd7s0rjchq6hksknnm8rlbvjd50m3gk4732jcakx6wnhmssb0dn";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Simulates 3D cellular automata";

      };
    };

    "LMD"."cellestial_game" = buildMinetestPackage rec {
      type = "game";
      pname = "cellestial_game";
      version = "rolling-40";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "cellestial_game";
        release = 8834;
        versionName = "rolling-40";
        sha256 = "14azmigbl02lzbrbfxyvpbpszln4m01k84jcvarx5b59sdvxhw1s";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Game of Life in three dimensions.";

      };
    };

    "LMD"."cellestiall" = buildMinetestPackage rec {
      type = "mod";
      pname = "cellestiall";
      version = "rolling-10";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "cellestiall";
        release = 5800;
        versionName = "rolling-10";
        sha256 = "1s0nmhfz6c219p43gr1q9yfz4xj123wnac3bx6gc7snh0h33gvnn";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Simulates 3D cellular automata in your entire world. WARNING: you will lose items & buildings in your world.";

      };
    };

    "LMD"."character_anim" = buildMinetestPackage rec {
      type = "mod";
      pname = "character_anim";
      version = "rolling-38";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "character_anim";
        release = 12907;
        versionName = "rolling-38";
        sha256 = "04skg64g4fb6iijdvvy33h6cs29h8vmv0kgdhc1h641ynxwf5f14";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Animates the character";

      };
    };

    "LMD"."cmdlib" = buildMinetestPackage rec {
      type = "mod";
      pname = "cmdlib";
      version = "rolling-21";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "cmdlib";
        release = 13738;
        versionName = "rolling-21";
        sha256 = "025yj5ds1w46iyvcgalqfybc25xcj2hyd6lb0jczhplfym2hi247";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Library for registering chatcommands.";

      };
    };

    "LMD"."cycle_limit" = buildMinetestPackage rec {
      type = "mod";
      pname = "cycle_limit";
      version = "rolling-13";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "cycle_limit";
        release = 5799;
        versionName = "rolling-13";
        sha256 = "0iif9khzn6y628la1ryffpd4rkq7xl597rgi46vk9vzgxnnrj8iv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Limits hotbar slot switching";

      };
    };

    "LMD"."dash" = buildMinetestPackage rec {
      type = "mod";
      pname = "dash";
      version = "rolling-8";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "dash";
        release = 5771;
        versionName = "rolling-8";
        sha256 = "081mi0dh2b5yfsvhzvwhxvcbxm6561y6l2vmg4kzfpfjbmmnpbc1";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Quick energy burst alternative to sprinting";

      };
    };

    "LMD"."dbg" = buildMinetestPackage rec {
      type = "mod";
      pname = "dbg";
      version = "2022-09-24";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "dbg";
        release = 14020;
        versionName = "2022-09-24";
        sha256 = "0icrkc1r4s1kn3l1wmw39mch7m3c4q4lfjjpmayh7jq1hws6dglp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Debugging on steroids";

      };
    };

    "LMD"."deathlist" = buildMinetestPackage rec {
      type = "mod";
      pname = "deathlist";
      version = "rolling-16";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "deathlist";
        release = 13912;
        versionName = "rolling-16";
        sha256 = "1dvrzc14x7wr10ay8rmxx4r66v41i3ywqcks8xz1bqk3jw47zgi3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a kill history";

      };
    };

    "LMD"."disable_build_where_they_stand" = buildMinetestPackage rec {
      type = "mod";
      pname = "disable_build_where_they_stand";
      version = "rolling-10";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "disable_build_where_they_stand";
        release = 12263;
        versionName = "rolling-10";
        sha256 = "1csfiwgj1j3z12x0wazx6r2gxphdfcnid3nxykharmbjyb85hrmn";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Disables placing blocks at places where they would collide with a player";

      };
    };

    "LMD"."epidermis" = buildMinetestPackage rec {
      type = "mod";
      pname = "epidermis";
      version = "2022-08-21";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "epidermis";
        release = 13456;
        versionName = "2022-08-21";
        sha256 = "09hpiv8ldfhzd6cd4h6iaxnj902s6cpvpixg499mr61wrfq8jk57";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Live in-game skin editing! Upload & download to & from SkinDB!";

      };
    };

    "LMD"."fslib" = buildMinetestPackage rec {
      type = "mod";
      pname = "fslib";
      version = "2022-06-15";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "fslib";
        release = 12532;
        versionName = "2022-06-15";
        sha256 = "1szly9jvki79jsa2k9mhnvs585m07w2d5s472y41z5cbl6l15fyn";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Formspec string builder & event handler callbacks";

      };
    };

    "LMD"."ghosts" = buildMinetestPackage rec {
      type = "mod";
      pname = "ghosts";
      version = "rolling-6";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "ghosts";
        release = 12265;
        versionName = "rolling-6";
        sha256 = "1bp1kii0xgmwywgvww5wdpz6yb16ms69kpb3wbl542gkhdflx2dm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds fancy particle ghosts";

      };
    };

    "LMD"."go" = buildMinetestPackage rec {
      type = "mod";
      pname = "go";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "go";
        release = 13192;
        versionName = "2022-08-12";
        sha256 = "13n774rxjxl4g1ysyydgh3050db3606s9iplxp8lgwqvqz91yld1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "A game of Go";

      };
    };

    "LMD"."hud_timers" = buildMinetestPackage rec {
      type = "mod";
      pname = "hud_timers";
      version = "rolling-8";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "hud_timers";
        release = 5774;
        versionName = "rolling-8";
        sha256 = "0vvynwa7fr06f0jacj6c5sl4fww4syn2g2rdm6g40hz70bkpi5sj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A lightweight library for adding hud timers.";

      };
    };

    "LMD"."item_limit" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_limit";
      version = "rolling-9";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "item_limit";
        release = 5773;
        versionName = "rolling-9";
        sha256 = "0cbdwkk66inad5f7bidzks2qj3ih07n1d53hg1n7cs3kvn2iq00c";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Limits the amount of items of certain types in player inventories";

      };
    };

    "LMD"."magic_potions" = buildMinetestPackage rec {
      type = "mod";
      pname = "magic_potions";
      version = "rolling-10";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "magic_potions";
        release = 5777;
        versionName = "rolling-10";
        sha256 = "0n3ca19dqy2x4xbgkrpd8s64yr9qi1s150xyz28fab27jrpshk7m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Potions which grant player effects";

      };
    };

    "LMD"."moblib" = buildMinetestPackage rec {
      type = "mod";
      pname = "moblib";
      version = "rolling-19";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "moblib";
        release = 10472;
        versionName = "rolling-19";
        sha256 = "1pj0zhz28rq7jkdw5jrqrhvzpa14snm1gwa6bclhkvzgrdzx85hv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Low-level high-performance entity library";

      };
    };

    "LMD"."modlib" = buildMinetestPackage rec {
      type = "mod";
      pname = "modlib";
      version = "rolling-98";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "modlib";
        release = 12711;
        versionName = "rolling-98";
        sha256 = "0dxjxamy8qffmycg4nwq6sjwz9nmh6bkmrj3cpaamjbd9ss04d4n";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Multipurpose Minetest Modding Library";

      };
    };

    "LMD"."online_craftguide" = buildMinetestPackage rec {
      type = "mod";
      pname = "online_craftguide";
      version = "2022-06-04";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "online_craftguide";
        release = 13171;
        versionName = "2022-06-04";
        sha256 = "04rzxnqld4hkvn0rnqczbv5xqs0ik3v54z2jc1f3xdgz044m0jyx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Generates a static craftguide website";

      };
    };

    "LMD"."place_limit" = buildMinetestPackage rec {
      type = "mod";
      pname = "place_limit";
      version = "rolling-10";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "place_limit";
        release = 5779;
        versionName = "rolling-10";
        sha256 = "164kjrgswp6388hcbgs5fxmnbisy0c8s7azlkr4s8xgxh06mrdwz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Limits node placement";

      };
    };

    "LMD"."playertags" = buildMinetestPackage rec {
      type = "mod";
      pname = "playertags";
      version = "rolling-9";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "playertags";
        release = 13910;
        versionName = "rolling-9";
        sha256 = "07i1ka2yh1crkk32mhim4bvxy0x989al73j1m3cshbr76zmcf1hy";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."MIT" ];
        description = "Adds player nametags floating above players.";

      };
    };

    "LMD"."respawn_timer" = buildMinetestPackage rec {
      type = "mod";
      pname = "respawn_timer";
      version = "rolling-7";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "respawn_timer";
        release = 12266;
        versionName = "rolling-7";
        sha256 = "0w1yfbkla4svwrxc7474z4hpbnp48pqdfsnnh2n235lz8v1pm8v1";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Forces players to wait a set duration before respawning";

      };
    };

    "LMD"."strictest" = buildMinetestPackage rec {
      type = "mod";
      pname = "strictest";
      version = "2022-07-05";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "strictest";
        release = 12724;
        versionName = "2022-07-05";
        sha256 = "1b82da440bn9i43yjhppriy54y68nvbp1b3llshlrwjgcgl6d7hj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Disallows questionable usage of the Lua API & Lua itself to help catch errors";

      };
    };

    "LMD"."texgen" = buildMinetestPackage rec {
      type = "mod";
      pname = "texgen";
      version = "rolling-2";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "texgen";
        release = 12486;
        versionName = "rolling-2";
        sha256 = "1xz1pwlcycc0mda4y1pa7xjfd29946a7ychwkl5scl5swiqaf903";
      };
      meta = src.meta // {
        license = [ spdx."MIT" lib.licenses.free ];
        description = "Dynamically generated texture packs";

      };
    };

    "LMD"."visible_wielditem" = buildMinetestPackage rec {
      type = "mod";
      pname = "visible_wielditem";
      version = "rolling-7";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "visible_wielditem";
        release = 12948;
        versionName = "rolling-7";
        sha256 = "06m27s17pr1x06c3fnd6shlrf8pqgnhflgjd84a8k8fplmbi51si";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Shows your wielditem";

      };
    };

    "LMD"."voxelizer" = buildMinetestPackage rec {
      type = "mod";
      pname = "voxelizer";
      version = "rolling-13";
      src = fetchFromContentDB {
        author = "LMD";
        technicalName = "voxelizer";
        release = 5780;
        versionName = "rolling-13";
        sha256 = "1n45iz6y6cmzi23w60i1az7l91hy12qi49krwpnrim894zsqqamz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Turns 3D models into astonishing voxel builds.";

      };
    };

    "LNJ"."drawers" = buildMinetestPackage rec {
      type = "mod";
      pname = "drawers";
      version = "v0.6.5";
      src = fetchFromContentDB {
        author = "LNJ";
        technicalName = "drawers";
        release = 11003;
        versionName = "v0.6.5";
        sha256 = "078vpnds4qf8pavmslaw9dlsrvrm2bg1r9ankfikvv279qxp10cg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adding simple storages for items, showing the item's inventory image in the front.";

      };
    };

    "LNJ"."jukebox" = buildMinetestPackage rec {
      type = "mod";
      pname = "jukebox";
      version = "1.0";
      src = fetchFromContentDB {
        author = "LNJ";
        technicalName = "jukebox";
        release = 13108;
        versionName = "1.0";
        sha256 = "13dmzwjfl9xz82shmqfr6yxybvybw781xcvvycxdsvynh5xspx0a";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A mod that adds a jukebox with nine different discs.";

      };
    };

    "LNJ"."lapis" = buildMinetestPackage rec {
      type = "mod";
      pname = "lapis";
      version = "2020-03-08";
      src = fetchFromContentDB {
        author = "LNJ";
        technicalName = "lapis";
        release = 12990;
        versionName = "2020-03-08";
        sha256 = "1clx355f863f6a9q7cg5y2ak03pbz6swpm7d186r6pirvv64kjvv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."WTFPL" ];
        description = "Adds lapis lazuli ore, items and blocks.";

      };
    };

    "LRV"."mcg_dyemixer" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcg_dyemixer";
      version = "0.6_beta";
      src = fetchFromContentDB {
        author = "LRV";
        technicalName = "mcg_dyemixer";
        release = 5972;
        versionName = "0.6_beta";
        sha256 = "05wppj0r8yckwwrjkvb1lqbnczz652xy8r10hbiih885yiglajxz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" spdx."WTFPL" ];
        description = "This mod removes the mixes of dyes and the crafting recipes that allow you to dye wool and make them craftable in the Dye Mixer.";

      };
    };

    "LRV"."mcg_lockworkshop" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcg_lockworkshop";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "LRV";
        technicalName = "mcg_lockworkshop";
        release = 14465;
        versionName = "2021-01-29";
        sha256 = "0mw73pzp3v6lmrv0q0ll34jmxhx7v2nw2k65214b9j6ymf3zz6mi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "This mod removes the crafts for locked and shared nodes and makes them craftable in the lock workshop via their unlocked/locked counterpart and a lock.";

      };
    };

    "Lahusen"."bread" = buildMinetestPackage rec {
      type = "mod";
      pname = "bread";
      version = "2022-02-01";
      src = fetchFromContentDB {
        author = "Lahusen";
        technicalName = "bread";
        release = 11015;
        versionName = "2022-02-01";
        sha256 = "0n5lnpvp3ka0rhzcc1mwp0h48x0fgjr7kbh1b076aaj6fdj362dr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Just my favourite bread recipes";

      };
    };

    "Lefty"."water_game" = buildMinetestPackage rec {
      type = "game";
      pname = "water_game";
      version = "Update_mod.conf";
      src = fetchFromContentDB {
        author = "Lefty";
        technicalName = "water_game";
        release = 8455;
        versionName = "Update mod.conf";
        sha256 = "0ddi1scg2rna9mgb88pwvimfyzss7x9jgrf5r8c6w5krm9x8ppf8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "A WIP game of underwater exploration and survival. ";

          homepage = "https://discord.gg/t9wQ3Qz";

      };
    };

    "Lejo"."adv_keys" = buildMinetestPackage rec {
      type = "mod";
      pname = "adv_keys";
      version = "remove_deprecated_depends.txt";
      src = fetchFromContentDB {
        author = "Lejo";
        technicalName = "adv_keys";
        release = 12323;
        versionName = "remove deprecated depends.txt";
        sha256 = "0zn24si7abym07fjawmwywc0rw8hklvsbhblp0plcjgfd70m8sw1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Replaces the Skeleton Key with one with multiple chests.";

      };
    };

    "Lejo"."playtime" = buildMinetestPackage rec {
      type = "mod";
      pname = "playtime";
      version = "1.2";
      src = fetchFromContentDB {
        author = "Lejo";
        technicalName = "playtime";
        release = 1615;
        versionName = "1.2";
        sha256 = "1dxn9d92ndfg6xq9y42cwy39l7f1l48jpmiimy6m6zfli37i50cx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Use /playtime to get the time you played";

      };
    };

    "Lejo"."reportlist" = buildMinetestPackage rec {
      type = "mod";
      pname = "reportlist";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Lejo";
        technicalName = "reportlist";
        release = 4118;
        versionName = "1.1";
        sha256 = "0h25rxz7sa3rlrz4rvfhhdni1x3b6lsbwhblir1pv3rv2f47da27";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A Report System to manage player reporting use /reportlist to view reports";

      };
    };

    "Lejo"."vps_blocker" = buildMinetestPackage rec {
      type = "mod";
      pname = "vps_blocker";
      version = "Make_nested_function_local";
      src = fetchFromContentDB {
        author = "Lejo";
        technicalName = "vps_blocker";
        release = 5012;
        versionName = "Make nested function local";
        sha256 = "0r1rqa2j0mqcypicqa31vj0ypbiafpsx3i98g75f818qbcfcrlii";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Block players using vpns, proxys or other hosting services";

      };
    };

    "LibraSubtilis"."minebase" = buildMinetestPackage rec {
      type = "game";
      pname = "minebase";
      version = "Initial_Release";
      src = fetchFromContentDB {
        author = "LibraSubtilis";
        technicalName = "minebase";
        release = 7815;
        versionName = "Initial Release";
        sha256 = "1baj530cn7y5mkbjl5f81rw5pdl9zygw15d93gfzxk7qk7ddg25z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "A basic exploration, mining, crafting and building sandbox game with no NPCs, monsters or animals.";

      };
    };

    "LibraSubtilis"."tortou" = buildMinetestPackage rec {
      type = "mod";
      pname = "tortou";
      version = "v3";
      src = fetchFromContentDB {
        author = "LibraSubtilis";
        technicalName = "tortou";
        release = 11808;
        versionName = "v3";
        sha256 = "0a5ys8s5fc8bz2iy168s08cs989h4vs3mxfzsi4ip60yg2nax12z";
      };
      meta = src.meta // {
        license = [ spdx."MIT" lib.licenses.free ];
        description = "Turtle graphics, hyperloop travelingsystem and cubic mobs.";

      };
    };

    "Liil"."12345" = buildMinetestPackage rec {
      type = "txp";
      pname = "12345";
      version = "Wilhelmines_Texture_Pack_V1.6";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "12345";
        release = 7468;
        versionName = "Wilhelmines Texture Pack V1.6";
        sha256 = "04vxqcz3f2fs8cfgszqa5iq74cng2a3pp87mdac2qw6mibdqfwbj";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Wilhelmines Texture Pack – Inspired by the colors of Nature!";

      };
    };

    "Liil"."animalworld" = buildMinetestPackage rec {
      type = "mod";
      pname = "animalworld";
      version = "Wilhelmines_Animalworld_V1.6";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "animalworld";
        release = 7467;
        versionName = "Wilhelmines Animalworld V1.6";
        sha256 = "1p6064ychjv4v72n091cnyq0szffh9gb20y0n3fx0zl6m4sdjcqr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various wild animals to your Minetest Game world.";

      };
    };

    "Liil"."livingfloatlands" = buildMinetestPackage rec {
      type = "mod";
      pname = "livingfloatlands";
      version = "Living_Floatlands_V1.1";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "livingfloatlands";
        release = 6859;
        versionName = "Living Floatlands V1.1";
        sha256 = "0fdr7wiks1dmw01kivpqjry8pzb6c9wrv5zg3854hj9a28jlb70n";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various prehistoric animals to your Floatland Zone, if you are using V7 Map Generator.";

      };
    };

    "Liil"."livingnether" = buildMinetestPackage rec {
      type = "mod";
      pname = "livingnether";
      version = "Wilhelmines_LivingNether_V1.1";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "livingnether";
        release = 6635;
        versionName = "Wilhelmines LivingNether V1.1";
        sha256 = "14rjyskmz179raam0zcn2jv438qh8jw911lgjc6hkqxw60pc2qnc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various creatures to your Nether.";

      };
    };

    "Liil"."nativevillages" = buildMinetestPackage rec {
      type = "mod";
      pname = "nativevillages";
      version = "NativeVillagesV0.5";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "nativevillages";
        release = 7404;
        versionName = "NativeVillagesV0.5";
        sha256 = "14mrd4ynqhshr0xi146r6gayn87j0pgfq8s7hsfv04gbyzdk609r";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds villages of native people to the world.";

      };
    };

    "Liil"."naturalbiomes" = buildMinetestPackage rec {
      type = "mod";
      pname = "naturalbiomes";
      version = "Natural_Biomes_V1.3";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "naturalbiomes";
        release = 13116;
        versionName = "Natural Biomes V1.3";
        sha256 = "0qj900238y1rnjzak78k4f3n1bq49sbn19ghrj6xrc4czwdiq3c9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds 7 new biomes";

      };
    };

    "Liil"."people" = buildMinetestPackage rec {
      type = "mod";
      pname = "people";
      version = "People_V_0.5_BETA";
      src = fetchFromContentDB {
        author = "Liil";
        technicalName = "people";
        release = 6771;
        versionName = "People V 0.5 BETA";
        sha256 = "0s0cvw7c7szkbr5ihaxcbhpclgyh21vw07gnwnwlb8pkv37lnsyg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds the possibility to build living Villages. Trade items for random stuff from your villagers, recruit mounts and warriors.";

      };
    };

    "Linuxdirk"."cement" = buildMinetestPackage rec {
      type = "mod";
      pname = "cement";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "cement";
        release = 13205;
        versionName = "2022-08-12";
        sha256 = "1jjr8bmmylr9i218cw4zga989bsxc8464sjl3g7zspsqqzhcif20";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A craftable and “makeable“ cement block.";

      };
    };

    "Linuxdirk"."hunger_ng" = buildMinetestPackage rec {
      type = "mod";
      pname = "hunger_ng";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "hunger_ng";
        release = 13204;
        versionName = "2022-08-12";
        sha256 = "0fh89s768mlci320ggrb910fz03269awx5qia58cvbwkpx1abf29";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "Hunger NG is a mod for Minetest adding a very customizable and easy to extend hunger system.";

          homepage = "https://4w.gitlab.io/hunger_ng/";

      };
    };

    "Linuxdirk"."imese" = buildMinetestPackage rec {
      type = "mod";
      pname = "imese";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "imese";
        release = 13203;
        versionName = "2022-08-12";
        sha256 = "0s3dqscffdq250h9d9zfidxll8jly800azxy5g9rm1cn09542zm2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Craft and use industrial Mese";

      };
    };

    "Linuxdirk"."mtimer" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtimer";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "mtimer";
        release = 13201;
        versionName = "2022-08-12";
        sha256 = "01pzhcshsw8kja35g9hw5lsyi3dgg0p8v64k7wgzf6wjcxbsv0ci";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Ingame timer for showing current playtime, current day time, ingame time, etc.";

      };
    };

    "Linuxdirk"."pixelart" = buildMinetestPackage rec {
      type = "mod";
      pname = "pixelart";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "pixelart";
        release = 13200;
        versionName = "2022-08-12";
        sha256 = "1p72kdl0cb8qw5av8g1z0p4qwypgjcdbvarc3jh6knw0g6pq90bi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "This mod adds nodes for pixelart grouped in color palettes to Minetest";

      };
    };

    "Linuxdirk"."playtime_limit" = buildMinetestPackage rec {
      type = "mod";
      pname = "playtime_limit";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "playtime_limit";
        release = 13199;
        versionName = "2022-08-12";
        sha256 = "1m2kxyjhk2nf37vf0s8clc2lhac2sjdp38fdv167yj0favicxrnx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Limit how long players are allowed to play";

          homepage = "https://gitlab.com/4w/playtime-limit";

      };
    };

    "Linuxdirk"."redef" = buildMinetestPackage rec {
      type = "mod";
      pname = "redef";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "redef";
        release = 13202;
        versionName = "2022-08-12";
        sha256 = "1wjsw3pvhvs28nakxmg8qjvbx6sd9qph1sabc1ar51mb8w0q57fb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Changes smaller things that are issues for either Minetest or Minetest Game that are technically fixable but won’t be fixed due to several non-technical reasons.";

          homepage = "https://gitlab.com/4w/redef/-/blob/master/README.md";

      };
    };

    "Linuxdirk"."sdwalls" = buildMinetestPackage rec {
      type = "mod";
      pname = "sdwalls";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "sdwalls";
        release = 13197;
        versionName = "2022-08-12";
        sha256 = "0qdr3hgky8byg828qq0pm1r11p24ba6mb53wxl718pc3wi6j66cn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "This mod adds modular flexible walls to Minetest.";

      };
    };

    "Linuxdirk"."uniham" = buildMinetestPackage rec {
      type = "mod";
      pname = "uniham";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "uniham";
        release = 13198;
        versionName = "2022-08-12";
        sha256 = "1klz5365z62pfa1kkq4sj97q9kp5nzn6acsh0p8vy23620nysxga";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Various hammers that can be used to crush nodes.";

      };
    };

    "Linuxdirk"."void" = buildMinetestPackage rec {
      type = "game";
      pname = "void";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "Linuxdirk";
        technicalName = "void";
        release = 13206;
        versionName = "2022-08-12";
        sha256 = "0wcig9sjsarv9162rlrnsmwb72zzjsbxs3qdi77h522jkfgr44v4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "The purpose of this game is to test mods in an absolutely “clean” environment with absolutely no “3rd-party” mods ";

      };
    };

    "LissoBone"."goodtorch" = buildMinetestPackage rec {
      type = "mod";
      pname = "goodtorch";
      version = "2022-08-30";
      src = fetchFromContentDB {
        author = "LissoBone";
        technicalName = "goodtorch";
        release = 13644;
        versionName = "2022-08-30";
        sha256 = "03c8d8vyvz727cv02k0fzypqzllqslvgk2g206qqkyig2cr6qj09";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Merely a flashlight that uses ray casting.";

      };
    };

    "LissoBone"."manhunt" = buildMinetestPackage rec {
      type = "mod";
      pname = "manhunt";
      version = "The_almost_fixed_release.";
      src = fetchFromContentDB {
        author = "LissoBone";
        technicalName = "manhunt";
        release = 14378;
        versionName = "The almost fixed release.";
        sha256 = "0hfvixxdvb79jfl8yv32b216lk7yqpjrmgz2fzhwpawkl801nb14";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Play with your friends and enemies in this exciting and popular manhunt game.";

      };
    };

    "Lokrates"."biofuel" = buildMinetestPackage rec {
      type = "mod";
      pname = "biofuel";
      version = "Biofuel_v0.7";
      src = fetchFromContentDB {
        author = "Lokrates";
        technicalName = "biofuel";
        release = 12552;
        versionName = "Biofuel v0.7";
        sha256 = "0xg0wg705nlhj358dfxgqj0k3a6nmzrs2svzsddwpab752gylhv3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Produce biofuel from unused plants.";

      };
    };

    "Lokrates"."polygonia" = buildMinetestPackage rec {
      type = "txp";
      pname = "polygonia";
      version = "2021-08-25";
      src = fetchFromContentDB {
        author = "Lokrates";
        technicalName = "polygonia";
        release = 9112;
        versionName = "2021-08-25";
        sha256 = "105n6kl05nbjqd62kcg2mywpk1qw02rhg4w1d1kq3gii6aylw0v5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A 256px texture pack created with Blender3D.";

      };
    };

    "Lone_Wolf"."3d_armor_mobile" = buildMinetestPackage rec {
      type = "mod";
      pname = "3d_armor_mobile";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "3d_armor_mobile";
        release = 425;
        versionName = "v1.1";
        sha256 = "0fm7890ixkxkx02yhzjyc726x7p69ghiind13ng96lifm6yqqsp7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a command to bring up a formspec that allows mobile users to put on armor";

      };
    };

    "Lone_Wolf"."fire_plus" = buildMinetestPackage rec {
      type = "mod";
      pname = "fire_plus";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "fire_plus";
        release = 6179;
        versionName = "v1.1";
        sha256 = "0wq8k9d1gwd69p95pgl69b2c4ri4qmgwj2ymda69qhzyv6g3z5mf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Allows players to be lit on fire.";

      };
    };

    "Lone_Wolf"."grenades" = buildMinetestPackage rec {
      type = "mod";
      pname = "grenades";
      version = "Version_0.9.6";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "grenades";
        release = 2622;
        versionName = "Version 0.9.6";
        sha256 = "07vifz6855qgp7a0az1m9380bib91i570mg1vhn52d81ldm9dhly";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an API for easily creating grenades";

      };
    };

    "Lone_Wolf"."grenades_basic" = buildMinetestPackage rec {
      type = "mod";
      pname = "grenades_basic";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "grenades_basic";
        release = 3081;
        versionName = "v1.0.1";
        sha256 = "1zxxvwr58d7j8yqfhlchxm1gmrsl7fakpgn7rr1j8r2l4166n9r6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds some basic grenades using the grenades API";

      };
    };

    "Lone_Wolf"."hammer_of_power" = buildMinetestPackage rec {
      type = "mod";
      pname = "hammer_of_power";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "hammer_of_power";
        release = 6277;
        versionName = "2021-01-29";
        sha256 = "1s818zy90mb9xhkgl6rxm92maz2fch7rnlkx3nmmdv18xzvrb2ns";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a steel hammer and the powerful version that you can create from it.";

      };
    };

    "Lone_Wolf"."headanim" = buildMinetestPackage rec {
      type = "mod";
      pname = "headanim";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "headanim";
        release = 8888;
        versionName = "v1.1";
        sha256 = "1ihg4rsbillg1wkq5a2gqy9pvipkrrmz1knbmjcaf4c5y5shncc9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Makes player heads follow their look direction";

      };
    };

    "Lone_Wolf"."knockback" = buildMinetestPackage rec {
      type = "mod";
      pname = "knockback";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "knockback";
        release = 2928;
        versionName = "Version 1.0";
        sha256 = "13cnkb584496ahagrkifm3r6dhf5ni0rbf8sq1dnic6x5l9faxml";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds knockback for pre-5.1 Minetest clients without using entities";

      };
    };

    "Lone_Wolf"."lavastuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "lavastuff";
      version = "v3.7.3";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "lavastuff";
        release = 11424;
        versionName = "v3.7.3";
        sha256 = "19hddv6b912cir5nj4vgnjrbk06j7z2flzgq1bqxhbkl69fablm3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds lava armor, tools, and blocks";

      };
    };

    "Lone_Wolf"."nc_rabbits" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_rabbits";
      version = "2021-06-24";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "nc_rabbits";
        release = 8191;
        versionName = "2021-06-24";
        sha256 = "16pck6za13m5h5b9w5mfyj649h57w5fb7m9qsjyis9mjzj2i78zd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds rabbit holes, rabbits, and traps to the Nodecore game";

      };
    };

    "Lone_Wolf"."notices" = buildMinetestPackage rec {
      type = "mod";
      pname = "notices";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "notices";
        release = 6292;
        versionName = "2021-01-29";
        sha256 = "0gg1rapzh6qxf1yvaj1hgqsbd5240llp0g398y0klflgi5ma2507";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds chatcommands server staff can use for announcements";

      };
    };

    "Lone_Wolf"."pm_sound" = buildMinetestPackage rec {
      type = "mod";
      pname = "pm_sound";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "pm_sound";
        release = 2931;
        versionName = "v1.2";
        sha256 = "0ya8zrgqc869f3g1prwh2npzrdj40pamd4rm2s5vj6jjhsqyy4zs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Colors Private messages in chat and plays a notification sound to players that are messaged";

      };
    };

    "Lone_Wolf"."voxel_knights" = buildMinetestPackage rec {
      type = "game";
      pname = "voxel_knights";
      version = "v0.1.5";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "voxel_knights";
        release = 5110;
        versionName = "v0.1.5";
        sha256 = "0frqrgznfnclc5623c2n4n9cmj901zy0vigswjh6802pd8z3r8aq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = " WIP Medival Fantasy Open World PvE game ";

      };
    };

    "Lone_Wolf"."wonderpick" = buildMinetestPackage rec {
      type = "mod";
      pname = "wonderpick";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Lone_Wolf";
        technicalName = "wonderpick";
        release = 6293;
        versionName = "2021-01-29";
        sha256 = "1mqcpnfsix2hvrcr9clc9nngsjrn2yjlc1plxnq3dsyndyzpvxl0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a pickaxe that can dig almost any block";

      };
    };

    "Lunovox"."lunolimits" = buildMinetestPackage rec {
      type = "mod";
      pname = "lunolimits";
      version = "Lunolimits_2020-04-17";
      src = fetchFromContentDB {
        author = "Lunovox";
        technicalName = "lunolimits";
        release = 3504;
        versionName = "Lunolimits 2020-04-17";
        sha256 = "1d5smvzblihs1k67p5zpkajjlslwi09j78qzx75x2fd5ph0sb1cp";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "If the player moves 500 blocks away from the public respawn (configurable distance), he will receive an audible warning and a warning graphic along with radiation damage (configurable damage).";

      };
    };

    "MCL"."chocolate" = buildMinetestPackage rec {
      type = "mod";
      pname = "chocolate";
      version = "2022-05-11";
      src = fetchFromContentDB {
        author = "MCL";
        technicalName = "chocolate";
        release = 13663;
        versionName = "2022-05-11";
        sha256 = "1p6ydp450x0yhsr22n3437jvz5q5j6qkqns6rs5pxwrs6ml9j1bb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "A mod that adds chocolate and chocolate-related items such as chocolate milk, chocolate blocks, etc.";

      };
    };

    "MCL"."coconut_collection" = buildMinetestPackage rec {
      type = "game";
      pname = "coconut_collection";
      version = "2022-10-09";
      src = fetchFromContentDB {
        author = "MCL";
        technicalName = "coconut_collection";
        release = 14259;
        versionName = "2022-10-09";
        sha256 = "0fl7nn7r6rslk813afpbahf2g2iih5c3qqaqvf4lmjs26pqklijm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-2.0-only" ];
        description = "A game heavily inspired by \"Coconut Hut\" for the Ouya.";

      };
    };

    "Majozoe"."grue" = buildMinetestPackage rec {
      type = "mod";
      pname = "grue";
      version = "The_Grue_mod_-_v1.0.1";
      src = fetchFromContentDB {
        author = "Majozoe";
        technicalName = "grue";
        release = 13209;
        versionName = "The Grue mod - v1.0.1";
        sha256 = "1hnw04ag0yqy7cwpaxy09j6dzhv15s3yv8zmblsf2fpfiidj641z";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "It is pitch black. You are likely to be eaten by a Grue.";

      };
    };

    "Mantar"."exile" = buildMinetestPackage rec {
      type = "game";
      pname = "exile";
      version = "v0.3.8d";
      src = fetchFromContentDB {
        author = "Mantar";
        technicalName = "exile";
        release = 13402;
        versionName = "v0.3.8d";
        sha256 = "185ylvr8kj35vxax1bhp7q57p2s4fxh0q65qdxqnxv2a64kdgb9y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Challenging, at times brutal, wilderness survival with simple technology. ";

          homepage = "https://exile.planetofnix.com/wiki/pmwiki.php?n=Main.HomePage";

      };
    };

    "Marnack"."dlxtrains" = buildMinetestPackage rec {
      type = "mod";
      pname = "dlxtrains";
      version = "1.9.1";
      src = fetchFromContentDB {
        author = "Marnack";
        technicalName = "dlxtrains";
        release = 13520;
        versionName = "1.9.1";
        sha256 = "0i26sj7cs7ylhqjn7qsw3lzvzfx9nhjhxg6m2jnvnr75353ssh4f";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Additional railway related content for use with Advanced Trains (advtrains).";

      };
    };

    "Mathias"."death_timer" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_timer";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Mathias";
        technicalName = "death_timer";
        release = 2162;
        versionName = "1.0.0";
        sha256 = "1dgjb0dzaldpvd2n9rzb0ixnsk5jzmr519dyz5pn2crs7q754xm3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Timer that adds a delay between deaths.";

      };
    };

    "Mathias"."minercantile" = buildMinetestPackage rec {
      type = "mod";
      pname = "minercantile";
      version = "5.3.0";
      src = fetchFromContentDB {
        author = "Mathias";
        technicalName = "minercantile";
        release = 6034;
        versionName = "5.3.0";
        sha256 = "1lrp2j9w9j12asd37c4j7wnqqc6144wixlzs6ziq8dxmxdgribl5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Economy featuring a primitive supply and demand system for exchanging goods.";

      };
    };

    "Maverick2797"."advtrains_portable_remote_control" = buildMinetestPackage rec {
      type = "mod";
      pname = "advtrains_portable_remote_control";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Maverick2797";
        technicalName = "advtrains_portable_remote_control";
        release = 12187;
        versionName = "1.0.1";
        sha256 = "1ch40ay78cpz69zkxjrraqkw16gwg18nqmz8k0jr5rw6jw38bs8g";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Handheld Remote Control for Advtrains";

      };
    };

    "Maverick2797"."mesecons_microphone" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_microphone";
      version = "2022-01-19";
      src = fetchFromContentDB {
        author = "Maverick2797";
        technicalName = "mesecons_microphone";
        release = 14452;
        versionName = "2022-01-19";
        sha256 = "1v29rrzn0ib4wf3pm441w7w2ay1rdzky5z7nm2bv4igy4mabk4rz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-3.0-only" ];
        description = "Chat-toggleable mesecons node.";

      };
    };

    "Menetorplayz"."def_style" = buildMinetestPackage rec {
      type = "txp";
      pname = "def_style";
      version = "Def-style";
      src = fetchFromContentDB {
        author = "Menetorplayz";
        technicalName = "def_style";
        release = 2334;
        versionName = "Def-style";
        sha256 = "1m033l7d8b6s8mcqgi76vb5girdl010fsqf47w4gmgqvw8zjxp1y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "(Pvp texture pack) A default edit of MT textures.";

      };
    };

    "MeseCraft"."bouncy_bed" = buildMinetestPackage rec {
      type = "mod";
      pname = "bouncy_bed";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "MeseCraft";
        technicalName = "bouncy_bed";
        release = 6308;
        versionName = "1.0.2";
        sha256 = "1ai3h1jl8c384h4j37gbzkd0y32b1xsy7rbv69gig2mxic6kfpza";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-3.0" ];
        description = "Simply makes beds bouncy.";

          homepage = "https://www.mesecraft.com";

      };
    };

    "MeseCraft"."mesecraft" = buildMinetestPackage rec {
      type = "game";
      pname = "mesecraft";
      version = "mesecraft-2022-09-27";
      src = fetchFromContentDB {
        author = "MeseCraft";
        technicalName = "mesecraft";
        release = 14074;
        versionName = "mesecraft-2022-09-27";
        sha256 = "0bnp0j99zig8h4wwm03i3cf5mgmh6vsgi4kpg8yl74gmglpq48ir";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "The best game for Minetest. A survival game with new depth, mechanics, biomes, mobs and many essential additions. Has a focus on being fun, user-friendly, stable, and minimalist but featured.";

          homepage = "https://www.mesecraft.com";

      };
    };

    "MeseCraft"."void_chest" = buildMinetestPackage rec {
      type = "mod";
      pname = "void_chest";
      version = "2022-07-19";
      src = fetchFromContentDB {
        author = "MeseCraft";
        technicalName = "void_chest";
        release = 12862;
        versionName = "2022-07-19";
        sha256 = "0n6ijpqlnjird15bx5zvzixabl2lmcs11ydi68qwjqdwr0nszaxc";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-4.0" ];
        description = "Access your belongings anywhere by using the power of the void chest!";

          homepage = "https://www.mesecraft.com/";

      };
    };

    "Methro"."methro_pack" = buildMinetestPackage rec {
      type = "txp";
      pname = "methro_pack";
      version = "2021-11-26";
      src = fetchFromContentDB {
        author = "Methro";
        technicalName = "methro_pack";
        release = 9774;
        versionName = "2021-11-26";
        sha256 = "0q5jldzg6nc92g0bawlcmqlnh6r4rsckmsgczrblxsb6ay4h342m";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A very nice texture pack based for PvP";

      };
    };

    "MightyAlex200"."witt" = buildMinetestPackage rec {
      type = "mod";
      pname = "witt";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "MightyAlex200";
        technicalName = "witt";
        release = 1045;
        versionName = "1.0.1";
        sha256 = "0s1vlm7dyxawlxkb3xkipikwnsvwgfxxx506danlnmmq3j8kf9j2";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Small indicator to show what the player is looking at.";

      };
    };

    "MikeRedwood"."ambient_light" = buildMinetestPackage rec {
      type = "mod";
      pname = "ambient_light";
      version = "Ambient_Light_v1.0";
      src = fetchFromContentDB {
        author = "MikeRedwood";
        technicalName = "ambient_light";
        release = 6567;
        versionName = "Ambient Light v1.0";
        sha256 = "1ga8v5d9ra03jxxajdgfdpn0im94h38hsl2c15bxh4fxj9jks1yy";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Makes all nodes lit to a small degree!";

      };
    };

    "MikeRedwood"."basic_anvil" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_anvil";
      version = "Basic_Anvil_v1.1";
      src = fetchFromContentDB {
        author = "MikeRedwood";
        technicalName = "basic_anvil";
        release = 6133;
        versionName = "Basic Anvil v1.1";
        sha256 = "040swznp37vqvb9vsbjz683m1fl18vcs8vmllp41py193c7d54hl";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds an easy tool repair craft";

      };
    };

    "MikeRedwood"."craftable_lava" = buildMinetestPackage rec {
      type = "mod";
      pname = "craftable_lava";
      version = "Craftable_Lava_v1.0";
      src = fetchFromContentDB {
        author = "MikeRedwood";
        technicalName = "craftable_lava";
        release = 5741;
        versionName = "Craftable Lava v1.0";
        sha256 = "0lvdngmk8iw3y5cn7cfh74ysvvy2xmkx9f8isdk9ghq5ic92sf5a";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Enables the crafting of lava from baked stone";

      };
    };

    "MikeRedwood"."simple_xray" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_xray";
      version = "X-ray_v1.1";
      src = fetchFromContentDB {
        author = "MikeRedwood";
        technicalName = "simple_xray";
        release = 7038;
        versionName = "X-ray v1.1";
        sha256 = "1l5rddw096aj8pmk5x17qmxh708kcawh4956ai7ihh670sjgw3ly";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Makes stone and desert stone see through, also works with nether mod";

      };
    };

    "MikeRedwood"."sticks_stones" = buildMinetestPackage rec {
      type = "mod";
      pname = "sticks_stones";
      version = "Sticks_Stones_v1.1";
      src = fetchFromContentDB {
        author = "MikeRedwood";
        technicalName = "sticks_stones";
        release = 5943;
        versionName = "Sticks Stones v1.1";
        sha256 = "0n7w9zn9zbm08xamxvy5i30zhahz03772yvm7mgfg8kkzh3jqsnv";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Makes Sticks from leaves and scatters small stones";

      };
    };

    "Mineminer"."technic_addons" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_addons";
      version = "Initial_Public_Release_";
      src = fetchFromContentDB {
        author = "Mineminer";
        technicalName = "technic_addons";
        release = 4856;
        versionName = "Initial Public Release ";
        sha256 = "1yavj06bf531sg08vpcz5hn26wks15xid5ihy63g2rqcgqvrcrhs";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds additional content to Technic. Currently adds mk2 and mk3 chainsaws and vacuums, as well as medium and large cans.";

          homepage = "https://playminetest.com";

      };
    };

    "Minetest"."minetest_game" = buildMinetestPackage rec {
      type = "game";
      pname = "minetest_game";
      version = "5.6.1";
      src = fetchFromContentDB {
        author = "Minetest";
        technicalName = "minetest_game";
        release = 13955;
        versionName = "5.6.1";
        sha256 = "0c5i68p9vcsb0pzx78favy84qvwxfbi8qgss3pmvq5ckdgbg4mmz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A lightweight and well-maintained base for modding";

      };
    };

    "Miniontoby"."doorbell" = buildMinetestPackage rec {
      type = "mod";
      pname = "doorbell";
      version = "Doorbell_1.6";
      src = fetchFromContentDB {
        author = "Miniontoby";
        technicalName = "doorbell";
        release = 2892;
        versionName = "Doorbell 1.6";
        sha256 = "12zscdi4jm2s0yjz93ysr31fpa70b5hfrzmqbhaln6z4117k7375";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "A doorbell mod with sound ";

      };
    };

    "Miniontoby"."qrcode" = buildMinetestPackage rec {
      type = "mod";
      pname = "qrcode";
      version = "2022-01-12";
      src = fetchFromContentDB {
        author = "Miniontoby";
        technicalName = "qrcode";
        release = 10582;
        versionName = "2022-01-12";
        sha256 = "15k15a6vyprm45ffz6p24y6y93rbx0hhs11ngld8zvjh8653052w";
      };
      meta = src.meta // {
        license = [ spdx."BSD-3-Clause" ];
        description = "Create QR Codes in your world";

      };
    };

    "Miniontoby"."title" = buildMinetestPackage rec {
      type = "mod";
      pname = "title";
      version = "title_1.1";
      src = fetchFromContentDB {
        author = "Miniontoby";
        technicalName = "title";
        release = 5055;
        versionName = "title 1.1";
        sha256 = "0f9q76f0pzfcpf5s5w56k943mq9vsyv58x4fzydx2kp0pi6rnh2f";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "A HUD Title mod";

      };
    };

    "MisterE"."balloon_bop" = buildMinetestPackage rec {
      type = "mod";
      pname = "balloon_bop";
      version = "2022-10-05";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "balloon_bop";
        release = 14206;
        versionName = "2022-10-05";
        sha256 = "17fcjb01m6xriik5w7n0nys568j3vzs8gjaddk38gws81dkiikk9";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Based on ExeVirus's Balloon Bash Ludum Dare submission, comes a minigame for Arena_lib all about Popping huge quantities of balloons and not letting them touch the ground.";

      };
    };

    "MisterE"."blockbomber" = buildMinetestPackage rec {
      type = "game";
      pname = "blockbomber";
      version = "2022-03-15";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "blockbomber";
        release = 11576;
        versionName = "2022-03-15";
        sha256 = "0r6vwy3qkz2jsb8bprf9n22ck7hj640gdg644z1aj0k7qjsibvzq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-only" ];
        description = "Battle your friends for power-ups and be the last blocker standing! A Multiplayer Bomberman clone.";

          homepage = "https://www.blockbomber.org";

      };
    };

    "MisterE"."blockbomber_editor" = buildMinetestPackage rec {
      type = "game";
      pname = "blockbomber_editor";
      version = "2022-03-08";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "blockbomber_editor";
        release = 11519;
        versionName = "2022-03-08";
        sha256 = "0pp86c2zjnqdn5rwmxx63x5rimyzzz5f63a78a14hccmdyrg20ll";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Make arenas for Blockbomber";

      };
    };

    "MisterE"."gems" = buildMinetestPackage rec {
      type = "mod";
      pname = "gems";
      version = "2022-10-18";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "gems";
        release = 14440;
        versionName = "2022-10-18";
        sha256 = "0k47dr10z29fnvjdxrrwk17mkfc4k0m6sasky2ab7pgny0cwr7sd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "2 and 4 team gems minigames like eggwars, but with different interesting mechanics";

      };
    };

    "MisterE"."grapple" = buildMinetestPackage rec {
      type = "mod";
      pname = "grapple";
      version = "2022-10-16";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "grapple";
        release = 14400;
        versionName = "2022-10-16";
        sha256 = "1h3dlilnjhvlz7iakpi184sk0svhxigjmwp1dvwb1c1w6a6qpmfm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "A grappling hook, especially for minigames";

      };
    };

    "MisterE"."karst_caverns" = buildMinetestPackage rec {
      type = "mod";
      pname = "karst_caverns";
      version = "1.0";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "karst_caverns";
        release = 12929;
        versionName = "1.0";
        sha256 = "0l8fzbx49wsk4a34bvbk1hzkhmg80ds42h84fsiwg4ib8lf407a6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A cavern generator that creates complex karst cavern systems, with rooms interconnected by multilevel tunnels. Experience the joy of caving. ";

      };
    };

    "MisterE"."quikbild" = buildMinetestPackage rec {
      type = "mod";
      pname = "quikbild";
      version = "2022-10-02";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "quikbild";
        release = 14147;
        versionName = "2022-10-02";
        sha256 = "0hg4q4kd1y4fciwikfsfcslww3rsk9aa82ji5bgl6r8shvdwm50l";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "quikbild Minigame";

      };
    };

    "MisterE"."sumo" = buildMinetestPackage rec {
      type = "mod";
      pname = "sumo";
      version = "2022-10-05";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "sumo";
        release = 14204;
        versionName = "2022-10-05";
        sha256 = "0770zilg9xddr5zapgkp8kzzy04yi14016wcrxn4qyicwqxg36r7";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Sumo Minigame (Arena_lib)";

      };
    };

    "MisterE"."wormball" = buildMinetestPackage rec {
      type = "mod";
      pname = "wormball";
      version = "2022-10-05";
      src = fetchFromContentDB {
        author = "MisterE";
        technicalName = "wormball";
        release = 14205;
        versionName = "2022-10-05";
        sha256 = "1gky4f1m5jzvd8gbq5rxvzqpcfxvl71wks0y1pzvlg4s1rvcfi30";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Wormball subgame";

      };
    };

    "MrBertram"."grass_instabreak" = buildMinetestPackage rec {
      type = "mod";
      pname = "grass_instabreak";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "MrBertram";
        technicalName = "grass_instabreak";
        release = 14015;
        versionName = "1.0.0";
        sha256 = "17ngyc4fyacrv4bdv7x1v3jf26jnpx8h5cxkh3dfcwr5qisgkwsf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Makes certain flora blocks instantly breakable by hand.";

      };
    };

    "MrDraxs"."autoclimb" = buildMinetestPackage rec {
      type = "mod";
      pname = "autoclimb";
      version = "Update2";
      src = fetchFromContentDB {
        author = "MrDraxs";
        technicalName = "autoclimb";
        release = 13593;
        versionName = "Update2";
        sha256 = "0i0x9mp6yyii54m7xg6la9jpr2ny5ipa4pr1knn9nyvckagjmfyr";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds autoclimb, idea by mrdraxs and code by ( FatalError, once again seasoned ) and ( ElCeejo ).";

      };
    };

    "MrFreeman"."colour_jump" = buildMinetestPackage rec {
      type = "mod";
      pname = "colour_jump";
      version = "2022-10-16";
      src = fetchFromContentDB {
        author = "MrFreeman";
        technicalName = "colour_jump";
        release = 14395;
        versionName = "2022-10-16";
        sha256 = "0z3fr9k3xmxwcb9lfnh8v89fyhnjsznhn2r5slng1b9mrsjnipvy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A simple minigame where the players need to jump on the correct platform to avoid to fall down";

          homepage = "https://gitlab.com/mrfreeman_works/ColourJump";

      };
    };

    "MysticTempest"."refi_textures" = buildMinetestPackage rec {
      type = "txp";
      pname = "refi_textures";
      version = "2022-09-17";
      src = fetchFromContentDB {
        author = "MysticTempest";
        technicalName = "refi_textures";
        release = 13900;
        versionName = "2022-09-17";
        sha256 = "1mgi84br71yj5v9d485c02xavm3lwwml9v71pss8xx2ca02zxvfv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "16px - Attempts to recapture the aesthetic of Minecraft, while improving upon visibility.";

      };
    };

    "NO11"."balloonair" = buildMinetestPackage rec {
      type = "game";
      pname = "balloonair";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "balloonair";
        release = 10150;
        versionName = "1.0.0";
        sha256 = "1by3in98n2px5gy2yzj646zwrbhdgkn7wynqhzdq3wc450a7mbqb";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A hot air balloon game created for the 2021 Minetest GAME JAM.";

      };
    };

    "NO11"."extreme_randomizer" = buildMinetestPackage rec {
      type = "mod";
      pname = "extreme_randomizer";
      version = "2021-09-25";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "extreme_randomizer";
        release = 9358;
        versionName = "2021-09-25";
        sha256 = "09j46fnn9zyr7nn1j910yg9yai4m5hyb9lqj0w7c03ljs07wh4h6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Randomises crafting, mob and block drops.";

      };
    };

    "NO11"."mcl_copper" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_copper";
      version = "2021-08-20";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_copper";
        release = 9011;
        versionName = "2021-08-20";
        sha256 = "0m3256z719iyx3x2zf9h25cm1capzb6w0nk7cxywqq5mch9j1ix6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds Copper Ore, blocks and items.";

      };
    };

    "NO11"."mcl_deepslate" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_deepslate";
      version = "2021-08-02";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_deepslate";
        release = 8741;
        versionName = "2021-08-02";
        sha256 = "04kav47ix54mb8j9jsaj8hw5w8ry82mzyy8whcw0rcj3ysl3bjnw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds 30 new deepslate blocks!";

      };
    };

    "NO11"."mcl_falling_anvils" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_falling_anvils";
      version = "2021-07-03";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_falling_anvils";
        release = 8334;
        versionName = "2021-07-03";
        sha256 = "1r24alpm4m5j1s6y0bv4z3lwfg28p2yk8xx8aq270r1vm2vkc7qv";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A survival challenge for Mineclone2.";

      };
    };

    "NO11"."mcl_more_ore_variants" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_more_ore_variants";
      version = "2021-09-06";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_more_ore_variants";
        release = 9235;
        versionName = "2021-09-06";
        sha256 = "083yfsmqb5v1m3gvirjlfp3k6d71n8j6v25gr6n7nd58rv642ijv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Make ores in stone like andesite or diorite look better.";

      };
    };

    "NO11"."mcl_nether_gold" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_nether_gold";
      version = "2021-07-11";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_nether_gold";
        release = 8451;
        versionName = "2021-07-11";
        sha256 = "130ansp49kz4kcvhwsdbdpnwbzg86z13rr5rpmx5f15wwi8bp6qh";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Nether Gold Ore ";

      };
    };

    "NO11"."mcl_raw_ores" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_raw_ores";
      version = "2021-06-26";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_raw_ores";
        release = 8218;
        versionName = "2021-06-26";
        sha256 = "01w2ghkizm77gy5d18rrx872gnmx0yg9r1rrlf9j9v5x7b6fd8c1";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds raw iron and raw gold.";

      };
    };

    "NO11"."mcl_spyglass" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_spyglass";
      version = "2021-07-23";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_spyglass";
        release = 8591;
        versionName = "2021-07-23";
        sha256 = "1z64cv21fnz7mj7pmzh7qx0dz2vvyml35zwg36gvdchrcw91mb6c";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "This adds a spyglass, which is an item that can be used for zooming in on specific locations.";

      };
    };

    "NO11"."mcl_underwater_challenge" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_underwater_challenge";
      version = "2021-08-27";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "mcl_underwater_challenge";
        release = 9147;
        versionName = "2021-08-27";
        sha256 = "0lmf6m6c7r75sdimrz77k5pvs30h5zsz5q869dpbq4afq4xyf99g";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A survival challenge for Mineclone2. Try to survive in a flooded world. ";

      };
    };

    "NO11"."oneblock" = buildMinetestPackage rec {
      type = "mod";
      pname = "oneblock";
      version = "2022-09-01";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "oneblock";
        release = 13664;
        versionName = "2022-09-01";
        sha256 = "1birkid04r16z0pbnwy1gfifnrfsx7ixb6255b1y348czv6h58rc";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Build your island in the sky with random items!";

      };
    };

    "NO11"."raining_items" = buildMinetestPackage rec {
      type = "mod";
      pname = "raining_items";
      version = "2021-08-17";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "raining_items";
        release = 8957;
        versionName = "2021-08-17";
        sha256 = "09qggh78jzcszyqk53zrm1gczi6hsdwk8bzkj535sbsi14m1ccxr";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Minetest, but its raining random items!";

      };
    };

    "NO11"."randomizer" = buildMinetestPackage rec {
      type = "mod";
      pname = "randomizer";
      version = "2021-08-23";
      src = fetchFromContentDB {
        author = "NO11";
        technicalName = "randomizer";
        release = 9077;
        versionName = "2021-08-23";
        sha256 = "0pikjpyfslabfpa5s5g5nqaacdmgzi9sa86phvwpkrzvszli9zm6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A survival challenge. Try to survive in a randomized world.";

      };
    };

    "Nathan.S"."drinks" = buildMinetestPackage rec {
      type = "mod";
      pname = "drinks";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Nathan.S";
        technicalName = "drinks";
        release = 6386;
        versionName = "2021-01-29";
        sha256 = "095q3g6f7y72fr9nsld8jmip0pfk1aw0j9qjy94gwar9pii5kxpb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a juice press and two juice storage containers.";

          homepage = "https://www.nathansalapat.com/minetest/drinks";

      };
    };

    "Nathan.S"."more_coral" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_coral";
      version = "2021-11-30";
      src = fetchFromContentDB {
        author = "Nathan.S";
        technicalName = "more_coral";
        release = 9818;
        versionName = "2021-11-30";
        sha256 = "0a8nq4x7wnxi3dwrzsv8sdcksljv9k59jmi6bv0a3fm9v23wa587";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds coral in more colors.";

      };
    };

    "Nathan.S"."mylandscaping" = buildMinetestPackage rec {
      type = "mod";
      pname = "mylandscaping";
      version = "1.6";
      src = fetchFromContentDB {
        author = "Nathan.S";
        technicalName = "mylandscaping";
        release = 999;
        versionName = "1.6";
        sha256 = "0a18kqa02641n680ry38x0v22wz0fcg5ghbadjmdl6jl156sr4q4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Lets you put up decorative walls around your gardens, and make pretty hardscapes.";

          homepage = "http://www.nathansalapat.com/minetest/mylandscaping";

      };
    };

    "Nathan.S"."survival" = buildMinetestPackage rec {
      type = "mod";
      pname = "survival";
      version = "2022-08-10";
      src = fetchFromContentDB {
        author = "Nathan.S";
        technicalName = "survival";
        release = 13128;
        versionName = "2022-08-10";
        sha256 = "03y59s5y8bv3sx514lak93rh88x16fq7ywqwd5z9pq6dr55a3p1a";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds several survival related items.";

      };
    };

    "Nathan.S"."tombs" = buildMinetestPackage rec {
      type = "mod";
      pname = "tombs";
      version = "2021-08-18";
      src = fetchFromContentDB {
        author = "Nathan.S";
        technicalName = "tombs";
        release = 8969;
        versionName = "2021-08-18";
        sha256 = "1vrbz06z0nx0nrsjwwfkm4bqlsdd2nxpk88jvj9ardkjbm09vwp8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds many shapes and styles of tombstones.";

          homepage = "http://www.nathansalapat.com/minetest/tombs";

      };
    };

    "NathanielFreeman"."emeraldbank" = buildMinetestPackage rec {
      type = "mod";
      pname = "emeraldbank";
      version = "1.3.0";
      src = fetchFromContentDB {
        author = "NathanielFreeman";
        technicalName = "emeraldbank";
        release = 11555;
        versionName = "1.3.0";
        sha256 = "1idli96hqykrb2fscfmyx61qahqmxws30w0931r0i59674k9dlj8";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC0-1.0" ];
        description = "Keep your Emeralds in a Bank";

      };
    };

    "Nicu"."wetmud" = buildMinetestPackage rec {
      type = "mod";
      pname = "wetmud";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Nicu";
        technicalName = "wetmud";
        release = 13074;
        versionName = "1.0";
        sha256 = "13qs9w3jibysjgl3pjzgf8d04hwcz506xs57gplh1yvbyvmwra10";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."GPL-3.0-or-later" ];
        description = "Hydrates farmland without using water directly";

      };
    };

    "Niden"."death_coords" = buildMinetestPackage rec {
      type = "mod";
      pname = "death_coords";
      version = "Commands";
      src = fetchFromContentDB {
        author = "Niden";
        technicalName = "death_coords";
        release = 14333;
        versionName = "Commands";
        sha256 = "09w06lrfzdk5fv8zn56iwvxs6s17k4n0ijghj372x4kaq7m1y23k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Show Death Coordinates";

          homepage = "https://universal-network.xyz";

      };
    };

    "Nigel"."symmetool" = buildMinetestPackage rec {
      type = "mod";
      pname = "symmetool";
      version = "Ready_For_Action_v1.6";
      src = fetchFromContentDB {
        author = "Nigel";
        technicalName = "symmetool";
        release = 2411;
        versionName = "Ready For Action v1.6";
        sha256 = "1v11x63imhisk1pxb4graldl3bb42a1iq7vf4sn7mkl0s1l6ydab";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Symmetric building tool for MineTest.";

          homepage = "https://github.com/nyje/symmetool/blob/master/README.md";

      };
    };

    "Nigel"."vbots" = buildMinetestPackage rec {
      type = "mod";
      pname = "vbots";
      version = "v1.2_Bugfix_release";
      src = fetchFromContentDB {
        author = "Nigel";
        technicalName = "vbots";
        release = 1790;
        versionName = "v1.2 Bugfix release";
        sha256 = "158ksimz0zj8g8d9av317xrpg6s9jbcr2z1g1fqif0x0wxwvcs10";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Visually programmable turtle bots";

          homepage = "https://github.com/nyje/visual-bots/blob/1.0_Stable/README.md";

      };
    };

    "Niklp"."colored_concrete" = buildMinetestPackage rec {
      type = "mod";
      pname = "colored_concrete";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Niklp";
        technicalName = "colored_concrete";
        release = 14332;
        versionName = "1.0.0";
        sha256 = "069wjpr9qfpknbabwggs0yxf0m1s6lrvf0kv7l2mmv6swc0vvkri";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds colored concrete.";

      };
    };

    "NoctisLabs"."an_televator" = buildMinetestPackage rec {
      type = "mod";
      pname = "an_televator";
      version = "Televator_1.0";
      src = fetchFromContentDB {
        author = "NoctisLabs";
        technicalName = "an_televator";
        release = 2186;
        versionName = "Televator 1.0";
        sha256 = "0a7yab10s4vas2wwqylm9i7jldb9a45mw3pr8gnx3w0vf4aazgfl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Simple lag-free teleporting elevators.";

      };
    };

    "Noodlemire"."clumpfall" = buildMinetestPackage rec {
      type = "mod";
      pname = "clumpfall";
      version = "1.3.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "clumpfall";
        release = 9072;
        versionName = "1.3.0";
        sha256 = "1azqmxi1axy640dx3jnffpm44a1lzvwz0d6rjxkjwgbvapnz4w5z";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Makes most nodes able to fall without enough support.";

      };
    };

    "Noodlemire"."entitycontrol" = buildMinetestPackage rec {
      type = "mod";
      pname = "entitycontrol";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "entitycontrol";
        release = 2737;
        versionName = "1.0.0";
        sha256 = "0pa637z1rzra2akshpsax68l2hc5ss4jlmbbaj03av8irgc48dkr";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "Adds functions to override and unregister entities.";

      };
    };

    "Noodlemire"."lua_inv" = buildMinetestPackage rec {
      type = "mod";
      pname = "lua_inv";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "lua_inv";
        release = 9208;
        versionName = "1.0.2";
        sha256 = "0xhvw48411qqcxfdrl0d0b3g20vdw5576vri13d59r74wby8f2zv";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Creates a completely custom inventory system, which doesn't rely at all on any of the usual UserData objects.";

      };
    };

    "Noodlemire"."nd_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "nd_tools";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "nd_tools";
        release = 9079;
        versionName = "1.0.0";
        sha256 = "1zwlwaa29dlbww31hvf3q428qcx76xb813a40rw355zppczywnqf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Overrides pre-existing tools to make them cause persistent node damage.";

      };
    };

    "Noodlemire"."node_damage" = buildMinetestPackage rec {
      type = "mod";
      pname = "node_damage";
      version = "1.0.3";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "node_damage";
        release = 9078;
        versionName = "1.0.3";
        sha256 = "1hzg83af9ca2ai17pgiklysq9a59kblw52rm9j64hcmy0r75z35b";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Enables nodes to be partially damaged, and to be repaired afterwards.";

      };
    };

    "Noodlemire"."placeable_buckets" = buildMinetestPackage rec {
      type = "mod";
      pname = "placeable_buckets";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "placeable_buckets";
        release = 9070;
        versionName = "1.0.1";
        sha256 = "1rl4r9z15i0d3zgsqpwpb6qxaxhn5fs6j7i0vzb6g61f1mz24vps";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Allows empty buckets to be placed as nodes in order to collect rainwater.";

      };
    };

    "Noodlemire"."projectile" = buildMinetestPackage rec {
      type = "mod";
      pname = "projectile";
      version = "1.1.3";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "projectile";
        release = 4832;
        versionName = "1.1.3";
        sha256 = "00w3g4cmnfgwj98sz4i1w8ic73q4zgwabbhaify49pbialfyyd5k";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds various projectile weapons which work based off of MT 5.3.0's new collision info provided to objects' on_step functions.";

      };
    };

    "Noodlemire"."rnd" = buildMinetestPackage rec {
      type = "mod";
      pname = "rnd";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "rnd";
        release = 4583;
        versionName = "1.1.0";
        sha256 = "13jw5wv4jhscbzlkqa1lh2n812cr8j3rwlxjnj9wg9i82krrhhyl";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Obtain and research enough of a specific item to unlock the ability to infinitely duplicate it.";

      };
    };

    "Noodlemire"."smart_vector_table" = buildMinetestPackage rec {
      type = "mod";
      pname = "smart_vector_table";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "smart_vector_table";
        release = 9157;
        versionName = "1.0.0";
        sha256 = "0g0zw8p2xs9qy27j9jqyys7fm6m245p5b36jlf31kf638vmp9dqz";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "API that adds a way to create tables indexed by 3D Vectors.";

      };
    };

    "Noodlemire"."voxeldungeon" = buildMinetestPackage rec {
      type = "game";
      pname = "voxeldungeon";
      version = "1.6.1";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "voxeldungeon";
        release = 9212;
        versionName = "1.6.1";
        sha256 = "1rwg2swq8jrnmq8kfirxnmn7nbg13g6lhb4zq5m08k86vfv1j0zl";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "This is a recreation and adaptation of an Android rogue-like game, Pixel Dungeon by Watabou.";

      };
    };

    "Noodlemire"."voxelmodel" = buildMinetestPackage rec {
      type = "mod";
      pname = "voxelmodel";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Noodlemire";
        technicalName = "voxelmodel";
        release = 4969;
        versionName = "1.0.0";
        sha256 = "04qwy6p353a8wnlhl4r7nhr2c8cgxh6s61zvv7z3wnm6js7ik6jc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Provides voxelmodel.obj, a model designed to be shaped by changing its texture, in order to easily create fancy voxelized models.";

      };
    };

    "Nore"."mg" = buildMinetestPackage rec {
      type = "mod";
      pname = "mg";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Nore";
        technicalName = "mg";
        release = 13143;
        versionName = "2021-01-29";
        sha256 = "05vsm4qwwk3696526g9vbiyxnqjvm8mqjxnzm2fr1avfw14q2ynr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Changes the way ores are placed, add new biomes and villages.";

      };
    };

    "OgelGames"."digicontrol" = buildMinetestPackage rec {
      type = "mod";
      pname = "digicontrol";
      version = "v1.0.0";
      src = fetchFromContentDB {
        author = "OgelGames";
        technicalName = "digicontrol";
        release = 9015;
        versionName = "v1.0.0";
        sha256 = "0dq5m2yrnl96cr3n9zn63wlg4kygi9hvb9cbkmqrad8caqdr52ya";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds nodes to control the flow of digiline messages";

      };
    };

    "OgelGames"."headlamp" = buildMinetestPackage rec {
      type = "mod";
      pname = "headlamp";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "OgelGames";
        technicalName = "headlamp";
        release = 11435;
        versionName = "v1.0.1";
        sha256 = "17k7azrdcbw3y7c743zmpslzr307djvw3g4aqy8bia383ml1411f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds a headlamp that can be worn as armor, providing a bright light source";

      };
    };

    "OgelGames"."minimap_radar" = buildMinetestPackage rec {
      type = "mod";
      pname = "minimap_radar";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "OgelGames";
        technicalName = "minimap_radar";
        release = 9976;
        versionName = "v1.0.1";
        sha256 = "12my281y3bjv4ll4px982f5xcf7w0ybf9hry7sgckhd14mjv6n6i";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A simple mod that enables the use of the minimap radar with a craftable item";

      };
    };

    "OgelGames"."obsidianstuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "obsidianstuff";
      version = "v1.0.0";
      src = fetchFromContentDB {
        author = "OgelGames";
        technicalName = "obsidianstuff";
        release = 9977;
        versionName = "v1.0.0";
        sha256 = "1sf09l08s911qm0ylahddhq0plvzkv0dm480j4yfbi9pxz5i14ar";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds obsidian tools and armor";

      };
    };

    "OgelGames"."powerbanks" = buildMinetestPackage rec {
      type = "mod";
      pname = "powerbanks";
      version = "v1.0.4";
      src = fetchFromContentDB {
        author = "OgelGames";
        technicalName = "powerbanks";
        release = 12489;
        versionName = "v1.0.4";
        sha256 = "01lgy09296s3d140znvfq1fiivwqmxdw5xydzvm5vk9a9phh266p";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds portable powerbanks used to charge technic tools";

      };
    };

    "OttoPattemore"."colored_leaves" = buildMinetestPackage rec {
      type = "mod";
      pname = "colored_leaves";
      version = "2022-06-03";
      src = fetchFromContentDB {
        author = "OttoPattemore";
        technicalName = "colored_leaves";
        release = 12449;
        versionName = "2022-06-03";
        sha256 = "01j7wlnlzl1r5srrrvksjilvi8l4li90q3dxnh4y32wn6l13y3ns";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds several colors of leaves";

          homepage = "https://github.com/OttoPattemore/colored_leaves";

      };
    };

    "Oxalis"."creativefuel" = buildMinetestPackage rec {
      type = "mod";
      pname = "creativefuel";
      version = "08_09_2021";
      src = fetchFromContentDB {
        author = "Oxalis";
        technicalName = "creativefuel";
        release = 9258;
        versionName = "08/09/2021";
        sha256 = "1m404jcsxkcwfr4gbkgma78flpb56ag1zsc4kf9270kggydzsc1v";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "infinite fuel";

      };
    };

    "Palige"."moremesecons" = buildMinetestPackage rec {
      type = "mod";
      pname = "moremesecons";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "Palige";
        technicalName = "moremesecons";
        release = 13137;
        versionName = "2021-01-29";
        sha256 = "0r5jk2545iwk2irdjivlbrix7j1ry07pwzlq8r54l2h29jmv0d80";
      };
      meta = src.meta // {
        license = [ spdx."MPL-2.0" spdx."WTFPL" ];
        description = "Adds more Mesecons items.";

      };
    };

    "Palige"."throwing" = buildMinetestPackage rec {
      type = "mod";
      pname = "throwing";
      version = "2020-08-14";
      src = fetchFromContentDB {
        author = "Palige";
        technicalName = "throwing";
        release = 6388;
        versionName = "2020-08-14";
        sha256 = "10059jh2bhkavg65n5vj8s75cijhy06ib6mhhfm7palrfghrrfp4";
      };
      meta = src.meta // {
        license = [ spdx."MPL-2.0" ];
        description = "New throwing implementation designed to be extensible";

      };
    };

    "Panquesito7"."cloud_items" = buildMinetestPackage rec {
      type = "mod";
      pname = "cloud_items";
      version = "2022-03-23";
      src = fetchFromContentDB {
        author = "Panquesito7";
        technicalName = "cloud_items";
        release = 13163;
        versionName = "2022-03-23";
        sha256 = "1an4cyc0n8xz3z3jak8wni3lzmc17rrsy1v5bw7yj7hbdz7qrrid";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Powerful cloud tools.";

      };
    };

    "Panquesito7"."lib_mount" = buildMinetestPackage rec {
      type = "mod";
      pname = "lib_mount";
      version = "2021-11-15";
      src = fetchFromContentDB {
        author = "Panquesito7";
        technicalName = "lib_mount";
        release = 13158;
        versionName = "2021-11-15";
        sha256 = "07zm01fn30jrmfns2csh50mxz7512gdqxn38sj6wk30p4ck0b3kh";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "API Framework for mounting objects.";

      };
    };

    "Panquesito7"."vehicle_mash" = buildMinetestPackage rec {
      type = "mod";
      pname = "vehicle_mash";
      version = "2022-06-28";
      src = fetchFromContentDB {
        author = "Panquesito7";
        technicalName = "vehicle_mash";
        release = 12646;
        versionName = "2022-06-28";
        sha256 = "01940c9rhhj6mlj8czayan1yk9i2y4sh0v6qgchlnhaz16yx44sm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-NC-SA-3.0" spdx."WTFPL" ];
        description = "Adds many types of vehicles: cars, boats, hovercrafts and more.";

      };
    };

    "PetiAPocok"."minetest_extended" = buildMinetestPackage rec {
      type = "game";
      pname = "minetest_extended";
      version = "1.2";
      src = fetchFromContentDB {
        author = "PetiAPocok";
        technicalName = "minetest_extended";
        release = 7305;
        versionName = "1.2";
        sha256 = "0qcc4yny4zkni7mczqcq79h76kzz5qi1dizf66nqd2xs5mlapg2a";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "The extended version of the default Minetest Game.";

      };
    };

    "Phii"."pilzmod" = buildMinetestPackage rec {
      type = "mod";
      pname = "pilzmod";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "Phii";
        technicalName = "pilzmod";
        release = 12819;
        versionName = "1.0.4";
        sha256 = "0cnaxa2913l0f3x36pn7xpr46v0qrc2amprsmj4mhhgs19jmv7l0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "a spreading mushroom biome which you can spawn into the world, with its own monsters and a boss you need to slay to stop the biome's growth. Best played with bow & armor mod and after reading manual.";

          homepage = "https://github.com/phseiff/pilzmod/blob/main/documentation/pilzmod.pdf";

      };
    };

    "Piezo_"."hangglider" = buildMinetestPackage rec {
      type = "mod";
      pname = "hangglider";
      version = "2019_4_1";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "hangglider";
        release = 1269;
        versionName = "2019_4_1";
        sha256 = "0c8gc4yqdpxbai7lmnngqdwp54c9x7rl5p1hj5zq2yfd0zbl800m";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Fly around with fully functional hang-gliders!";

      };
    };

    "Piezo_"."illumination" = buildMinetestPackage rec {
      type = "mod";
      pname = "illumination";
      version = "2019_3_3";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "illumination";
        release = 1091;
        versionName = "2019_3_3";
        sha256 = "1qknq4sqq366a58r27fibjii3qd33p3gvbdbrcdcvrd3w78hm7w1";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Causes players to emit light while holding any luminescent node.";

      };
    };

    "Piezo_"."instant_ores" = buildMinetestPackage rec {
      type = "mod";
      pname = "instant_ores";
      version = "2019_5_9";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "instant_ores";
        release = 1418;
        versionName = "2019_5_9";
        sha256 = "0qy5lw9wwp25msnrn1h9jj64lnqcr4lc09ikr332kknbn9j7d4pm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "A tool for registering entire materials, complete with ore generation, tool-sets and automatically generated sprites with almost no effort required";

      };
    };

    "Piezo_"."kotatsu_table" = buildMinetestPackage rec {
      type = "mod";
      pname = "kotatsu_table";
      version = "2019_5_31";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "kotatsu_table";
        release = 1528;
        versionName = "2019_5_31";
        sha256 = "1l3l93gvanpy3ypp4mmrypvdv2ijsh4ig74bn421d0n5s949ddhw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds a new piece of furniture based on Japanese kotatsu tables";

      };
    };

    "Piezo_"."meseportals" = buildMinetestPackage rec {
      type = "mod";
      pname = "meseportals";
      version = "2019_5_22";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "meseportals";
        release = 1476;
        versionName = "2019_5_22";
        sha256 = "1s2ibhlxq228m57q2npqlpafx5q0gkq13pixzj6g9d8fzw5zjv8i";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A futuristic multiplayer transportation system";

      };
    };

    "Piezo_"."minetest_systemd" = buildMinetestPackage rec {
      type = "mod";
      pname = "minetest_systemd";
      version = "2019_5_19-R";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "minetest_systemd";
        release = 1460;
        versionName = "2019_5_19-R";
        sha256 = "0m9xr90bhyb662x2bmbmgr8rpq874q9zyfkbhzk7361sk92lix4z";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Debugging utility and compatibility tools for server owners and/or modpack creators";

      };
    };

    "Piezo_"."rainbarrel" = buildMinetestPackage rec {
      type = "mod";
      pname = "rainbarrel";
      version = "2019_3_3";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "rainbarrel";
        release = 1092;
        versionName = "2019_3_3";
        sha256 = "1yzw04a63vgwn388lj455zd2z6mcv3920nyxyzmqbarn1amrcx0f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Replaces overpowered \"water generators\" with a unique water-harvesting system";

      };
    };

    "Piezo_"."tmw_slimes" = buildMinetestPackage rec {
      type = "mod";
      pname = "tmw_slimes";
      version = "2019_5_22";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "tmw_slimes";
        release = 1474;
        versionName = "2019_5_22";
        sha256 = "0m1g5z2jbcp0kki2f5acwvjd40xrdvmw26v1c6a0jbx99jjb4bgw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds several types of slimes inspired by TheManaWorld";

      };
    };

    "Piezo_"."unique_ores" = buildMinetestPackage rec {
      type = "mod";
      pname = "unique_ores";
      version = "2019_3_3";
      src = fetchFromContentDB {
        author = "Piezo_";
        technicalName = "unique_ores";
        release = 1101;
        versionName = "2019_3_3";
        sha256 = "048ix7fpchl3drzgzjri3md4s0righnc57g70zg7k8j9j7wzy3ll";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Adds two randomly created ores to each world with varying properties depending on the world's seed";

      };
    };

    "PilzAdam"."airsword" = buildMinetestPackage rec {
      type = "mod";
      pname = "airsword";
      version = "2018-07-10";
      src = fetchFromContentDB {
        author = "PilzAdam";
        technicalName = "airsword";
        release = 407;
        versionName = "2018-07-10";
        sha256 = "1m8rc30msygq2sh88crcvkq5a69ag96lgqd8sr4i46pvkphx6dzz";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds the legendary air sword!";

      };
    };

    "PilzAdam"."nether" = buildMinetestPackage rec {
      type = "mod";
      pname = "nether";
      version = "v3.3";
      src = fetchFromContentDB {
        author = "PilzAdam";
        technicalName = "nether";
        release = 11303;
        versionName = "v3.3";
        sha256 = "1003pmnclnqjay86qyp2zh9bkn6q8zb1cwl9gx44zdxxjqny033y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."ISC" ];
        description = "Adds a deep underground realm with different mapgen that you can reach with obsidian portals.";

      };
    };

    "PolySaken"."ocular_networks" = buildMinetestPackage rec {
      type = "mod";
      pname = "ocular_networks";
      version = "11.0.59";
      src = fetchFromContentDB {
        author = "PolySaken";
        technicalName = "ocular_networks";
        release = 5817;
        versionName = "11.0.59";
        sha256 = "0vz3lcxlpmpnycmcgbqa3pr9zyw6yyxfl2vkjqxl66xclxw6dis3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Draw power from the world, and use it to power machines and tools.";

      };
    };

    "PolySaken"."poly_decor" = buildMinetestPackage rec {
      type = "mod";
      pname = "poly_decor";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "PolySaken";
        technicalName = "poly_decor";
        release = 8514;
        versionName = "2021-01-29";
        sha256 = "192pff68ns8vx1p1qhjm5mf4nqnafskr7r76qf0znlr60z1if9ya";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "My spin on decorative stuff.";

      };
    };

    "PolySaken"."vision_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "vision_lib";
      version = "1.8";
      src = fetchFromContentDB {
        author = "PolySaken";
        technicalName = "vision_lib";
        release = 5818;
        versionName = "1.8";
        sha256 = "0rjqqf7mp6ckvw9j7dvwh8q4pz5n6ymi4yqj995sm2dynq776dvi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Common library for PolySaken's mods.";

      };
    };

    "PrairieWind"."color_blocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "color_blocks";
      version = "Color_Blocks_V1.2";
      src = fetchFromContentDB {
        author = "PrairieWind";
        technicalName = "color_blocks";
        release = 5402;
        versionName = "Color Blocks V1.2";
        sha256 = "0yyla9ymm6jp52cp23rqzsf9qk8mywq5zdbpvq1pn3g6j5cbg3p5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Contains colored building blocks.";

      };
    };

    "PrairieWind"."mcl_extra_structures" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_extra_structures";
      version = "Release_1.2.0";
      src = fetchFromContentDB {
        author = "PrairieWind";
        technicalName = "mcl_extra_structures";
        release = 14492;
        versionName = "Release 1.2.0";
        sha256 = "0lmdq0imzvfd6y719j79dxr9791dkqr7qiv5m1kgblbj06lh8jgy";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds extra structures to MineClone2";

      };
    };

    "PrairieWind"."mcl_fish_traps" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_fish_traps";
      version = "Release_1.0.1";
      src = fetchFromContentDB {
        author = "PrairieWind";
        technicalName = "mcl_fish_traps";
        release = 13430;
        versionName = "Release 1.0.1";
        sha256 = "1v8lm500wdcbjlwmpb68hrbfvaa3xbkwi3ajwpap2myh012f6sfy";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds fishing traps to MineClone 2";

      };
    };

    "PrairieWind"."mcl_xp_atm" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_xp_atm";
      version = "Release_1.0.0";
      src = fetchFromContentDB {
        author = "PrairieWind";
        technicalName = "mcl_xp_atm";
        release = 13513;
        versionName = "Release 1.0.0";
        sha256 = "0blkdj782f8v40x1nlhy9jnkvh1s2xkqja798pr316p2r7p5zzka";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds experience atms to MineClone 2";

      };
    };

    "PrairieWind"."technic_diamond" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_diamond";
      version = "Fix_Diamond_Dust_Texture";
      src = fetchFromContentDB {
        author = "PrairieWind";
        technicalName = "technic_diamond";
        release = 12521;
        versionName = "Fix Diamond Dust Texture";
        sha256 = "0061pw7wk8hxp3xkar8ki5jb9rjv565rmkzl578v71llyv3nryx6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Use technic to grind and compress diamonds.";

      };
    };

    "Psyco"."uwu" = buildMinetestPackage rec {
      type = "mod";
      pname = "uwu";
      version = "1.1.3";
      src = fetchFromContentDB {
        author = "Psyco";
        technicalName = "uwu";
        release = 8813;
        versionName = "1.1.3";
        sha256 = "1cchwm2wdy1rxbfvz4pkz0rxnmlmaq5mrxvsigij138vac3q400v";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Add UwU block, uwu crystal ores, uwu tools and more.";

          homepage = "https://www.gnu.org/";

      };
    };

    "Pudding"."standart_textures" = buildMinetestPackage rec {
      type = "txp";
      pname = "standart_textures";
      version = "Ores__lumps_and_ingots";
      src = fetchFromContentDB {
        author = "Pudding";
        technicalName = "standart_textures";
        release = 13633;
        versionName = "Ores, lumps and ingots";
        sha256 = "1zy4f2jynf4yxxsg0lip3yydvf0c8i8qk45dxi5n77bcsqj1b91k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A 2D texturepack, made with gimp";

      };
    };

    "Pyrollo"."digiterms" = buildMinetestPackage rec {
      type = "mod";
      pname = "digiterms";
      version = "v0.2";
      src = fetchFromContentDB {
        author = "Pyrollo";
        technicalName = "digiterms";
        release = 1442;
        versionName = "v0.2";
        sha256 = "07qc15pp295jd5nicwfj54gxijfyv64kpaxczfdcpwmika379n8a";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "8bits style monitor and keyboards using digilines";

      };
    };

    "Pyrollo"."display_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "display_modpack";
      version = "2020-12-05";
      src = fetchFromContentDB {
        author = "Pyrollo";
        technicalName = "display_modpack";
        release = 6379;
        versionName = "2020-12-05";
        sha256 = "0423r4wf95hz61aylnifxwhwjlyv5ml10az690gmmd5rwrpy7rfq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Display modpack provides mods with dynamic display (signs, clocks, steles) and api to manage font and display";

      };
    };

    "Pyrollo"."font_botic" = buildMinetestPackage rec {
      type = "mod";
      pname = "font_botic";
      version = "2022-08-27";
      src = fetchFromContentDB {
        author = "Pyrollo";
        technicalName = "font_botic";
        release = 14455;
        versionName = "2022-08-27";
        sha256 = "0pk51qrdhfkl5kbdhgr8lg96myd1c4f212hyf3sx5pd07qskj37x";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" spdx."OFL-1.1" ];
        description = "Botic font minetest mod for font API ";

      };
    };

    "Pyrollo"."font_oldwizard" = buildMinetestPackage rec {
      type = "mod";
      pname = "font_oldwizard";
      version = "2022-08-27";
      src = fetchFromContentDB {
        author = "Pyrollo";
        technicalName = "font_oldwizard";
        release = 14456;
        versionName = "2022-08-27";
        sha256 = "1dpwq8n881m5v7a3whq3vkim1jdrlmjrgkj6kxx6ky0r6p8amg83";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-2.1-only" ];
        description = "OldWizard font minetest mod for font API ";

      };
    };

    "QuillNewelt"."modname_tooltip" = buildMinetestPackage rec {
      type = "mod";
      pname = "modname_tooltip";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "QuillNewelt";
        technicalName = "modname_tooltip";
        release = 11958;
        versionName = "1.0.0";
        sha256 = "13dbpwag9srsls9sk41bk2i0wm6yfb7sbcqilwrhmqv2yzgj4y0q";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Tooltip that shows you what mod a node or item is from";

      };
    };

    "QuoteNat"."vein_miner" = buildMinetestPackage rec {
      type = "mod";
      pname = "vein_miner";
      version = "0.2.2";
      src = fetchFromContentDB {
        author = "QuoteNat";
        technicalName = "vein_miner";
        release = 13421;
        versionName = "0.2.2";
        sha256 = "157c3q03z0bza3vm23qzlxz7365sn74cdk5w34384n9xmbhxgbxq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Automatically mines ore veins and trees while sneaking";

      };
    };

    "ROllerozxa"."chest_with_everything" = buildMinetestPackage rec {
      type = "mod";
      pname = "chest_with_everything";
      version = "2022-05-22";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "chest_with_everything";
        release = 12344;
        versionName = "2022-05-22";
        sha256 = "0j8ibvfxj8xnw5sgg0ns2apwraq3yhfbsdlrvv22lv7m5c1i90yz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds a chest node containing all registered nodes, items and tools.";

      };
    };

    "ROllerozxa"."enable_shadows" = buildMinetestPackage rec {
      type = "mod";
      pname = "enable_shadows";
      version = "2022-05-01";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "enable_shadows";
        release = 12072;
        versionName = "2022-05-01";
        sha256 = "1fmx07sy3vcylxz2nxjn0bnksm0f1c3sk25ag81i3gp5nckqsk4k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Reenable dynamic shadows for 5.6.0+";

      };
    };

    "ROllerozxa"."floppy" = buildMinetestPackage rec {
      type = "mod";
      pname = "floppy";
      version = "2022-09-21";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "floppy";
        release = 13998;
        versionName = "2022-09-21";
        sha256 = "030lk1zg3chhqcp38qmlcagj3mgknkczqyia7j94sx17yqrgaaqw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Throwable floppies... That's what they're used for right?";

      };
    };

    "ROllerozxa"."flyspeed" = buildMinetestPackage rec {
      type = "mod";
      pname = "flyspeed";
      version = "2022-04-05";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "flyspeed";
        release = 11739;
        versionName = "2022-04-05";
        sha256 = "0q0vg3f503635pv5mhr7k2pfn9v476s9zxpx5vr3j4ijixgpdryg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Fine grained control over your flight speed.";

      };
    };

    "ROllerozxa"."greenscreen" = buildMinetestPackage rec {
      type = "mod";
      pname = "greenscreen";
      version = "2022-04-16";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "greenscreen";
        release = 11851;
        versionName = "2022-04-16";
        sha256 = "1j2f20qig5hkmgxlswvlrr4w5gamwqamlyvc48351zmp72xsra1f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Brightly coloured nodes for chroma-keying. (greenscreens)";

      };
    };

    "ROllerozxa"."no_touch_griefer" = buildMinetestPackage rec {
      type = "mod";
      pname = "no_touch_griefer";
      version = "2022-09-30";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "no_touch_griefer";
        release = 14142;
        versionName = "2022-09-30";
        sha256 = "1hrs7a571p8h1zig9a10mgnn874209zk9yfjb1vccx45bm7drwdq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Per-IP interact privilege bans";

      };
    };

    "ROllerozxa"."nodecore_movement" = buildMinetestPackage rec {
      type = "mod";
      pname = "nodecore_movement";
      version = "2022-10-02";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "nodecore_movement";
        release = 14159;
        versionName = "2022-10-02";
        sha256 = "1lrjbs9a2kjdicdkxdpfaz1wg9kl3bgplkhfz4820ydaywcf55ws";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "NodeCore-esque movement for other games";

      };
    };

    "ROllerozxa"."ohceedee" = buildMinetestPackage rec {
      type = "txp";
      pname = "ohceedee";
      version = "2022-10-13";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "ohceedee";
        release = 14360;
        versionName = "2022-10-13";
        sha256 = "1wcgrrnaayan5s0ijj6997k95my8x8liy648vqy9n3g6vd70s6v9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Flat geometrical texture pack inspired by FVDisco's oCd Minecraft resource pack.";

      };
    };

    "ROllerozxa"."owospeak" = buildMinetestPackage rec {
      type = "mod";
      pname = "owospeak";
      version = "2022-09-17";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "owospeak";
        release = 13911;
        versionName = "2022-09-17";
        sha256 = "1g0psff7861gq8gv26wikfn64mhkf5wdh452ay3csn1pm0bc324p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Converts everything in chat into OwOspeak";

      };
    };

    "ROllerozxa"."permatime" = buildMinetestPackage rec {
      type = "mod";
      pname = "permatime";
      version = "2022-07-27";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "permatime";
        release = 12935;
        versionName = "2022-07-27";
        sha256 = "1frv1gg84fyih8lzk8s7aa2r4yqm2a6srh84ckz0hprbmm5d2q55";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Set the day of time cycle to a certain time permanently.";

      };
    };

    "ROllerozxa"."pickblock" = buildMinetestPackage rec {
      type = "mod";
      pname = "pickblock";
      version = "2022-04-16";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "pickblock";
        release = 11850;
        versionName = "2022-04-16";
        sha256 = "0pvxbmcqfndk1mnc28y063iyzd0a8xcv72yzic7df1l0hlc99vxx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows you to put the selected node in an empty slot of your hotbar when you're in creative mode.";

      };
    };

    "ROllerozxa"."simple_roads" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_roads";
      version = "2022-09-20";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "simple_roads";
        release = 13973;
        versionName = "2022-09-20";
        sha256 = "1gcas1346nqph7v44fg5p1bba6i96vz33fzkjikmkdxblbk1r0f0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Simple and generic nodes with road markings, for building road networks.";

      };
    };

    "ROllerozxa"."skygrid" = buildMinetestPackage rec {
      type = "mod";
      pname = "skygrid";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "skygrid";
        release = 11741;
        versionName = "1.1.1";
        sha256 = "1dwc66hrsrq84n6h5f7y4prgkd587cc2ypsh5np8nygxljaq2l8y";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Custom skygrid mapgen.";

      };
    };

    "ROllerozxa"."sudoku" = buildMinetestPackage rec {
      type = "game";
      pname = "sudoku";
      version = "2022-08-25";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "sudoku";
        release = 13553;
        versionName = "2022-08-25";
        sha256 = "1dbms2jbqi4alcc6fs2fyir4967ax4iqjysapsp8g4fz13afs1dr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A game of sudoku.";

      };
    };

    "ROllerozxa"."troll" = buildMinetestPackage rec {
      type = "mod";
      pname = "troll";
      version = "2022-07-22";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "troll";
        release = 12892;
        versionName = "2022-07-22";
        sha256 = "0srykgbj93jk8ksinqrrm552d4vh8qz331sl0cpsgjqiyz3jyzzi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Troll your friends and foes nicely!";

      };
    };

    "ROllerozxa"."vilja_pix_2" = buildMinetestPackage rec {
      type = "txp";
      pname = "vilja_pix_2";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "vilja_pix_2";
        release = 14490;
        versionName = "2022-10-19";
        sha256 = "1hp88zc57809zkrx28wdcbg4smbdgnx6r1vpw9rlq9i3ssrngjdw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A sophisticated texture pack for Minetest.";

      };
    };

    "ROllerozxa"."webtoon" = buildMinetestPackage rec {
      type = "txp";
      pname = "webtoon";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "webtoon";
        release = 14491;
        versionName = "2022-10-19";
        sha256 = "0sfc85x0x3firh2r69560dc43f63j6sy8l4rfkf6pjy95isg5anf";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A Minetest texture pack with only 216 colors in 8x8 size.";

      };
    };

    "ROllerozxa"."zline" = buildMinetestPackage rec {
      type = "txp";
      pname = "zline";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "ROllerozxa";
        technicalName = "zline";
        release = 14489;
        versionName = "2022-10-19";
        sha256 = "0hk7y855dkgxcbaq9rpjjn3vxfybr9j7ngx3y9j6a5b80pbizikx";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Gives most nodes a diagonally striped, cloth-looking texture.";

      };
    };

    "RandomLegoBrick91"."mcl_ore_crops" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_ore_crops";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "RandomLegoBrick91";
        technicalName = "mcl_ore_crops";
        release = 13245;
        versionName = "1.0.1";
        sha256 = "0jdbc6f7hnjw66148cpakcjs638n758yzg1gyx4l5iirwhlkpqsd";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-or-later" ];
        description = "Adds crops that let you grow minerals such as gold and iron";

      };
    };

    "RealBadAngel"."framedglass" = buildMinetestPackage rec {
      type = "mod";
      pname = "framedglass";
      version = "2022-05-27";
      src = fetchFromContentDB {
        author = "RealBadAngel";
        technicalName = "framedglass";
        release = 12379;
        versionName = "2022-05-27";
        sha256 = "1zfk33658pcx923nbflma25cvf18kqv68zlni78zr2vifwrqhnyh";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Framed glass adds glass nodes with a frame that connects automatically to neighbouring nodes";

      };
    };

    "RealBadAngel"."technic" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic";
      version = "2022-10-20";
      src = fetchFromContentDB {
        author = "RealBadAngel";
        technicalName = "technic";
        release = 14508;
        versionName = "2022-10-20";
        sha256 = "0zdsv5wqm0q5z22rih3mz44msmpdch02llm719f704ky2xhrgl46";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Extensive machinery mod with electricity and ores.";

      };
    };

    "RealBadAngel"."unified_inventory" = buildMinetestPackage rec {
      type = "mod";
      pname = "unified_inventory";
      version = "2022-10-06";
      src = fetchFromContentDB {
        author = "RealBadAngel";
        technicalName = "unified_inventory";
        release = 14217;
        versionName = "2022-10-06";
        sha256 = "1jkh33wfhd5jkk5wpd8yiiix5dqcmcbpi0w387611hndx4fpzzw7";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Replaces the default inventory and adds a number of features, such as a crafting guide";

      };
    };

    "Red_King_Cyclops"."saturn_moon" = buildMinetestPackage rec {
      type = "mod";
      pname = "saturn_moon";
      version = "0.1.0";
      src = fetchFromContentDB {
        author = "Red_King_Cyclops";
        technicalName = "saturn_moon";
        release = 1608;
        versionName = "0.1.0";
        sha256 = "028c127lg0vr9db89ra5xh9c4i7jmj8s802cyj9iyx31lkhrgdqy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Replaces the default earthlike setting with a generic moon of Saturn.";

      };
    };

    "Red_King_Cyclops"."time_travel" = buildMinetestPackage rec {
      type = "mod";
      pname = "time_travel";
      version = "0.1.2";
      src = fetchFromContentDB {
        author = "Red_King_Cyclops";
        technicalName = "time_travel";
        release = 2075;
        versionName = "0.1.2";
        sha256 = "144x7p06ma7az4kkamh4337a93fi7a10kfsfh2n8cm1jc6j8s349";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds in a craftable time machine that can be used to time travel to different time periods of Earth's history.";

      };
    };

    "Rotfuchs-von-Vulpes"."what_is_this_uwu" = buildMinetestPackage rec {
      type = "mod";
      pname = "what_is_this_uwu";
      version = "1.1.10";
      src = fetchFromContentDB {
        author = "Rotfuchs-von-Vulpes";
        technicalName = "what_is_this_uwu";
        release = 13647;
        versionName = "1.1.10";
        sha256 = "1rq5495inlr9p7284qhblb5cm7v5qnkskqrall2kvqcjc9yhpk3g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "That shows at the top of your screen what you're looking at.";

      };
    };

    "Roux"."vallee_des_roses" = buildMinetestPackage rec {
      type = "mod";
      pname = "vallee_des_roses";
      version = "Vallee_Des_Roses_v1.1";
      src = fetchFromContentDB {
        author = "Roux";
        technicalName = "vallee_des_roses";
        release = 12876;
        versionName = "Vallee Des Roses v1.1";
        sha256 = "1fdw9f3chc52iizvpq83xk7mfzrcijy3nzkm2xjp6pj354cm8pf0";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Adds Flowers, Ores, Tools, Food and More";

      };
    };

    "SFENCE"."adaptation_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "adaptation_modpack";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "adaptation_modpack";
        release = 14425;
        versionName = "1.0.0";
        sha256 = "0pwbw64dxihwmqfww61vbazlqhjjxa9bi848xph6dk6vxsmqpipg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Key based adaptation database of items.";

      };
    };

    "SFENCE"."appliances" = buildMinetestPackage rec {
      type = "mod";
      pname = "appliances";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "appliances";
        release = 12577;
        versionName = "1.2.0";
        sha256 = "083q8dwz8jjzq0nfzmmw9z504mh175p3h2il8vq75jc69xg998iy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "API for create appliances in other mods powered by technic, mesecons or hand.";

      };
    };

    "SFENCE"."chair_lift" = buildMinetestPackage rec {
      type = "mod";
      pname = "chair_lift";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "chair_lift";
        release = 13193;
        versionName = "1.0.4";
        sha256 = "0gp9bj5ls9h1wjd8am1v8n12ggb3w696w6qi098if98n8pn76kia";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Add craftable and usable chair lift. TIPS: Use gearbox, grease parts (hemp oil), check grease with inspect tool, combine more engines...";

      };
    };

    "SFENCE"."church" = buildMinetestPackage rec {
      type = "mod";
      pname = "church";
      version = "2.0.1";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "church";
        release = 13519;
        versionName = "2.0.1";
        sha256 = "19l7wmc51nj80d8mpa3za9wlz793izp6c9ll8aadwbgws3hlq745";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Church Modpack adds many decorative nodes to the game.";

      };
    };

    "SFENCE"."clothing" = buildMinetestPackage rec {
      type = "mod";
      pname = "clothing";
      version = "2.3.6";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "clothing";
        release = 13740;
        versionName = "2.3.6";
        sha256 = "1g4xx6dx6kmsp1j6w778ifby4d0a4m3abwxf184apjr6c7j01vib";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Add clothes to game, based on clothing from stu. For available machines and clothes, use this with appliances mod. Skinsdb makes clothing visible.";

      };
    };

    "SFENCE"."composting" = buildMinetestPackage rec {
      type = "mod";
      pname = "composting";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "composting";
        release = 13382;
        versionName = "1.0.4";
        sha256 = "0sjzqpvgmfxkdzqpp43q7x0bq0qf4dlxn5hjhlhcafy9div9kh1v";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Compost and composter machines. Mix dirt with compost to get garden soil. Plants from farming/farming redo/hades_extrafarming grows faster on garden soil. Hades Revisited is supported.";

      };
    };

    "SFENCE"."feed_buckets" = buildMinetestPackage rec {
      type = "mod";
      pname = "feed_buckets";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "feed_buckets";
        release = 14426;
        versionName = "1.0.0";
        sha256 = "152il9as9413ffx3nnyy6dcwa26qhcm3dhhkprdbmqkpvkiwmlh2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Craftable bucket of feeds which can be used for feed nearby animals.";

      };
    };

    "SFENCE"."hades_biofuel" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_biofuel";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_biofuel";
        release = 13704;
        versionName = "2022-09-05";
        sha256 = "0mj36j9lqk60wzh91ai26mbl7x32yf5v301xlp12qgbs13cl202k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Produce biofuel from unused plants. ";

      };
    };

    "SFENCE"."hades_compatibility" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_compatibility";
      version = "0.13.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_compatibility";
        release = 9521;
        versionName = "0.13.0";
        sha256 = "0rjgmw76s43i8d51jc168nbpg06wgy176rz8vvniq9k3xjcbgsma";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Make old Hades Revisited world compatible with new versions of Hades Revisited (from version 0.7.0 to 0.13.0).";

      };
    };

    "SFENCE"."hades_cool_trees" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_cool_trees";
      version = "2022-08-03";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_cool_trees";
        release = 13028;
        versionName = "2022-08-03";
        sha256 = "1k07y96sihlf6a0ccnbpz79g4v8piw77m7b88g7g15145rm6dc65";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "It adds some cute trees to Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_cottages" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_cottages";
      version = "2022-08-03";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_cottages";
        release = 13030;
        versionName = "2022-08-03";
        sha256 = "1k0xiq0c6y39xzi8l3vi7g8h13f65vx8421bxj6zck00gfpszaz2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Build medieval cottages with furniture, window shutters and roofs, thresh your wheat. ";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_extensionmods" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_extensionmods";
      version = "2022-08-21";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_extensionmods";
        release = 13458;
        versionName = "2022-08-21";
        sha256 = "0xwl2kk6nin4nkcbf1ibz8z094w467zc4bx1p3j24dwbmaq5jdg9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Pack of mods for subgame Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_mesecons" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_mesecons";
      version = "2022-08-03";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_mesecons";
        release = 13026;
        versionName = "2022-08-03";
        sha256 = "0jlb0h71gsyncngxglpad49y1wsy14m0j9zywi6a2c9k7vvk3g3k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds digital circuitry, including wires, buttons, lights, and even programmable controllers for Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_paleotest" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_paleotest";
      version = "2022-8-16";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_paleotest";
        release = 13315;
        versionName = "2022-8-16";
        sha256 = "0adc4y17ybb0diip3ifnqk8zakvnwsk1pa7wx1xx2rgd4x3dy88v";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Not Only Prehistoric Fauna and Flora to Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_pkarcs" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_pkarcs";
      version = "2022-08-03";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_pkarcs";
        release = 13031;
        versionName = "2022-08-03";
        sha256 = "1mvh50ykvh9i4knfv7yadynqvanl5xqin572rshl1bj79kw6p6x9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds arched doors to Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_ski" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_ski";
      version = "2022-1-2";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_ski";
        release = 10404;
        versionName = "2022-1-2";
        sha256 = "1g6blsxfl9rlxldnppadw2x3rrxkwdxys8dmcq8mk60dx8br6sjp";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Ski for Hades Revisited.";

          homepage = "https://forum.minetest.net/viewtopic.php?t=26747";

      };
    };

    "SFENCE"."hades_skinsdb" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_skinsdb";
      version = "2021-05-13";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_skinsdb";
        release = 7732;
        versionName = "2021-05-13";
        sha256 = "12n79mgjb6r9j7wsqindzpgnphrr5dw84cvf8ydm0qqj79w68z3r";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Custom player skins manager with support for 1.0 and 1.8er skins and inventory skins selector for Hades Revisited";

      };
    };

    "SFENCE"."hades_snow" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_snow";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_snow";
        release = 11799;
        versionName = "1.1.1";
        sha256 = "1p0l5zxs8hy1x94aly4qphx80jm2h88jmzz4bn5q3f5cx46nmksy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Add snow to Hades Revisited via snow cannon.";

      };
    };

    "SFENCE"."hades_travelnet" = buildMinetestPackage rec {
      type = "mod";
      pname = "hades_travelnet";
      version = "2021-10-16";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "hades_travelnet";
        release = 9501;
        versionName = "2021-10-16";
        sha256 = "0cnakspbgz397qvvx9aqzzk2k5ljq58wrjgprbihnhzi4gkq7njn";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Network of teleporter-boxes that allow easy travelling to other boxes on the same network. Compatible with travelnet removed from Hades Revisited in release 0.13.0.";

      };
    };

    "SFENCE"."inspect_tool" = buildMinetestPackage rec {
      type = "mod";
      pname = "inspect_tool";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "inspect_tool";
        release = 11792;
        versionName = "1.0.0";
        sha256 = "12x8xsfby9sr8kfdpw8n48c1csw5nwyhm3xs5ary72623w47saqi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Inspect tool to show some info about nodes which support inspection.";

      };
    };

    "SFENCE"."items_update" = buildMinetestPackage rec {
      type = "mod";
      pname = "items_update";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "items_update";
        release = 13439;
        versionName = "1.0.2";
        sha256 = "1iw9jzsypxbh0aw25pw1j8rvf528npg6a0apa9mziphgmsk0yjmd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Update items in player inventory if they are alias.";

      };
    };

    "SFENCE"."moretools" = buildMinetestPackage rec {
      type = "mod";
      pname = "moretools";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "moretools";
        release = 9655;
        versionName = "1.0.0";
        sha256 = "1ai54qcq6bwbx381bp2hzxhsa59icp87b0lqq6p6iajjny1m8h46";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Add more variant of screwdriver and shears (if vines is enabled). Add garden trowel tool if composting is enabled.";

      };
    };

    "SFENCE"."painting" = buildMinetestPackage rec {
      type = "mod";
      pname = "painting";
      version = "3.1.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "painting";
        release = 12305;
        versionName = "3.1.0";
        sha256 = "0sx2wvhk34gcrpgzd6llbl7zcwb1x11cpj132bnlp89q0fyks9xg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "In-game painting.";

      };
    };

    "SFENCE"."palisade" = buildMinetestPackage rec {
      type = "mod";
      pname = "palisade";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "palisade";
        release = 9881;
        versionName = "1.2.0";
        sha256 = "1ily09mkvc4fhi4lf3gkdigw2s5lr1df3k7r8vk5wqkqc0lkrapd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Add craftable palisades in many styles. Hades Revisited is supported.";

      };
    };

    "SFENCE"."pole_scaffolding" = buildMinetestPackage rec {
      type = "mod";
      pname = "pole_scaffolding";
      version = "0.8.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "pole_scaffolding";
        release = 12430;
        versionName = "0.8.0";
        sha256 = "112n79hgi97wcr9fnw8vqynhc2fpc12dvd0ibxm56aqv9l6ygkrx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Craftable pole scaffoldings. Support default game and Hades Revisited game.";

      };
    };

    "SFENCE"."power_generators" = buildMinetestPackage rec {
      type = "mod";
      pname = "power_generators";
      version = "0.7.2";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "power_generators";
        release = 13194;
        versionName = "0.7.2";
        sha256 = "0hfg7v3bqw7yff8xvk2jmfc78q3jvf3qz89vnklnvxa1p25n07ci";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Add power generators based on appliances API.";

      };
    };

    "SFENCE"."powered_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "powered_tools";
      version = "0.9.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "powered_tools";
        release = 12582;
        versionName = "0.9.0";
        sha256 = "1z2z88pcr94virwacp6l8g99khhcwwz90kri67yz1x8jcs6x8mgl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Tools powered by electric/combustion engine. Includes brush cutter and chainsaw.";

      };
    };

    "SFENCE"."rope_bridges" = buildMinetestPackage rec {
      type = "mod";
      pname = "rope_bridges";
      version = "0.9.3";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "rope_bridges";
        release = 9565;
        versionName = "0.9.3";
        sha256 = "1mp1h4hyawb5nndy6yl761va9lg36fy7zkyvqk8ayivajsar8q9v";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Buildable rope bridge. Should be used with moreblocks or hades_moreblocks.";

      };
    };

    "SFENCE"."sculpture" = buildMinetestPackage rec {
      type = "mod";
      pname = "sculpture";
      version = "0.9.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "sculpture";
        release = 11966;
        versionName = "0.9.0";
        sha256 = "16viv6lwni84njnva3lrqcd4icahx17bhmdbhi2a7wrxmszrnpa5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Make player possible to make his own sculture and paint on it with painting oil colors. Hades Revisited is supported.";

      };
    };

    "SFENCE"."skeletons" = buildMinetestPackage rec {
      type = "mod";
      pname = "skeletons";
      version = "0.7.0";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "skeletons";
        release = 7649;
        versionName = "0.7.0";
        sha256 = "1mnrpfqfvx27m6kyhrjgqg89ss8vg1pwpvkbskchsajj8g84sawi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Add player and some animals skeleton to your game.";

      };
    };

    "SFENCE"."wateringcan" = buildMinetestPackage rec {
      type = "mod";
      pname = "wateringcan";
      version = "1.5";
      src = fetchFromContentDB {
        author = "SFENCE";
        technicalName = "wateringcan";
        release = 12470;
        versionName = "1.5";
        sha256 = "1b7whlknm3i3pjfsbqjhvdv9k4ihykq82fd3sqjd8nrcipx61jz3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A watering can to wetten soil. Support for Hades Revisited. Supported by composting.";

      };
    };

    "SaKeL"."x_bows" = buildMinetestPackage rec {
      type = "mod";
      pname = "x_bows";
      version = "v1.2.0";
      src = fetchFromContentDB {
        author = "SaKeL";
        technicalName = "x_bows";
        release = 14421;
        versionName = "v1.2.0";
        sha256 = "0y0m465w3nnwwdjvw9a7rh8xqkg7f3mkf25ycc3qc0afds70aryj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Adds bow and arrows to Minetest.";

      };
    };

    "SaKeL"."x_farming" = buildMinetestPackage rec {
      type = "mod";
      pname = "x_farming";
      version = "v1.7.2";
      src = fetchFromContentDB {
        author = "SaKeL";
        technicalName = "x_farming";
        release = 14352;
        versionName = "v1.7.2";
        sha256 = "0mpyqypp07nwcdzsifck17rkwpwl505rm2q49wdjfaspn52m40by";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Extends default farming with new plants, crops and ice fishing.";

      };
    };

    "Saturn"."mobs_skeletons" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_skeletons";
      version = "v0.2.0";
      src = fetchFromContentDB {
        author = "Saturn";
        technicalName = "mobs_skeletons";
        release = 7826;
        versionName = "v0.2.0";
        sha256 = "1pljf37zf891cjrw5yfbbcpd4k3qjx7c0zk1qk466mvm2i6xmrsm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds skeletons.";

      };
    };

    "Semmett9"."fakefire" = buildMinetestPackage rec {
      type = "mod";
      pname = "fakefire";
      version = "2020-06-16";
      src = fetchFromContentDB {
        author = "Semmett9";
        technicalName = "fakefire";
        release = 8084;
        versionName = "2020-06-16";
        sha256 = "132y7yibhq8grhjbajamb0cx86q31h2xnlvr2xddsh2axbdylabc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Adds in a block that looks like fire, but dose not have the risk of burning down your creations.";

      };
    };

    "Semmett9"."scaffolding" = buildMinetestPackage rec {
      type = "mod";
      pname = "scaffolding";
      version = "2020-07-25";
      src = fetchFromContentDB {
        author = "Semmett9";
        technicalName = "scaffolding";
        release = 8107;
        versionName = "2020-07-25";
        sha256 = "067pzvxpf96qyi90xcr0d1hvnpwqgny4hqdyaik2xr05fmvymwhf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Adds wooden and Iron scaffolding.";

      };
    };

    "ShadMOrdre"."mg_earth" = buildMinetestPackage rec {
      type = "mod";
      pname = "mg_earth";
      version = "2022-09-08";
      src = fetchFromContentDB {
        author = "ShadMOrdre";
        technicalName = "mg_earth";
        release = 14449;
        versionName = "2022-09-08";
        sha256 = "1w2zbxjs7qfk0mbn30argyyzqz3yqa4r4i236ldkb9z5qv0zn4pg";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Lua mapgen with many options.";

      };
    };

    "ShadowNinja"."areas" = buildMinetestPackage rec {
      type = "mod";
      pname = "areas";
      version = "2020-09-07";
      src = fetchFromContentDB {
        author = "ShadowNinja";
        technicalName = "areas";
        release = 5030;
        versionName = "2020-09-07";
        sha256 = "0clyrlky5kn4pl1irbbvl27n514asgplcsqwlf5ys1qhbrfv10gi";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Areas is a advanced area protection mod based on node_ownership.";

      };
    };

    "ShadowNinja"."irc_commands" = buildMinetestPackage rec {
      type = "mod";
      pname = "irc_commands";
      version = "2019-04-11";
      src = fetchFromContentDB {
        author = "ShadowNinja";
        technicalName = "irc_commands";
        release = 5928;
        versionName = "2019-04-11";
        sha256 = "1dihsl07saxrxw5qsi4hrq6d72g3n2pzggs8970fvv4ffwrixxh6";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Control your server from IRC";

      };
    };

    "Shara"."caverealms" = buildMinetestPackage rec {
      type = "mod";
      pname = "caverealms";
      version = "2018-05-23";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "caverealms";
        release = 30;
        versionName = "2018-05-23";
        sha256 = "11zfwccp06n9fiydc0x706ksp6mb03drqkjlip43q8ik31iy1ckj";
      };
      meta = src.meta // {
        license = [ spdx."BSD-2-Clause-FreeBSD" ];
        description = "A mod for Minetest to add underground realms.";

      };
    };

    "Shara"."fireflies" = buildMinetestPackage rec {
      type = "mod";
      pname = "fireflies";
      version = "2018-05-24";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "fireflies";
        release = 56;
        versionName = "2018-05-24";
        sha256 = "16pw81adwdd6nfsi62q3r8l9b7azmpdh9hjybal6hrmkz71z4bns";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds fireflies which can be caught in a net and placed in bottles for lighting.";

      };
    };

    "Shara"."handholds" = buildMinetestPackage rec {
      type = "mod";
      pname = "handholds";
      version = "2018-06-21";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "handholds";
        release = 290;
        versionName = "2018-06-21";
        sha256 = "03hhvs5hhh6r62ib3v3g2iynkm0zlj4001hhhny4r65w9pb5cl4d";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a climbing pick which creates handholds in stone, desert stone, sandstones and ice nodes.";

      };
    };

    "Shara"."hedges" = buildMinetestPackage rec {
      type = "mod";
      pname = "hedges";
      version = "2018-09-05";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "hedges";
        release = 615;
        versionName = "2018-09-05";
        sha256 = "1zsjvsms3lfrsgqjb7nm6adbi26vg640a8n9crcw9jgc4l366mjq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds connected hedges that that can be crafted from leaves.";

      };
    };

    "Shara"."mese_restriction" = buildMinetestPackage rec {
      type = "mod";
      pname = "mese_restriction";
      version = "2018-09-05";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "mese_restriction";
        release = 616;
        versionName = "2018-09-05";
        sha256 = "0bd8aklw7gyq5yh7h8rb3622mn008a9g7agglacx52g6pnv6aa82";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Restrict mesecons use to require a privilege. ";

      };
    };

    "Shara"."name_hider" = buildMinetestPackage rec {
      type = "mod";
      pname = "name_hider";
      version = "2018-05-26";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "name_hider";
        release = 125;
        versionName = "2018-05-26";
        sha256 = "0qys8dc9y4r3645nabq2w49x5r57kcfq92bdzyp9s2nvqk2663av";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Minetest mod to hide player names";

      };
    };

    "Shara"."rainbow_source" = buildMinetestPackage rec {
      type = "mod";
      pname = "rainbow_source";
      version = "2018-05-26";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "rainbow_source";
        release = 119;
        versionName = "2018-05-26";
        sha256 = "0lgy0aanh8gigp1i9mkybbhm5nqvhhrvbprqlwzgjs375baps1ar";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds coloured water.";

      };
    };

    "Shara"."server_news" = buildMinetestPackage rec {
      type = "mod";
      pname = "server_news";
      version = "2018-05-26";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "server_news";
        release = 122;
        versionName = "2018-05-26";
        sha256 = "1yy0k8gi0hfc2xa4rsjnvn4yvhhjjr0p4dckqvr5m2gz00dpdhkx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Minetest mod to show server news when players join";

      };
    };

    "Shara"."under_sky" = buildMinetestPackage rec {
      type = "mod";
      pname = "under_sky";
      version = "2018-05-23";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "under_sky";
        release = 26;
        versionName = "2018-05-23";
        sha256 = "1vnaq5659cvhq8p5a3w1xmzf79w2hz8qy335d42cy5f2g2x1wi7s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Skybox switch for really dark Minetest caves";

      };
    };

    "Shara"."warp_potions" = buildMinetestPackage rec {
      type = "mod";
      pname = "warp_potions";
      version = "2018-05-23";
      src = fetchFromContentDB {
        author = "Shara";
        technicalName = "warp_potions";
        release = 25;
        versionName = "2018-05-23";
        sha256 = "0ffsjhffx62brkjdp97f39r66gq0nvw9sv16crwmx1747d3f3j47";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Cost per use potions teleport system designed for survival servers.";

      };
    };

    "Sharpik"."sharpnet_textures" = buildMinetestPackage rec {
      type = "txp";
      pname = "sharpnet_textures";
      version = "00031";
      src = fetchFromContentDB {
        author = "Sharpik";
        technicalName = "sharpnet_textures";
        release = 14467;
        versionName = "00031";
        sha256 = "01yc0v82drk7l07gypc37s7b57y73iq2h5b50m93s1lra5w0yh6z";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "It's Photo Realism pack with few mod support.";

      };
    };

    "Sires"."obdy" = buildMinetestPackage rec {
      type = "mod";
      pname = "obdy";
      version = "Master_release_1.0_";
      src = fetchFromContentDB {
        author = "Sires";
        technicalName = "obdy";
        release = 1088;
        versionName = "Master release(1.0)";
        sha256 = "0njlh3hpi3r213zbazv3bajnjrlyl4879w8dicgb0x4n3laljq44";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds some pretty OP tools :)";

      };
    };

    "Skyisblue"."skycornv1" = buildMinetestPackage rec {
      type = "txp";
      pname = "skycornv1";
      version = "Skycornpack_v1";
      src = fetchFromContentDB {
        author = "Skyisblue";
        technicalName = "skycornv1";
        release = 3175;
        versionName = "Skycornpack v1";
        sha256 = "04zk6l7a3nx0ssm103rqip1s9dafk1f57gghfxvwazlhzmh8zvg0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Here i want to release my first pack : The Skycornpack v1. It's a simple 16p edit.";

      };
    };

    "Sodomon"."papercutout" = buildMinetestPackage rec {
      type = "txp";
      pname = "papercutout";
      version = "v1.0b";
      src = fetchFromContentDB {
        author = "Sodomon";
        technicalName = "papercutout";
        release = 2310;
        versionName = "v1.0b";
        sha256 = "15l7n04bpvcrb4zs2dp1v22wffxfl5sbypd17131jzdf6f6vh1vn";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Paper Cut-Out textures pack by Sodomon";

      };
    };

    "Sokomine"."apartment" = buildMinetestPackage rec {
      type = "mod";
      pname = "apartment";
      version = "2018-07-01";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "apartment";
        release = 311;
        versionName = "2018-07-01";
        sha256 = "0m7c8q937slxlg2px9ybg5abjlpbs7crwky5d24hgicx82nczpxl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Rent an apartment with your own chests and furnaces close to spawn";

      };
    };

    "Sokomine"."basic_houses" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_houses";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "basic_houses";
        release = 395;
        versionName = "2018-07-09";
        sha256 = "1mgbm90narclh5yhf1andc1h2jxgni3g191s7qxim52jzgjqj8j2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Simple random houses spawning in small groups on the map";

      };
    };

    "Sokomine"."bell" = buildMinetestPackage rec {
      type = "mod";
      pname = "bell";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "bell";
        release = 398;
        versionName = "2018-07-09";
        sha256 = "1r6fqhm54rjq3ql42asjm0rkczqlrqvri09i6pzbnzc0anf54da0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "A bell that sounds each hour - like a historic bell in a church or town hall";

      };
    };

    "Sokomine"."bridges" = buildMinetestPackage rec {
      type = "mod";
      pname = "bridges";
      version = "2018-07-01";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "bridges";
        release = 310;
        versionName = "2018-07-01";
        sha256 = "09vivgzrkc2vxrv4zjf9hc1dz2i3bxkb98nf67y55axwil59a0kv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Self-building bridge, small bridge building and handrails";

      };
    };

    "Sokomine"."chesttools" = buildMinetestPackage rec {
      type = "mod";
      pname = "chesttools";
      version = "2021-04-06_shift_click";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "chesttools";
        release = 7412;
        versionName = "2021-04-06_shift_click";
        sha256 = "001hqi75dr6l258rkqr2482nwlw06zxzmajwp7xpbxnqd8j8mjkr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Shared locked chests with bag support and quick inventory access";

      };
    };

    "Sokomine"."compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "compass";
      version = "2018-06-30";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "compass";
        release = 308;
        versionName = "2018-06-30";
        sha256 = "1n1q217h5kvkmagwm420g3b819l8gxlfgpa1s6r6x9dc5rqx3wbr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Compass block that can be placed and shows you where north is.";

      };
    };

    "Sokomine"."cottages" = buildMinetestPackage rec {
      type = "mod";
      pname = "cottages";
      version = "2020-10-02";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "cottages";
        release = 6372;
        versionName = "2020-10-02";
        sha256 = "05fwpsp4k5rp38gamisqfv56d21kv14sy8cvl7x1a7cjajjbb00m";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Build medieval cottages with furniture, window shutters and roofs, thresh your wheat, repair your tools.";

      };
    };

    "Sokomine"."gates_long" = buildMinetestPackage rec {
      type = "mod";
      pname = "gates_long";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "gates_long";
        release = 399;
        versionName = "2018-07-09";
        sha256 = "1mvdcj835nmh5wa0v29f990kch2sw9sgmbw25zbgzbarjiq1sl93";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Wide gates for easy walking through and keeping cattle inside";

      };
    };

    "Sokomine"."handle_schematics" = buildMinetestPackage rec {
      type = "mod";
      pname = "handle_schematics";
      version = "2020-10-16_Bugfixes_for_MT_5.x";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "handle_schematics";
        release = 5339;
        versionName = "2020-10-16 Bugfixes for MT 5.x";
        sha256 = "19gkqgj06wmpkiq71pd7jy4lcx8v1g9gh0ac6dml9h0cnsz0qmgl";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A library to make creating and placing saved areas easier.";

      };
    };

    "Sokomine"."locked_travelnet" = buildMinetestPackage rec {
      type = "mod";
      pname = "locked_travelnet";
      version = "2_3_1";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "locked_travelnet";
        release = 1159;
        versionName = "2,3,1";
        sha256 = "1ijzri4qshz25dh95fy2la6jv53c8fim5gzkyh6c91r04kykmiba";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Protect travelnet stations with locks and/or passwords";

      };
    };

    "Sokomine"."locks" = buildMinetestPackage rec {
      type = "mod";
      pname = "locks";
      version = "2.3.1";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "locks";
        release = 1160;
        versionName = "2.3.1";
        sha256 = "1pybrq65f5ib1354bk2kj7h4wxq1skcgvfkdjpn73fj2l9s86fn3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Shared chests, doors, furnaces and signs - with keys";

      };
    };

    "Sokomine"."markers" = buildMinetestPackage rec {
      type = "mod";
      pname = "markers";
      version = "2018-06-30";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "markers";
        release = 306;
        versionName = "2018-06-30";
        sha256 = "1wxacnhxg3k1226g6fpw5jsjm0in69bqn82vpd01579wdwyw6zmq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Easy interface (GUI) for the areas/advanced_areas protection mod";

      };
    };

    "Sokomine"."mg_villages" = buildMinetestPackage rec {
      type = "mod";
      pname = "mg_villages";
      version = "2020-10-16_Major_bugfixes";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "mg_villages";
        release = 5340;
        versionName = "2020-10-16 Major bugfixes";
        sha256 = "19vn692blvcp8cly2gvlxjczsl8cf0449ar1d8dbl2pgrsvd4z7z";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Explore the world and find villages of diffrent types. Buy a house in a village and settle down.";

      };
    };

    "Sokomine"."mobf_trader" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobf_trader";
      version = "2018-07-29";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "mobf_trader";
        release = 496;
        versionName = "2018-07-29";
        sha256 = "1y9ybzkj8nnm7i45lvgja9lcsm18gx5mjv6zav4qrvz3pwca0bv8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Configurable mobs/NPC which can trade for you.";

      };
    };

    "Sokomine"."moresnow" = buildMinetestPackage rec {
      type = "mod";
      pname = "moresnow";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "moresnow";
        release = 401;
        versionName = "2018-07-09";
        sha256 = "1w9ig5sp0s4nqna00fl6lsyxbm2yw8z00b7cyf6vs4q5j5fkz4x3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "snow and wool for stairs - nicer winter landscape and snow-covered roofs";

      };
    };

    "Sokomine"."plasterwork" = buildMinetestPackage rec {
      type = "mod";
      pname = "plasterwork";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "plasterwork";
        release = 397;
        versionName = "2018-07-09";
        sha256 = "001imz2ri08qzj30p8f6lr7llilh09h89mi5j357mrwykggjrccn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Add colored plaster coats to nodes";

      };
    };

    "Sokomine"."replacer" = buildMinetestPackage rec {
      type = "mod";
      pname = "replacer";
      version = "2017-12-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "replacer";
        release = 76;
        versionName = "2017-12-09";
        sha256 = "0qskzmy5xszs4lan5blvhycj1gm5nmdmgwc2wwsp3439ywfsl830";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Exchange/replace nodes with one click.";

      };
    };

    "Sokomine"."windmill" = buildMinetestPackage rec {
      type = "mod";
      pname = "windmill";
      version = "2018-07-01";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "windmill";
        release = 309;
        versionName = "2018-07-01";
        sha256 = "0m1x3pbiqdpicn2wfpj1bajr5fblgrffxjmcwgp0dgg80k2k9z9l";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Rotating sails and rotor blades for classic and modern windmills.";

      };
    };

    "Sokomine"."xconnected" = buildMinetestPackage rec {
      type = "mod";
      pname = "xconnected";
      version = "2018-07-09";
      src = fetchFromContentDB {
        author = "Sokomine";
        technicalName = "xconnected";
        release = 400;
        versionName = "2018-07-09";
        sha256 = "1kxpzh2jfy4f7084n5d6adzqbzm519b7kfwbifmsprcg8adhw0ns";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "connected nodes like xpanes, xfences, walls";

      };
    };

    "SoloSniper"."obsidianstuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "obsidianstuff";
      version = "ObsidianStuff";
      src = fetchFromContentDB {
        author = "SoloSniper";
        technicalName = "obsidianstuff";
        release = 3262;
        versionName = "ObsidianStuff";
        sha256 = "0gxxhv5kq40h1gldn3g4py6gnbrwlcw7dgbsqgv4pzgq54i8ank6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds obsidian tools and armour";

      };
    };

    "SonoMichele"."betterpm" = buildMinetestPackage rec {
      type = "mod";
      pname = "betterpm";
      version = "v1.3.0";
      src = fetchFromContentDB {
        author = "SonoMichele";
        technicalName = "betterpm";
        release = 6889;
        versionName = "v1.3.0";
        sha256 = "07d7563dply0jxsf16x8vgmbv8y9a5pwkyfwbyrj85h9j940inqj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Improves private messages and makes them more customizable ";

          homepage = "https://micheleviotto.it";

      };
    };

    "SonoMichele"."folks" = buildMinetestPackage rec {
      type = "mod";
      pname = "folks";
      version = "v0.2.0";
      src = fetchFromContentDB {
        author = "SonoMichele";
        technicalName = "folks";
        release = 6613;
        versionName = "v0.2.0";
        sha256 = "1pd6xbc99hb05ylahdxrn9h63i7a3yhvad27x74w3gyl9lgmmkgj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds customizable NPCs";

          homepage = "https://micheleviotto.it";

      };
    };

    "SpaghettiToastBook"."beacons" = buildMinetestPackage rec {
      type = "mod";
      pname = "beacons";
      version = "2019-01-26";
      src = fetchFromContentDB {
        author = "SpaghettiToastBook";
        technicalName = "beacons";
        release = 943;
        versionName = "2019-01-26";
        sha256 = "152fih1s64hl4fm87f7r8wwfdyv48b1f8qd0106lx85il9wpm29q";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds craftable beacons in several different colors.";

      };
    };

    "Splizard"."buildacity" = buildMinetestPackage rec {
      type = "game";
      pname = "buildacity";
      version = "v0.3.2-agpl";
      src = fetchFromContentDB {
        author = "Splizard";
        technicalName = "buildacity";
        release = 10209;
        versionName = "v0.3.2-agpl";
        sha256 = "1kv18gp6b453s9zw328gxa5lqf26pj7qi327f3lcd4j9djcr9l0z";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-3.0" ];
        description = "A multiplayer city-building game. Press 'i' ingame for help.";

          homepage = "https://builda.city";

      };
    };

    "StarNinjas"."jail_escape" = buildMinetestPackage rec {
      type = "game";
      pname = "jail_escape";
      version = "Version_2.3__New_Music__";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "jail_escape";
        release = 11625;
        versionName = "Version 2.3 (New Music!)";
        sha256 = "0d358idjplr8fhbhr08awa04c792z66qviqh8cd7j7p7asxk7frm";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-2.1-or-later" ];
        description = "Escape the Jail! Don't get caught!";

      };
    };

    "StarNinjas"."nextgen_bedrock" = buildMinetestPackage rec {
      type = "mod";
      pname = "nextgen_bedrock";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "nextgen_bedrock";
        release = 6503;
        versionName = "1.0.1";
        sha256 = "08if09qqky1ajys53h5c9blbqjq60wz92h41lhnldf1f0vz00fll";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."CC0-1.0" ];
        description = "Adds an indestructible bedrock layer at the bottom of the world.";

      };
    };

    "StarNinjas"."nextgen_bows" = buildMinetestPackage rec {
      type = "mod";
      pname = "nextgen_bows";
      version = "2022-08-20";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "nextgen_bows";
        release = 13427;
        versionName = "2022-08-20";
        sha256 = "0bqr4yfhflq2gwqv4h7dv88vrgawfxvw5sv8wxp9ha3j6hsx0zip";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-2.1-or-later" ];
        description = "Adds bow and arrows.";

      };
    };

    "StarNinjas"."nextgen_compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "nextgen_compass";
      version = "2021-09-01";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "nextgen_compass";
        release = 9199;
        versionName = "2021-09-01";
        sha256 = "17n900akqk7x0cy15bgm0qg0i2mmcflp39srbswlhy715qm2yanv";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "A compass item which points towards the world origin.";

      };
    };

    "StarNinjas"."nextgen_fungi" = buildMinetestPackage rec {
      type = "mod";
      pname = "nextgen_fungi";
      version = "Version_1";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "nextgen_fungi";
        release = 12160;
        versionName = "Version 1";
        sha256 = "05lk5vpsad4rc9yg22rwaf7l3i50cnbdbfad42smm76rjzz972mm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."CC0-1.0" ];
        description = "Adds 3D mushrooms";

      };
    };

    "StarNinjas"."nextgen_tinted_glass" = buildMinetestPackage rec {
      type = "mod";
      pname = "nextgen_tinted_glass";
      version = "Version_1.2";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "nextgen_tinted_glass";
        release = 11891;
        versionName = "Version 1.2";
        sha256 = "044mq38z3aadl121jd605m63c92rcxnma4c7lw6jh9drmsx6mkjg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds tinted glass that doesn't allow light to pass through";

      };
    };

    "StarNinjas"."simplepixel" = buildMinetestPackage rec {
      type = "txp";
      pname = "simplepixel";
      version = "2022-09-08";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "simplepixel";
        release = 13758;
        versionName = "2022-09-08";
        sha256 = "11d1pkjkd262j428jks6hwkfa93r9kc28y5j6k8g6bdazi80bbc5";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "SimplePixel is a texturepack, based on Minecraft Promo Art/Barebones Texturepack. This texturepack is simple, yet elegant.";

      };
    };

    "StarNinjas"."sounds_redone" = buildMinetestPackage rec {
      type = "mod";
      pname = "sounds_redone";
      version = "2022-10-01";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "sounds_redone";
        release = 14132;
        versionName = "2022-10-01";
        sha256 = "0y71xrb5l60pp76rlnczkbzkhrhq1y2yffsbd3cqahpbvwi7hi4k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."CC0-1.0" ];
        description = "Adds sounds to specific blocks";

      };
    };

    "StarNinjas"."spyglass" = buildMinetestPackage rec {
      type = "mod";
      pname = "spyglass";
      version = "1.1";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "spyglass";
        release = 13534;
        versionName = "1.1";
        sha256 = "12c6y8lbc28z5s0ygrz9pfkqkyg19qjlazaqc2qc57hkgw8k9qym";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds the ability to zoom in via a Spyglass";

      };
    };

    "StarNinjas"."xblox" = buildMinetestPackage rec {
      type = "mod";
      pname = "xblox";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "xblox";
        release = 8168;
        versionName = "2021-01-29";
        sha256 = "0z0cmby63bm2gad3dpr4f3avdkkh9bsgwnr7n1rs86zjpbdj6g1m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "New blocks!";

      };
    };

    "StarNinjas"."xcopper" = buildMinetestPackage rec {
      type = "mod";
      pname = "xcopper";
      version = "2021-06-24";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "xcopper";
        release = 8193;
        versionName = "2021-06-24";
        sha256 = "0frvjxxgx7ax5ca3n9svnq5bkgng65i61m3bixrp0psaa8panpyk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "This mod aims to make copper/bronze more realistic by making them slowly oxidize into a bluish/green block when exposed to water.";

      };
    };

    "StarNinjas"."xocean" = buildMinetestPackage rec {
      type = "mod";
      pname = "xocean";
      version = "Version_2.4";
      src = fetchFromContentDB {
        author = "StarNinjas";
        technicalName = "xocean";
        release = 13618;
        versionName = "Version 2.4";
        sha256 = "1vvzxhlx7fdakblfbafmqkqjbgqig5pbvjqzl1ls8cv7w0nc3ml3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds coral reefs, fish, decorative ocean blocks and much more!";

      };
    };

    "Starbeamrainbowlabs"."floating_anchor" = buildMinetestPackage rec {
      type = "mod";
      pname = "floating_anchor";
      version = "v0.6.1";
      src = fetchFromContentDB {
        author = "Starbeamrainbowlabs";
        technicalName = "floating_anchor";
        release = 8478;
        versionName = "v0.6.1";
        sha256 = "1m97kzrv7cgkd2gdlxb6fxcd7njvgppgvxqbvpfgwz56ddp7cfy6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MPL-2.0" ];
        description = "ExtraUtilities' Angel Block for Minecraft in Minetest! Place structures in mid-air with ease.";

      };
    };

    "Starbeamrainbowlabs"."plasticbox" = buildMinetestPackage rec {
      type = "mod";
      pname = "plasticbox";
      version = "v1.3";
      src = fetchFromContentDB {
        author = "Starbeamrainbowlabs";
        technicalName = "plasticbox";
        release = 6389;
        versionName = "v1.3";
        sha256 = "1mqi9znm9r3fsp5iyqcxzjj5kyv9qy3lhj61gp8w8d5cbiv0f0cc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a recolourable plastic box. Fork of @cheapie's version with improvements.";

      };
    };

    "Starbeamrainbowlabs"."worldedit_hud_helper" = buildMinetestPackage rec {
      type = "mod";
      pname = "worldedit_hud_helper";
      version = "v0.5";
      src = fetchFromContentDB {
        author = "Starbeamrainbowlabs";
        technicalName = "worldedit_hud_helper";
        release = 8684;
        versionName = "v0.5";
        sha256 = "124hnmv9qa1ibnbgd5ancdaxpb4pl5mp7h4nq79jrzxjh920jxph";
      };
      meta = src.meta // {
        license = [ spdx."MPL-2.0" ];
        description = "Displays the name of the node you're looking at & your rotation in your HUD. Banish the debug text forever!";

      };
    };

    "Starbeamrainbowlabs"."worldeditadditions" = buildMinetestPackage rec {
      type = "mod";
      pname = "worldeditadditions";
      version = "v1.13";
      src = fetchFromContentDB {
        author = "Starbeamrainbowlabs";
        technicalName = "worldeditadditions";
        release = 10434;
        versionName = "v1.13";
        sha256 = "0hfv8f7ibb6xfbvrwc4wsw0g931467fidrdnglcypgvhrmpv6iss";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MPL-2.0" ];
        description = "Extra tools and commands to extend WorldEdit. Currently has over 22 commands!";

          homepage = "https://worldeditadditions.mooncarrot.space/";

      };
    };

    "Stix"."w_api" = buildMinetestPackage rec {
      type = "mod";
      pname = "w_api";
      version = "2.0.0";
      src = fetchFromContentDB {
        author = "Stix";
        technicalName = "w_api";
        release = 2086;
        versionName = "2.0.0";
        sha256 = "00n40f3hc7fsinbb33dh6xvl9fn119r0n02xn54m9k2c6kgi7hf4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an API to easily register custom weapons";

      };
    };

    "Sumianvoice"."sum_air_currents" = buildMinetestPackage rec {
      type = "mod";
      pname = "sum_air_currents";
      version = "2022-08-20";
      src = fetchFromContentDB {
        author = "Sumianvoice";
        technicalName = "sum_air_currents";
        release = 13429;
        versionName = "2022-08-20";
        sha256 = "1096fagslybk6sg14d0s45ijypxay31ar2sj7fbzjgfk10vs2yvj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds air currents which can push objects and players.";

      };
    };

    "Sumianvoice"."sum_airship" = buildMinetestPackage rec {
      type = "mod";
      pname = "sum_airship";
      version = "2022-08-14";
      src = fetchFromContentDB {
        author = "Sumianvoice";
        technicalName = "sum_airship";
        release = 13250;
        versionName = "2022-08-14";
        sha256 = "19s3wp6b9l1d7fa2r0w0z27vmk2357kb7y46qqlzpigvkhx32al3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds a simple airship for getting around the floatlands. Also optionally uses air currents.";

      };
    };

    "Sumianvoice"."sum_parachute" = buildMinetestPackage rec {
      type = "mod";
      pname = "sum_parachute";
      version = "2022-08-17b";
      src = fetchFromContentDB {
        author = "Sumianvoice";
        technicalName = "sum_parachute";
        release = 13377;
        versionName = "2022-08-17b";
        sha256 = "17yjn1x5k0c1rdgcyzjfqx2rm5a1q6n2c4qcd4ib91bmfnav5svp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds parachutes. These are reusable but require you to craft to pack the parachute into your bag.";

      };
    };

    "Suzakuu"."actionpvpforctf" = buildMinetestPackage rec {
      type = "txp";
      pname = "actionpvpforctf";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Suzakuu";
        technicalName = "actionpvpforctf";
        release = 11948;
        versionName = "1.0";
        sha256 = "1wjczk1qhh7n38yvhlgawl5k4sf389dij1irsyh95k1w1jn7nq5b";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A 16-32px PVP pack for CTF(Rubenwardy) ";

      };
    };

    "SwissalpS"."postool" = buildMinetestPackage rec {
      type = "mod";
      pname = "postool";
      version = "v20220807.1717";
      src = fetchFromContentDB {
        author = "SwissalpS";
        technicalName = "postool";
        release = 13386;
        versionName = "v20220807.1717";
        sha256 = "0v2h3b54h0bjdw0b4ncqybp40n4zkv3zayab69k7wzzhj1k18y2i";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a HUD to show current ingame time and position also tool to visualize map-blocks";

      };
    };

    "TBSHEB"."balloonblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "balloonblocks";
      version = "v1.3.1";
      src = fetchFromContentDB {
        author = "TBSHEB";
        technicalName = "balloonblocks";
        release = 4229;
        versionName = "v1.3.1";
        sha256 = "1dsawdvv5lkdss0d32bh67lshg0ij10hl7l092fxq7ga8qkhbws6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds balloon blocks that can be placed on air.";

      };
    };

    "Tarruvi"."cropocalypse" = buildMinetestPackage rec {
      type = "mod";
      pname = "cropocalypse";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "Tarruvi";
        technicalName = "cropocalypse";
        release = 13606;
        versionName = "1.0.2";
        sha256 = "1zbdz4agmcjbm21r3jhawc7b6lhrzl5gxmqirjljywzdxj6j8115";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a few crops, mushrooms and food items";

      };
    };

    "TenPlus1"."ambience" = buildMinetestPackage rec {
      type = "mod";
      pname = "ambience";
      version = "2021-11-19";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "ambience";
        release = 9707;
        versionName = "2021-11-19";
        sha256 = "0vvvqpj5lrwbilbmb5fcvggyky1vh7nvyq68vzk25d7kkhj93mvx";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Add ambient sounds to the world around you";

      };
    };

    "TenPlus1"."bakedclay" = buildMinetestPackage rec {
      type = "mod";
      pname = "bakedclay";
      version = "2022-09-04";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "bakedclay";
        release = 13687;
        versionName = "2022-09-04";
        sha256 = "03j4iv9gnprc6wghbfy2l3bgwv5fl88mp6hrr96zg3zfnwc3arnp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds the ability to bake clay into blocks and colour them with dye.";

      };
    };

    "TenPlus1"."beds" = buildMinetestPackage rec {
      type = "mod";
      pname = "beds";
      version = "2022-09-28";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "beds";
        release = 14081;
        versionName = "2022-09-28";
        sha256 = "0ysdzzdmr6c5asvs5655jqnzr5ihwlbfjf7f69k2q8vw63gk4ags";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "beds which allows sleep, featured to (auto) skip the night.";

      };
    };

    "TenPlus1"."bees" = buildMinetestPackage rec {
      type = "mod";
      pname = "bees";
      version = "2022-08-31";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "bees";
        release = 13655;
        versionName = "2022-08-31";
        sha256 = "0zh2vxygd50p90yg92p8gfchn2m0cvq2w3d7wivbbgasp7hscaxc";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "This mod adds bees and beehives into minetest";

      };
    };

    "TenPlus1"."bonemeal" = buildMinetestPackage rec {
      type = "mod";
      pname = "bonemeal";
      version = "2022-09-15";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "bonemeal";
        release = 13876;
        versionName = "2022-09-15";
        sha256 = "15cah871571vp26786y90m7rxka92xyiw3qx15avdv5yg1kdaizg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds bone and bonemeal giving the ability to quickly grow plants and saplings.";

      };
    };

    "TenPlus1"."bows" = buildMinetestPackage rec {
      type = "mod";
      pname = "bows";
      version = "2021-06-19";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "bows";
        release = 8131;
        versionName = "2021-06-19";
        sha256 = "0ryml2qigaw93p0h8v5s1cg5jmf4ajal4sadyq5dfkhmp1bfypsa";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds bows and arrows to game. Fork of the mod by AiTechEye";

      };
    };

    "TenPlus1"."builtin_item" = buildMinetestPackage rec {
      type = "mod";
      pname = "builtin_item";
      version = "2022-10-03";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "builtin_item";
        release = 14175;
        versionName = "2022-10-03";
        sha256 = "1jhrqvqiav8kmkmqj1cpym9ii5qm0b88cbywsicsyvac91iw7nkj";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" spdx."MIT" ];
        description = "Dropped items can now be pushed by water, burn quickly in lava and have their own custom functions.";

      };
    };

    "TenPlus1"."cblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "cblocks";
      version = "2021-06-04";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "cblocks";
        release = 7927;
        versionName = "2021-06-04";
        sha256 = "1470ybhn9j6czs1ls1hiw8572z63jlijd0jprhjimd82wl3g4c95";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds coloured wood, glass and stone blocks.";

      };
    };

    "TenPlus1"."dmobs" = buildMinetestPackage rec {
      type = "mod";
      pname = "dmobs";
      version = "2022-08-26c";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "dmobs";
        release = 13567;
        versionName = "2022-08-26c";
        sha256 = "16r1p9lyhakh94dasr7p5x8zrl4cfhghin6jh4g02brai5ng8dlq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds new monsters and animals into your world.";

      };
    };

    "TenPlus1"."doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "doors";
      version = "2022-09-22";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "doors";
        release = 14002;
        versionName = "2022-09-22";
        sha256 = "1zi3g0jlbv61gl4bh0ngggvcp4j0di24pzp6h400rdcm0wy428vd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Doors mod with lock tool to open, lock or protect any registered door.";

      };
    };

    "TenPlus1"."ethereal" = buildMinetestPackage rec {
      type = "mod";
      pname = "ethereal";
      version = "2022-10-11b";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "ethereal";
        release = 14307;
        versionName = "2022-10-11b";
        sha256 = "1sr0h6hhpzxy523svz17qv8aaymrf9dwv7gxy7gi61w6sh4ssl1f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Ethereal mod uses the v7 mapgen to add many new biomes to the world.";

      };
    };

    "TenPlus1"."falling_item" = buildMinetestPackage rec {
      type = "mod";
      pname = "falling_item";
      version = "2021-06-26";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "falling_item";
        release = 8233;
        versionName = "2021-06-26";
        sha256 = "0jb9qm5nhcdbnj0j4sjpzmvd2vqlld3qm66v9153c5x0qscp0ma0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Custom falling blocks tweaks";

      };
    };

    "TenPlus1"."farming" = buildMinetestPackage rec {
      type = "mod";
      pname = "farming";
      version = "2022-10-18";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "farming";
        release = 14445;
        versionName = "2022-10-18";
        sha256 = "0v7j8al48ibm0rclzpffnqggwsxlb7zw8wzn6c6xjfdl3vbdl47k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds many plants and food to Minetest";

      };
    };

    "TenPlus1"."hopper" = buildMinetestPackage rec {
      type = "mod";
      pname = "hopper";
      version = "2022-03-31";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "hopper";
        release = 11690;
        versionName = "2022-03-31";
        sha256 = "1h5h4l5mklzbigk72iqg6xhmzh0lbnjhgrjqap0673rz11qn8767";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds hoppers to transport items between chests/furnace etc.";

      };
    };

    "TenPlus1"."inventory_plus" = buildMinetestPackage rec {
      type = "mod";
      pname = "inventory_plus";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "inventory_plus";
        release = 326;
        versionName = "2018-07-08";
        sha256 = "08kwaf3licgb3g8lm7xsyczj1dgvvvhgafa1g0n5l45mz22dw49g";
      };
      meta = src.meta // {
        license = [ spdx."BSD-3-Clause" spdx."CC0-1.0" ];
        description = "Simple Inventory replacement";

      };
    };

    "TenPlus1"."invisibility" = buildMinetestPackage rec {
      type = "mod";
      pname = "invisibility";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "invisibility";
        release = 344;
        versionName = "2018-07-08";
        sha256 = "017rydri537d82m9v77mc31lrg02w1z74lwcmbd1fvsp4mk4r41z";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Craft a potion to make yourself invisible";

      };
    };

    "TenPlus1"."itemframes" = buildMinetestPackage rec {
      type = "mod";
      pname = "itemframes";
      version = "2022-07-16";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "itemframes";
        release = 12838;
        versionName = "2022-07-16";
        sha256 = "1dl7zy105n64cgyvdqckrm66d26qk7jiajhg3r1g0bkczygmnr2s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds itemframes and pedestals you can place items inside";

      };
    };

    "TenPlus1"."lucky_block" = buildMinetestPackage rec {
      type = "mod";
      pname = "lucky_block";
      version = "2022-10-08";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "lucky_block";
        release = 14251;
        versionName = "2022-10-08";
        sha256 = "026my18p3dbbg4cbqlhh84g2sgcswkrz4qydcizs7v95ndcwd4gd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Craft and break lucky blocks to give something good, bad or painful :)";

      };
    };

    "TenPlus1"."mob_horse" = buildMinetestPackage rec {
      type = "mod";
      pname = "mob_horse";
      version = "2022-09-29";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mob_horse";
        release = 14104;
        versionName = "2022-09-29";
        sha256 = "0h0wyar4pnn4k3la66pp9k5s29wncgmwc0iww4g3nrmzh38jk68x";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds rideable horse";

      };
    };

    "TenPlus1"."mobs" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs";
      version = "2022-10-15";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs";
        release = 14380;
        versionName = "2022-10-15";
        sha256 = "1vgqai5i71rx38rblh1rzj94xva45857s9rrd0snl7cz4s0dwq56";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a mob api for mods to add animals or monsters etc.";

      };
    };

    "TenPlus1"."mobs_animal" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_animal";
      version = "2022-10-11b";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs_animal";
        release = 14306;
        versionName = "2022-10-11b";
        sha256 = "0467bbq832x2f31wgkvqqrg3k4g6amyn7a2zvgf233y4kypl1pm8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds farm animals.";

      };
    };

    "TenPlus1"."mobs_monster" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_monster";
      version = "2022-08-21";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs_monster";
        release = 13462;
        versionName = "2022-08-21";
        sha256 = "1xd3kp661skjwyhxxzf37c53r7z7rhsdnr22qpki17gmd5sh4175";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds many types of monster.";

      };
    };

    "TenPlus1"."mobs_npc" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_npc";
      version = "2022-10-08";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs_npc";
        release = 14253;
        versionName = "2022-10-08";
        sha256 = "0g51dnmhip26c3sn12pgldbnngpz1xhpzz1x3k43cbidj7swhwmi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds simple NPC and Trader.";

      };
    };

    "TenPlus1"."mobs_sky" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_sky";
      version = "2022-04-30";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs_sky";
        release = 12029;
        versionName = "2022-04-30";
        sha256 = "0gzj0ymzzwdjr3n2pv69m7vd312rk7wb3wads5kfng6wvvs0njvs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-2.0-only" ];
        description = "Sky Mobs for Mobs Redo";

      };
    };

    "TenPlus1"."mobs_water" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_water";
      version = "2022-07-10";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "mobs_water";
        release = 12784;
        versionName = "2022-07-10";
        sha256 = "0h7b72zck77r347icjffzxqzqm0gshjwlm2vczpiwb0kkxs46w88";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Water Mobs for Mobs Redo";

      };
    };

    "TenPlus1"."nssb" = buildMinetestPackage rec {
      type = "mod";
      pname = "nssb";
      version = "2022-08-24";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "nssb";
        release = 13521;
        versionName = "2022-08-24";
        sha256 = "1vr769yfix53nz3awrjbhpngf8g64kjfyp7xs2v01y7l4qwf3a9l";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-2.1-or-later" ];
        description = "BIOME integration for nssm, the not so simple buildings.";

      };
    };

    "TenPlus1"."nssm" = buildMinetestPackage rec {
      type = "mod";
      pname = "nssm";
      version = "2022-10-02";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "nssm";
        release = 14153;
        versionName = "2022-10-02";
        sha256 = "0lq1qgsj9nyfhfhndnslk46q5h5g93bcr94y069qgan9gsrlwq1y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds a host of creatures into your world with new weapons too.";

      };
    };

    "TenPlus1"."other_worlds" = buildMinetestPackage rec {
      type = "mod";
      pname = "other_worlds";
      version = "2021-04-20d";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "other_worlds";
        release = 7581;
        versionName = "2021-04-20d";
        sha256 = "183k9yjbqs3r45a0h4mzybmi9a6f97l5p26gc61jl0an9ba66cgw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds asteroid layers and height-based skybox switches to create space environments.";

      };
    };

    "TenPlus1"."pbj_pup" = buildMinetestPackage rec {
      type = "mod";
      pname = "pbj_pup";
      version = "2021-07-03";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "pbj_pup";
        release = 8322;
        versionName = "2021-07-03";
        sha256 = "10407qqxwp4iv6vc7wr6phnawq7f02a84n15qldb0dyryyfn6yg2";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds PB&J Pup, Nyan Cats or MooGnu into your world";

      };
    };

    "TenPlus1"."pigiron" = buildMinetestPackage rec {
      type = "mod";
      pname = "pigiron";
      version = "2022-09-30";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "pigiron";
        release = 14122;
        versionName = "2022-09-30";
        sha256 = "1wr1ccnbbpyqzcg97k42i1gjak36jgwgqikipr8f6gaxfi51rqdy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds pig iron ingots which need to be crafted to make steel, also blocks and stairs.";

      };
    };

    "TenPlus1"."pink_lava" = buildMinetestPackage rec {
      type = "mod";
      pname = "pink_lava";
      version = "2021-02-02";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "pink_lava";
        release = 6397;
        versionName = "2021-02-02";
        sha256 = "1388lpp7xvazj7kzydc43sdpm29mxk23miyhcmhj09dvd3rd5rml";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds pink lava to certain depth of map with new mahogany obsidian block";

      };
    };

    "TenPlus1"."playerplus" = buildMinetestPackage rec {
      type = "mod";
      pname = "playerplus";
      version = "2022-07-30";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "playerplus";
        release = 12958;
        versionName = "2022-07-30";
        sha256 = "16cf2nh52cn7wdnw28hjpgbv2hyhfhp0bl6cc99bd3yb54ip9n21";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds effects to player to change speeds and cause damage";

      };
    };

    "TenPlus1"."pova" = buildMinetestPackage rec {
      type = "mod";
      pname = "pova";
      version = "2022-01-11";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "pova";
        release = 10573;
        versionName = "2022-01-11";
        sha256 = "0nbzdvvgnkdrilrlkrj6r4qbyi1ff4szylqzkg9hmv74ghkxj2dq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Pova gives mod makers a set of functions to safely apply overrides for player speed, jump height and gravity.";

      };
    };

    "TenPlus1"."protector" = buildMinetestPackage rec {
      type = "mod";
      pname = "protector";
      version = "2022-08-23";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "protector";
        release = 13500;
        versionName = "2022-08-23";
        sha256 = "1nk9k7hk02ama6jh7winbr8j61vr5jq0r68y8mq8b98rb32qi06n";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Lets players craft special blocks to protect their builds or disable PVP in areas.";

      };
    };

    "TenPlus1"."real_torch" = buildMinetestPackage rec {
      type = "mod";
      pname = "real_torch";
      version = "2022-02-19";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "real_torch";
        release = 11348;
        versionName = "2022-02-19";
        sha256 = "0absa2yqld3yfzgnsmm0kq27snwaifcbhz6lql6vvy9whybqzsrl";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Realistic torches that go out eventually and drop in water";

      };
    };

    "TenPlus1"."regrow" = buildMinetestPackage rec {
      type = "mod";
      pname = "regrow";
      version = "2021-02-02";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "regrow";
        release = 6398;
        versionName = "2021-02-02";
        sha256 = "0jkalp1606c7z0n10ld2ms82z8kv8yknnfk714n5wm2nha1zvbab";
      };
      meta = src.meta // {
        license = [ spdx."MIT" spdx."Unlicense" ];
        description = "This mod helps to regrow tree fruits instead of replanting saplings.";

      };
    };

    "TenPlus1"."sfinv_bags" = buildMinetestPackage rec {
      type = "mod";
      pname = "sfinv_bags";
      version = "2021-11-27";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "sfinv_bags";
        release = 9792;
        versionName = "2021-11-27";
        sha256 = "1i1qsaxg3mwciyv5kkxh504pqq5bnpjwpn03yd697kvb2j6flid8";
      };
      meta = src.meta // {
        license = [ spdx."BSD-3-Clause" ];
        description = "Adds a BAGS tab to SF Inventory with slots for different size bags to store items";

      };
    };

    "TenPlus1"."sfinv_home" = buildMinetestPackage rec {
      type = "mod";
      pname = "sfinv_home";
      version = "2021-03-29";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "sfinv_home";
        release = 7250;
        versionName = "2021-03-29";
        sha256 = "1vqk7iszz03jd8rdr206wjfl1ljwqqpyadczpgkjxdx140cav8vm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" spdx."Unlicense" ];
        description = "Adds HOME tab to SF Inventory to set and go to player home point";

      };
    };

    "TenPlus1"."simple_skins" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_skins";
      version = "2022-03-24";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "simple_skins";
        release = 11634;
        versionName = "2022-03-24";
        sha256 = "1zf5d7b60898vhb307y5dzypw06cza7xh5lsdwx3798pynx20jcb";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Mod that allows players to set their individual skins.";

      };
    };

    "TenPlus1"."stairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "stairs";
      version = "2021-01-28";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "stairs";
        release = 6246;
        versionName = "2021-01-28";
        sha256 = "0nm8m0d0f40qrywcyagcvymx5chw6c3d3syzqn9j7z0gn2g962gc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds more stair types to Minetest.";

      };
    };

    "TenPlus1"."stamina" = buildMinetestPackage rec {
      type = "mod";
      pname = "stamina";
      version = "2022-08-02";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "stamina";
        release = 13011;
        versionName = "2022-08-02";
        sha256 = "055cid6pdbgchh0vwvpd1a48ri0m4l4wv0wsbqda7zvxpxkcn94c";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds stamina and hunger (this fork adds drunk effects and player_monoids/pova support)";

      };
    };

    "TenPlus1"."teleport_potion" = buildMinetestPackage rec {
      type = "mod";
      pname = "teleport_potion";
      version = "2022-09-09";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "teleport_potion";
        release = 13771;
        versionName = "2022-09-09";
        sha256 = "1abz0r5pchlmd9m3w20ki86qa1hypsqbfggxrj5fv6jw4zaqy2p5";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds craftable teleport potions (throwable) and teleport pads.";

      };
    };

    "TenPlus1"."wine" = buildMinetestPackage rec {
      type = "mod";
      pname = "wine";
      version = "2022-08-29";
      src = fetchFromContentDB {
        author = "TenPlus1";
        technicalName = "wine";
        release = 13636;
        versionName = "2022-08-29";
        sha256 = "0kl96fqzink1ff87frz2qavm5q2nlg0j8bp9wy4a0dwl96ars0fh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds wine.";

      };
    };

    "Termos"."islands" = buildMinetestPackage rec {
      type = "mod";
      pname = "islands";
      version = "210315";
      src = fetchFromContentDB {
        author = "Termos";
        technicalName = "islands";
        release = 7005;
        versionName = "210315";
        sha256 = "1f4lwmmbfqj5x5icz3qk3g4sr7d1zqfg8jrm6zlcl2am7sdaj0a8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "lua mapgen featuring tropical islands and vast ocean";

      };
    };

    "Termos"."mobkit" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobkit";
      version = "2021-02-02";
      src = fetchFromContentDB {
        author = "Termos";
        technicalName = "mobkit";
        release = 6391;
        versionName = "2021-02-02";
        sha256 = "0r89wl01y5firh5npj7mhqhj9s9g6zryl6jdqmxqn1r84cs58q1m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Entity API";

      };
    };

    "Termos"."sailing_kit" = buildMinetestPackage rec {
      type = "mod";
      pname = "sailing_kit";
      version = "v210110";
      src = fetchFromContentDB {
        author = "Termos";
        technicalName = "sailing_kit";
        release = 6033;
        versionName = "v210110";
        sha256 = "1lwrgai1622d1a6a6pbx0c6gamrwlsd370am4aiqpnlr25819977";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a craftable sailboat";

      };
    };

    "Termos"."waterfalls" = buildMinetestPackage rec {
      type = "mod";
      pname = "waterfalls";
      version = "Waterfalls_1.0";
      src = fetchFromContentDB {
        author = "Termos";
        technicalName = "waterfalls";
        release = 1373;
        versionName = "Waterfalls 1.0";
        sha256 = "042bm98vik9h3v4dbi83f29fbh9jbhv2alivh4m6kzbyfjvn2sr0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds water erosion, so flowing water forms somewhat more realistic looking waterfalls.";

      };
    };

    "Termos"."wildlife" = buildMinetestPackage rec {
      type = "mod";
      pname = "wildlife";
      version = "2020-03-07";
      src = fetchFromContentDB {
        author = "Termos";
        technicalName = "wildlife";
        release = 6367;
        versionName = "2020-03-07";
        sha256 = "0hac28vmcahxipqg6rzm82zgf4r0gspv9vmmwm1jlldffjqzkdf2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds some wild animals that interact with each other.";

      };
    };

    "TestificateMods"."climate" = buildMinetestPackage rec {
      type = "mod";
      pname = "climate";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "climate";
        release = 5305;
        versionName = "1.0.4";
        sha256 = "07sn4d18hfcqjvhfmdcgdl3bc0bwb60hz0ylkd1aw6c3p1irn0aj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Not every biome is the same and neither should their weather be. The complete weather bundle for any game.";

      };
    };

    "TestificateMods"."climate_api" = buildMinetestPackage rec {
      type = "mod";
      pname = "climate_api";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "climate_api";
        release = 3796;
        versionName = "1.0.2";
        sha256 = "13a8fkkbbil0px833dghcikmpfm3qzjj8my0bcj1ga2ghc3sxm4v";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-3.0-only" ];
        description = "A powerful engine for weather presets and visual effects. Requires a weather pack like Regional Weather.";

      };
    };

    "TestificateMods"."handholds_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "handholds_redo";
      version = "2.0.2";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "handholds_redo";
        release = 7453;
        versionName = "2.0.2";
        sha256 = "0xq9sgpbsw7w5wnbkb8w84qxhpbs7yqp7g8ix7k1bjqhhb1rkczh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds additional functionality to pickaxes as a climbing tool";

      };
    };

    "TestificateMods"."item_snatcher" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_snatcher";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "item_snatcher";
        release = 3539;
        versionName = "1.0.0";
        sha256 = "0hvvfr4lgq12s8x4x0ys5ayqzcmvmk39jm9qb0b4g4qavahw75mw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Makes the apple snatcher from Wuzzy's tutorial game available as a standalone item.";

      };
    };

    "TestificateMods"."moon_phases" = buildMinetestPackage rec {
      type = "mod";
      pname = "moon_phases";
      version = "2.1.0";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "moon_phases";
        release = 3757;
        versionName = "2.1.0";
        sha256 = "0bir2gfksazd07hyilhrfysy1b7zw23np23snlwirk7xlnvzycdp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Changes the moon to follow a cycle between eight different phases.";

      };
    };

    "TestificateMods"."regional_weather" = buildMinetestPackage rec {
      type = "mod";
      pname = "regional_weather";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "regional_weather";
        release = 5306;
        versionName = "1.0.2";
        sha256 = "0j2vmch5v3rxv17a51xvdbjahg9g1qyca0jyqzcwzfhvx7mddkq9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-3.0-only" ];
        description = "A weather pack for Climate API";

      };
    };

    "TestificateMods"."sickles" = buildMinetestPackage rec {
      type = "mod";
      pname = "sickles";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "TestificateMods";
        technicalName = "sickles";
        release = 5298;
        versionName = "1.3.1";
        sha256 = "1g5alxvvryp0f4vgff0r4v3wdlc767a393fgn1qnv57nvcmzwg9c";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds scythes and sickles with unique applications for farming";

      };
    };

    "ThatGhzGamer"."gocm_carbon" = buildMinetestPackage rec {
      type = "mod";
      pname = "gocm_carbon";
      version = "GOCM_0.3-1a_Tool_Update";
      src = fetchFromContentDB {
        author = "ThatGhzGamer";
        technicalName = "gocm_carbon";
        release = 1013;
        versionName = "GOCM 0.3-1a Tool Update";
        sha256 = "12gvswcxf9yydfk39d2avgq54glk91dw211p92si3lyn5srrvy3z";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various charcoal related items such as a Marvelous Hammer to Compress things, New Gear, New Diamonds, Charcoal and Willow Charcoal.";

      };
    };

    "TheAlchemist0033"."alchemy" = buildMinetestPackage rec {
      type = "mod";
      pname = "alchemy";
      version = "Development_Release_1.0.9";
      src = fetchFromContentDB {
        author = "TheAlchemist0033";
        technicalName = "alchemy";
        release = 7635;
        versionName = "Development Release 1.0.9";
        sha256 = "175j9h5dh23ap5hnk781d96gh3m560ry2429kzfg7d2p2wcvvszy";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "adds throwable and regular potions to game (beta)";

      };
    };

    "TheFanne"."betterice" = buildMinetestPackage rec {
      type = "mod";
      pname = "betterice";
      version = "2019-08-20";
      src = fetchFromContentDB {
        author = "TheFanne";
        technicalName = "betterice";
        release = 1821;
        versionName = "2019-08-20";
        sha256 = "0kn52p9qp12lisngm8mmgwi6rkmkv244mfvafdrxnd4w6asf24jz";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Modifies ice so that it melts into water when broken, and will be melted by torches";

      };
    };

    "TheFanne"."raining_nodes" = buildMinetestPackage rec {
      type = "game";
      pname = "raining_nodes";
      version = "2019-08-13";
      src = fetchFromContentDB {
        author = "TheFanne";
        technicalName = "raining_nodes";
        release = 1787;
        versionName = "2019-08-13";
        sha256 = "0r3w9vll0xl10v8595w1kcj5gijz69h8jlbpvd9jafhqwgwb8qhx";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Survive in a strange world where nodes constantly rain down from the sky!";

      };
    };

    "TheFanne"."random_api" = buildMinetestPackage rec {
      type = "mod";
      pname = "random_api";
      version = "2019-08-20";
      src = fetchFromContentDB {
        author = "TheFanne";
        technicalName = "random_api";
        release = 1820;
        versionName = "2019-08-20";
        sha256 = "1iy4pr7p5b0znx0ggyvkyxic4xri6xklxpzzll4ni3yvz8017vlw";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Provides a simple-to-use framework for selecting random objects with probabilities";

      };
    };

    "Thomas-S"."ts_doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "ts_doors";
      version = "2021-05-09";
      src = fetchFromContentDB {
        author = "Thomas-S";
        technicalName = "ts_doors";
        release = 13152;
        versionName = "2021-05-09";
        sha256 = "0pfd6jrsl3x5wgh7bkr39xvllb3b4gazvk1py6dfgs0xw9bqmh3f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds doors for all kinds of wood.";

      };
    };

    "Thomas-S"."ts_furniture" = buildMinetestPackage rec {
      type = "mod";
      pname = "ts_furniture";
      version = "2021-05-17";
      src = fetchFromContentDB {
        author = "Thomas-S";
        technicalName = "ts_furniture";
        release = 8627;
        versionName = "2021-05-17";
        sha256 = "06i4pnvpv6q3kwxwlzmnh2fjycb8kxj7m4d029crsdp826ifhbkh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds basic furniture (Chairs, Tables, Small Tables, Tiny Tables, Benches).";

      };
    };

    "Thomas-S"."ts_workshop" = buildMinetestPackage rec {
      type = "mod";
      pname = "ts_workshop";
      version = "2022-08-14";
      src = fetchFromContentDB {
        author = "Thomas-S";
        technicalName = "ts_workshop";
        release = 13659;
        versionName = "2022-08-14";
        sha256 = "0bq8rj8fn07fhlih87l2kvjnspaicbw5b3qbiig6sfjmca07rimh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "API for workshops";

      };
    };

    "Thresher"."news_markdown" = buildMinetestPackage rec {
      type = "mod";
      pname = "news_markdown";
      version = "2022-10-18";
      src = fetchFromContentDB {
        author = "Thresher";
        technicalName = "news_markdown";
        release = 14444;
        versionName = "2022-10-18";
        sha256 = "150dc7smbqm3rmqirz7iyb6pycd9kpkyp09p8f9ic6jmfwwrk0kc";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Shows players the server news when they log in";

      };
    };

    "Thresher"."player_status" = buildMinetestPackage rec {
      type = "mod";
      pname = "player_status";
      version = "2022-10-16";
      src = fetchFromContentDB {
        author = "Thresher";
        technicalName = "player_status";
        release = 14401;
        versionName = "2022-10-16";
        sha256 = "0ijgj5bpci3jram27q1fnkqx8mgspsymihk5k8q3xqy9nmds9rfl";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Allows you to set and get the in-game status of players";

      };
    };

    "Thunder1035"."mcl_build_spawner" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_build_spawner";
      version = "0.7";
      src = fetchFromContentDB {
        author = "Thunder1035";
        technicalName = "mcl_build_spawner";
        release = 12310;
        versionName = "0.7";
        sha256 = "0nf3iccbr81mxp6gswrs13nxg2izm672gqz1sg5nbs46rnnjbjvr";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Gives build spawner for spawing builds in mineclone 2 and 5";

      };
    };

    "Thunder1035"."pacman" = buildMinetestPackage rec {
      type = "game";
      pname = "pacman";
      version = "version-8_bug_fixing_";
      src = fetchFromContentDB {
        author = "Thunder1035";
        technicalName = "pacman";
        release = 13328;
        versionName = "version-8(bug_fixing)";
        sha256 = "1f460vfnpnkbybs7xp3q71v13hv6ac3fn2sdb5qgdwll1andxjc6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = " A Pacman inspired game";

      };
    };

    "Thunder1035"."the_build_spawner" = buildMinetestPackage rec {
      type = "mod";
      pname = "the_build_spawner";
      version = "version-9";
      src = fetchFromContentDB {
        author = "Thunder1035";
        technicalName = "the_build_spawner";
        release = 11757;
        versionName = "version-9";
        sha256 = "1njh4jrvxiwdir3hbgw862xmdcs3340jhwg93fdp6nbv78yfy4a9";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Gives build spawner for spawning builds which makes city creation easy";

      };
    };

    "Tim7"."asbestos" = buildMinetestPackage rec {
      type = "mod";
      pname = "asbestos";
      version = "0.5";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "asbestos";
        release = 11633;
        versionName = "0.5";
        sha256 = "0xn8mah0ihi7bzkpg1hcn62f1q2smyd43xak8z0rynywa53qhgci";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A useful fire retardant.";

      };
    };

    "Tim7"."awesome_monsters" = buildMinetestPackage rec {
      type = "mod";
      pname = "awesome_monsters";
      version = "0.3";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "awesome_monsters";
        release = 11683;
        versionName = "0.3";
        sha256 = "0jjbiz9n2r53xmkfj32qn0wd6arvvz307197j415xkzr0ssc4m56";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds strong monsters to your worlds.";

      };
    };

    "Tim7"."bouncy_mushrooms" = buildMinetestPackage rec {
      type = "mod";
      pname = "bouncy_mushrooms";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "bouncy_mushrooms";
        release = 11826;
        versionName = "1.0.1";
        sha256 = "17w50lcmhj9y8q1rcgga4ng96qc6c4sshdsr3vwsxjpcgaj2ir8g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds bouncy mushrooms.";

      };
    };

    "Tim7"."cupcakes" = buildMinetestPackage rec {
      type = "mod";
      pname = "cupcakes";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "cupcakes";
        release = 11630;
        versionName = "1.1";
        sha256 = "1vdw4r19v0jra5gn573idn05fz9ggap20yi0jwlid8z8cwnyj5sa";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds tasty cupcakes!";

      };
    };

    "Tim7"."easy_wool" = buildMinetestPackage rec {
      type = "mod";
      pname = "easy_wool";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "easy_wool";
        release = 8785;
        versionName = "1.0";
        sha256 = "08zhncih7k69hqx4a72xqzqphm69g57n0g8bxbcj2vpic9ysd7wx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Makes wool easier to make.";

      };
    };

    "Tim7"."fantasy_biomes" = buildMinetestPackage rec {
      type = "mod";
      pname = "fantasy_biomes";
      version = "0.6";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "fantasy_biomes";
        release = 10500;
        versionName = "0.6";
        sha256 = "0fqk62s26m806nx4xlvdi9l7f8my9x355yz8qgysk68fn13pmxa7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This adds cool fantasy biomes!";

      };
    };

    "Tim7"."higher_ores" = buildMinetestPackage rec {
      type = "mod";
      pname = "higher_ores";
      version = "0.3";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "higher_ores";
        release = 13962;
        versionName = "0.3";
        sha256 = "1g34z6q2shdv3ba6n2316va25vhgql62yx265l9wa8xxa03z9gzi";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Made for lazy people like me who don't want to bother mining for a long time.";

      };
    };

    "Tim7"."limboarria" = buildMinetestPackage rec {
      type = "game";
      pname = "limboarria";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "limboarria";
        release = 10397;
        versionName = "1.2.0";
        sha256 = "0nw8i8v0bh0bh5n2d1fgsbjxx6md5dca6l8dhd8adxn4x8qrz2c6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "limboarria is a game I made.";

      };
    };

    "Tim7"."pets" = buildMinetestPackage rec {
      type = "mod";
      pname = "pets";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "pets";
        release = 11624;
        versionName = "1.1";
        sha256 = "0rpvkp8clp89jnsqdnalwgrbyrs26z0c2ygkcfq70dn420fhigbc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds awesome pets!";

      };
    };

    "Tim7"."supertuxstuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "supertuxstuff";
      version = "Release_1";
      src = fetchFromContentDB {
        author = "Tim7";
        technicalName = "supertuxstuff";
        release = 7887;
        versionName = "Release 1";
        sha256 = "1h2lncb8520bgffmpqy1k4zdhfhpzm3r31qclmm80v7zas5syy70";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "This is in development, currently there is only one block but more are coming soon! :)";

      };
    };

    "Tmanyo"."bank_accounts" = buildMinetestPackage rec {
      type = "mod";
      pname = "bank_accounts";
      version = "1.1.1_1_15_2017";
      src = fetchFromContentDB {
        author = "Tmanyo";
        technicalName = "bank_accounts";
        release = 1639;
        versionName = "1.1.1 1/15/2017";
        sha256 = "1v8w0vjwn4caw0wrqcszmy9mk42w0msqf0cdznl90fljn5q24k8v";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."MIT" ];
        description = "Adds bank accounts with ATMs and Debit\Credit cards.";

      };
    };

    "Tony996-source"."mcl_light_blocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_light_blocks";
      version = "mcl_light_blocks";
      src = fetchFromContentDB {
        author = "Tony996-source";
        technicalName = "mcl_light_blocks";
        release = 12963;
        versionName = "mcl light blocks";
        sha256 = "0p5km1zm57zfv0zfqlq7hyv5s0c9g5gvx6104d8zw4dwsxnpp78g";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds coloured light blocks to Minetest subgame (MineClone2).";

      };
    };

    "Tony996-source"."mcl_small_3d_plants" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_small_3d_plants";
      version = "2022-08-07";
      src = fetchFromContentDB {
        author = "Tony996-source";
        technicalName = "mcl_small_3d_plants";
        release = 13088;
        versionName = "2022-08-07";
        sha256 = "0mi70r3p7dzsn45hn4sqf51g4nfj0rp7vry8xnldcz4kjkpkfpc2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds mesh nodes for small plants";

      };
    };

    "Traxie21"."tpr" = buildMinetestPackage rec {
      type = "mod";
      pname = "tpr";
      version = "2021-08-09";
      src = fetchFromContentDB {
        author = "Traxie21";
        technicalName = "tpr";
        release = 13153;
        versionName = "2021-08-09";
        sha256 = "1sfl2s8k6lzp7wmc2f8ixk3z63lnd0f6981w9lpscl35q02xilkf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Allows players to send a request to other players to teleport to them. Includes many more teleporting features";

      };
    };

    "Truemmerer"."colordcement" = buildMinetestPackage rec {
      type = "mod";
      pname = "colordcement";
      version = "05-21";
      src = fetchFromContentDB {
        author = "Truemmerer";
        technicalName = "colordcement";
        release = 7736;
        versionName = "05-21";
        sha256 = "12y1klj7mvx0k3nm560cwpy2l30fmsws3glaa14n26svv467657f";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."LGPL-2.1-only" ];
        description = "Add Cement Blocks with unifieddyes support";

          homepage = "https://minelife-minetest.de/";

      };
    };

    "Truemmerer"."invisible_blocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "invisible_blocks";
      version = "01-21v1";
      src = fetchFromContentDB {
        author = "Truemmerer";
        technicalName = "invisible_blocks";
        release = 6135;
        versionName = "01-21v1";
        sha256 = "0ag0gf55jx4aspnvly641z6qfz9yj4xsy1zff9rixzkllh2js4vn";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Add invisible Blocks";

          homepage = "https://minelife-minetest.de";

      };
    };

    "Truemmerer"."serversay" = buildMinetestPackage rec {
      type = "mod";
      pname = "serversay";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Truemmerer";
        technicalName = "serversay";
        release = 3476;
        versionName = "1.0";
        sha256 = "0a2ygi9yz0is3ss4qg5r7k2nbj13xwdimjys1qqjvq8sczpdsm3z";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Write in the Chat as the server";

      };
    };

    "TumeniNodes"."ambiguity" = buildMinetestPackage rec {
      type = "txp";
      pname = "ambiguity";
      version = "2017_04_05";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "ambiguity";
        release = 740;
        versionName = "2017/04/05";
        sha256 = "138vq6layawnbagjv6rxgfcwrq1gzgw93s2f3pak7hyap7l1crz0";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC-BY-SA-3.0" ];
        description = "The default TP for Minetest Game, using greyscale";

      };
    };

    "TumeniNodes"."angledstairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "angledstairs";
      version = "2018_5_25";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "angledstairs";
        release = 117;
        versionName = "2018/5/25";
        sha256 = "1fdbkh4888jxc0wc1j6yalbkl096cqpd286lp0d4gmlcpvb45fpw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds angled stairs to the Minetest Game.";

      };
    };

    "TumeniNodes"."angledwalls" = buildMinetestPackage rec {
      type = "mod";
      pname = "angledwalls";
      version = "angledwalls";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "angledwalls";
        release = 1934;
        versionName = "angledwalls";
        sha256 = "1dx1bhws0vh0sb0w8zisshmj7p6hw8lylyvjbi6z253mxwhrwarv";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Angled & Sloped Walls, Angled Glass, & Angled Doors";

      };
    };

    "TumeniNodes"."artdeco" = buildMinetestPackage rec {
      type = "mod";
      pname = "artdeco";
      version = "2018_5_25";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "artdeco";
        release = 115;
        versionName = "2018/5/25";
        sha256 = "0asjaajabc34g89k49c6fb3dx5wmc4cjfsw382nnm776lnbmbpzb";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "This mod just adds some new building blocks to Minetest.";

      };
    };

    "TumeniNodes"."block_in_block" = buildMinetestPackage rec {
      type = "mod";
      pname = "block_in_block";
      version = "Block_In_Block";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "block_in_block";
        release = 2120;
        versionName = "Block In Block";
        sha256 = "14mfs34f257hkz6j7ng8j6gya21nlws0q5iml9lx168dm3ayxg18";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A silly mod to spark creativity";

      };
    };

    "TumeniNodes"."c_doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "c_doors";
      version = "c_doors";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "c_doors";
        release = 1913;
        versionName = "c_doors";
        sha256 = "0qkci88305xnh5n8r2ac1frvf650mbk65hy5n2va3kq2hr9px7ym";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds centered doors, and villa style windows to Minetest.";

      };
    };

    "TumeniNodes"."default_ls" = buildMinetestPackage rec {
      type = "txp";
      pname = "default_ls";
      version = "2019-03-29";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "default_ls";
        release = 1245;
        versionName = "2019-03-29";
        sha256 = "1g8nj94x1kbvf9bi3zsmlamjz8r74dbsizc3h7isggijjdj4x2nb";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC-BY-SA-3.0" ];
        description = "The default TP for Minetest Game, using reduced saturation";

      };
    };

    "TumeniNodes"."facade" = buildMinetestPackage rec {
      type = "mod";
      pname = "facade";
      version = "facade";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "facade";
        release = 1610;
        versionName = "facade";
        sha256 = "0gzadl6181f1qmcf3bqqz0g6ch8i957cxi1h37gif62r66p9chcq";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds decorative clay and stone-type nodes to Minetest Game.";

      };
    };

    "TumeniNodes"."pkarcs" = buildMinetestPackage rec {
      type = "mod";
      pname = "pkarcs";
      version = "pkarcs";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "pkarcs";
        release = 1933;
        versionName = "pkarcs";
        sha256 = "1zxvl1fs8fqwvkh8kh6csj9dgysl64nzik2c9m1rgqpivfkqk4ha";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds arched doors";

      };
    };

    "TumeniNodes"."stackslabs" = buildMinetestPackage rec {
      type = "mod";
      pname = "stackslabs";
      version = "1.0";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "stackslabs";
        release = 674;
        versionName = "1.0";
        sha256 = "0q96s25q8hj7svcnymf21lxan6i9vx79pmmyda988mwz6ppnx702";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "stackable slabs for Minetest";

      };
    };

    "TumeniNodes"."stoneworks" = buildMinetestPackage rec {
      type = "mod";
      pname = "stoneworks";
      version = "2018_5_25";
      src = fetchFromContentDB {
        author = "TumeniNodes";
        technicalName = "stoneworks";
        release = 116;
        versionName = "2018/5/25";
        sha256 = "0qdicn1wz5p2dwb1c6gxxwa5f6i3dqmkk0k14fahgvz6qxz4a4m6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Stoneworks simply adds some fun, and cool building options to Minetest.";

      };
    };

    "TwigGlenn4"."ore_info" = buildMinetestPackage rec {
      type = "mod";
      pname = "ore_info";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "TwigGlenn4";
        technicalName = "ore_info";
        release = 2422;
        versionName = "1.0.0";
        sha256 = "0zrvms6hyrk3zmfpwyms82hg7v6p48x84p4lq9w9w6g0ncm64qsi";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Show ore depth and rarity.";

      };
    };

    "TwigGlenn4"."resource_crops" = buildMinetestPackage rec {
      type = "mod";
      pname = "resource_crops";
      version = "1.2.2";
      src = fetchFromContentDB {
        author = "TwigGlenn4";
        technicalName = "resource_crops";
        release = 11843;
        versionName = "1.2.2";
        sha256 = "1xwbwbvcji62fz8w9w5l6gv6sidkapsfkams9x6rmgkw1kgd7lkq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Simple crops to grow resources inspired by Mystical Agriculture for Minecraft";

      };
    };

    "UbuntuJared"."speed_boots" = buildMinetestPackage rec {
      type = "mod";
      pname = "speed_boots";
      version = "More_Boots";
      src = fetchFromContentDB {
        author = "UbuntuJared";
        technicalName = "speed_boots";
        release = 8008;
        versionName = "More Boots";
        sha256 = "0sc6w3hqdadd9f0gr8p567n891x5mkaa222vdl4ks8cw6krvg7f7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Fork of ClothierEdward's \"Boots Of Swiftness\", adds new boots that let you jump higher and run faster";

      };
    };

    "UnbrokenUnworn"."modular_portals" = buildMinetestPackage rec {
      type = "game";
      pname = "modular_portals";
      version = "Minetest_Game_Jam";
      src = fetchFromContentDB {
        author = "UnbrokenUnworn";
        technicalName = "modular_portals";
        release = 10101;
        versionName = "Minetest Game Jam";
        sha256 = "03d8k7cn5wgfha4mgsvipy78ysgzmrivgd8a10akdm4kdgvy4xlg";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Explore a strange hall filled with portals";

      };
    };

    "VanessaE"."basic_materials" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_materials";
      version = "2022-08-12";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "basic_materials";
        release = 13187;
        versionName = "2022-08-12";
        sha256 = "0w08n3ipbcwry3qznnnbpibl7rwgzdlq8pfyknzpanm7q9h4i3ca";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides a small selection of \"basic\" materials and items that other mods should use when possible -- things like steel bars and chains, wire, plastic strips and sheets, and more.";

      };
    };

    "VanessaE"."basic_signs" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_signs";
      version = "2022-06-17";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "basic_signs";
        release = 12541;
        versionName = "2022-06-17";
        sha256 = "0y4zw1xsf4z725i4bh8dsgcrswv90ihfq5r3an38r7yjjl861192";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "A small selection of metal wall signs, and a few kinds of wooden signs.";

      };
    };

    "VanessaE"."biome_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "biome_lib";
      version = "2022-07-10";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "biome_lib";
        release = 12782;
        versionName = "2022-07-10";
        sha256 = "0ks3s9hsp3b898q00d5g9xhc3g5gzyldn658q65fgwmwf45iis8a";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "The biome spawning and management library.";

      };
    };

    "VanessaE"."coloredwood" = buildMinetestPackage rec {
      type = "mod";
      pname = "coloredwood";
      version = "2021-04-14-1";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "coloredwood";
        release = 7513;
        versionName = "2021-04-14-1";
        sha256 = "1hwprj1xx8gryrm29rl69izq410rp2c2564bqpqa3is4ymnr72s4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Colorize some wood!";

      };
    };

    "VanessaE"."currency" = buildMinetestPackage rec {
      type = "mod";
      pname = "currency";
      version = "2022-08-10";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "currency";
        release = 13120;
        versionName = "2022-08-10";
        sha256 = "1agpz8d6mzd924xk8af7qwxnqvk58j3fv1m8mf1i10ipcwj6vlx6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides shops, barter tables, safes, and multiple denominations of currency, called \"Minegeld\". Originally written by Dan Duncombe, but maintained by me.";

      };
    };

    "VanessaE"."dreambuilder_game" = buildMinetestPackage rec {
      type = "game";
      pname = "dreambuilder_game";
      version = "2022-10-20";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "dreambuilder_game";
        release = 14509;
        versionName = "2022-10-20";
        sha256 = "0fisbc4gkd158i5j1mlk3qyhaap03xx2gv61ri5jqrc8laz5hwyf";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-4.0" ];
        description = "Dreambuilder is my attempt to give the player pretty much everything they could ever want to build with, and all the tools they should need to actually get the job done.";

      };
    };

    "VanessaE"."dreambuilder_hotbar" = buildMinetestPackage rec {
      type = "mod";
      pname = "dreambuilder_hotbar";
      version = "2022-07-23";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "dreambuilder_hotbar";
        release = 12893;
        versionName = "2022-07-23";
        sha256 = "1y2lqvnn4l0pmhr6g09yc17hz1pf530apx6dxjyy8bxk2s9qlvsz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Expands the hotbar to up to 32 slots";

      };
    };

    "VanessaE"."gloopblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "gloopblocks";
      version = "2022-06-23";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "gloopblocks";
        release = 12593;
        versionName = "2022-06-23";
        sha256 = "1m68rjv8ny4r5dzs2apd4nxw6wwdqxpr910awim2244pkgibgyr2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds decorative and functional blocks, including cement, rainbow blocks, \"evil\" blocks, and tools.";

      };
    };

    "VanessaE"."home_workshop_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "home_workshop_modpack";
      version = "2022-07-28";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "home_workshop_modpack";
        release = 12937;
        versionName = "2022-07-28";
        sha256 = "16b7x8vxcw5280bkhb9a5rzfdvlpzxhqn2x6647d1snbibr1blk1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "This is a simple modpack containing computers, tools, machines, etc. ";

      };
    };

    "VanessaE"."homedecor_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "homedecor_modpack";
      version = "2022-09-03";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "homedecor_modpack";
        release = 13683;
        versionName = "2022-09-03";
        sha256 = "009m2zgxl543j907mjvvwn39jfipdnwb3af9lwagwv7qqmmw2zxs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Feature-filled home decor modpack.";

      };
    };

    "VanessaE"."ilights" = buildMinetestPackage rec {
      type = "mod";
      pname = "ilights";
      version = "2022-07-18";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "ilights";
        release = 12851;
        versionName = "2022-07-18";
        sha256 = "1006fwl64pa9kyqx0hpkl72a627dp4sr67msnyy9zwz2aj0rpi54";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds various lights.";

      };
    };

    "VanessaE"."led_marquee" = buildMinetestPackage rec {
      type = "mod";
      pname = "led_marquee";
      version = "2022-07-25";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "led_marquee";
        release = 12914;
        versionName = "2022-07-25";
        sha256 = "1xab9g8yl9m0qy55y6x90869jai92vaf67qmh2x3zhgl7fwza0x1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides a simple LED marquee that accepts single characters, strings, or whole screen-fulls of text, via Digilines.";

      };
    };

    "VanessaE"."minislots_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "minislots_modpack";
      version = "2021-04-14-1";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "minislots_modpack";
        release = 7502;
        versionName = "2021-04-14-1";
        sha256 = "0lgn5z7hrl01ab2fyqpsdnqfj4w7li0n8257x43qchjx616skkpj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides an \"engine\" to drive simple slot machines (includes two). Spins reels, takes in/pays out in Minegeld (Dan's currency mod), etc.";

      };
    };

    "VanessaE"."moretrees" = buildMinetestPackage rec {
      type = "mod";
      pname = "moretrees";
      version = "2022-08-26";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "moretrees";
        release = 13556;
        versionName = "2022-08-26";
        sha256 = "1xvs024lp0lwh3p5w7lwmqzl1088vqdlhiiv0whpfinsxqwsnmpd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds a whole bunch of new types of trees, some bearing fruit or similar, using biome_lib for the placement engine.";

      };
    };

    "VanessaE"."new_campfire" = buildMinetestPackage rec {
      type = "mod";
      pname = "new_campfire";
      version = "2022-07-21";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "new_campfire";
        release = 12875;
        versionName = "2022-07-21";
        sha256 = "1szagrxk8lsqhsjf52r882nnm6c64gh65jzg3283f8m3n747mrv5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "You can craft and use better campfire.";

      };
    };

    "VanessaE"."nixie_tubes" = buildMinetestPackage rec {
      type = "mod";
      pname = "nixie_tubes";
      version = "2022-07-13";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "nixie_tubes";
        release = 12809;
        versionName = "2022-07-13";
        sha256 = "1dnakqcvasrb8gxkmz37xp73j7zb42bjllwbdsrdg9qr16239slh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides a set of classic numeric Nixie tubes, alphanumeric tubes similar to Burroughs B-7971, and Dekatron tubes, all controlled by Digilines.";

      };
    };

    "VanessaE"."pipeworks" = buildMinetestPackage rec {
      type = "mod";
      pname = "pipeworks";
      version = "2021-04-14-1";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "pipeworks";
        release = 7488;
        versionName = "2021-04-14-1";
        sha256 = "1navsizqsdl6fmga2qzxls66rwddyzjy218s6dgp36jd46r8zqqi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Supplies a complete set of nice, round mesh-based water pipes, boxy item-transport tubes, and devices that work with them.";

      };
    };

    "VanessaE"."plantlife_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "plantlife_modpack";
      version = "2022-10-11";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "plantlife_modpack";
        release = 14299;
        versionName = "2022-10-11";
        sha256 = "1xw1wc1yv9k32na4v9z0z4ivhkqydl9ki236grbic4w92zxbgsvc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds various kinds of plants, fruit bushes, fallen trees, and a whole host of foliage and other ground cover.";

      };
    };

    "VanessaE"."signs_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "signs_lib";
      version = "2022-07-22";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "signs_lib";
        release = 12884;
        versionName = "2022-07-22";
        sha256 = "10dbb7h9x9rvqa9w9rm6cvzv6inxmyv92zbfr39w5y0pg9f9gcr1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds signs with readable text.";

      };
    };

    "VanessaE"."simple_streetlights" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_streetlights";
      version = "2021-12-26";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "simple_streetlights";
        release = 10264;
        versionName = "2021-12-26";
        sha256 = "0gp7cbv66hq8f99qqi3dncdq5awdmd8na7sp5zazhvr2ixjc9d78";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds various streetlight \"spawners\" (5m tall, supports multiple pole materials and light sources)";

      };
    };

    "VanessaE"."street_signs" = buildMinetestPackage rec {
      type = "mod";
      pname = "street_signs";
      version = "2021-04-14-1";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "street_signs";
        release = 7509;
        versionName = "2021-04-14-1";
        sha256 = "03ijp3wx76ipx3zjdydnaq2ffqax9aqw36ccckzim8r2hi5in1kr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Road signs galore!";

      };
    };

    "VanessaE"."unifieddyes" = buildMinetestPackage rec {
      type = "mod";
      pname = "unifieddyes";
      version = "2022-09-12";
      src = fetchFromContentDB {
        author = "VanessaE";
        technicalName = "unifieddyes";
        release = 13815;
        versionName = "2022-09-12";
        sha256 = "05ddva98bdnlccpkp4hczjq2rm730fkv0widjh9jcdqgjb9pywa3";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Unified Dyes expands the standard dye set from 15 to up to 256 colors (depending on the object to be colored)";

      };
    };

    "VeproGames"."100_minerals_to_success" = buildMinetestPackage rec {
      type = "game";
      pname = "100_minerals_to_success";
      version = "1.1";
      src = fetchFromContentDB {
        author = "VeproGames";
        technicalName = "100_minerals_to_success";
        release = 14430;
        versionName = "1.1";
        sha256 = "1xn2hk6mg30iw69immahzqk7cv8hxk14hfxd2ca05rxrdywfqlf0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Mine Minerals, Craft Pickaxes and dig deeper! Mine all 100 Minerals and beware of hazards!";

      };
    };

    "WINNIE"."color_armors" = buildMinetestPackage rec {
      type = "mod";
      pname = "color_armors";
      version = "0.4";
      src = fetchFromContentDB {
        author = "WINNIE";
        technicalName = "color_armors";
        release = 7930;
        versionName = "0.4";
        sha256 = "0gpgkmi2ailzcfw0szisd53yy48ly9cs6jb053f62vngznxhhnhj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Colorful Armors :)";

      };
    };

    "WINNIE"."miner16px" = buildMinetestPackage rec {
      type = "txp";
      pname = "miner16px";
      version = "0.1.16__PvP_Update_";
      src = fetchFromContentDB {
        author = "WINNIE";
        technicalName = "miner16px";
        release = 14292;
        versionName = "0.1.16 (PvP Update)";
        sha256 = "1jxkzazfrxqhkwz276b8sii8v7y0p5h56pzd353cz0pjpf3padzm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "An easy comfortable 16px texture pack";

      };
    };

    "WINNIE"."topaz_items" = buildMinetestPackage rec {
      type = "mod";
      pname = "topaz_items";
      version = "0.1.2";
      src = fetchFromContentDB {
        author = "WINNIE";
        technicalName = "topaz_items";
        release = 7188;
        versionName = "0.1.2";
        sha256 = "027vdcnbnx0qc0b3614ahjza9f98d6y9wjfyc6m6x0p307sh7vx2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Topaz Items for Minetest";

      };
    };

    "Walfun"."outline_square_crosshair" = buildMinetestPackage rec {
      type = "txp";
      pname = "outline_square_crosshair";
      version = "outline_square_crosshair_v0.2";
      src = fetchFromContentDB {
        author = "Walfun";
        technicalName = "outline_square_crosshair";
        release = 13436;
        versionName = "outline_square_crosshair_v0.2";
        sha256 = "0pjvd27phdpf6ml8n46bxz2ppf6hg3fqbpw5avd8vy5csy2yphwn";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "It replaces the + and X crosshair to the outline square crosshair.";

      };
    };

    "Warr1024"."autotrek" = buildMinetestPackage rec {
      type = "mod";
      pname = "autotrek";
      version = "01665528-f249002";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "autotrek";
        release = 10284;
        versionName = "01665528-f249002";
        sha256 = "0biscl65w69hpy1bs0dr8sw7i3pj9dni244fvdk6b44p3nk5rn7z";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Automatic long-distance walking via assisted auto-forward";

      };
    };

    "Warr1024"."doomsday" = buildMinetestPackage rec {
      type = "mod";
      pname = "doomsday";
      version = "01809780-c6cb06c";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "doomsday";
        release = 11747;
        versionName = "01809780-c6cb06c";
        sha256 = "1gcwcjik268s5lqh84w0y3srbx31w60qyw02m3fj3pnb6mb56irj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The pinnacle of explosives mods";

      };
    };

    "Warr1024"."nc_ad_removal" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_ad_removal";
      version = "01809780-8a14d76";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_ad_removal";
        release = 11746;
        versionName = "01809780-8a14d76";
        sha256 = "044xkmdwgczxh900svr7x2pv7wv3jmh67cdwsbx0dca82543qhp2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Removes all ads from NodeCore";

      };
    };

    "Warr1024"."nc_beacon" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_beacon";
      version = "01712818-0a3575f";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_beacon";
        release = 10917;
        versionName = "01712818-0a3575f";
        sha256 = "0k6dljlxa13d3a4yvx1mamskwm2gkqa29f22xi3grpd6swrplqxn";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Long-distance navigation beacons for NodeCore";

      };
    };

    "Warr1024"."nc_cats" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_cats";
      version = "02092259-c7f1cba";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_cats";
        release = 14474;
        versionName = "02092259-c7f1cba";
        sha256 = "0c2h93cas7ix5pbcrzidm5rv6acdmyp8pidh19i6aw5qbc2dm6fq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add adorable cats to NodeCore";

      };
    };

    "Warr1024"."nc_exmachina" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_exmachina";
      version = "02075462-39491c6";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_exmachina";
        release = 14239;
        versionName = "02075462-39491c6";
        sha256 = "0zjak6za3f02d2wr36m9s9f297kf7vr90wsx3warjinkb341szf9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "An other-worldly platform to preserve some of your stuff across map resets for NodeCore";

      };
    };

    "Warr1024"."nc_nature" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_nature";
      version = "01665531-9ff7576";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_nature";
        release = 10790;
        versionName = "01665531-9ff7576";
        sha256 = "14kn6b607dviviidllxf3dmpmx0779h4rx70jcyr55rpd0nxhl2g";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Updated, fixed, enhanced edition of Winter94's NodeCore Nature";

      };
    };

    "Warr1024"."nc_reative" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_reative";
      version = "01665537-f127e05";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_reative";
        release = 10287;
        versionName = "01665537-f127e05";
        sha256 = "1rd1iib20bnhh1ig6zaa2hqzal3vgqnpswfgi8sxbv5krk6nlci2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "\"Creative mode\" for NodeCore: adds a rc_reative priv, /rs chat command, and \"replica\" nodes.";

          homepage = "https://nodecore.mine.nu";

      };
    };

    "Warr1024"."nc_regression" = buildMinetestPackage rec {
      type = "txp";
      pname = "nc_regression";
      version = "01712878-3226e4f";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_regression";
        release = 10919;
        versionName = "01712878-3226e4f";
        sha256 = "0z5l3w4k29r4b0i7vda09mi6g092jwcs3617gdvi3vrf67282m9s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The Comic Sans of NodeCore Textures";

      };
    };

    "Warr1024"."nc_skins" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_skins";
      version = "01833213-b94cae0";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_skins";
        release = 11937;
        versionName = "01833213-b94cae0";
        sha256 = "1lkx58k0lj0rv2z6jk6hk0hd0mvs7px1zr940zshbs64af8sfyig";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Custom player skins for NodeCore";

      };
    };

    "Warr1024"."nc_sky_ultra_mulligan" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_sky_ultra_mulligan";
      version = "01712899-ad38bcd";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_sky_ultra_mulligan";
        release = 10922;
        versionName = "01712899-ad38bcd";
        sha256 = "0v8598952cxrida8qk9c2syj9x4g16517rm4jy0xc782l6gynwrc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Safety net against falling off your island";

      };
    };

    "Warr1024"."nc_skyrealm" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_skyrealm";
      version = "02093694-0147874";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_skyrealm";
        release = 14516;
        versionName = "02093694-0147874";
        sha256 = "1bnqz7x13q2vji4w7dz2v1nq3dq30wa7jh0vfafhpdwv7qq12dlx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "SkyBlocks inside vanilla NodeCore";

      };
    };

    "Warr1024"."nc_stairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_stairs";
      version = "01809779-3d440e8";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_stairs";
        release = 11745;
        versionName = "01809779-3d440e8";
        sha256 = "179nifq0slv17bd10cmymz0ypqqp7nlpjhah55a2dda7byf7jd6i";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an assortment of stairs and slabs to NodeCore";

      };
    };

    "Warr1024"."nc_vanillapack" = buildMinetestPackage rec {
      type = "txp";
      pname = "nc_vanillapack";
      version = "02057398-92cd0a2";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_vanillapack";
        release = 14035;
        versionName = "02057398-92cd0a2";
        sha256 = "1w496phxiqzsidvhxnky64njn5l435vapcmnrnk4dw0xz2nzs0qm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "NodeCore's Default Textures, as a Texture Pack";

      };
    };

    "Warr1024"."nc_yctiwy" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_yctiwy";
      version = "02080335-e145fc9";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_yctiwy";
        release = 14297;
        versionName = "02080335-e145fc9";
        sha256 = "0bw4x3w48hxbfwj0q87vk01837k2ynbxmpnrz5cdfpx0y2hv5piy";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "NodeCore players leave their items behind, accessible to other players, when they log out.";

          homepage = "https://nodecore.mine.nu/";

      };
    };

    "Warr1024"."nc_ziprunes" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_ziprunes";
      version = "02082753-50cc8d7";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nc_ziprunes";
        release = 14340;
        versionName = "02082753-50cc8d7";
        sha256 = "0xb5j0n8q8p6g567grq8j06kmwasdgldsik279q9qxyjv6npqlp3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Gameplay-integrated fast-travel system for NodeCore.";

          homepage = "https://nodecore.mine.nu/";

      };
    };

    "Warr1024"."nodecore" = buildMinetestPackage rec {
      type = "game";
      pname = "nodecore";
      version = "02082752-f5a43c58";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nodecore";
        release = 14409;
        versionName = "02082752-f5a43c58";
        sha256 = "15667x8q51cafy1r48kvnrw3xwbpxq8nha0p1qg4z3d9nhkladmf";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Minetest's top original voxel game about emergent mechanics and exploration";

          homepage = "https://nodecore.mine.nu";

      };
    };

    "Warr1024"."nodecore_alpha" = buildMinetestPackage rec {
      type = "game";
      pname = "nodecore_alpha";
      version = "02093764-d0a508f0";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "nodecore_alpha";
        release = 14520;
        versionName = "02093764-d0a508f0";
        sha256 = "1s7m78akvgfzl2gf388kr2aw0xhcg8zw68cbma71n7khly6shm87";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Early-access edition of NodeCore with latest features (and maybe bugs)";

          homepage = "https://nodecore.mine.nu";

      };
    };

    "Warr1024"."puzzlemap" = buildMinetestPackage rec {
      type = "mod";
      pname = "puzzlemap";
      version = "01712903-cff5f80";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "puzzlemap";
        release = 10924;
        versionName = "01712903-cff5f80";
        sha256 = "03h5fhh9j5ail1h4czmhxfd91xqh8mydczsg9w0q16wjsv0x76si";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Puzzle/Adventure Map System using Node Protection Mechanic";

      };
    };

    "Warr1024"."szutilpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "szutilpack";
      version = "02093716-7665c4d";
      src = fetchFromContentDB {
        author = "Warr1024";
        technicalName = "szutilpack";
        release = 14518;
        versionName = "02093716-7665c4d";
        sha256 = "1axf0yz4051zyd99qxm2ipfq2jn5wmanx6zx0dgxkm9krq5cg7ph";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A collection of misc dependency-free utilities primarily for server hosts.";

      };
    };

    "WilLiam12"."willadmin" = buildMinetestPackage rec {
      type = "mod";
      pname = "willadmin";
      version = "texture_fix";
      src = fetchFromContentDB {
        author = "WilLiam12";
        technicalName = "willadmin";
        release = 8648;
        versionName = "texture fix";
        sha256 = "099xrzn6yyxg1mgpqq275j00ni4aajjx5pg10qj119vnizifc6qf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Tools for server admins to ban and kick bad players.";

      };
    };

    "Winter94"."nc_adamant" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_adamant";
      version = "NC_Adamant__Fixed__2021-12-28";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_adamant";
        release = 10333;
        versionName = "NC Adamant ~Fixed~ 2021-12-28";
        sha256 = "0pwbnbqjp2a3ilrgxhpskcxvlylkr4p93rsxw9dbx2dax41z49nw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Adamant, a new metal ore, deep underground/";

      };
    };

    "Winter94"."nc_light" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_light";
      version = "NC_Light_2021-c";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_light";
        release = 7478;
        versionName = "NC Light 2021-c";
        sha256 = "0qgp55xc259l10fm343gbalqnp2i5zbn63qlpc8pi53z67pgn0xa";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "New light sources for NodeCore";

      };
    };

    "Winter94"."nc_lignite" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_lignite";
      version = "Lignite_2021-12-28";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_lignite";
        release = 10327;
        versionName = "Lignite 2021-12-28";
        sha256 = "1iq7bh6y37c8fs2snnis3kj39zhwihdavs8fswxi1s4w6v1iwwvj";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Lignite, an ore of coal.";

      };
    };

    "Winter94"."nc_pebbles" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_pebbles";
      version = "NC_Pebbles__Last_Release_";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_pebbles";
        release = 10739;
        versionName = "NC Pebbles ~Last Release~";
        sha256 = "0pwp0mqwgp169088z0bs12ra51jfqxdf4dp4hc8g6kcbb3nx49z3";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "adds pebbles to NodeCore in order to simplify a few logical leaps and inconsistencies.";

      };
    };

    "Winter94"."nc_pumbob" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_pumbob";
      version = "NC_Pumbob_2022-b";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_pumbob";
        release = 10564;
        versionName = "NC Pumbob 2022-b";
        sha256 = "0n96dfgcyq6rwq0wknixmacmfzf4kwg7vc9751p86fng1z347c7m";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "adds carvable and sealable pumice bobbers/floaters";

      };
    };

    "Winter94"."nc_pummine" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_pummine";
      version = "NodeCore_PumMINE_v1";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_pummine";
        release = 7284;
        versionName = "NodeCore PumMINE v1";
        sha256 = "0wg9n3k2bw9s1akq8jyi707r14gpkh5skaxj1hhg2d3m6cxpc9li";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Mineable pumice";

      };
    };

    "Winter94"."nc_steam" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_steam";
      version = "NC_Steam_2022-b";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_steam";
        release = 10590;
        versionName = "NC Steam 2022-b";
        sha256 = "1kn11sr15xvh954b9nnsm8y1276d6krlgli5jbzm2sr59fcy8gcc";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds new mechanics to Nodecore, such as steam power and dynamic water";

      };
    };

    "Winter94"."nc_vulcan" = buildMinetestPackage rec {
      type = "mod";
      pname = "nc_vulcan";
      version = "2022-02-14";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "nc_vulcan";
        release = 12883;
        versionName = "2022-02-14";
        sha256 = "19px5l68dd9j41q4cr0jplbf2bbwys22bdazinghjfm03dn04dr1";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Reworks Magma Generation in NodeCore.";

      };
    };

    "Winter94"."wc_adamant" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_adamant";
      version = "2022-01-09";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_adamant";
        release = 10567;
        versionName = "2022-01-09";
        sha256 = "0lnm5079mafpk3l3i6cc1sgqa7wv62zyvgdzybqz2zp2m7h3vmdl";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds Adamant, a new metal ore, deep underground/";

      };
    };

    "Winter94"."wc_coal" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_coal";
      version = "WC_Coal_2022-c";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_coal";
        release = 12891;
        versionName = "WC Coal 2022-c";
        sha256 = "0wb0y654gcpi8mf6n3pmmbfbxwmhpx5ymlsw5gdsnwmm8pskz7h0";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds 3 ores of coal to NodeCore. ";

      };
    };

    "Winter94"."wc_luminous" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_luminous";
      version = "2022-02-20";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_luminous";
        release = 11359;
        versionName = "2022-02-20";
        sha256 = "1i661p9m4sf3l6fya7aiwc4xnib9m7ya4pnh45xkkax21bbbiggy";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "New light sources for NodeCore";

      };
    };

    "Winter94"."wc_meltdown" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_meltdown";
      version = "Meltdown_2022-e";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_meltdown";
        release = 10640;
        versionName = "Meltdown 2022-e";
        sha256 = "0z2kqdb42car0isn5qd4bmi02wldmka9vp3rs65ba27g20lpnjz1";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A new challenge, with serious implications...";

      };
    };

    "Winter94"."wc_naturae" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_naturae";
      version = "2022-02-21";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_naturae";
        release = 11373;
        versionName = "2022-02-21";
        sha256 = "1hm6pc9v0chnwj4zk6lailm1aq7q79j0kp0pby6v29q9c70rjvv6";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "The Latest and Greatest Version of NodeCore Nature, with updated code from Warr1024!";

      };
    };

    "Winter94"."wc_plumbum" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_plumbum";
      version = "2022-02-03";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_plumbum";
        release = 11041;
        versionName = "2022-02-03";
        sha256 = "000zjzngcz9abzn8v6b85zjg3b6zmrsck5xv7xnsbs5f850vd42i";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Plumbum, the best radiation protection the earth can provide!";

      };
    };

    "Winter94"."wc_road" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_road";
      version = "The_Road__NC__21-12-28";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_road";
        release = 10330;
        versionName = "The Road (NC) 21-12-28";
        sha256 = "13bhc39yapxnnydpb08mbkwnwhhg0rlfy37jwp2skxdyzk2jygj5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This is a port of thelowerroad for NodeCore that adds a long road from -Z to +Z to the world, during world-generation.";

      };
    };

    "Winter94"."wc_steam" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_steam";
      version = "NodeCore_Steam_Re_2022-a";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_steam";
        release = 10875;
        versionName = "NodeCore Steam Re 2022-a";
        sha256 = "14bsc879z31iizivkhylshs3q7186v2gb6kzlm3p1ns6iqn84ng4";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds Steam & Basic Steam Behavior To NodeCore";

      };
    };

    "Winter94"."wc_steampunk" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_steampunk";
      version = "NodeCore_Steampunk_Engineering";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_steampunk";
        release = 10877;
        versionName = "NodeCore Steampunk Engineering";
        sha256 = "1s11zaqp19pn73ha5326977i7w73ncbv7pjchqpbjv9jg5dxhyrj";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Steam Turbines, Waterwheels, & More!";

      };
    };

    "Winter94"."wc_storage" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_storage";
      version = "2022-02-23";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_storage";
        release = 11403;
        versionName = "2022-02-23";
        sha256 = "1znxizfki0bwgysb34508mrkndhdkyvii3p8bb5hzcwryqhkj15w";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds More Storage Containers to NodeCore";

      };
    };

    "Winter94"."wc_strata" = buildMinetestPackage rec {
      type = "mod";
      pname = "wc_strata";
      version = "WC_Strata_-_Lignite_Compatible";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wc_strata";
        release = 10325;
        versionName = "WC Strata - Lignite Compatible";
        sha256 = "16w0mx0ma2025x9pfqrh43k9vsy0pfi8pj3f29i7l1cd9kdy38g1";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Exploring the NodeCore underground has never been more colorful.";

      };
    };

    "Winter94"."wintercore" = buildMinetestPackage rec {
      type = "txp";
      pname = "wintercore";
      version = "2022-01-04";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wintercore";
        release = 10528;
        versionName = "2022-01-04";
        sha256 = "0v8grq0vw32q6929qf2madf5bgpp19jrwndaaa6jzdjj4g5v7n3x";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "A stark and detailed texture pack for NodeCore";

      };
    };

    "Winter94"."wintercore_dark" = buildMinetestPackage rec {
      type = "txp";
      pname = "wintercore_dark";
      version = "2022-01-25";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wintercore_dark";
        release = 10835;
        versionName = "2022-01-25";
        sha256 = "11rp55yx18j1wny7xyhflifw52xai8smwm4747adxzn3k46bp39v";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Dark and bold textures for NodeCore by WintersKnight94";

      };
    };

    "Winter94"."wintercore_detailed" = buildMinetestPackage rec {
      type = "txp";
      pname = "wintercore_detailed";
      version = "2022-09-09";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wintercore_detailed";
        release = 13768;
        versionName = "2022-09-09";
        sha256 = "1h37cznfnygw8asvkw8005ll6xnwf60cbzqcqm40yb4zwhfh5pvk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Custom 32x32 Nodecore textures by Wintersknight";

      };
    };

    "Winter94"."wintercore_vibrant" = buildMinetestPackage rec {
      type = "txp";
      pname = "wintercore_vibrant";
      version = "2022-02-23";
      src = fetchFromContentDB {
        author = "Winter94";
        technicalName = "wintercore_vibrant";
        release = 11404;
        versionName = "2022-02-23";
        sha256 = "1fd1l8rymnjiiyqf5s3hdjvz5b17qzr7n5c6vcsf71zvzxy69gmk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Custom Nodecore textures by Wintersknight";

      };
    };

    "Wovado"."openion_glostone_building_blocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "openion_glostone_building_blocks";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Wovado";
        technicalName = "openion_glostone_building_blocks";
        release = 12461;
        versionName = "1.0";
        sha256 = "0zr7n2ch5nkh6yhs3y2n6mcaqgfgapmzvsl1n15gqlkdy2dgjd7b";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Adds basic glostone-based building materials";

      };
    };

    "Wovado"."openion_yeast" = buildMinetestPackage rec {
      type = "mod";
      pname = "openion_yeast";
      version = "0.8";
      src = fetchFromContentDB {
        author = "Wovado";
        technicalName = "openion_yeast";
        release = 12462;
        versionName = "0.8";
        sha256 = "02r564l3xjx5zzaahgjy2y00kinwnhlxjph65mn6w9aibmfyhng7";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Adds Yeast and a Yeast Barrel";

      };
    };

    "Wuzzy"."basic_hud" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_hud";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "basic_hud";
        release = 331;
        versionName = "2018-07-08";
        sha256 = "1w8rjnz5yqi21zlwdh4vmnbqm0cxk2yp9badbnqxvna844hbrjgr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds basic but neccessary HUD images: Heart icon, bubble icon, … (for game authors)";

      };
    };

    "Wuzzy"."bedrock2" = buildMinetestPackage rec {
      type = "mod";
      pname = "bedrock2";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "bedrock2";
        release = 338;
        versionName = "2018-07-08";
        sha256 = "0w41sr857fy9s5xlsiifh401cg182vdajnrd9maia2hdpl94cxp8";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds an indestructable bedrock layer at the bottom of the world.";

      };
    };

    "Wuzzy"."biomeinfo" = buildMinetestPackage rec {
      type = "mod";
      pname = "biomeinfo";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "biomeinfo";
        release = 1865;
        versionName = "1.0.1";
        sha256 = "1kqgzh7lfcn03gpxfvnyw2m1px1fsmz9gnyhv20rk1ajd0a107ms";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Simple API to get data about biomes.";

      };
    };

    "Wuzzy"."calendar" = buildMinetestPackage rec {
      type = "mod";
      pname = "calendar";
      version = "1.1.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "calendar";
        release = 14049;
        versionName = "1.1.1";
        sha256 = "09wjhlq3yxh4vqzm3pgand652d32v951mlngn8nkm2vb1wzb6ri2";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "A simple calender system to track the passage of days";

      };
    };

    "Wuzzy"."calendar_node" = buildMinetestPackage rec {
      type = "mod";
      pname = "calendar_node";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "calendar_node";
        release = 5048;
        versionName = "1.0.1";
        sha256 = "09hli2ck601ji8ir3mr9rrhli51icsvnsmf0j8r010ni3sf9kyqg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a placeable calendar";

      };
    };

    "Wuzzy"."central_message" = buildMinetestPackage rec {
      type = "mod";
      pname = "central_message";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "central_message";
        release = 333;
        versionName = "2018-07-08";
        sha256 = "1pn9icfipkf8rfk4574ad0q0sdcl5iq9r7jwjrh07fnp39wq80ma";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Simple API to show messages to the center of the screen to players.";

      };
    };

    "Wuzzy"."colorcubes" = buildMinetestPackage rec {
      type = "mod";
      pname = "colorcubes";
      version = "0.4";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "colorcubes";
        release = 467;
        versionName = "0.4";
        sha256 = "1wkkpaqvas1z3igcz11d5vhzmk3vdmi3df02xpzpwinsw8wf5ag8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This mod contains several colorful abstract blocks for decoration.";

      };
    };

    "Wuzzy"."cups" = buildMinetestPackage rec {
      type = "mod";
      pname = "cups";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "cups";
        release = 1855;
        versionName = "1.0.0";
        sha256 = "12cxnaka05sm7nlg933ys4skhk6sh5sshdqixli51bgwkk9iqlsy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Decorative cups.";

      };
    };

    "Wuzzy"."dice2" = buildMinetestPackage rec {
      type = "mod";
      pname = "dice2";
      version = "1.3";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "dice2";
        release = 468;
        versionName = "1.3";
        sha256 = "1kgvsbbl5bsn421d79ak2s2qy4gqjd5qm157nn0ix89d4rdidays";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Decorational dice blocks which face a random direction.";

      };
    };

    "Wuzzy"."doc" = buildMinetestPackage rec {
      type = "mod";
      pname = "doc";
      version = "1.3.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "doc";
        release = 7272;
        versionName = "1.3.0";
        sha256 = "059hbf3w6zblg4hh8665m69gavp3vc61mar22c1lh1225qpqnbpw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A simple in-game documentation system which enables mods to add help entries based on templates.";

      };
    };

    "Wuzzy"."doc_basics" = buildMinetestPackage rec {
      type = "mod";
      pname = "doc_basics";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "doc_basics";
        release = 7273;
        versionName = "1.2.0";
        sha256 = "1ydk4kvlh137jh21m14vzzycqgd2px6g1cslzqljh86q2zysfbyh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds some help texts explaining how to use Minetest.";

      };
    };

    "Wuzzy"."doc_encyclopedia" = buildMinetestPackage rec {
      type = "mod";
      pname = "doc_encyclopedia";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "doc_encyclopedia";
        release = 7277;
        versionName = "1.3.1";
        sha256 = "0fc7f2xccyjkdn3hknpig1dkbnndx12a8nllmr96wss7q0ixynsi";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an encyclopedia item which allows you to access the help.";

      };
    };

    "Wuzzy"."doc_identifier" = buildMinetestPackage rec {
      type = "mod";
      pname = "doc_identifier";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "doc_identifier";
        release = 7276;
        versionName = "1.3.1";
        sha256 = "00dz39294kxyas6xmvwhisp0my8bvk1akjypgch3c9fb8ipjnd3s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a tool which shows help entries about almost anything which it punches.";

      };
    };

    "Wuzzy"."doc_items" = buildMinetestPackage rec {
      type = "mod";
      pname = "doc_items";
      version = "1.3.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "doc_items";
        release = 7275;
        versionName = "1.3.0";
        sha256 = "012sn057c9li5029c0i4gh14lp9j9wajll8g9dg8s65pb4bzmpy9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds automatically generated help texts for items.";

      };
    };

    "Wuzzy"."easyvend" = buildMinetestPackage rec {
      type = "mod";
      pname = "easyvend";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "easyvend";
        release = 3353;
        versionName = "1.0.1";
        sha256 = "06yh1fb08w7sf3sxdb6v8xa4h1wymis0p1bwkcjwr9lmq24ckkmp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds vending and depositing machines which allow to buy and sell items from other players, using a currency item.";

      };
    };

    "Wuzzy"."findbiome" = buildMinetestPackage rec {
      type = "mod";
      pname = "findbiome";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "findbiome";
        release = 2241;
        versionName = "1.0.1";
        sha256 = "0ljrk6fk29lv5yx124isizqd4q56jv05k1pxwm269xiy0sbmaxyw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add commands to list and find biomes";

      };
    };

    "Wuzzy"."flying_carpet" = buildMinetestPackage rec {
      type = "mod";
      pname = "flying_carpet";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "flying_carpet";
        release = 1216;
        versionName = "1.0.0";
        sha256 = "08rqaysgmmi9m378z9qpl0bv1ndvssqiiyz6gwii189b3hpym7fx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Quickly explore the vast terrain with the magical flying carpet.";

      };
    };

    "Wuzzy"."giftbox2" = buildMinetestPackage rec {
      type = "mod";
      pname = "giftbox2";
      version = "v3.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "giftbox2";
        release = 9426;
        versionName = "v3.0";
        sha256 = "1w0spiy3vsnfgz1bcljk6y1zifhpjn339mf55bav9idh6kwc1iyi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Gift boxes that players can give to other who will then receive random items";

      };
    };

    "Wuzzy"."hades_revisited" = buildMinetestPackage rec {
      type = "game";
      pname = "hades_revisited";
      version = "0.15.2";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "hades_revisited";
        release = 12964;
        versionName = "0.15.2";
        sha256 = "18zlz6zqm0wpjfrkjl31r932j55lfbz9a9n0bis9fr55cwfm6x5h";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "You have stranded on the planet Hades. Use your limited supplies to survive and use terraforming to create a beautiful habitable place. (EARLY TEST VERSION)";

      };
    };

    "Wuzzy"."hbarmor" = buildMinetestPackage rec {
      type = "mod";
      pname = "hbarmor";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "hbarmor";
        release = 12993;
        versionName = "1.0.1";
        sha256 = "1y3wmfszspp9rq2xqx4bld9s674swcj7c2wr6hisj6c94r23asc4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a HUD bar displaying the current damage of the player's armor.";

      };
    };

    "Wuzzy"."hbhunger" = buildMinetestPackage rec {
      type = "mod";
      pname = "hbhunger";
      version = "1.1.2";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "hbhunger";
        release = 9156;
        versionName = "1.1.2";
        sha256 = "0ww9sg70hxihlz9d1rrs613vz1jmmhgcwfk3q3rxjhpfp3aqd3zq";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This mod adds a simple hunger mechanic (plus HUD bar) to the game. Eat food to avoid starvation, be sated to regenerate health.";

      };
    };

    "Wuzzy"."hudbars" = buildMinetestPackage rec {
      type = "mod";
      pname = "hudbars";
      version = "2.3.3";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "hudbars";
        release = 8390;
        versionName = "2.3.3";
        sha256 = "12b0bb32w54d6djx64fdwvrwy6llj7vcbivdmhzmixj0cm6vla93";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Replaces the default health and breath symbols by horizontal colored bars with text showing the number. Extensible.";

      };
    };

    "Wuzzy"."inventory_icon" = buildMinetestPackage rec {
      type = "mod";
      pname = "inventory_icon";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "inventory_icon";
        release = 469;
        versionName = "1.1.0";
        sha256 = "0q6zwx2qd822vqlks70qiylqic5zr4qw260gc5j8v6xzkqilw7n4";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Shows a backpack icon in the HUD, which shows how many slots are available and free in the player inventory and equipped bags (if available).";

      };
    };

    "Wuzzy"."lazarr" = buildMinetestPackage rec {
      type = "game";
      pname = "lazarr";
      version = "1.3.2";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "lazarr";
        release = 12770;
        versionName = "1.3.2";
        sha256 = "12kdmxcpg9rk4aslxv35r2bqvvkdg5xcvkfpf0fhlhmlx52a09ar";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Laser puzzle game (UNFINISHED!)";

      };
    };

    "Wuzzy"."ltool" = buildMinetestPackage rec {
      type = "mod";
      pname = "ltool";
      version = "1.6.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "ltool";
        release = 1206;
        versionName = "1.6.1";
        sha256 = "0qyllvhbhcx95d7h3rl4qm9im2wswa4q8qmkjcpnlzhbas3bjghv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A form to easily spawn L-system trees, aimed at mod developers.";

      };
    };

    "Wuzzy"."mana" = buildMinetestPackage rec {
      type = "mod";
      pname = "mana";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "mana";
        release = 1215;
        versionName = "1.3.1";
        sha256 = "0jsa67rn1vxmqk4bpxj77j9c5npwbkni9y7ggmk7dcmzw2vjrapn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a mana attribute to players, can be used as energy source for magical items, etc.";

      };
    };

    "Wuzzy"."mesecons_window" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_window";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "mesecons_window";
        release = 470;
        versionName = "1.0.0";
        sha256 = "1hpb2fdn9p0g7yb3v6jk8p8qxq2l40ac1jinwymyvab0281rqvag";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds 3 glass blocks which change their transparency when supplied with Mesecons power.";

      };
    };

    "Wuzzy"."mineclone2" = buildMinetestPackage rec {
      type = "game";
      pname = "mineclone2";
      version = "0.79.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "mineclone2";
        release = 13864;
        versionName = "0.79.0";
        sha256 = "1icbvjzrgbcmha9dbr4vhigh1k2r229bch4mr0h39kj8jjn13j9l";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A survival sandbox game (work in progress!). Survive, gather, hunt, build, explore, and do much more. An imitation of Minecraft.";

      };
    };

    "Wuzzy"."mtg_plus" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtg_plus";
      version = "1.1.2";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "mtg_plus";
        release = 11968;
        versionName = "1.1.2";
        sha256 = "04bcir41001v7r91iykdrbzr0k3svvq62j80x7plvv7gjrq9rxxy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds various simple decorative blocks, doors, panes and other items, focusing on snow, ice, luxury, bamboo and more.";

      };
    };

    "Wuzzy"."no_fall_damage" = buildMinetestPackage rec {
      type = "mod";
      pname = "no_fall_damage";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "no_fall_damage";
        release = 5788;
        versionName = "1.0.0";
        sha256 = "13gv2k8rhls77zw3k8rj033z91r59yvhhpcmd6k6idmkk2y8ly4b";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Disables fall damage.";

      };
    };

    "Wuzzy"."orienteering" = buildMinetestPackage rec {
      type = "mod";
      pname = "orienteering";
      version = "1.6";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "orienteering";
        release = 5466;
        versionName = "1.6";
        sha256 = "1qb079iijjm88my6wmfrnk31y2d6m47i2hb1ay5gg9p6p2ihv3vg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A collection of tools to help you orient yourselves in the world, such as compass, altimeter, etc.";

      };
    };

    "Wuzzy"."origin" = buildMinetestPackage rec {
      type = "mod";
      pname = "origin";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "origin";
        release = 471;
        versionName = "1.3.1";
        sha256 = "079vrh53pcw4jbkivbxijnvqsf5aknvld388x4vzpd42cbbp2bvl";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds a single starter block below the first spawn position in singlenode, called “The Origin”";

      };
    };

    "Wuzzy"."pedology" = buildMinetestPackage rec {
      type = "mod";
      pname = "pedology";
      version = "2016-11-13";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "pedology";
        release = 472;
        versionName = "2016-11-13";
        sha256 = "0vq4kyaa4v93s717zgd8y23f27k0q717zsrz5fidfs1nvgn61b2j";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds some different ground blocks in several wetness levels; the wetness slowly flows downward.";

      };
    };

    "Wuzzy"."pep" = buildMinetestPackage rec {
      type = "mod";
      pname = "pep";
      version = "2019-08-25";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "pep";
        release = 8091;
        versionName = "2019-08-25";
        sha256 = "0nrqii1l471cy96zgp345r8gi7v4sfmzfjfvv1rh6nn5w04mdgnv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds potions with temporary player effects.";

      };
    };

    "Wuzzy"."perlin_explorer" = buildMinetestPackage rec {
      type = "mod";
      pname = "perlin_explorer";
      version = "1.0.3";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "perlin_explorer";
        release = 12239;
        versionName = "1.0.3";
        sha256 = "0mgxqrl4qh1r1w0nlyq3553r5v6y5vbm6pni3iv4xqxybskpwl8c";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Developer tool to create previews of Perlin noises";

      };
    };

    "Wuzzy"."playereffects" = buildMinetestPackage rec {
      type = "mod";
      pname = "playereffects";
      version = "2019-06-23";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "playereffects";
        release = 8086;
        versionName = "2019-06-23";
        sha256 = "1n76pka41wq9baqaqqgwpija8m92llr3d9nzlkg7dgf61qgqg2j4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Framework for temporary effects for players.";

      };
    };

    "Wuzzy"."playerphysics" = buildMinetestPackage rec {
      type = "mod";
      pname = "playerphysics";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "playerphysics";
        release = 8397;
        versionName = "1.0.1";
        sha256 = "11nzkrsi8zyy8iyrfpsm1djcknjclaynx8hs068a36r6r89yhhjp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This makes it possible for multiple mods to modify player physics (speed, jumping strength, gravity) without conflict.";

      };
    };

    "Wuzzy"."pride_flags" = buildMinetestPackage rec {
      type = "mod";
      pname = "pride_flags";
      version = "2.1.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "pride_flags";
        release = 14107;
        versionName = "2.1.1";
        sha256 = "02qfs5fmv73fsiz55d9zk0pb4pb16xd2hfwv57g8f6qyhxpw9ca2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a variety of animated flags to celebrate Pride";

      };
    };

    "Wuzzy"."repixture" = buildMinetestPackage rec {
      type = "game";
      pname = "repixture";
      version = "3.5.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "repixture";
        release = 13332;
        versionName = "3.5.0";
        sha256 = "1sn4qdcyadrli91jhiwr6b30sx123radh7anq51fxd1i7a160pqg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Simplistic sandbox survival game that plays in mostly lush biomes in a mostly peaceful world and only simple technologies.";

      };
    };

    "Wuzzy"."retroplus" = buildMinetestPackage rec {
      type = "txp";
      pname = "retroplus";
      version = "9";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "retroplus";
        release = 7328;
        versionName = "9";
        sha256 = "0wv6dkzla1d7x7hxdy95gxkq6wgqdmygdzs6j18vrlb5vri1iz59";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Look and feel of the oldest versions of Minetest-c55";

      };
    };

    "Wuzzy"."returnmirror" = buildMinetestPackage rec {
      type = "mod";
      pname = "returnmirror";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "returnmirror";
        release = 466;
        versionName = "1.0.4";
        sha256 = "1krllp95hn6k6gfs0j1sbzhskpc78d2ar3q9ri6a21csgk0y9rgf";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds a magical item which teleports the user to a previously set location.";

      };
    };

    "Wuzzy"."schemedit" = buildMinetestPackage rec {
      type = "mod";
      pname = "schemedit";
      version = "1.5.1";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "schemedit";
        release = 12278;
        versionName = "1.5.1";
        sha256 = "0x411w2r36cnyvc1ayycy19jyx35ygvx2bs712zyklbjgc17hi17";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Advanced tool for modders and advanced users to create and edit schematics.";

      };
    };

    "Wuzzy"."select_item" = buildMinetestPackage rec {
      type = "mod";
      pname = "select_item";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "select_item";
        release = 1204;
        versionName = "1.1.0";
        sha256 = "1a8zd4f91yykifws3w7c96bxnq13nv2q1aznfl6vj3yy6m3qihyq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows other mods to add a simple form to choose a single item.";

      };
    };

    "Wuzzy"."sfinv_buttons" = buildMinetestPackage rec {
      type = "mod";
      pname = "sfinv_buttons";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "sfinv_buttons";
        release = 361;
        versionName = "2018-07-08";
        sha256 = "03cgqi2cqvd7h6mkza7hib7ihxmr3scf2x90gy5g175bf10jjixg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a tab to the Simple Fast Inventory on which mods can add buttons for easy access.";

      };
    };

    "Wuzzy"."show_wielded_item" = buildMinetestPackage rec {
      type = "mod";
      pname = "show_wielded_item";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "show_wielded_item";
        release = 7596;
        versionName = "1.2.0";
        sha256 = "1pcyhq5dw4fyl2asyy5mxh5i98q38jmh11s7z8qq94gm0bj0l1kl";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Displays the name of the wielded item.";

      };
    };

    "Wuzzy"."sloweater" = buildMinetestPackage rec {
      type = "mod";
      pname = "sloweater";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "sloweater";
        release = 1202;
        versionName = "1.1.0";
        sha256 = "1p98rvfp38nx4s5q0flfjdl1h2qm9ixs0l0yhc5qzm52ksanfrfx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "After eating something, the player must wait for 5 seconds before eating again.";

      };
    };

    "Wuzzy"."spawnbuilder" = buildMinetestPackage rec {
      type = "mod";
      pname = "spawnbuilder";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "spawnbuilder";
        release = 8592;
        versionName = "1.1.0";
        sha256 = "1jwdlxkkmh240rpfwxkjm092ccjdixrjvpkjv6083g56ypms8cg5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Generates a stone platform below the world origin or static spawn point.";

      };
    };

    "Wuzzy"."teletool" = buildMinetestPackage rec {
      type = "mod";
      pname = "teletool";
      version = "1.3";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "teletool";
        release = 464;
        versionName = "1.3";
        sha256 = "1xarp2yjndx9gifp29x2wcyy6gyv26i2c0wbbj02m8vqi557cxn6";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds a short-distance teleportation device which allows the user to instantly change the position in front of a pointed node.";

      };
    };

    "Wuzzy"."treasurer" = buildMinetestPackage rec {
      type = "mod";
      pname = "treasurer";
      version = "0.2.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "treasurer";
        release = 2791;
        versionName = "0.2.0";
        sha256 = "0gvz8smcq8iy5fyqmlkhhrlwmgni4fvdliyq6gzv8irspc7fdxgf";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A framework to define and distribute random treasures into the world.";

      };
    };

    "Wuzzy"."tsm_pyramids" = buildMinetestPackage rec {
      type = "mod";
      pname = "tsm_pyramids";
      version = "1.0.4";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "tsm_pyramids";
        release = 14415;
        versionName = "1.0.4";
        sha256 = "1kq8lld6xw7pdw6n5jazqxv8r83fph2jqf5p6fg8b7hbjn2nm8ld";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Pyramids with treasures!";

      };
    };

    "Wuzzy"."tsm_surprise" = buildMinetestPackage rec {
      type = "mod";
      pname = "tsm_surprise";
      version = "2016-11-16";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "tsm_surprise";
        release = 465;
        versionName = "2016-11-16";
        sha256 = "1p9xncz148y2sv9mg0yn0dqkg5827k1fnpg91nnl6xvpqpnvggri";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Randomly spawns surprise blocks closely about ground level.";

      };
    };

    "Wuzzy"."tt" = buildMinetestPackage rec {
      type = "mod";
      pname = "tt";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "tt";
        release = 5069;
        versionName = "1.0.0";
        sha256 = "08zx33vip22pfa2r3s7wlywzzz4hszzgd6vpj27b8qihlqpc70gp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Support for custom tooltip extensions for items";

      };
    };

    "Wuzzy"."tt_base" = buildMinetestPackage rec {
      type = "mod";
      pname = "tt_base";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "tt_base";
        release = 5068;
        versionName = "1.0.0";
        sha256 = "1l11chbgahm936vbpxsf3csn1kgd6wm1mhqdllmzx2b79mxd7wwv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds generic tooltip extensions to items";

      };
    };

    "Wuzzy"."tutorial" = buildMinetestPackage rec {
      type = "game";
      pname = "tutorial";
      version = "3.3.0";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "tutorial";
        release = 13032;
        versionName = "3.3.0";
        sha256 = "0pyzrv85s3r5vafxxwwlf3lan06qby9b8a5pgl962bb3mnzm2jx5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Learn how to play!";

      };
    };

    "Wuzzy"."wateringcan" = buildMinetestPackage rec {
      type = "mod";
      pname = "wateringcan";
      version = "1.4";
      src = fetchFromContentDB {
        author = "Wuzzy";
        technicalName = "wateringcan";
        release = 1276;
        versionName = "1.4";
        sha256 = "08srxfmcvda6x96x8m6f8w8krrcpjdappcamdcy6a4xgjn1zgr2b";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A watering can to wetten soil.";

      };
    };

    "X17"."chains" = buildMinetestPackage rec {
      type = "mod";
      pname = "chains";
      version = "0.1";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "chains";
        release = 12201;
        versionName = "0.1";
        sha256 = "1liry6m7kqckchpvf8xcf4jxj97z38s9l1dv6xa9wxc0mlyhh8xr";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds chains to climb or decorate";

      };
    };

    "X17"."charcoal" = buildMinetestPackage rec {
      type = "mod";
      pname = "charcoal";
      version = "0.2";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "charcoal";
        release = 10549;
        versionName = "0.2";
        sha256 = "0ysc7p1z40f3s761d09xcsxqsma07i0b7w891ccfycyasv868c3d";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Make charcoal from trees and use this as fuel";

      };
    };

    "X17"."config_pack" = buildMinetestPackage rec {
      type = "mod";
      pname = "config_pack";
      version = "0.1";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "config_pack";
        release = 14428;
        versionName = "0.1";
        sha256 = "06hmws14n3b53zavi0871ldyk3bk5ywazgqly1adkhawfagr997p";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Contains several node setting changes";

      };
    };

    "X17"."invisible_wall" = buildMinetestPackage rec {
      type = "mod";
      pname = "invisible_wall";
      version = "0.4";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "invisible_wall";
        release = 14154;
        versionName = "0.4";
        sha256 = "03a6q5qdn4qnv0zgpyq5b0ai35zgq1snl005l28l7gh5dzfid4yx";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds a simple invisible block";

      };
    };

    "X17"."leather_armor" = buildMinetestPackage rec {
      type = "mod";
      pname = "leather_armor";
      version = "0.2";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "leather_armor";
        release = 13631;
        versionName = "0.2";
        sha256 = "05qzwy8lv1wxks5prlca9fb0wj8fvj4nnqnfl8xvp6sgh2rnwkym";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds an armor made of leather";

      };
    };

    "X17"."roadway" = buildMinetestPackage rec {
      type = "mod";
      pname = "roadway";
      version = "0.1";
      src = fetchFromContentDB {
        author = "X17";
        technicalName = "roadway";
        release = 10547;
        versionName = "0.1";
        sha256 = "0aijcls5sxyaqrv0b0y88m4g0b84ysndy5rng7lifldw3zanl0hv";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds simple roads in 4 sizes.";

      };
    };

    "Xanthus"."cube_mobs" = buildMinetestPackage rec {
      type = "mod";
      pname = "cube_mobs";
      version = "v0.2";
      src = fetchFromContentDB {
        author = "Xanthus";
        technicalName = "cube_mobs";
        release = 5759;
        versionName = "v0.2";
        sha256 = "18nfnaklaq9wpdp5r36pwq91vlj1fj12dm8l4w5sanhiwgfz16s9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds various cube mobs with different abilities using mobkit.";

      };
    };

    "XxCrisThor1012xX"."extrastoneutilities" = buildMinetestPackage rec {
      type = "mod";
      pname = "extrastoneutilities";
      version = "Extra_Stone_Utilities";
      src = fetchFromContentDB {
        author = "XxCrisThor1012xX";
        technicalName = "extrastoneutilities";
        release = 8782;
        versionName = "Extra Stone Utilities";
        sha256 = "1hbr09rmc4q89aq6h6i1m9gz403cyc5kpk17jisx20wn7rgkd4fy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds new uses of stone";

      };
    };

    "Zander_200"."clean" = buildMinetestPackage rec {
      type = "txp";
      pname = "clean";
      version = "CleaN";
      src = fetchFromContentDB {
        author = "Zander_200";
        technicalName = "clean";
        release = 6480;
        versionName = "CleaN";
        sha256 = "133balp2x00qfzd6xp129gqbpj09izd84iwmhk4523jyvjd7p6jd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Just a simple Clean texture pack";

      };
    };

    "Zemtzov7"."doas" = buildMinetestPackage rec {
      type = "mod";
      pname = "doas";
      version = "1.0";
      src = fetchFromContentDB {
        author = "Zemtzov7";
        technicalName = "doas";
        release = 13510;
        versionName = "1.0";
        sha256 = "0xl2la0jm5ivccdx0kadby2ykx38qh39jm9s6dxmsryi29wj1qbk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Execute commands on behalf of another player";

      };
    };

    "Zemtzov7"."rocket_launcher" = buildMinetestPackage rec {
      type = "mod";
      pname = "rocket_launcher";
      version = "2022-10-20";
      src = fetchFromContentDB {
        author = "Zemtzov7";
        technicalName = "rocket_launcher";
        release = 14511;
        versionName = "2022-10-20";
        sha256 = "1fgk521pbg8r8h0sf255l8f4nn4nfzpw07z3xxnd85y0a58i25vy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Rocket launcher using MT's tnt.boom function";

      };
    };

    "Zemtzov7"."translocator" = buildMinetestPackage rec {
      type = "mod";
      pname = "translocator";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Zemtzov7";
        technicalName = "translocator";
        release = 13908;
        versionName = "1.1";
        sha256 = "1xk9ss6pbcjajkrn9h8h40g95zwbf5dphccnvv189v0fk049lh4d";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Teleportation tool inspired by Unreal Tournament 2004";

      };
    };

    "Zooloo75"."first_person_shooter" = buildMinetestPackage rec {
      type = "mod";
      pname = "first_person_shooter";
      version = "v0.1.0_Alpha";
      src = fetchFromContentDB {
        author = "Zooloo75";
        technicalName = "first_person_shooter";
        release = 2071;
        versionName = "v0.1.0 Alpha";
        sha256 = "0zybm3z4sk1kgzpv2i8ysfymw2qzvk3dx2fvi5g49bjas8rdg83r";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds sprite-based guns with animations (warning: may lag or crash)";

      };
    };

    "Zughy"."achievements_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "achievements_lib";
      version = "0.2";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "achievements_lib";
        release = 14197;
        versionName = "0.2";
        sha256 = "0av8jp10fc62vp9acw7m428hq7nhpgfm4iq546rk2h0l4jg6i949";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "API to store all your achievements in one place";

      };
    };

    "Zughy"."arena_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "arena_lib";
      version = "5.2.0";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "arena_lib";
        release = 12388;
        versionName = "5.2.0";
        sha256 = "1i4xw3g03ay0zgivaghpbqvj8gw0viqg6nabqxh308rz7cj56i9p";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Library working as a core for any mini-game you have in mind";

      };
    };

    "Zughy"."block_league" = buildMinetestPackage rec {
      type = "mod";
      pname = "block_league";
      version = "0.6.0";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "block_league";
        release = 12419;
        versionName = "0.6.0";
        sha256 = "19j16wzwwz81x9d6z758v3f79k8dmmfmxgv6ryjarsv532zvvxaq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "S4 League inspired shooter minigame";

      };
    };

    "Zughy"."magic_compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "magic_compass";
      version = "1.3.4";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "magic_compass";
        release = 11012;
        versionName = "1.3.4";
        sha256 = "17xd0a02sw9a6pl8w8r6hsj4jmdlrssmwldxcbwz4vpr5ai41s1s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Teleport system, all inside a compass";

      };
    };

    "Zughy"."panel_lib" = buildMinetestPackage rec {
      type = "mod";
      pname = "panel_lib";
      version = "2.2.0";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "panel_lib";
        release = 10947;
        versionName = "2.2.0";
        sha256 = "1w7jl8g3c198cld0mg3j4rjkx1i41izm4g6jx4ybq7bd0k7j9sph";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Library allowing modders to create complex HUDs in an easy way";

      };
    };

    "Zughy"."parties" = buildMinetestPackage rec {
      type = "mod";
      pname = "parties";
      version = "1.3.0";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "parties";
        release = 11013;
        versionName = "1.3.0";
        sha256 = "1ll43kxda91ybydmfd6p3pv587v01ylwcsgcscq5bvn92y50xwkw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Team up with your friends and create a party!";

      };
    };

    "Zughy"."soothing32" = buildMinetestPackage rec {
      type = "txp";
      pname = "soothing32";
      version = "1.7.1";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "soothing32";
        release = 14418;
        versionName = "1.7.1";
        sha256 = "097b04gp1g7ajnalclbjy01cdqlfm7v4zpwx4hbafi3fk6rffkh7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Lightweight yet aesthetically pleasing texture pack. Seriously, it could run on a toaster!";

      };
    };

    "Zughy"."whitelist" = buildMinetestPackage rec {
      type = "mod";
      pname = "whitelist";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "Zughy";
        technicalName = "whitelist";
        release = 10329;
        versionName = "1.2.0";
        sha256 = "0al6hg6qyahhq9xpdp2dwandk0hk7y5pxnckfrmim5fqqx2zfva7";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Manage who can and who can't enter in your server";

      };
    };

    "_Xenon"."brights" = buildMinetestPackage rec {
      type = "mod";
      pname = "brights";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "brights";
        release = 6254;
        versionName = "v1.0";
        sha256 = "0f96hjz89j2vrcpz6p0da1ag6xn88xdv0xv90pgkmdlvsagxld48";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds bright stuff";

          homepage = "https://xenonca.gitlab.io/content/";

      };
    };

    "_Xenon"."colorize" = buildMinetestPackage rec {
      type = "mod";
      pname = "colorize";
      version = "1.0";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "colorize";
        release = 6707;
        versionName = "1.0";
        sha256 = "1i3dlml1r9rm1gk49m5z1wnx8fyypnj4zinmqs7fj5kgvz7pm90k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Lets you colorize your messages using HEX color codes (for testing purposes).";

          homepage = "https://xenonca.gitlab.io/content/";

      };
    };

    "_Xenon"."darks" = buildMinetestPackage rec {
      type = "mod";
      pname = "darks";
      version = "v1.3_GitLab";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "darks";
        release = 6253;
        versionName = "v1.3 GitLab";
        sha256 = "0g84f3dzmglb75y98m2gmdn46h6mii3lb1qkmsf2mlra78i6rz60";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds dark stuff";

          homepage = "https://xenonca.gitlab.io/content/";

      };
    };

    "_Xenon"."ptime" = buildMinetestPackage rec {
      type = "mod";
      pname = "ptime";
      version = "v1.3";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "ptime";
        release = 9273;
        versionName = "v1.3";
        sha256 = "0gwhpwq0kcbccwcz28mhqc97wsgazi95kdcjhhbypz94q3l2z98s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows players to have permanent day/night without changing the game time.";

          homepage = "https://xenonca.gitlab.io/home";

      };
    };

    "_Xenon"."staffchan" = buildMinetestPackage rec {
      type = "mod";
      pname = "staffchan";
      version = "1.0";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "staffchan";
        release = 2295;
        versionName = "1.0";
        sha256 = "18ba46acr29p1f6hj9bsjmmk5zd4z07njm43xkg7mhb0jqrwm5iq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Write messages only to staff";

          homepage = "https://xenonca.github.io/mods.html";

      };
    };

    "_Xenon"."uni8" = buildMinetestPackage rec {
      type = "txp";
      pname = "uni8";
      version = "v1.6_Add_CTFv3_support";
      src = fetchFromContentDB {
        author = "_Xenon";
        technicalName = "uni8";
        release = 13360;
        versionName = "v1.6 Add CTFv3 support";
        sha256 = "089qc2f33hzs7i2sabk97jdb4xs4avk8s6iziv3y1jzldpfh5axf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Simple and plain texture pack with 8px textures.";

          homepage = "https://xenonca.github.io/mods.html";

      };
    };

    "_gianpy_"."api_between" = buildMinetestPackage rec {
      type = "mod";
      pname = "api_between";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "_gianpy_";
        technicalName = "api_between";
        release = 13849;
        versionName = "1.2.1";
        sha256 = "11jdhniqzgnp3wjqdsd619hklrzbslamm5595500s8h29xjgjpjs";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Interpolation functions and a Tween object to make smooth interpolations in huds or anything else you need.";

          homepage = "https://between-api-minetest.readthedocs.io/en/latest/";

      };
    };

    "activivan"."dcwebhook" = buildMinetestPackage rec {
      type = "mod";
      pname = "dcwebhook";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "activivan";
        technicalName = "dcwebhook";
        release = 10577;
        versionName = "v1.0.1";
        sha256 = "1svgmyk6b24y4bv18v9kw4l5m35c0j1y4bi76rcbgazlck4dwcqq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Discord Webhook";

      };
    };

    "addi"."cannons" = buildMinetestPackage rec {
      type = "mod";
      pname = "cannons";
      version = "v2.5.1_Maintenance_update";
      src = fetchFromContentDB {
        author = "addi";
        technicalName = "cannons";
        release = 12471;
        versionName = "v2.5.1 Maintenance update";
        sha256 = "0j5cf9mmf030hpvfvc1ay4ms8phllhx5989zlngx558nr1pis1jf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Adds Cannons. Insert muni and gunpowder, and punch it with a torch. The muni can destroy nodes and hurts players.";

      };
    };

    "addi"."darkage" = buildMinetestPackage rec {
      type = "mod";
      pname = "darkage";
      version = "1.4";
      src = fetchFromContentDB {
        author = "addi";
        technicalName = "darkage";
        release = 12600;
        versionName = "1.4";
        sha256 = "1wdf3adiykq4r4f0m7qjjgk6g1myi7bnpr882h2rw7bhp7ps1y0a";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "DarkAge adds several new nodes and crafts to create a pre industrial landscape.";

      };
    };

    "aerkiaga"."nodeverse" = buildMinetestPackage rec {
      type = "game";
      pname = "nodeverse";
      version = "0.2.2";
      src = fetchFromContentDB {
        author = "aerkiaga";
        technicalName = "nodeverse";
        release = 13551;
        versionName = "0.2.2";
        sha256 = "1cbwvkwdgnlx3yf5rqpvbzm0fqprakmaqzaym8vq9d4wkdc6ls41";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A procedurally generated space exploration game";

      };
    };

    "aether123"."raining_death" = buildMinetestPackage rec {
      type = "mod";
      pname = "raining_death";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "aether123";
        technicalName = "raining_death";
        release = 5952;
        versionName = "1.0.0";
        sha256 = "1qqs4dlggm6cdp58xyv1s5pdwg4fxi4zc4n07kzyvxccyjfg2chw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "TNT Rains from the Sky";

      };
    };

    "alerikaisattera"."compactor" = buildMinetestPackage rec {
      type = "mod";
      pname = "compactor";
      version = "1.0";
      src = fetchFromContentDB {
        author = "alerikaisattera";
        technicalName = "compactor";
        release = 13776;
        versionName = "1.0";
        sha256 = "1pggw0sayih3dj9xji66ymwwkqp30a4cjldia2vv8a79fgryygxg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-or-later" ];
        description = "A Technic based machine for converting certain items into more compact forms";

      };
    };

    "alerikaisattera"."etherium_stuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "etherium_stuff";
      version = "1.4";
      src = fetchFromContentDB {
        author = "alerikaisattera";
        technicalName = "etherium_stuff";
        release = 14416;
        versionName = "1.4";
        sha256 = "0f4ary6w4qwh706i0b0hr42c23apfv9bzibzv7a333ykix51bryc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-2.0-only" ];
        description = "Decorative stuff using ethereal's etherium dust";

      };
    };

    "alerikaisattera"."technic_recipes" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_recipes";
      version = "1.0";
      src = fetchFromContentDB {
        author = "alerikaisattera";
        technicalName = "technic_recipes";
        release = 13645;
        versionName = "1.0";
        sha256 = "1ilix9apizppv0bdrh71qrv1c5wbcnkms6rrgsqfwgdxv9npmifs";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Extra recipes for processing various items with Technic machines";

      };
    };

    "amalon"."numeracy" = buildMinetestPackage rec {
      type = "mod";
      pname = "numeracy";
      version = "v0.4";
      src = fetchFromContentDB {
        author = "amalon";
        technicalName = "numeracy";
        release = 9694;
        versionName = "v0.4";
        sha256 = "1nc9fnjwygg5fiv5irdn4cs9cvviqc9m0whph8x23hi7wvygxpx5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds blocks for exploring numeracy with children, which join together and change appearance as in the Numberblocks TV programme.";

      };
    };

    "andersje"."stained_glass" = buildMinetestPackage rec {
      type = "mod";
      pname = "stained_glass";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "andersje";
        technicalName = "stained_glass";
        release = 14458;
        versionName = "2021-01-29";
        sha256 = "1iqg0ddi8cp5fbdppl6mh9jr0k6sjai5lkg2h5ffx9brhzh9svlw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Adds various stained glass blocks, originally by doyousketch2";

      };
    };

    "apercy"."airutils" = buildMinetestPackage rec {
      type = "mod";
      pname = "airutils";
      version = "0.37";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "airutils";
        release = 12849;
        versionName = "0.37";
        sha256 = "1cbkman1laa9crv4q7953qyahpqglv1qa8fljn13nwi2h4499ahq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A lib for airplanes and some useful tools";

      };
    };

    "apercy"."automobiles_pck" = buildMinetestPackage rec {
      type = "mod";
      pname = "automobiles_pck";
      version = "0.39c";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "automobiles_pck";
        release = 14192;
        versionName = "0.39c";
        sha256 = "0a2hgk1qnr5v8gn0w0njr6b1q8x4sqvllpw61zzjfxywkhiiph2n";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Collection of automobiles";

      };
    };

    "apercy"."demoiselle" = buildMinetestPackage rec {
      type = "mod";
      pname = "demoiselle";
      version = "0.49a";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "demoiselle";
        release = 13829;
        versionName = "0.49a";
        sha256 = "0gn9488rn7irly069sax4pgd53xk6mbzdlhb07bv1vs9qc0dr3cq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a Demoiselle, an historical airplane";

      };
    };

    "apercy"."direction_compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "direction_compass";
      version = "0.2";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "direction_compass";
        release = 13620;
        versionName = "0.2";
        sha256 = "1w6sc0ada84igv86qnfv79k7s6ibjgxiqyprprsl2ad4igvrnggy";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds a compass";

      };
    };

    "apercy"."hidroplane" = buildMinetestPackage rec {
      type = "mod";
      pname = "hidroplane";
      version = "0.49d";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "hidroplane";
        release = 14199;
        versionName = "0.49d";
        sha256 = "0xj9jalq3a6wh0i97mlk8422d635djgg9lra9dlrfbj1jqiag8xg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-only" ];
        description = "Adds a craftable hydroplane";

      };
    };

    "apercy"."hud_analog_clock" = buildMinetestPackage rec {
      type = "mod";
      pname = "hud_analog_clock";
      version = "0.1";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "hud_analog_clock";
        release = 9816;
        versionName = "0.1";
        sha256 = "159dj8qckw3qvhfwybhzml0vyg6j7w8czfw93qhpw6ywyirxv4a4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an analogic clock to hud";

      };
    };

    "apercy"."ju52" = buildMinetestPackage rec {
      type = "mod";
      pname = "ju52";
      version = "0.29a";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "ju52";
        release = 13762;
        versionName = "0.29a";
        sha256 = "18jsssjm7nz2jxhilxxm19i8706x2sp0blsy9i55f8m0w75bzr7i";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a Ju52 airplane";

      };
    };

    "apercy"."kartcar" = buildMinetestPackage rec {
      type = "mod";
      pname = "kartcar";
      version = "0.16";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "kartcar";
        release = 13842;
        versionName = "0.16";
        sha256 = "1rnh9bvv4jpandk2lxll2abc1vdc6xwx9biygkdmg8dy6cbz5n36";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a craftable kart";

      };
    };

    "apercy"."motorboat" = buildMinetestPackage rec {
      type = "mod";
      pname = "motorboat";
      version = "0.4";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "motorboat";
        release = 12792;
        versionName = "0.4";
        sha256 = "0wks0dzvrf0n4yr0pnzsaf5p3czi03msk860wy9y7f2jqrh9ir5w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a craftable motorboat";

      };
    };

    "apercy"."nautilus" = buildMinetestPackage rec {
      type = "mod";
      pname = "nautilus";
      version = "0.44";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "nautilus";
        release = 14504;
        versionName = "0.44";
        sha256 = "1f4kczp4yjqwjbannhq1mvrb7ng7zlszclh7nvp3ikw8v9l2i0gc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a craftable submarine";

      };
    };

    "apercy"."nss_helicopter" = buildMinetestPackage rec {
      type = "mod";
      pname = "nss_helicopter";
      version = "0.1b";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "nss_helicopter";
        release = 13210;
        versionName = "0.1b";
        sha256 = "105jkzys1kx2k9cvz9qvfllcshscs6mpbk4904v1bwkgh0yghrv0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-2.0-or-later" ];
        description = "It adds an expensive helicopter with power consumption.";

      };
    };

    "apercy"."pa28" = buildMinetestPackage rec {
      type = "mod";
      pname = "pa28";
      version = "0.21";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "pa28";
        release = 14354;
        versionName = "0.21";
        sha256 = "109i2092b3h9rqwi43rmzf7f5g65vm8ax2ymvz8b3yhw33rk8mdv";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a craftable PA28";

      };
    };

    "apercy"."steampunk_blimp" = buildMinetestPackage rec {
      type = "mod";
      pname = "steampunk_blimp";
      version = "0.24a";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "steampunk_blimp";
        release = 14434;
        versionName = "0.24a";
        sha256 = "1kmg7bhvy67rxy7kjnxlrbyi9hqggnjq87838bxkz0cl2fgl0v82";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a steampunk blimp";

      };
    };

    "apercy"."supercub" = buildMinetestPackage rec {
      type = "mod";
      pname = "supercub";
      version = "0.51";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "supercub";
        release = 13255;
        versionName = "0.51";
        sha256 = "0ani89f0afg95npsl45dkhp0dxl26rxrigy7brimyrzv3pzanbh1";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a craftable Super Cub airplane";

      };
    };

    "apercy"."trike" = buildMinetestPackage rec {
      type = "mod";
      pname = "trike";
      version = "0.48";
      src = fetchFromContentDB {
        author = "apercy";
        technicalName = "trike";
        release = 13253;
        versionName = "0.48";
        sha256 = "0m6abp9gxy6p8x1w9f33r8ij3vn8f3kxq1a2f2wrp90bwq32r6h1";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-3.0-only" ];
        description = "Adds a craftable ultralight trike";

      };
    };

    "archfan7411"."discordmt" = buildMinetestPackage rec {
      type = "mod";
      pname = "discordmt";
      version = "2021-07-06";
      src = fetchFromContentDB {
        author = "archfan7411";
        technicalName = "discordmt";
        release = 8368;
        versionName = "2021-07-06";
        sha256 = "1gph58ly3ivhqqm8in2a6gra11h015w3g7xw68gvzbphcslvjcsw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Mod + external program providing Discord relaying and commands.";

      };
    };

    "archfan7411"."enhanced" = buildMinetestPackage rec {
      type = "mod";
      pname = "enhanced";
      version = "0.1";
      src = fetchFromContentDB {
        author = "archfan7411";
        technicalName = "enhanced";
        release = 1211;
        versionName = "0.1";
        sha256 = "137gycfsk1rhmh6hcacgxqpfvjd1zw9kvnf46z8v5zj3100iici1";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Allows players to enhance their tools through mese infusion";

      };
    };

    "archfan7411"."envelopes" = buildMinetestPackage rec {
      type = "mod";
      pname = "envelopes";
      version = "0.1";
      src = fetchFromContentDB {
        author = "archfan7411";
        technicalName = "envelopes";
        release = 885;
        versionName = "0.1";
        sha256 = "1ncqmmp91hkr5alk7zx26i9xfybs5lix4ds9njzm7nncb1bca5jk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Write and address an envelope to another player!";

      };
    };

    "archfan7411"."shadowrealm" = buildMinetestPackage rec {
      type = "mod";
      pname = "shadowrealm";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "archfan7411";
        technicalName = "shadowrealm";
        release = 3421;
        versionName = "1.0.0";
        sha256 = "03q4psix8d6fnnq762ifzhfq81zqycwqqrmcjric8r399sckx6fb";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "The realm of shadows contains many hidden horrors.";

      };
    };

    "argyle"."borders" = buildMinetestPackage rec {
      type = "mod";
      pname = "borders";
      version = "0.3.2";
      src = fetchFromContentDB {
        author = "argyle";
        technicalName = "borders";
        release = 1056;
        versionName = "0.3.2";
        sha256 = "1d66c76cprh82ca379sxb03kh40k61d2l6gjd1f45dcp9jpm7qyp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add impenetrable barriers to the sides and bottom of the world.";

      };
    };

    "artur99"."secret" = buildMinetestPackage rec {
      type = "mod";
      pname = "secret";
      version = "2013-03-29";
      src = fetchFromContentDB {
        author = "artur99";
        technicalName = "secret";
        release = 2155;
        versionName = "2013-03-29";
        sha256 = "0v9sdyhlms5dx81wql5jcfpb9pjncqa7ghzd0i2jw34al9af1a25";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds hidden and secret nodes.";

      };
    };

    "auto.umdenken"."titanic_mod" = buildMinetestPackage rec {
      type = "mod";
      pname = "titanic_mod";
      version = "Titanic_Mod";
      src = fetchFromContentDB {
        author = "auto.umdenken";
        technicalName = "titanic_mod";
        release = 7915;
        versionName = "Titanic Mod";
        sha256 = "189iafwb7c1q5ijsvvrxk9d67ck7544rb4ws4k707jns0ma9dhh0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "adds several nodes in the style of the RMS TITANIC";

          homepage = "https://www.youtube.com/channel/UCbPE4I53iqVNy-E7oTVPXYw";

      };
    };

    "auto.umdenken"."titanic_mod2" = buildMinetestPackage rec {
      type = "mod";
      pname = "titanic_mod2";
      version = "Titanic_Mod2";
      src = fetchFromContentDB {
        author = "auto.umdenken";
        technicalName = "titanic_mod2";
        release = 7916;
        versionName = "Titanic Mod2";
        sha256 = "1wr7583920gjlx4gacpbrma68z36fsrwfinhjj5n2jb6c0z6mc0f";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Addition to \"Titanic Mod\", adds several nodes in the style of the RMS TITANIC";

          homepage = "https://www.youtube.com/channel/UCbPE4I53iqVNy-E7oTVPXYw";

      };
    };

    "beaver700nh"."mtpoimap" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtpoimap";
      version = "v0.1.1";
      src = fetchFromContentDB {
        author = "beaver700nh";
        technicalName = "mtpoimap";
        release = 12756;
        versionName = "v0.1.1";
        sha256 = "15m3ypcbk3mg5y1vybik6a6gn3lh112y5lmqv9z2zkjdkaw6lyqw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Displays a map with points of interest, for any game (no dependencies).";

      };
    };

    "beaver700nh"."mtqol" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtqol";
      version = "v0.1.2";
      src = fetchFromContentDB {
        author = "beaver700nh";
        technicalName = "mtqol";
        release = 12864;
        versionName = "v0.1.2";
        sha256 = "0y6r04acrw1flifpswxmkx674ni3yk1r2fj9w4hvvjjr8b0rhc7d";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Improves in-game QOL by adding helpful commands";

      };
    };

    "bell07"."carpets" = buildMinetestPackage rec {
      type = "mod";
      pname = "carpets";
      version = "2020-03-10";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "carpets";
        release = 3671;
        versionName = "2020-03-10";
        sha256 = "1vzfza4hmlfy536iwqm2bdx6dblyip3sn70n5xrjikw8xqh8p9wy";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Carpets";

      };
    };

    "bell07"."ccompass" = buildMinetestPackage rec {
      type = "mod";
      pname = "ccompass";
      version = "2021-09-07";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "ccompass";
        release = 9247;
        versionName = "2021-09-07";
        sha256 = "1hwr4ka5p5i034pc41xfzirv9a3k370rdhkmjazg0b7kxzm0d6bi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a calibratable compass to the minetest";

      };
    };

    "bell07"."frozenenergy" = buildMinetestPackage rec {
      type = "mod";
      pname = "frozenenergy";
      version = "2018-04";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "frozenenergy";
        release = 983;
        versionName = "2018-04";
        sha256 = "00y6fqccy16sbvadbrqfcgs5rrqp125f7lhy3m1hri8wqxyjbmwv";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Use frozen energy crystals to freeze water";

      };
    };

    "bell07"."orecutting" = buildMinetestPackage rec {
      type = "mod";
      pname = "orecutting";
      version = "2018-02";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "orecutting";
        release = 985;
        versionName = "2018-02";
        sha256 = "03danali498p2jaqwww09hm8fj9l92bjqq7svsczps1lykd22jx4";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Ore mining helper";

      };
    };

    "bell07"."qa_block" = buildMinetestPackage rec {
      type = "mod";
      pname = "qa_block";
      version = "2022-09-12";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "qa_block";
        release = 13944;
        versionName = "2022-09-12";
        sha256 = "05iyhksl2694xjam0b7l2jmrvqm45zhb5zfqbd9zkc93xn0n9kla";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A mods development / QA helper";

      };
    };

    "bell07"."skinsdb" = buildMinetestPackage rec {
      type = "mod";
      pname = "skinsdb";
      version = "2022-04-01";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "skinsdb";
        release = 11695;
        versionName = "2022-04-01";
        sha256 = "1gccdm2rdpl18k59q4bx32nwrx0vg5js06v164a5r6v9mpbv0vni";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Custom player skins manager with support for 1.0 and 1.8er skins and inventory skins selector";

      };
    };

    "bell07"."smart_inventory" = buildMinetestPackage rec {
      type = "mod";
      pname = "smart_inventory";
      version = "2020-12-01";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "smart_inventory";
        release = 5622;
        versionName = "2020-12-01";
        sha256 = "1sc7l444cvvhd4s227vpirg6bpgjmkq7lgkgbhd9wi02bnmm5z3m";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."WTFPL" ];
        description = "A fast player inventory with focus on a many number of items and big screens";

      };
    };

    "bell07"."subspacewalker" = buildMinetestPackage rec {
      type = "mod";
      pname = "subspacewalker";
      version = "2018-04";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "subspacewalker";
        release = 984;
        versionName = "2018-04";
        sha256 = "1j2wqxf7nks2l244f2mn7m03pqs2bpdyw1ckm21fgm8h043b2zdg";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Go trough walls, rock or lava using Subspace Walker tool";

      };
    };

    "bell07"."whynot_game" = buildMinetestPackage rec {
      type = "game";
      pname = "whynot_game";
      version = "2022-10-04";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "whynot_game";
        release = 14220;
        versionName = "2022-10-04";
        sha256 = "1pkrncfj2kdax1jn483qqxdfyks58sqp6y0c1pky9nn7m43fc2b7";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Aims to get all existing high quality mods working together";

      };
    };

    "bell07"."wielded_light" = buildMinetestPackage rec {
      type = "mod";
      pname = "wielded_light";
      version = "2022-06-24";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "wielded_light";
        release = 12597;
        versionName = "2022-06-24";
        sha256 = "0lik4ln62z69bbkq3jk24w8ksfc7lr2cy2qyxspc902jv4a6pyik";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds shining for wielded and dropped items";

      };
    };

    "bell07"."woodcutting" = buildMinetestPackage rec {
      type = "mod";
      pname = "woodcutting";
      version = "2022-01-07";
      src = fetchFromContentDB {
        author = "bell07";
        technicalName = "woodcutting";
        release = 10496;
        versionName = "2022-01-07";
        sha256 = "1fvdz93vhisg10334wr6yp375z638zxbqk8dqgkm4xws7j717yqd";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Mine the first tree node from a tree while the sneak key is pressed to start the woodcutting process.";

      };
    };

    "benedict424"."denseores" = buildMinetestPackage rec {
      type = "mod";
      pname = "denseores";
      version = "1.2.3";
      src = fetchFromContentDB {
        author = "benedict424";
        technicalName = "denseores";
        release = 9511;
        versionName = "1.2.3";
        sha256 = "0m5nn1awg1krc3l15pnp7xpy1v46m7gcydhssdcn7g8wvan587v1";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds rare ores with twice the drops of their normal counterpart.";

      };
    };

    "benrob0329"."ikea" = buildMinetestPackage rec {
      type = "game";
      pname = "ikea";
      version = "0.0.5";
      src = fetchFromContentDB {
        author = "benrob0329";
        technicalName = "ikea";
        release = 10088;
        versionName = "0.0.5";
        sha256 = "14d2lpypkqkywyagqjlsncgl6z45ggiq59jfinn8p9pjdgwlrrig";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A survival horror game based on SCP-3008";

      };
    };

    "benrob0329"."lambda" = buildMinetestPackage rec {
      type = "mod";
      pname = "lambda";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "benrob0329";
        technicalName = "lambda";
        release = 8069;
        versionName = "v1.1";
        sha256 = "1kl1i6q60ywfsz0b6caizgzqd0dxhah1scgj4a4phry9bpi7m2zw";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Atomic lambda string-parser for Lua.";

      };
    };

    "benrob0329"."table_goodies" = buildMinetestPackage rec {
      type = "mod";
      pname = "table_goodies";
      version = "v1.0-1";
      src = fetchFromContentDB {
        author = "benrob0329";
        technicalName = "table_goodies";
        release = 10886;
        versionName = "v1.0-1";
        sha256 = "0mpfh0dc2d06kjzflyjjmgi6zzq8097ypy1890sn7fmfja5bwn6b";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A small package for extra (can't live without) functions for working with tables.";

      };
    };

    "biochemist"."mcl_rubber" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_rubber";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "biochemist";
        technicalName = "mcl_rubber";
        release = 13851;
        versionName = "1.0.2";
        sha256 = "1fl8s2nf790c5ldgwrphhkrbvkzmvy8kjbafd6n1g68nd0b0wncc";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds rubber and related Items to MineClone.";

      };
    };

    "bloopy1"."bloopy1_ctf_pack" = buildMinetestPackage rec {
      type = "txp";
      pname = "bloopy1_ctf_pack";
      version = "2020-09-08";
      src = fetchFromContentDB {
        author = "bloopy1";
        technicalName = "bloopy1_ctf_pack";
        release = 13766;
        versionName = "2020-09-08";
        sha256 = "1ixfbh2gfv43g4fzc17jk55qmp98sr60a814inmpcrp0h9myk868";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A texture pack made by bloopy1 for ctf";

      };
    };

    "bosapara"."emoji" = buildMinetestPackage rec {
      type = "mod";
      pname = "emoji";
      version = "Emoji_1.0";
      src = fetchFromContentDB {
        author = "bosapara";
        technicalName = "emoji";
        release = 1937;
        versionName = "Emoji 1.0";
        sha256 = "1d77jf5c7fq1m7ljq5rhj4m5z7ryhrrinm8v5z0fh477n3qdmqly";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "\"Emoji\" show emoji icon above player with command \"/e\" or with text smiles in chat like 'o_O'";

          homepage = "https://bosapara.github.io/";

      };
    };

    "brylie"."manners" = buildMinetestPackage rec {
      type = "mod";
      pname = "manners";
      version = "0.2";
      src = fetchFromContentDB {
        author = "brylie";
        technicalName = "manners";
        release = 1157;
        versionName = "0.2";
        sha256 = "14nq4hjjp9h4l6yk0kd61y3is600gxfvvvl03m272cfbmwwxpy5n";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Polite farts and burps.";

      };
    };

    "cakenggt"."sailing" = buildMinetestPackage rec {
      type = "mod";
      pname = "sailing";
      version = "0.1";
      src = fetchFromContentDB {
        author = "cakenggt";
        technicalName = "sailing";
        release = 1005;
        versionName = "0.1";
        sha256 = "0fyf3s41glzj9r85a9i1zdx9glhc1l81b25zbq7l8dfwl2k9ds8h";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Live in a tropical paradise where you can sail, mine coconuts, etc.";

      };
    };

    "carlos_rupp"."berzerkpt" = buildMinetestPackage rec {
      type = "game";
      pname = "berzerkpt";
      version = "2021-12-27";
      src = fetchFromContentDB {
        author = "carlos_rupp";
        technicalName = "berzerkpt";
        release = 10305;
        versionName = "2021-12-27";
        sha256 = "166g0b03asw50ksypck382giq6ra6zr9g13smy9s9d8s940iirrs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Action game in ancient Egypt.";

      };
    };

    "cathaya7d4"."spawn" = buildMinetestPackage rec {
      type = "mod";
      pname = "spawn";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "cathaya7d4";
        technicalName = "spawn";
        release = 12734;
        versionName = "0.0.1";
        sha256 = "0iw607csi0bvmpnl4hz3w0rfq1g65r2fhy3bpy2g6748j9n3nfb7";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Drop-in replacement for default/spawn for more third-party biomes";

      };
    };

    "cd2"."colored_steel" = buildMinetestPackage rec {
      type = "mod";
      pname = "colored_steel";
      version = "2017-09-11";
      src = fetchFromContentDB {
        author = "cd2";
        technicalName = "colored_steel";
        release = 12992;
        versionName = "2017-09-11";
        sha256 = "1h17vpy52q2qnwwvflns7wvr7xr961zcjy03h73qwpdk67f495k2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Adds colored steel blocks.";

      };
    };

    "cd2"."public_inventory" = buildMinetestPackage rec {
      type = "mod";
      pname = "public_inventory";
      version = "2016-03-28";
      src = fetchFromContentDB {
        author = "cd2";
        technicalName = "public_inventory";
        release = 12988;
        versionName = "2016-03-28";
        sha256 = "0hpibf929202agigczwawiwzmxxgki5nyyalwzh69y4vp4hdc3vl";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Adds a public inventory.";

      };
    };

    "chaosomnium"."alien_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "alien_tools";
      version = "0.0.0.2";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "alien_tools";
        release = 9023;
        versionName = "0.0.0.2";
        sha256 = "1w1jjp8fwjc2gw19snxxfr4vr8lwlb9p6419hi6i3c7hr5x4ngc0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Alien Tools Mod for Minetest - adds Alien Tool, Shield, biome, etc";

      };
    };

    "chaosomnium"."joke_currency" = buildMinetestPackage rec {
      type = "mod";
      pname = "joke_currency";
      version = "0.0.0.0";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "joke_currency";
        release = 7339;
        versionName = "0.0.0.0";
        sha256 = "199lq5sgqkd1f2jnyirgky5bcbdm06vsskkp35qis840449lci5n";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds a joke economy in game with controllable inflation and deflation.";

      };
    };

    "chaosomnium"."mining_game" = buildMinetestPackage rec {
      type = "game";
      pname = "mining_game";
      version = "0.0.0.2";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "mining_game";
        release = 7428;
        versionName = "0.0.0.2";
        sha256 = "0zc60ljz0kyj7303jjbzgq7dfl6dh7xxavgy21190qihilqwksvk";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A simple base game where you mine mud for ores probabilistically in space.";

      };
    };

    "chaosomnium"."multibiomegen" = buildMinetestPackage rec {
      type = "mod";
      pname = "multibiomegen";
      version = "0.0.0.0";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "multibiomegen";
        release = 7542;
        versionName = "0.0.0.0";
        sha256 = "1nvviwq6ksskbkdxw3gm3mzzxhjrffhr64qnp81r684rsbqcp9gr";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "230 Pseudorandomly Generated Biomes, Trees, Fruits, Ores, Tools, and Liquids";

      };
    };

    "chaosomnium"."randomwalker" = buildMinetestPackage rec {
      type = "mod";
      pname = "randomwalker";
      version = "0.0.0.2";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "randomwalker";
        release = 7074;
        versionName = "0.0.0.2";
        sha256 = "1sppc99h0pjrfjgl0bwka460qwgfb2baqy59fwj9lkw1hdzw4wa5";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "3d Random Walker Blocks that create interesting structures in the world";

      };
    };

    "chaosomnium"."underbed_toilet_math_mg" = buildMinetestPackage rec {
      type = "mod";
      pname = "underbed_toilet_math_mg";
      version = "0.0.0.1";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "underbed_toilet_math_mg";
        release = 7326;
        versionName = "0.0.0.1";
        sha256 = "1018xa6nc64lwd4kjjgdghrdm12lnpkl7kgcfjg9mjzlj5xq47ii";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Voxelmanip mapgen with strange layered zone experimental mapgens.";

      };
    };

    "chaosomnium"."weedstone" = buildMinetestPackage rec {
      type = "mod";
      pname = "weedstone";
      version = "0.0.0.1";
      src = fetchFromContentDB {
        author = "chaosomnium";
        technicalName = "weedstone";
        release = 7647;
        versionName = "0.0.0.1";
        sha256 = "0pa9nylnmfa72yc3jvs71h0awk08w31jh0fn3cslsg5ffarg4sgh";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Originally meant to be a simple electronics type mod inspired by redstones, I messed around with the code after getting bored and got this weird mod, and now it's this thing. Enjoy I guess?";

      };
    };

    "cheapie"."areasprotector" = buildMinetestPackage rec {
      type = "mod";
      pname = "areasprotector";
      version = "2021-02-28";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "areasprotector";
        release = 6715;
        versionName = "2021-02-28";
        sha256 = "12fh6in5n6lr3in26rpgpjhnmha5cv1cxbsxvcb78ql4dqigi36m";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Simple protector block for ShadowNinja's areas system";

      };
    };

    "cheapie"."arrowboards" = buildMinetestPackage rec {
      type = "mod";
      pname = "arrowboards";
      version = "2017-01-31";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "arrowboards";
        release = 6693;
        versionName = "2017-01-31";
        sha256 = "1rxfaaf0si0nhy3b34k98xckzi6bm0xfrd722fmnw4hx0yb68kq8";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Arrow boards for road construction";

      };
    };

    "cheapie"."digiscreen" = buildMinetestPackage rec {
      type = "mod";
      pname = "digiscreen";
      version = "2020-04-30";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "digiscreen";
        release = 6694;
        versionName = "2020-04-30";
        sha256 = "1389c4r7fk59p9b8ph32lyiflqc14vdgqk9vy62p5xynrjkprf5l";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Digilines graphical screen";

      };
    };

    "cheapie"."digistuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "digistuff";
      version = "2022-01-08";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "digistuff";
        release = 10507;
        versionName = "2022-01-08";
        sha256 = "1qcs2ill01id0qv7hmip2xpvfs61zlk5bf5mx8agb3qyxl28dpnc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Random digilines devices";

      };
    };

    "cheapie"."dropthecaps" = buildMinetestPackage rec {
      type = "mod";
      pname = "dropthecaps";
      version = "2021-02-28";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "dropthecaps";
        release = 6716;
        versionName = "2021-02-28";
        sha256 = "0rx3f78vbxys53y268724ybkdy6cmgf5lfznq5s60kimrrp2gkz1";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Kicks players that spew all-caps messages";

      };
    };

    "cheapie"."handdryer" = buildMinetestPackage rec {
      type = "mod";
      pname = "handdryer";
      version = "2021-01-31";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "handdryer";
        release = 6697;
        versionName = "2021-01-31";
        sha256 = "1ban70mwir91fn6sn3vwzia2bv41h4k95a04z7wdbmhzfi37d2ll";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Decorative hand dryers";

      };
    };

    "cheapie"."icemachine" = buildMinetestPackage rec {
      type = "mod";
      pname = "icemachine";
      version = "2018-11-22";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "icemachine";
        release = 6695;
        versionName = "2018-11-22";
        sha256 = "1r5ri8fakbnid3jb07slq8phva3x5cs9lm8a4bff5cqnywd2iw7n";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "A machine that makes ice cubes.";

      };
    };

    "cheapie"."ltc4000e" = buildMinetestPackage rec {
      type = "mod";
      pname = "ltc4000e";
      version = "2017-01-20";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "ltc4000e";
        release = 6652;
        versionName = "2017-01-20";
        sha256 = "01xv3br9x5r076jf0347bplhbbh1l0mismpawsfw8z2nfhdkmhba";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Advanced traffic signal controller";

      };
    };

    "cheapie"."mesecons_carts" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_carts";
      version = "2021-02-05";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "mesecons_carts";
        release = 6696;
        versionName = "2021-02-05";
        sha256 = "0wlzs449gd45n6xhd3ii1j3q1c8lh6jkc3mbclqg4wxk85pzwd90";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."Unlicense" ];
        description = "Mesecons and digilines-controllable rails";

      };
    };

    "cheapie"."newplayer" = buildMinetestPackage rec {
      type = "mod";
      pname = "newplayer";
      version = "2020-04-26";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "newplayer";
        release = 6651;
        versionName = "2020-04-26";
        sha256 = "1vqiznn5p887ifr1q7h0fx9m996p6w10lb4ivk193cy8ild7wbnz";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Yet another show-people-the-rules thing";

      };
    };

    "cheapie"."prefab_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "prefab_redo";
      version = "2018-11-24";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "prefab_redo";
        release = 794;
        versionName = "2018-11-24";
        sha256 = "1l57na27bcvzmxnj8ylzn1gk8g2sfn64r3whhwzbaa3fnhhp3z2m";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Cheapie's version of Dan's old prefab mod, which adds pre-fabricated concrete elements: catwalks, benches, ladders, railings...";

      };
    };

    "cheapie"."roads" = buildMinetestPackage rec {
      type = "mod";
      pname = "roads";
      version = "2018-11-11-2";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "roads";
        release = 769;
        versionName = "2018-11-11-2";
        sha256 = "070z2sq0qbvdrap6pxkb978fm74ffxxw3fksm1mmygsrlrb2jmrs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Advanced modern road infastructure (fork)";

      };
    };

    "cheapie"."solidcolor" = buildMinetestPackage rec {
      type = "mod";
      pname = "solidcolor";
      version = "2019-07-18";
      src = fetchFromContentDB {
        author = "cheapie";
        technicalName = "solidcolor";
        release = 6659;
        versionName = "2019-07-18";
        sha256 = "0bk9cybbbsmlblk61x4cr802vwzrmf6pf9gdwplj56rb9mzglfsy";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Colorable (via unifieddyes) solid-color blocks.";

      };
    };

    "citorva"."pillars" = buildMinetestPackage rec {
      type = "mod";
      pname = "pillars";
      version = "First_version_release";
      src = fetchFromContentDB {
        author = "citorva";
        technicalName = "pillars";
        release = 1547;
        versionName = "First version release";
        sha256 = "129mjv216kbikffh7b3yj7h4jihnfxwqxzsirzl3aw97nqx9w1fh";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Add a lot of pillars for fun.";

      };
    };

    "cj_clippy"."matterbridge_player_events" = buildMinetestPackage rec {
      type = "mod";
      pname = "matterbridge_player_events";
      version = "0.0.6";
      src = fetchFromContentDB {
        author = "cj_clippy";
        technicalName = "matterbridge_player_events";
        release = 14165;
        versionName = "0.0.6";
        sha256 = "0sp17133vl84gmfjc00dcfjzijzqrb7klb90r9ahljyk5ciz5b9g";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Sends a message to the matterbridge when a player joins/parts";

      };
    };

    "cj_clippy"."msg_color" = buildMinetestPackage rec {
      type = "mod";
      pname = "msg_color";
      version = "2022-10-08";
      src = fetchFromContentDB {
        author = "cj_clippy";
        technicalName = "msg_color";
        release = 14250;
        versionName = "2022-10-08";
        sha256 = "1j2zmhq73mm2gvsz9gx4cdbi5wsfrnz3bv7kn7y1mm9ii5g6h8ry";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Add colored chat messages to your server.";

          homepage = "https://grimtech.net/about";

      };
    };

    "cool_beans"."aether_new" = buildMinetestPackage rec {
      type = "mod";
      pname = "aether_new";
      version = "1_3_2022";
      src = fetchFromContentDB {
        author = "cool_beans";
        technicalName = "aether_new";
        release = 10436;
        versionName = "1/3/2022";
        sha256 = "0s8a78vrlhnh8n2r5virgwrr10fahswzb3h805q3qwy4s9biakdk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds a hard to obtain yet powerful substance called Aether.";

      };
    };

    "cool_beans"."decraft" = buildMinetestPackage rec {
      type = "mod";
      pname = "decraft";
      version = "2022-10-02";
      src = fetchFromContentDB {
        author = "cool_beans";
        technicalName = "decraft";
        release = 14463;
        versionName = "2022-10-02";
        sha256 = "1xi4k3qs9spwxk7mwynmr9xh9swjb41gfjs7x6d72j90sqpr452f";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "De-craft items with the decrafting workbench.";

      };
    };

    "cool_beans"."fakery" = buildMinetestPackage rec {
      type = "mod";
      pname = "fakery";
      version = "3_12_2021__2_";
      src = fetchFromContentDB {
        author = "cool_beans";
        technicalName = "fakery";
        release = 6978;
        versionName = "3/12/2021 (2)";
        sha256 = "0akx72089kni6w8k00m0yqyc6a15h17jdyfpy0dr5i4xd6p3jynj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds counterfeit diamonds and other fake precious materials.";

      };
    };

    "cool_beans"."moth" = buildMinetestPackage rec {
      type = "mod";
      pname = "moth";
      version = "5_1_2021";
      src = fetchFromContentDB {
        author = "cool_beans";
        technicalName = "moth";
        release = 7652;
        versionName = "5/1/2021";
        sha256 = "1783a7l8n1yy5803j4d0dwg9wjs69wwhlad0d6iv7pz9vvq1fkjh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds moths which can send messages (from Lord of the Rings)";

      };
    };

    "cool_beans"."tardis_new" = buildMinetestPackage rec {
      type = "mod";
      pname = "tardis_new";
      version = "5_1_2021";
      src = fetchFromContentDB {
        author = "cool_beans";
        technicalName = "tardis_new";
        release = 7651;
        versionName = "5/1/2021";
        sha256 = "10yh6908j4sjc77sriyhxzx5xn3r7n5ms1kp6ibhvrivyzf8pv3n";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Adds a functioning space-time machine from the tv show doctor who.";

      };
    };

    "crabycowman123"."spmeter" = buildMinetestPackage rec {
      type = "game";
      pname = "spmeter";
      version = "0.1.2";
      src = fetchFromContentDB {
        author = "crabycowman123";
        technicalName = "spmeter";
        release = 11007;
        versionName = "0.1.2";
        sha256 = "0w42v2xmxfc9149j9pm0a97n5qr6s795dl87kpl4ln6b08dkpxi0";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-4.0" ];
        description = "game jam submission";

      };
    };

    "cracksmoka420"."ctf_guns" = buildMinetestPackage rec {
      type = "mod";
      pname = "ctf_guns";
      version = "2022-05-23";
      src = fetchFromContentDB {
        author = "cracksmoka420";
        technicalName = "ctf_guns";
        release = 12348;
        versionName = "2022-05-23";
        sha256 = "15accipal21y49703zgf8l8zyxj0g0xj6yclg9wi6x40dlm10q1k";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds craftable guns that feel like hit scan";

      };
    };

    "cronvel"."astral" = buildMinetestPackage rec {
      type = "mod";
      pname = "astral";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "cronvel";
        technicalName = "astral";
        release = 5021;
        versionName = "1.0.1";
        sha256 = "0qrmrrfs6zzglxp1ssxdcpmxcjc52hyvnc3p5hfmwcxqlqjjxyz5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add regular moon phases, as well as 9 special natural and surnatural Astral events to discover!";

      };
    };

    "cronvel"."landscape_shaping" = buildMinetestPackage rec {
      type = "mod";
      pname = "landscape_shaping";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "cronvel";
        technicalName = "landscape_shaping";
        release = 4965;
        versionName = "1.0.0";
        sha256 = "0vaahspwjd19ixql97m957j0mb5z884m6wx1lx1lhyz4fpf136y0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Landscape shaping tools and API";

      };
    };

    "cronvel"."namegen" = buildMinetestPackage rec {
      type = "mod";
      pname = "namegen";
      version = "v0.2";
      src = fetchFromContentDB {
        author = "cronvel";
        technicalName = "namegen";
        release = 5372;
        versionName = "v0.2";
        sha256 = "00182ibpas2njwa3l8k7qirnypnprj31kqmpl2y6b614ms48hsb8";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Name generator API.";

      };
    };

    "cronvel"."respawn" = buildMinetestPackage rec {
      type = "mod";
      pname = "respawn";
      version = "v0.10";
      src = fetchFromContentDB {
        author = "cronvel";
        technicalName = "respawn";
        release = 2406;
        versionName = "v0.10";
        sha256 = "1mdkxljwqxpwfq0w1xv905ld0yz8v3ip5x8b4jypb363pqcg2z8s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Manage respawn points, interesting places, teleportation and death records";

      };
    };

    "cultom"."hammermod" = buildMinetestPackage rec {
      type = "mod";
      pname = "hammermod";
      version = "0.1.3";
      src = fetchFromContentDB {
        author = "cultom";
        technicalName = "hammermod";
        release = 5912;
        versionName = "0.1.3";
        sha256 = "1bwilqamd7bhbqpjn2nbvdg4x3v151lsxhqdr6rr74zgc36bhcg4";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "Adds a steel hammer which allows to dig 3x3.";

      };
    };

    "cx384"."inventorybags" = buildMinetestPackage rec {
      type = "mod";
      pname = "inventorybags";
      version = "2017-12-31";
      src = fetchFromContentDB {
        author = "cx384";
        technicalName = "inventorybags";
        release = 305;
        versionName = "2017-12-31";
        sha256 = "0fdshg2hdz1n5nbjz1w23ki3fhw7ip8gdy8j7hbfnjmdc8d3bpm8";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds bags";

      };
    };

    "cx384"."snake_3d" = buildMinetestPackage rec {
      type = "game";
      pname = "snake_3d";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "cx384";
        technicalName = "snake_3d";
        release = 10140;
        versionName = "v1.1";
        sha256 = "0wvngyh0d3v77nzc7kfi51r7vm685q2lvzmgjqqsfh3i5wcq2pfj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "The classical Snake game extended to 3 dimensions.";

      };
    };

    "danil_2461"."cabinet" = buildMinetestPackage rec {
      type = "mod";
      pname = "cabinet";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "danil_2461";
        technicalName = "cabinet";
        release = 10075;
        versionName = "1.0.0";
        sha256 = "0g12xgq35skzkjg6ydrz0hw2xzwyifgnalvw0mg8lpfsgy0dp5js";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Adds the file cabinets from Windows.";

      };
    };

    "danil_2461"."ketchupland" = buildMinetestPackage rec {
      type = "game";
      pname = "ketchupland";
      version = "2022-07-13";
      src = fetchFromContentDB {
        author = "danil_2461";
        technicalName = "ketchupland";
        release = 12826;
        versionName = "2022-07-13";
        sha256 = "0psqf0xn3c4b2qivslpjdkwqrjmcszkz1biiv5jzbk4k3jjpb033";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "A game with tomatoes, ketchup, and mese.";

          homepage = "https://ketchupland.voxelmanip.se";

      };
    };

    "daret"."a_planet_alive" = buildMinetestPackage rec {
      type = "game";
      pname = "a_planet_alive";
      version = "2021-04-07_Release_0.8.1";
      src = fetchFromContentDB {
        author = "daret";
        technicalName = "a_planet_alive";
        release = 7402;
        versionName = "2021-04-07_Release_0.8.1";
        sha256 = "13svw7xr7xdrwwx0c07z96j5y1w6jkm3vmn5zavrqysa4csl0bv9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Living World full of mobs / Work in Progress (WIP)";

      };
    };

    "daret"."bucket" = buildMinetestPackage rec {
      type = "mod";
      pname = "bucket";
      version = "2021-02-09_Release-7.0";
      src = fetchFromContentDB {
        author = "daret";
        technicalName = "bucket";
        release = 6491;
        versionName = "2021-02-09_Release-7.0";
        sha256 = "110dli7xc5h1pypgz4yjkis97m8q0cyp3vpxv3f3x8if6if11n00";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Bucket - fork of Minetest Game mod with reduced \"bucket\" liquid flowing";

      };
    };

    "davidthecreator"."equippable_accessories" = buildMinetestPackage rec {
      type = "mod";
      pname = "equippable_accessories";
      version = "0.3";
      src = fetchFromContentDB {
        author = "davidthecreator";
        technicalName = "equippable_accessories";
        release = 7087;
        versionName = "0.3";
        sha256 = "10srpq3q7qrqm6v3i2a9inh2dqmc00fb6yc4b5km4n7lzv2cbm1r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "adds accessories that you can equip for the looks and stat bonuses.";

      };
    };

    "davidthecreator"."rangedweapons" = buildMinetestPackage rec {
      type = "mod";
      pname = "rangedweapons";
      version = "_2021.03.05___v0.4__";
      src = fetchFromContentDB {
        author = "davidthecreator";
        technicalName = "rangedweapons";
        release = 6992;
        versionName = "[2021.03.05] [v0.4] ";
        sha256 = "0ri2fichyhir5d7wwh6fgbv07pkwf1gkpl0qzndlk5q7qdlrwp4g";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Adds some guns and throwable weapons.";

      };
    };

    "dayer4b"."dirtcraft" = buildMinetestPackage rec {
      type = "mod";
      pname = "dirtcraft";
      version = "v0.4.0";
      src = fetchFromContentDB {
        author = "dayer4b";
        technicalName = "dirtcraft";
        release = 9722;
        versionName = "v0.4.0";
        sha256 = "0ssfbm3b7jb5qmn7wfzg8jhd4kyz9fymlksvx0g6qz6255bplgax";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds automatic crafting recipes for making most kinds of dirt";

      };
    };

    "debian044"."mcl_blackstone" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_blackstone";
      version = "0.2.0";
      src = fetchFromContentDB {
        author = "debian044";
        technicalName = "mcl_blackstone";
        release = 8469;
        versionName = "0.2.0";
        sha256 = "1j7q09a7gvy3ayn1njhi3ynw4lnkjvdzi7xk8d6n40z9wc0m05lr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Adds blackstone and some other new blocks for the nether.";

      };
    };

    "debiankaios"."alien_material" = buildMinetestPackage rec {
      type = "mod";
      pname = "alien_material";
      version = "0.10";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "alien_material";
        release = 6031;
        versionName = "0.10";
        sha256 = "06kd1v1vq77cpw91759yq8pab4km1bcx0f59h2aa3j6rc1k8s1b9";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Adds new blocks, items, and tools from aliens. A new time begins.";

          homepage = "http://debiankaios.de";

      };
    };

    "debiankaios"."proxima_survival" = buildMinetestPackage rec {
      type = "game";
      pname = "proxima_survival";
      version = "Alpha_0.1";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "proxima_survival";
        release = 10624;
        versionName = "Alpha 0.1";
        sha256 = "117xfdq9rfqc5dck49c78fd9dg48i7wkxgmg8vvgpzgvkc726syl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-or-later" ];
        description = "Survival on Proxima Centauri B. Work in Progress!";

          homepage = "http://proxima.debiankaios.de";

      };
    };

    "debiankaios"."simpletextures" = buildMinetestPackage rec {
      type = "txp";
      pname = "simpletextures";
      version = "0.6";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "simpletextures";
        release = 6440;
        versionName = "0.6";
        sha256 = "15bjmjf8r1zhhn910a5a4apb1nxh1gqs3kyi73yjrhn4q5sfy7va";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "It's adding texture, not the best.";

          homepage = "http://debiankaios.de/minetest";

      };
    };

    "debiankaios"."tntrun" = buildMinetestPackage rec {
      type = "mod";
      pname = "tntrun";
      version = "0.9";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "tntrun";
        release = 7729;
        versionName = "0.9";
        sha256 = "08kr5l9ixkwxzgy786rnbnfng4ph9knpcckghlm95d0d8pn38ra0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A spleef minigame";

      };
    };

    "debiankaios"."tnttag" = buildMinetestPackage rec {
      type = "mod";
      pname = "tnttag";
      version = "0.1";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "tnttag";
        release = 14233;
        versionName = "0.1";
        sha256 = "0ccdwn6g3nygg51z2mlb7iqxm34xa10zpaxyc8j7p2ln24g0ad3r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "TNTTag using arena_lib";

      };
    };

    "debiankaios"."xp_highscores" = buildMinetestPackage rec {
      type = "mod";
      pname = "xp_highscores";
      version = "Testing_0.1.1";
      src = fetchFromContentDB {
        author = "debiankaios";
        technicalName = "xp_highscores";
        release = 13804;
        versionName = "Testing 0.1.1";
        sha256 = "05wpvksmmglfdn5al9mhrdrxkqyc4vcx4z70zdkpqsgqwywkzilc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Add a better highscore system for xp_redo.";

      };
    };

    "demon_boy"."australia" = buildMinetestPackage rec {
      type = "mod";
      pname = "australia";
      version = "2018-07-23";
      src = fetchFromContentDB {
        author = "demon_boy";
        technicalName = "australia";
        release = 848;
        versionName = "2018-07-23";
        sha256 = "1wrc8bb4xs89cs3grzjvi7z38dm63lc19vzsb1b39j8asb496493";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Adds a wide variety of Australia-themed biomes and content";

      };
    };

    "devurandom"."colored_meselamps" = buildMinetestPackage rec {
      type = "mod";
      pname = "colored_meselamps";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "devurandom";
        technicalName = "colored_meselamps";
        release = 11122;
        versionName = "0.0.1";
        sha256 = "10mq9rpw0p9cm6y3mzzxfa2yyhl5q0f8hcvkw7ssfvqlih67vp43";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds colored versions of meselamps, craftable with dyes";

      };
    };

    "diceLibrarian"."ohgodpleasehelpme" = buildMinetestPackage rec {
      type = "game";
      pname = "ohgodpleasehelpme";
      version = "Alpha-05";
      src = fetchFromContentDB {
        author = "diceLibrarian";
        technicalName = "ohgodpleasehelpme";
        release = 13399;
        versionName = "Alpha-05";
        sha256 = "1kwhgjhdkx6mzjr5c8qj71qzf5bim8c9ymyqkd9jyysawj8zl2qb";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-NC-SA-3.0" ];
        description = "A casserole of mods created because dice thought it would be cool";

      };
    };

    "dino0815"."composter" = buildMinetestPackage rec {
      type = "mod";
      pname = "composter";
      version = "2022-09-23";
      src = fetchFromContentDB {
        author = "dino0815";
        technicalName = "composter";
        release = 14016;
        versionName = "2022-09-23";
        sha256 = "0vb5k500vm84sh9gj0nba3mgmm68v7hjw8ad8xabkcbpd0kpc469";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds a composter to make dirt out of your leaves.";

      };
    };

    "doctor_ew"."grappling_hook" = buildMinetestPackage rec {
      type = "mod";
      pname = "grappling_hook";
      version = "2020-03-16";
      src = fetchFromContentDB {
        author = "doctor_ew";
        technicalName = "grappling_hook";
        release = 3177;
        versionName = "2020-03-16";
        sha256 = "1pja82wsam42bikhyc4ahpz3i63wzj10fjjdbyklw1j58xlhsm9q";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "A throwable grappling_hook";

      };
    };

    "doomburger"."prismatic_stone" = buildMinetestPackage rec {
      type = "mod";
      pname = "prismatic_stone";
      version = "Prismatic_Stone";
      src = fetchFromContentDB {
        author = "doomburger";
        technicalName = "prismatic_stone";
        release = 1670;
        versionName = "Prismatic Stone";
        sha256 = "11hvjj103mw4r2k7zajd31j8gn212c4b435ib8p26vikzv0x75ld";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Adds decorative prismatic stone blocks, coral dyes, and six new crafting recipes.";

          homepage = "https://www.youtube.com/watch?v=wLgyyPyoy0Q&feature=youtu.be";

      };
    };

    "doxygen_spammer"."advtrains_attachment_offset_patch" = buildMinetestPackage rec {
      type = "mod";
      pname = "advtrains_attachment_offset_patch";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "doxygen_spammer";
        technicalName = "advtrains_attachment_offset_patch";
        release = 12531;
        versionName = "1.0.1";
        sha256 = "0g3k40j08xradh6hdvyiz0h3h0hsf30lpgc5r2zqb0vxs9a97pbl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Workaround to mitigate Minetest bug 10101, specifically for advtrains";

          homepage = "https://invent.kde.org/davidhurka/doxy_advtrains_attachment_offset_patch";

      };
    };

    "doxygen_spammer"."doxy_mini_tram" = buildMinetestPackage rec {
      type = "mod";
      pname = "doxy_mini_tram";
      version = "0.4.2";
      src = fetchFromContentDB {
        author = "doxygen_spammer";
        technicalName = "doxy_mini_tram";
        release = 12660;
        versionName = "0.4.2";
        sha256 = "0jmi2qfxzqs2bqpqc0a7h6fabv4w9bsx6yfpbgagn8kk3xn2k5j1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Scaled down Konstal 105N for advtrains";

          homepage = "https://invent.kde.org/davidhurka/doxy_mini_tram";

      };
    };

    "doxygen_spammer"."morelights_dim" = buildMinetestPackage rec {
      type = "mod";
      pname = "morelights_dim";
      version = "2020-10-02";
      src = fetchFromContentDB {
        author = "doxygen_spammer";
        technicalName = "morelights_dim";
        release = 9422;
        versionName = "2020-10-02";
        sha256 = "1ygi8v3rgjslmp81v3svbws52q5ys22bdmd4ih0jh3pzlmiqdiv9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Allows to turn morelights lights off or to dim them.";

      };
    };

    "drkwv"."minetest_hardcorebrix" = buildMinetestPackage rec {
      type = "mod";
      pname = "minetest_hardcorebrix";
      version = "_0.4.2";
      src = fetchFromContentDB {
        author = "drkwv";
        technicalName = "minetest_hardcorebrix";
        release = 11394;
        versionName = " 0.4.2";
        sha256 = "051pzfq64ay79f76hp3rrqkhlw0paihlxn666h5fbah480siivwk";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Adds durable building materials that won't break on a first dig.";

      };
    };

    "drkwv"."minetest_wadsprint" = buildMinetestPackage rec {
      type = "mod";
      pname = "minetest_wadsprint";
      version = "0.11.14";
      src = fetchFromContentDB {
        author = "drkwv";
        technicalName = "minetest_wadsprint";
        release = 11669;
        versionName = "0.11.14";
        sha256 = "1rggx189xqyr1jfghkd5vwfzf8dwafrjdrn957qkr4kbllhm9kqq";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Sprinting/running with W, A and D buttons.";

      };
    };

    "drummyfish"."drummyfish" = buildMinetestPackage rec {
      type = "txp";
      pname = "drummyfish";
      version = "1.1";
      src = fetchFromContentDB {
        author = "drummyfish";
        technicalName = "drummyfish";
        release = 834;
        versionName = "1.1";
        sha256 = "0w1b0gjxfx45yqj2xsfj042190mfgimi4dyl5yv2xf9ymnhqbwgg";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC0-1.0" ];
        description = "128 x 128 hand painted style texture pack";

      };
    };

    "duckgo"."duckstuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "duckstuff";
      version = "2022-05-31";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "duckstuff";
        release = 12429;
        versionName = "2022-05-31";
        sha256 = "1sglsfcvcqqwd7618vka34c1m1w0b02whbsi5p81yiai1wybw2ac";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "simple tools and duck armor";

      };
    };

    "duckgo"."forgotten_monsters" = buildMinetestPackage rec {
      type = "mod";
      pname = "forgotten_monsters";
      version = "forgotten_monsters_0020";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "forgotten_monsters";
        release = 14255;
        versionName = "forgotten_monsters_0020";
        sha256 = "0720glfhzm82jvsrspp9g716kc6g2a6kyaa60kdq0qxsbnkgpdsw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Monsters and Bosses...";

      };
    };

    "duckgo"."mcl_multitool" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_multitool";
      version = "0.02";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "mcl_multitool";
        release = 8254;
        versionName = "0.02";
        sha256 = "1yl77lxcp630vi0kshq1lmnz33l336d46q79j7lw430j601csjdk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "4 tools in one !";

      };
    };

    "duckgo"."mobs_ethereal_bosses" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_ethereal_bosses";
      version = "V006";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "mobs_ethereal_bosses";
        release = 14256;
        versionName = "V006";
        sha256 = "0yjngld3fmi4sz2kwwclsd3qvm7yg0kb2ddm6j88id5qdf2ibl6d";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Add Bosses to \"Ethereal NG\" biomes!";

      };
    };

    "duckgo"."nice_textures" = buildMinetestPackage rec {
      type = "txp";
      pname = "nice_textures";
      version = "nice_08";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "nice_textures";
        release = 13979;
        versionName = "nice_08";
        sha256 = "1z7mp80imi5lsm6ygbnqdhvgjvia2l0iw5182kyvvl75r35idx7q";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "A simple texture pack !!!";

      };
    };

    "duckgo"."survivetest" = buildMinetestPackage rec {
      type = "game";
      pname = "survivetest";
      version = "survivetest_0.5.5.3";
      src = fetchFromContentDB {
        author = "duckgo";
        technicalName = "survivetest";
        release = 14386;
        versionName = "survivetest 0.5.5.3";
        sha256 = "04rphz9nsv6r1qjqix2lz2s6kxn85k55h3rll6xw926ngflgzx0w";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-4.0" ];
        description = "Construction, mineration, farming , exploration , kill the monster, defeat the Boss, complete achievements and get prizes. and most importantly, have fun !";

      };
    };

    "enchant97"."element_exchange" = buildMinetestPackage rec {
      type = "mod";
      pname = "element_exchange";
      version = "2021-12-31";
      src = fetchFromContentDB {
        author = "enchant97";
        technicalName = "element_exchange";
        release = 10361;
        versionName = "2021-12-31";
        sha256 = "1v0gy6c29nx2pvjdrc1pnw7vqjfxadffglgb5andrn3gh4fvcjwq";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Exchange nodes into other nodes";

      };
    };

    "enchant97"."simple_commands" = buildMinetestPackage rec {
      type = "mod";
      pname = "simple_commands";
      version = "2021-07-17";
      src = fetchFromContentDB {
        author = "enchant97";
        technicalName = "simple_commands";
        release = 8518;
        versionName = "2021-07-17";
        sha256 = "1pp2ih06a8hj07akz4sb5zwgv4pcjfk8w27l6z74i5nzwab24j1l";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds simple chat commands";

      };
    };

    "entuland"."matrix" = buildMinetestPackage rec {
      type = "mod";
      pname = "matrix";
      version = "2018-07-02";
      src = fetchFromContentDB {
        author = "entuland";
        technicalName = "matrix";
        release = 318;
        versionName = "2018-07-02";
        sha256 = "1203rwv7gy1vrz0wvabrj71lhipfh7imvwrk8kxqsbr8waxpq853";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A wrapper around the Lua Matrix library to make it available to other mods";

      };
    };

    "entuland"."rhotator" = buildMinetestPackage rec {
      type = "mod";
      pname = "rhotator";
      version = "v1.5.0";
      src = fetchFromContentDB {
        author = "entuland";
        technicalName = "rhotator";
        release = 8192;
        versionName = "v1.5.0";
        sha256 = "1rgw4fvdwq4zchik6clyns8ydrjvmbjn0dzjl9bfgq1db0qa7zcp";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A predictable tool to rotate nodes";

      };
    };

    "entuland"."tpad" = buildMinetestPackage rec {
      type = "mod";
      pname = "tpad";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "entuland";
        technicalName = "tpad";
        release = 489;
        versionName = "Version 1.1";
        sha256 = "1gf1214mvx6xk8dq67a4l4j6njbnh1vk9i30qwfhqxng9qx04hq2";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A simple but powerful pad to create teleporting networks";

      };
    };

    "entuland"."wesh" = buildMinetestPackage rec {
      type = "mod";
      pname = "wesh";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "entuland";
        technicalName = "wesh";
        release = 910;
        versionName = "Version 1.1";
        sha256 = "0zj2hmw3hw153waxxcmr15c4di3nlr45s512abcbwzw9qvj14djm";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Not only wool! Miniaturizes builds and allows rebuilding them too";

      };
    };

    "epCode"."extra_mobs" = buildMinetestPackage rec {
      type = "mod";
      pname = "extra_mobs";
      version = "1.31__for_current_git_version_";
      src = fetchFromContentDB {
        author = "epCode";
        technicalName = "extra_mobs";
        release = 9155;
        versionName = "1.31 (for current git version)";
        sha256 = "1q8n44iay2iqic7dps9pq80wa2rw7n14a94pxxgpsk05vvqd5y3n";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Extra mobs for Mineclone.";

      };
    };

    "erlehmann"."bushy_leaves" = buildMinetestPackage rec {
      type = "mod";
      pname = "bushy_leaves";
      version = "2022-05-11";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "bushy_leaves";
        release = 12229;
        versionName = "2022-05-11";
        sha256 = "0bas88g0zf5yw6bbyml1j6wkf9y798c3cy8hasz3658sdf10zh2h";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Makes leaves render bushy instead of boxy.";

      };
    };

    "erlehmann"."mcl_lever_status_indicator" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_lever_status_indicator";
      version = "2022-05-06";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "mcl_lever_status_indicator";
        release = 12159;
        versionName = "2022-05-06";
        sha256 = "1ij7sbsaqf4r9lvif4zvql7pa0zq9ask34bidlykdighl5kdi20j";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "Makes levers in the “on” position have a red tip.";

      };
    };

    "erlehmann"."mcl_mushrooms_3d" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_mushrooms_3d";
      version = "2022-05-04";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "mcl_mushrooms_3d";
        release = 12129;
        versionName = "2022-05-04";
        sha256 = "1pif89n43ai716mj3igwiwvy8wxixm21pdi4hxikyl3rqji6ibqa";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Renders small mushrooms as 3D objects.";

      };
    };

    "erlehmann"."mcl_polished_stone_stairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_polished_stone_stairs";
      version = "2022-05-05";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "mcl_polished_stone_stairs";
        release = 12142;
        versionName = "2022-05-05";
        sha256 = "1bigr7g913rb2wmd9nn1afggcpk2za44300x906493niv1113dl4";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Adds polished stone stairs.";

      };
    };

    "erlehmann"."mcl_quick_harvest_replant" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_quick_harvest_replant";
      version = "2022-05-07";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "mcl_quick_harvest_replant";
        release = 12169;
        versionName = "2022-05-07";
        sha256 = "10zmwyaa5ymnfwi13s07v5r5mq6b0izzmhdm7aq87cdpmzqssw48";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Harvest and replant crops with one right-click.";

      };
    };

    "erlehmann"."studs" = buildMinetestPackage rec {
      type = "mod";
      pname = "studs";
      version = "2022-05-04";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "studs";
        release = 12132;
        versionName = "2022-05-04";
        sha256 = "111s080qzsp6gqk40752d80mfyrqa7rvr05fw4sk7cm5ixvzhxpf";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Adds studs on top of many nodes that are not ground content. This makes the decorated nodes look like interlocking bricks, similar to LEGO.";

      };
    };

    "erlehmann"."tga_encoder" = buildMinetestPackage rec {
      type = "mod";
      pname = "tga_encoder";
      version = "2022-07-31";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "tga_encoder";
        release = 12966;
        versionName = "2022-07-31";
        sha256 = "1msgfqzfrjqv909vmb83v1lnksk6y7b1zi1sfh2yn0sg6b9hsxq8";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "A TGA Encoder written in Lua without the use of external Libraries.";

      };
    };

    "erlehmann"."xmaps" = buildMinetestPackage rec {
      type = "mod";
      pname = "xmaps";
      version = "2022-05-22.2";
      src = fetchFromContentDB {
        author = "erlehmann";
        technicalName = "xmaps";
        release = 12343;
        versionName = "2022-05-22.2";
        sha256 = "0j5njc0iqy92n8fr7sa88y4r1yrak0654nkaxjvs415rnhpivn23";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "Adds map items that show terrain in HUD";

      };
    };

    "farfadet46"."dice" = buildMinetestPackage rec {
      type = "mod";
      pname = "dice";
      version = "Simple_Dice";
      src = fetchFromContentDB {
        author = "farfadet46";
        technicalName = "dice";
        release = 1084;
        versionName = "Simple Dice";
        sha256 = "1mm6kxv9lzgx1009kgr46p6a3d11ry862gmrcpd1kbnbw4w0ikfi";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Simple dice for little games ;)you can change the max value with commandslike that : /dice_max 6 to get a number from 1 to 6the default maximum is 10 (due to texture count)";

      };
    };

    "fgaz"."extruder" = buildMinetestPackage rec {
      type = "mod";
      pname = "extruder";
      version = "2.0.0";
      src = fetchFromContentDB {
        author = "fgaz";
        technicalName = "extruder";
        release = 14358;
        versionName = "2.0.0";
        sha256 = "1yvrb9502z3vdzanvyyq6m71jia9k14lphv0fw6ay1p4q7iykkaw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."EUPL-1.2" ];
        description = "Adds an extruder tool that can extend continuous surfaces towards the node face that was clicked";

          homepage = "https://sr.ht/~fgaz/minetest-extruder/";

      };
    };

    "ftrof"."ambion" = buildMinetestPackage rec {
      type = "mod";
      pname = "ambion";
      version = "Ambion";
      src = fetchFromContentDB {
        author = "ftrof";
        technicalName = "ambion";
        release = 14424;
        versionName = "Ambion";
        sha256 = "09iakigkf67aflbw2yrwn5lnh7a8inid5dhsqz12i8mf3s88yn8c";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "this is a mod for the new ambion ore";

          homepage = "https://github.com/ftrof7/ambion";

      };
    };

    "gabri.viane"."minebase" = buildMinetestPackage rec {
      type = "mod";
      pname = "minebase";
      version = "Minebase_0.4.1b";
      src = fetchFromContentDB {
        author = "gabri.viane";
        technicalName = "minebase";
        release = 14084;
        versionName = "Minebase 0.4.1b";
        sha256 = "14gqkd4n2ysilg61rlf17bimpchg6hykplhf4p84d2crv30n3azk";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "Adds APIs and new dynamic functionalities. ";

      };
    };

    "giga-turbo"."codeblock" = buildMinetestPackage rec {
      type = "mod";
      pname = "codeblock";
      version = "v0.7.3";
      src = fetchFromContentDB {
        author = "giga-turbo";
        technicalName = "codeblock";
        release = 12628;
        versionName = "v0.7.3";
        sha256 = "0izk6h143z2kbvgxgvpmyn1p14vcbjxgn068sk58plzf4fc2d2l5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Use lua code to build anything you want";

      };
    };

    "giga-turbo"."codecube" = buildMinetestPackage rec {
      type = "game";
      pname = "codecube";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "giga-turbo";
        technicalName = "codecube";
        release = 12748;
        versionName = "v1.0.2";
        sha256 = "1yr41ivr6ynph3vi753pakr9vn00fwfc6d0gzc8q4wz3px53h07f";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "A game where the player can construct by programming";

      };
    };

    "giga-turbo"."vector3" = buildMinetestPackage rec {
      type = "mod";
      pname = "vector3";
      version = "v1.5";
      src = fetchFromContentDB {
        author = "giga-turbo";
        technicalName = "vector3";
        release = 12613;
        versionName = "v1.5";
        sha256 = "1ygmmgfl1kj0viam1vv6d6simv9km0dhdji4sfqda6kj9ywfiq2n";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "3D Vector class with meta functions";

      };
    };

    "gimp"."simple8x" = buildMinetestPackage rec {
      type = "txp";
      pname = "simple8x";
      version = "Simple8x";
      src = fetchFromContentDB {
        author = "gimp";
        technicalName = "simple8x";
        release = 2253;
        versionName = "Simple8x";
        sha256 = "0wclmpmgpriid53rzb147fnciazz11mrldzj19y9rv51sv1p7bvz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "Pvp pack";

      };
    };

    "giov4"."enderpearl" = buildMinetestPackage rec {
      type = "mod";
      pname = "enderpearl";
      version = "1.1.3";
      src = fetchFromContentDB {
        author = "giov4";
        technicalName = "enderpearl";
        release = 5808;
        versionName = "1.1.3";
        sha256 = "15s30hcihrjzl0nr95azi1hdpkg8xfdbjpfyg3hl6ih2ya1vdksf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Throwable item that teleports you to the place it hit for some HPs";

      };
    };

    "giov4"."murder" = buildMinetestPackage rec {
      type = "mod";
      pname = "murder";
      version = "2.1.0";
      src = fetchFromContentDB {
        author = "giov4";
        technicalName = "murder";
        release = 7068;
        versionName = "2.1.0";
        sha256 = "1iavdzfhzqd01ns4mrm11xsv7qdhanbwwfcjmk2w3vf1fby961mf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "There's a murderer between us...";

      };
    };

    "giov4"."skywars" = buildMinetestPackage rec {
      type = "mod";
      pname = "skywars";
      version = "1.4.0";
      src = fetchFromContentDB {
        author = "giov4";
        technicalName = "skywars";
        release = 7069;
        versionName = "1.4.0";
        sha256 = "12v1zlz0yl0bc9jn2lrk00v41v74ziig8zwkbwk2jqd9vllw88mw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Skywars is a PvP minigame where players battle each other on floating islands until there is only one survivor remaining.";

      };
    };

    "gpcf"."moretrains" = buildMinetestPackage rec {
      type = "mod";
      pname = "moretrains";
      version = "0.1";
      src = fetchFromContentDB {
        author = "gpcf";
        technicalName = "moretrains";
        release = 10234;
        versionName = "0.1";
        sha256 = "02npzpljn215ip48irqqydg1y0vjx8i37099rcw6c31nqmr28v48";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Nice trains for Advtrains";

      };
    };

    "gpcf"."technictrain" = buildMinetestPackage rec {
      type = "mod";
      pname = "technictrain";
      version = "0.1";
      src = fetchFromContentDB {
        author = "gpcf";
        technicalName = "technictrain";
        release = 7515;
        versionName = "0.1";
        sha256 = "1s5hnmapb4w08723q1x0rawc0wz4svnv2qccpqs7bzghmv9nd2wb";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Various Technic machines mounted on rail cars";

      };
    };

    "grorp"."cascade" = buildMinetestPackage rec {
      type = "game";
      pname = "cascade";
      version = "v1.0.3";
      src = fetchFromContentDB {
        author = "grorp";
        technicalName = "cascade";
        release = 12440;
        versionName = "v1.0.3";
        sha256 = "1f5nxma3q40cibky3nsk14caybcknzi93jhngrxllx2f9qynafiv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Find the way through a cascade of mazes.";

      };
    };

    "haybame"."memeblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "memeblocks";
      version = "memeblocks";
      src = fetchFromContentDB {
        author = "haybame";
        technicalName = "memeblocks";
        release = 2782;
        versionName = "memeblocks";
        sha256 = "1xqkw5kb1y79cmrw1li5psm37n22287j4qz8xhrpk441j4vdz59b";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "adds memes to your minetest game";

      };
    };

    "heger"."streetbuilder" = buildMinetestPackage rec {
      type = "mod";
      pname = "streetbuilder";
      version = "2022-03-15";
      src = fetchFromContentDB {
        author = "heger";
        technicalName = "streetbuilder";
        release = 11573;
        versionName = "2022-03-15";
        sha256 = "1iyjy9afzvpzih3sqy7p6q7wbj6b26aqqnjfqq2fd7vmhwy2a01f";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-or-later" ];
        description = "Build a street from given points";

          homepage = "https://gitlab.com/seckl/streetbuilder/";

      };
    };

    "heger"."webchat" = buildMinetestPackage rec {
      type = "mod";
      pname = "webchat";
      version = "2022-03-13";
      src = fetchFromContentDB {
        author = "heger";
        technicalName = "webchat";
        release = 11566;
        versionName = "2022-03-13";
        sha256 = "08qk3xliyx9nbrrhzcxyvdr5vahl1vnq4x99p9ifffb96f8m5q4n";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-or-later" ];
        description = "Makes the in-game chat accessible through a web browser.";

          homepage = "https://gitlab.com/seckl/webchat/";

      };
    };

    "hilol"."epic_combat" = buildMinetestPackage rec {
      type = "game";
      pname = "epic_combat";
      version = "28";
      src = fetchFromContentDB {
        author = "hilol";
        technicalName = "epic_combat";
        release = 13489;
        versionName = "28";
        sha256 = "046fw66cch5kxpdz3gf04pbl11zqpljma9n93kd0pyr1zxi4lbcr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Fight mobs with various weapons and protect yourself with distinct sets of armour. Sharpen your skills in PVP and PVE.";

      };
    };

    "hilol"."textures__" = buildMinetestPackage rec {
      type = "txp";
      pname = "textures__";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "hilol";
        technicalName = "textures__";
        release = 13987;
        versionName = "1.0.2";
        sha256 = "0pyaag6s9mclx3lmp9w8b5wj8fl3gsdrx13ppymry192m1b0i8ld";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A great texture pack.";

      };
    };

    "hopefull"."medieval_weapons" = buildMinetestPackage rec {
      type = "mod";
      pname = "medieval_weapons";
      version = "new_textures__dagger";
      src = fetchFromContentDB {
        author = "hopefull";
        technicalName = "medieval_weapons";
        release = 13581;
        versionName = "new textures+ dagger";
        sha256 = "1p9cbpcyadgpl22y7cfhkip0sawa02n0w2fxn5ayvqd4s2bng33k";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "A simple mod that adds katanas, axes and sabres . Artwork by deathblade.";

      };
    };

    "hopefull"."tweaks_for_ctf" = buildMinetestPackage rec {
      type = "txp";
      pname = "tweaks_for_ctf";
      version = "long_grass";
      src = fetchFromContentDB {
        author = "hopefull";
        technicalName = "tweaks_for_ctf";
        release = 12546;
        versionName = "long grass";
        sha256 = "17sbcfkiv3m8nhf9rh7zjp6favcczdp07r0ir73sglpxxrj0fgxh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "This is a very simple texturepack for ctf based on WINNI's miner16px";

      };
    };

    "hutzdog"."yalib" = buildMinetestPackage rec {
      type = "mod";
      pname = "yalib";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "hutzdog";
        technicalName = "yalib";
        release = 13223;
        versionName = "0.0.1";
        sha256 = "0as4yi7hc7fcxq2n34h142lg941m2sqxrwbvd6z3w0ldxqk7ffy4";
      };
      meta = src.meta // {
        license = [ spdx."MPL-2.0" ];
        description = "Yet Another Library";

          homepage = "https://sr.ht/~hutzdog/YALib";

      };
    };

    "isaiah658"."the_pixel_pack" = buildMinetestPackage rec {
      type = "txp";
      pname = "the_pixel_pack";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "isaiah658";
        technicalName = "the_pixel_pack";
        release = 5787;
        versionName = "v1.0.2";
        sha256 = "1vk3c70ksycrxgkicwkbv2kzq916lffyvklhr7hlbhscpxi14wcj";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A 16px texture pack with a light happy feel.";

      };
    };

    "j45"."build_n_buy" = buildMinetestPackage rec {
      type = "game";
      pname = "build_n_buy";
      version = "2022-08-16";
      src = fetchFromContentDB {
        author = "j45";
        technicalName = "build_n_buy";
        release = 13312;
        versionName = "2022-08-16";
        sha256 = "1q14lcc0i20sg6mirxqlv719jxk76mr6k68ylxsp9hpz40xzn0jl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "A game inspired by Minecraft Championship's Build Mart, where you have to replicate mini build and to get the materials for them, you have to go 'shopping'.";

      };
    };

    "j45"."j_mute" = buildMinetestPackage rec {
      type = "mod";
      pname = "j_mute";
      version = "2022-08-27";
      src = fetchFromContentDB {
        author = "j45";
        technicalName = "j_mute";
        release = 13583;
        versionName = "2022-08-27";
        sha256 = "006adh892ldwkah1qdxpmfxrw80wg408kpn6qm40q2c4m1gr5987";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Mute players that are spamming.";

      };
    };

    "j45"."mcl_bubble_column" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_bubble_column";
      version = "2021-11-21";
      src = fetchFromContentDB {
        author = "j45";
        technicalName = "mcl_bubble_column";
        release = 9725;
        versionName = "2021-11-21";
        sha256 = "09i905zsbmh7gr2qq4x3c6z2j03y6zfsia8h5a73i2w7sb1cj3jd";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds whirlpools and upwards bubble columns to Mineclone2/5";

      };
    };

    "j45"."teleport_carrot" = buildMinetestPackage rec {
      type = "mod";
      pname = "teleport_carrot";
      version = "1.1";
      src = fetchFromContentDB {
        author = "j45";
        technicalName = "teleport_carrot";
        release = 9756;
        versionName = "1.1";
        sha256 = "18vklwzx5ixdcr52013x507cnpllyxpl6ww33rm76my7pfv0zpja";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "This mod is adds a craftable, eatable item that has a 1 in 10 chance of teleporting you to a nearby location.";

      };
    };

    "j45"."time_stone" = buildMinetestPackage rec {
      type = "mod";
      pname = "time_stone";
      version = "2021-09-03";
      src = fetchFromContentDB {
        author = "j45";
        technicalName = "time_stone";
        release = 9215;
        versionName = "2021-09-03";
        sha256 = "1zn4xjvp2kd0g10akaqw30xc0nzn28z8mlwryryhymdac4mc2pxq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "This mod adds 2 single use stones, a day stone and a night stone, the day stone turns time to sunrise and the night stone turns time to sunset.";

      };
    };

    "j8r"."entity_modifier" = buildMinetestPackage rec {
      type = "mod";
      pname = "entity_modifier";
      version = "2021-03-21";
      src = fetchFromContentDB {
        author = "j8r";
        technicalName = "entity_modifier";
        release = 7125;
        versionName = "2021-03-21";
        sha256 = "0b8n8r4q0989laz0i5091vbmz3qcglkz3r6dcpi6d5anansmmy3c";
      };
      meta = src.meta // {
        license = [ spdx."ISC" ];
        description = "Modify the model and size of entities, including players.";

      };
    };

    "jamiebearcub"."grand_theft_box" = buildMinetestPackage rec {
      type = "game";
      pname = "grand_theft_box";
      version = "Game_Jam_Submission";
      src = fetchFromContentDB {
        author = "jamiebearcub";
        technicalName = "grand_theft_box";
        release = 10176;
        versionName = "Game Jam Submission";
        sha256 = "09nmb2qppxs08g6wa7ymcsmk2k6mjzj8zhjj8rg9bdqm0a2fq99p";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Grand Theft Box!";

      };
    };

    "jbb"."agriculture" = buildMinetestPackage rec {
      type = "mod";
      pname = "agriculture";
      version = "0.7_20200528";
      src = fetchFromContentDB {
        author = "jbb";
        technicalName = "agriculture";
        release = 3948;
        versionName = "0.7+20200528";
        sha256 = "0zcy3ckka1a6jh97jwkp8vjnp4l0xr8pry1ky081sgkdjk8dm6w3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."WTFPL" ];
        description = "Adds many useful farming plants";

      };
    };

    "jbb"."fachwerk" = buildMinetestPackage rec {
      type = "mod";
      pname = "fachwerk";
      version = "2022-07-24";
      src = fetchFromContentDB {
        author = "jbb";
        technicalName = "fachwerk";
        release = 12912;
        versionName = "2022-07-24";
        sha256 = "0fdfvlwalq290wx5ypl2qvyzh6mvlbbr3xw1l1y6b9y7kf0xllwm";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."WTFPL" ];
        description = "This mod adds timber-framed clay, bricks, cobble, stone and stone bricks to the game.";

      };
    };

    "jkoop"."better_bookmarks" = buildMinetestPackage rec {
      type = "mod";
      pname = "better_bookmarks";
      version = "2022-01-30";
      src = fetchFromContentDB {
        author = "jkoop";
        technicalName = "better_bookmarks";
        release = 10969;
        versionName = "2022-01-30";
        sha256 = "03car2m5ii3y8mpz6m9wp98l8998hq8spc5mw466s1hmqa7zdfrb";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "keep location bookmarks, like /sethome";

      };
    };

    "joe7575"."hyperloop" = buildMinetestPackage rec {
      type = "mod";
      pname = "hyperloop";
      version = "2022-08-07";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "hyperloop";
        release = 13085;
        versionName = "2022-08-07";
        sha256 = "0m926c05gchwby5bjpr2fn04zp7dk60lsjnagj9rcx7cp71aqk6f";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-2.1-only" ];
        description = "Allows building of tubes to let players travel from point point in seconds (900 km/h)";

      };
    };

    "joe7575"."lumberjack" = buildMinetestPackage rec {
      type = "mod";
      pname = "lumberjack";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "lumberjack";
        release = 14468;
        versionName = "2022-10-19";
        sha256 = "0swdm8cvzpp9izbi8y2fk9c46ayfbfngyqswssli3qki69jzn6v4";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Chop down the entire tree by removing the bottom piece of the tree trunk.";

      };
    };

    "joe7575"."minecart" = buildMinetestPackage rec {
      type = "mod";
      pname = "minecart";
      version = "2022-07-12";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "minecart";
        release = 12797;
        versionName = "2022-07-12";
        sha256 = "12y1llc9pzf5z4crkhvqb8yvcgj7jls8wbsrmc417m3zw682v2ba";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Minecart, the lean railway transportation automation system";

      };
    };

    "joe7575"."signs_bot" = buildMinetestPackage rec {
      type = "mod";
      pname = "signs_bot";
      version = "2022-09-12";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "signs_bot";
        release = 13817;
        versionName = "2022-09-12";
        sha256 = "1b2zkx6f230yi6hmnpx2nr48zz6mm9fhmfqzyhkahkj9j1slnmsq";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "A robot controlled by signs";

      };
    };

    "joe7575"."ta4_jetpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "ta4_jetpack";
      version = "2022-07-27";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "ta4_jetpack";
        release = 12933;
        versionName = "2022-07-27";
        sha256 = "118hk9z1xan4hvx5qwij74v8207q7zxdyqmhvqgymsjhssradzj0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "JetPack for Techage";

      };
    };

    "joe7575"."ta4_paraglider" = buildMinetestPackage rec {
      type = "mod";
      pname = "ta4_paraglider";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "ta4_paraglider";
        release = 6466;
        versionName = "v1.0.1";
        sha256 = "126f70032afmn9g9phjlk9kg2xvgdrp7irfdvmmn5z65w9d3l1pj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "Techage Paraglider Mod";

      };
    };

    "joe7575"."techage_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "techage_modpack";
      version = "2022-09-24";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "techage_modpack";
        release = 14026;
        versionName = "2022-09-24";
        sha256 = "11jirrhhd8sfx5k5bhkqzp17b4g63i8cxmpcksa380a26l2dmhkm";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Go through five tech ages in search of wealth and power";

      };
    };

    "joe7575"."techpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "techpack";
      version = "2022-06-11";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "techpack";
        release = 12502;
        versionName = "2022-06-11";
        sha256 = "00xlpl8140ajmpbwvrram3i8lcb7jl1b858zysjirbq3yhfrk4q8";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "A Mining, Crafting, & Farming Modpack for Minetest";

      };
    };

    "joe7575"."techpack_stairway" = buildMinetestPackage rec {
      type = "mod";
      pname = "techpack_stairway";
      version = "2022-07-13";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "techpack_stairway";
        release = 12810;
        versionName = "2022-07-13";
        sha256 = "036b0x5y2cwkjxakjz795710pzm0syznz87cmkyy48rnkjxnrlrc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Simple stairways and bridges for your buildings and machines";

      };
    };

    "joe7575"."towercrane" = buildMinetestPackage rec {
      type = "mod";
      pname = "towercrane";
      version = "2021-04-29";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "towercrane";
        release = 7632;
        versionName = "2021-04-29";
        sha256 = "0g7q6ik57sl7bi9wc47qifdv059mw9ia8rf4v2nxm9vvfb7xj2kq";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "A scaffold alternative for your building site ";

      };
    };

    "joe7575"."tubelib2" = buildMinetestPackage rec {
      type = "mod";
      pname = "tubelib2";
      version = "2022-07-12";
      src = fetchFromContentDB {
        author = "joe7575";
        technicalName = "tubelib2";
        release = 12793;
        versionName = "2022-07-12";
        sha256 = "1bgccddr8zj0vqmk9ri1phmdagyg2l21qx6l56l2nvkdafl4w8f8";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "A library for mods which need connecting tubes / pipes / cables or similar.";

      };
    };

    "joenas"."matrix_chat" = buildMinetestPackage rec {
      type = "mod";
      pname = "matrix_chat";
      version = "v0.0.1";
      src = fetchFromContentDB {
        author = "joenas";
        technicalName = "matrix_chat";
        release = 312;
        versionName = "v0.0.1";
        sha256 = "1rzg6vcgsxyf6h2z63pv5zrlvz4d7g2f5h76iqrsp8cpkq7v365c";
      };
      meta = src.meta // {
        license = [ spdx."BSD-3-Clause" ];
        description = "This mod creates a bridge between a Matrix channel and the in-game chat!";

      };
    };

    "johalun"."mesebox" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesebox";
      version = "2020-10-27";
      src = fetchFromContentDB {
        author = "johalun";
        technicalName = "mesebox";
        release = 14453;
        versionName = "2020-10-27";
        sha256 = "0d5j4vysq44brj3q9f1zwdvz4cjfym88860fxbmg95s58jzk6a7a";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Mobile storage box powered by Mese";

      };
    };

    "joseanastacio"."challenge" = buildMinetestPackage rec {
      type = "mod";
      pname = "challenge";
      version = "2022-05-12";
      src = fetchFromContentDB {
        author = "joseanastacio";
        technicalName = "challenge";
        release = 12228;
        versionName = "2022-05-12";
        sha256 = "0yvxg328mfz1hqhfh09k8q815fdz2is8kaw75arsn0g6s4g4124j";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "challenges to create route challenges or to train flight";

      };
    };

    "joseanastacio"."gold_hunter" = buildMinetestPackage rec {
      type = "mod";
      pname = "gold_hunter";
      version = "2022-05-08";
      src = fetchFromContentDB {
        author = "joseanastacio";
        technicalName = "gold_hunter";
        release = 12184;
        versionName = "2022-05-08";
        sha256 = "17ih8adchc93xjzi1qqw3lw57rhkhkwh78jdh5hn9ayjh10i1fgq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "get gold minigame";

      };
    };

    "joseanastacio"."school_furniture" = buildMinetestPackage rec {
      type = "mod";
      pname = "school_furniture";
      version = "update_0.2";
      src = fetchFromContentDB {
        author = "joseanastacio";
        technicalName = "school_furniture";
        release = 12494;
        versionName = "update 0.2";
        sha256 = "1n3iw4kbcbnca0sryia7nrvfv19nlm0lpxrvgmn1sdv7ydq3j178";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."MIT" ];
        description = "school_furniture";

      };
    };

    "joseanastacio"."searchandrescue" = buildMinetestPackage rec {
      type = "mod";
      pname = "searchandrescue";
      version = "2022-05-06";
      src = fetchFromContentDB {
        author = "joseanastacio";
        technicalName = "searchandrescue";
        release = 12145;
        versionName = "2022-05-06";
        sha256 = "0zqbbnmny6l48057zxp936m2p0ybvj9ywavkliigpc3m6r3wiy27";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-or-later" spdx."MIT" ];
        description = "Adds search and rescue vehicles for difficult situations";

          homepage = "https://github.com/josegamestest";

      };
    };

    "jp"."craftguide" = buildMinetestPackage rec {
      type = "mod";
      pname = "craftguide";
      version = "craftguide_2.0";
      src = fetchFromContentDB {
        author = "jp";
        technicalName = "craftguide";
        release = 6625;
        versionName = "craftguide 2.0";
        sha256 = "192l1cymzvkh3g3g5q2bjhxhmkdayfzhad5wi5z8avp40x6rxg71";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The most comprehensive Crafting Guide for Minetest.";

      };
    };

    "jp"."i3" = buildMinetestPackage rec {
      type = "mod";
      pname = "i3";
      version = "i3_1.12.2";
      src = fetchFromContentDB {
        author = "jp";
        technicalName = "i3";
        release = 14157;
        versionName = "i3 1.12.2";
        sha256 = "0zic0bvk22g8dvfb87a6aykkspqz8ja3ggrd8c4c0bzrgrm8hmgb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A next-generation inventory";

      };
    };

    "jp"."pixelbox" = buildMinetestPackage rec {
      type = "txp";
      pname = "pixelbox";
      version = "PixelBOX";
      src = fetchFromContentDB {
        author = "jp";
        technicalName = "pixelbox";
        release = 2788;
        versionName = "PixelBOX";
        sha256 = "0vkyb0r1kl5gjjg7ivm9wvnqvnxv6dix0ady85qi45pwl3all85x";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Its design in a 16-bit ratio and broad range of colors and depth.";

      };
    };

    "jp"."spectator_mode" = buildMinetestPackage rec {
      type = "mod";
      pname = "spectator_mode";
      version = "2022-09-12";
      src = fetchFromContentDB {
        author = "jp";
        technicalName = "spectator_mode";
        release = 13846;
        versionName = "2022-09-12";
        sha256 = "1sbxcgxgpwhyxwwfii9fb418d7gwn7pycx236vplams5a37s0vp9";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "A mod for Minetest allowing you to watch other players in their 3rd person view.";

      };
    };

    "jp"."xdecor" = buildMinetestPackage rec {
      type = "mod";
      pname = "xdecor";
      version = "2022-09-21";
      src = fetchFromContentDB {
        author = "jp";
        technicalName = "xdecor";
        release = 13983;
        versionName = "2022-09-21";
        sha256 = "01ipbvab1f3vxzknj7bffs9sj1vwy0gjgx46jl26jfd566ir5i65";
      };
      meta = src.meta // {
        license = [ spdx."BSD-3-Clause" spdx."CC-BY-NC-SA-3.0" ];
        description = "A decoration mod meant to be simple and well-featured.";

      };
    };

    "jwmhjwmh"."area_containers" = buildMinetestPackage rec {
      type = "mod";
      pname = "area_containers";
      version = "1.6.1";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "area_containers";
        release = 12365;
        versionName = "1.6.1";
        sha256 = "12n96liwyzvnl1qjgxcm72di923jjqh5yrca19r54f3zdlmb7xs5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds nodes that contain areas in which you can build";

      };
    };

    "jwmhjwmh"."jitprofiler" = buildMinetestPackage rec {
      type = "mod";
      pname = "jitprofiler";
      version = "2022-10-04";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "jitprofiler";
        release = 14451;
        versionName = "2022-10-04";
        sha256 = "0dkna11h8wrca5qlns8zya1rdrfy09gjn7bzarir5f9ba6806h0p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Profile mods using LuaJIT's built-in profiler.";

      };
    };

    "jwmhjwmh"."large_slugs" = buildMinetestPackage rec {
      type = "mod";
      pname = "large_slugs";
      version = "1.1.2";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "large_slugs";
        release = 13703;
        versionName = "1.1.2";
        sha256 = "15nwqirn8czlv6mv9p35qfqnkwd9lxvspix9rs4v0ixhfsrwwdfw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds node-based slug mobs to your world";

      };
    };

    "jwmhjwmh"."node_object" = buildMinetestPackage rec {
      type = "mod";
      pname = "node_object";
      version = "0.1.0";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "node_object";
        release = 11375;
        versionName = "0.1.0";
        sha256 = "0qm43zcjyi41b4p1q54v6hsh8c95svla2q7v8ha83xabv640n8p1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A library for associating objects with nodes";

      };
    };

    "jwmhjwmh"."promisestuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "promisestuff";
      version = "0.4.1";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "promisestuff";
        release = 14011;
        versionName = "0.4.1";
        sha256 = "1hpnn8ch66hxvgqs9bz3aflimsah388jhvcsxrij4p6i21mrdcdk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A promise library";

      };
    };

    "jwmhjwmh"."shifter_tool" = buildMinetestPackage rec {
      type = "mod";
      pname = "shifter_tool";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "jwmhjwmh";
        technicalName = "shifter_tool";
        release = 11882;
        versionName = "1.0.1";
        sha256 = "0qvxxyz4nimdq0piv8jv41ybgyvm9r2jq16n01bmra8l9pyc04cg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-or-later" ];
        description = "Adds a tool for moving nodes as pistons would";

      };
    };

    "kaeza"."intllib" = buildMinetestPackage rec {
      type = "mod";
      pname = "intllib";
      version = "2021-02-24";
      src = fetchFromContentDB {
        author = "kaeza";
        technicalName = "intllib";
        release = 13148;
        versionName = "2021-02-24";
        sha256 = "19lnk0z3whfsximfrmmz1girka1v1kfsqjagcfgsg59zgp0jhlg9";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Internationalization library.";

      };
    };

    "kaeza"."irc" = buildMinetestPackage rec {
      type = "mod";
      pname = "irc";
      version = "2022-03-24";
      src = fetchFromContentDB {
        author = "kaeza";
        technicalName = "irc";
        release = 13164;
        versionName = "2022-03-24";
        sha256 = "12grr40w7rkqpfnx3kac9p3pzs4m0wa4fd454x3a58k3xk0195wl";
      };
      meta = src.meta // {
        license = [ spdx."BSD-2-Clause-FreeBSD" ];
        description = "Connect your server to an IRC channel, and install irc_commands to control the server from IRC";

      };
    };

    "kaeza"."no_guests" = buildMinetestPackage rec {
      type = "mod";
      pname = "no_guests";
      version = "1.0-Ruben";
      src = fetchFromContentDB {
        author = "kaeza";
        technicalName = "no_guests";
        release = 843;
        versionName = "1.0-Ruben";
        sha256 = "084y16c2j5ffm6f33i5iv7q8p3y4frfxsylk0zbf58way3ghxh68";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Stops guest players (ie: Guest1234) from joining your server";

      };
    };

    "kaeza"."xban2" = buildMinetestPackage rec {
      type = "mod";
      pname = "xban2";
      version = "2020-06-02";
      src = fetchFromContentDB {
        author = "kaeza";
        technicalName = "xban2";
        release = 6382;
        versionName = "2020-06-02";
        sha256 = "068dmyjhvhd86k9dzs7p0aq54jgfmrl59375jbbp3h5bis8vj0vd";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Tempbanning and better banning by keeping track of usernames and IP addresses";

      };
    };

    "karamel"."naturalslopes_hades_revisited" = buildMinetestPackage rec {
      type = "mod";
      pname = "naturalslopes_hades_revisited";
      version = "0.2";
      src = fetchFromContentDB {
        author = "karamel";
        technicalName = "naturalslopes_hades_revisited";
        release = 8822;
        versionName = "0.2";
        sha256 = "0byhm852y7prq2p0jyqf0b78jfpxb38hrsv0bq1q4x1c6fxq1h1b";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Add natural slopes for Hades Revisited";

          homepage = "https://www.cupnplategames.com/en/minetest-natural-slopes.html";

      };
    };

    "karamel"."naturalslopes_minetest_game" = buildMinetestPackage rec {
      type = "mod";
      pname = "naturalslopes_minetest_game";
      version = "0.4";
      src = fetchFromContentDB {
        author = "karamel";
        technicalName = "naturalslopes_minetest_game";
        release = 11372;
        versionName = "0.4";
        sha256 = "0kakzdlcmhjb0n487y8z6rn1js513m3pn3qy0q9fiagnpk1hh1l3";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Add natural slopes for Minetest Game";

          homepage = "https://www.cupnplategames.com/en/minetest-natural-slopes.html";

      };
    };

    "karamel"."naturalslopeslib" = buildMinetestPackage rec {
      type = "mod";
      pname = "naturalslopeslib";
      version = "1.5";
      src = fetchFromContentDB {
        author = "karamel";
        technicalName = "naturalslopeslib";
        release = 12020;
        versionName = "1.5";
        sha256 = "1p2iy7il1p97j3bbfzvmiv7ffyvvpcpbc6j6ir41qbq10ggkwp19";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Library to simply add slopes to regular nodes and include them on map generation and when changing the landscape.";

          homepage = "https://www.cupnplategames.com/en/minetest-natural-slopes.html";

      };
    };

    "karamel"."poschangelib" = buildMinetestPackage rec {
      type = "mod";
      pname = "poschangelib";
      version = "0.6";
      src = fetchFromContentDB {
        author = "karamel";
        technicalName = "poschangelib";
        release = 5896;
        versionName = "0.6";
        sha256 = "08c8adbnir7w0cz7nwmyxlgk08a41bp3hc610jmagc8ha3lf55df";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Players' position observing library";

      };
    };

    "karamel"."twmlib" = buildMinetestPackage rec {
      type = "mod";
      pname = "twmlib";
      version = "0.1";
      src = fetchFromContentDB {
        author = "karamel";
        technicalName = "twmlib";
        release = 5945;
        versionName = "0.1";
        sha256 = "1ls4ib6sqbfyl8i033dm02sxszz44pfljn1cbnm4c7xrf3gdq7i0";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Environmental ABM that could be triggered on a very wide range of nodes but only a few at a time.";

      };
    };

    "karlexceed"."base_gameplay_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "base_gameplay_modpack";
      version = "v0.2";
      src = fetchFromContentDB {
        author = "karlexceed";
        technicalName = "base_gameplay_modpack";
        release = 2894;
        versionName = "v0.2";
        sha256 = "1n0gkvmzl0zx63w276gj1wlax1b5qxbrkq69knb193rjgck619ki";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "This combines several other gameplay mods that I consider useful.";

      };
    };

    "karlexceed"."falling_dirt" = buildMinetestPackage rec {
      type = "mod";
      pname = "falling_dirt";
      version = "Release_v0.2";
      src = fetchFromContentDB {
        author = "karlexceed";
        technicalName = "falling_dirt";
        release = 2851;
        versionName = "Release v0.2";
        sha256 = "0s471lgk1d3svwdix13ynhwzglffjls28q3930b9pbjhni168ipk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Makes dirt nodes fall just like sand and gravel.";

      };
    };

    "kay27"."mineclone5" = buildMinetestPackage rec {
      type = "game";
      pname = "mineclone5";
      version = "MineClone_5.1.11_Advanced_Skin";
      src = fetchFromContentDB {
        author = "kay27";
        technicalName = "mineclone5";
        release = 12904;
        versionName = "MineClone 5.1.11 Advanced Skin";
        sha256 = "15v92fhn9bzpph51rfiv9957hwdcmgly46dw2ahpccalq4nabqiw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A fork of MineClone 2 with no release milestones, rapid delivery, merges by one approval and no MC target version limitations";

      };
    };

    "kestral"."cavetools" = buildMinetestPackage rec {
      type = "mod";
      pname = "cavetools";
      version = "2022-09-15";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "cavetools";
        release = 13886;
        versionName = "2022-09-15";
        sha256 = "06clrifs5w69hhvypj260i3l0l4895gl9fggp9zni6nprkm081b1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A collection of tools that can be useful for exploring caves.";

      };
    };

    "kestral"."default_grid" = buildMinetestPackage rec {
      type = "txp";
      pname = "default_grid";
      version = "2019-09-15";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "default_grid";
        release = 1999;
        versionName = "2019-09-15";
        sha256 = "05ns6bj0lnkfa92f4qy6qlllvg7b54warfkj2b5rd4ibry2fi0x8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" ];
        description = "Add grid overlay to MT Game 5.0 default textures.";

      };
    };

    "kestral"."hud_compass" = buildMinetestPackage rec {
      type = "mod";
      pname = "hud_compass";
      version = "2020-04-23";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "hud_compass";
        release = 3553;
        versionName = "2020-04-23";
        sha256 = "1bsqlizjz46zyd5rxls5x2rz3wmj1y803i4aix54ykaaxaa583zi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Optionally place a HUD compass and 24-hour clock on the screen.";

      };
    };

    "kestral"."realcompass" = buildMinetestPackage rec {
      type = "mod";
      pname = "realcompass";
      version = "1.23";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "realcompass";
        release = 8333;
        versionName = "1.23";
        sha256 = "0r66zia76sybbcnw3ly34kdiy93skyz806ssfq1a2mbgizpnyk1q";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A simple compass that only points north.";

      };
    };

    "kestral"."sleeping_mat" = buildMinetestPackage rec {
      type = "mod";
      pname = "sleeping_mat";
      version = "2020-01-29";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "sleeping_mat";
        release = 3151;
        versionName = "2020-01-29";
        sha256 = "0y0aclxymqk30hqlxs30bp6976w5qfv38fqsmjnh33z2jx5h4sy1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Simple sleeping mat made out of grass.";

      };
    };

    "kestral"."tunnelmaker" = buildMinetestPackage rec {
      type = "mod";
      pname = "tunnelmaker";
      version = "2.2.0";
      src = fetchFromContentDB {
        author = "kestral";
        technicalName = "tunnelmaker";
        release = 13333;
        versionName = "2.2.0";
        sha256 = "0w50lqwi04gripkx0kfn1fy0pfjv3q21jsvll0rfv2wpp7ly1b5j";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Easily create arbitrarily curved tunnels, paths, and bridges.";

      };
    };

    "kevins"."getname" = buildMinetestPackage rec {
      type = "mod";
      pname = "getname";
      version = "1.0.5";
      src = fetchFromContentDB {
        author = "kevins";
        technicalName = "getname";
        release = 4473;
        versionName = "1.0.5";
        sha256 = "1cb9wnzcjp1p3jzixgyad5d8ky0vnyac8yhpzshb058mp8i8czb5";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Adds an API and tool to generate random names for NPCs, mobs, and places.";

      };
    };

    "ksandr"."yatranslate" = buildMinetestPackage rec {
      type = "mod";
      pname = "yatranslate";
      version = "25.01.2021";
      src = fetchFromContentDB {
        author = "ksandr";
        technicalName = "yatranslate";
        release = 6206;
        versionName = "25.01.2021";
        sha256 = "1jwfhy72klx0zr45bwch3i0iksw0k2iravhkdi7i83l5n3bs8yz9";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds commands to translate chat messages into the recipient's language.";

      };
    };

    "kyleclaassen"."mathplot" = buildMinetestPackage rec {
      type = "mod";
      pname = "mathplot";
      version = "2.1.2";
      src = fetchFromContentDB {
        author = "kyleclaassen";
        technicalName = "mathplot";
        release = 8801;
        versionName = "2.1.2";
        sha256 = "11r7i8yjlv3dxs0h41ljvw9zrpqx2kh943xw4xkg1ifk5n31mlg9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "A tool for constructing mathematical curves/surfaces/solids.";

          homepage = "https://www.rose-hulman.edu/~claassen/coolstuff/minetest_mathplot/";

      };
    };

    "lag01"."bed_lives" = buildMinetestPackage rec {
      type = "mod";
      pname = "bed_lives";
      version = "2021-08-22";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "bed_lives";
        release = 14450;
        versionName = "2021-08-22";
        sha256 = "08vvpgxvm9ca1pmm34i9kb60vrfx7a32hy3qqnqi7d6pzhiaqwaf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Lose bed spawn point after spending 3 lives";

      };
    };

    "lag01"."chat2" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat2";
      version = "2018-06-05";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "chat2";
        release = 227;
        versionName = "2018-06-05";
        sha256 = "0pa3dbj8yy5jgnrbqydkd3m57db2j0bxd26v53y0cq4hxmbbr46k";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Complements game built-in chat or replaces it.";

      };
    };

    "lag01"."chat_anticurse" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_anticurse";
      version = "2016-04-06";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "chat_anticurse";
        release = 456;
        versionName = "2016-04-06";
        sha256 = "1sg99wx360xdzz9nhiz539yk2a8kf5rwrmczsjinj81d3zjdlj88";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Kick player out when they type a curse word in chat or using /me or /msg command.";

      };
    };

    "lag01"."climbing_pick" = buildMinetestPackage rec {
      type = "mod";
      pname = "climbing_pick";
      version = "0.1.1";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "climbing_pick";
        release = 9129;
        versionName = "0.1.1";
        sha256 = "1xq2dj2j3qrk5hi04d8h3z9j5gwb780n5y66pmzabk7d84c9hrq9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Tool to climb, double jump, and do good damage to mobs.";

      };
    };

    "lag01"."kick_voting" = buildMinetestPackage rec {
      type = "mod";
      pname = "kick_voting";
      version = "2014-12-21";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "kick_voting";
        release = 8101;
        versionName = "2014-12-21";
        sha256 = "0drfcr4v78cs7ym5lhmmdgddiswf18wjs0x5avxnqq398pckp2cj";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Allow players to vote to make life of selected griefers and especially agressive players harder.";

      };
    };

    "lag01"."lighting_rocket" = buildMinetestPackage rec {
      type = "mod";
      pname = "lighting_rocket";
      version = "0.1.1";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "lighting_rocket";
        release = 9136;
        versionName = "0.1.1";
        sha256 = "0h392l0yqnjvygd5wzdqk5a3i8b7sn7xmiqx0kwsy19njls51zi2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "For temporary lighting large areas";

      };
    };

    "lag01"."spawn_command" = buildMinetestPackage rec {
      type = "mod";
      pname = "spawn_command";
      version = "2021-05-29";
      src = fetchFromContentDB {
        author = "lag01";
        technicalName = "spawn_command";
        release = 8098;
        versionName = "2021-05-29";
        sha256 = "1464vx84jwprsrr8bb7bkkd6crzj2ymf9qf6ksz4mank451p9xps";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds a /spawn command that teleports you to the server spawn command.";

      };
    };

    "lazerbeak12345"."chocolatestuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "chocolatestuff";
      version = "1.5.4";
      src = fetchFromContentDB {
        author = "lazerbeak12345";
        technicalName = "chocolatestuff";
        release = 10873;
        versionName = "1.5.4";
        sha256 = "09jfzl4hyalbbw11kar1v3f1hi7bqiqhjjn2vjznhasrlml6mn1f";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Adds edible chocolate tools and armor to Minetest.";

      };
    };

    "lazerbeak12345"."ediblestuff_api" = buildMinetestPackage rec {
      type = "mod";
      pname = "ediblestuff_api";
      version = "1.6.0";
      src = fetchFromContentDB {
        author = "lazerbeak12345";
        technicalName = "ediblestuff_api";
        release = 13571;
        versionName = "1.6.0";
        sha256 = "1sc07dychrr1zsf4lm3fgx0hmn5hl44mvfiwc5vwvyzsw0xynb21";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "API for making items, tools and armor edible. Eat armor while wearing it!";

      };
    };

    "lazerbeak12345"."falling_stairs" = buildMinetestPackage rec {
      type = "mod";
      pname = "falling_stairs";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "lazerbeak12345";
        technicalName = "falling_stairs";
        release = 10994;
        versionName = "1.0.2";
        sha256 = "0qzcx9j0y6fi1s4w5wykyj68ww7vr3n1awr2j3rrlnwq8g4jhhki";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds falling stairs and slabs for gravel, sand and others.";

      };
    };

    "lisacvuk"."toolranks" = buildMinetestPackage rec {
      type = "mod";
      pname = "toolranks";
      version = "v1.2___fix";
      src = fetchFromContentDB {
        author = "lisacvuk";
        technicalName = "toolranks";
        release = 6378;
        versionName = "v1.2 + fix";
        sha256 = "1kcjyvwi8rrjhnp03ampzlan1x0di6l503bacssyj2g10glbchjj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Counts the number of nodes a specific tool has dug";

      };
    };

    "liteninglazer"."mystic_runes" = buildMinetestPackage rec {
      type = "mod";
      pname = "mystic_runes";
      version = "Mystic_Runes_2.2.1";
      src = fetchFromContentDB {
        author = "liteninglazer";
        technicalName = "mystic_runes";
        release = 13682;
        versionName = "Mystic Runes 2.2.1";
        sha256 = "1zh8a8lb5viq00g8jiznkwwkf6vyky5lhjc71d21abskkii0c331";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."GPL-3.0-only" ];
        description = "Adds runes which can be used to craft powerful items.";

      };
    };

    "liteninglazer"."mystical_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "mystical_tools";
      version = "Mystical_Tools_1.1.2";
      src = fetchFromContentDB {
        author = "liteninglazer";
        technicalName = "mystical_tools";
        release = 11197;
        versionName = "Mystical Tools 1.1.2";
        sha256 = "16p0m7hgdg7jwnn70wkjg365jn2bnjyfjhm08a10k3qgvdbpap8k";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "tool progression past diamonds and adds mystical staffs and wands";

      };
    };

    "logalog"."minegistic" = buildMinetestPackage rec {
      type = "game";
      pname = "minegistic";
      version = "07-02-22";
      src = fetchFromContentDB {
        author = "logalog";
        technicalName = "minegistic";
        release = 12692;
        versionName = "07-02-22";
        sha256 = "1wi28cgzdpr9blaz51akwmsrn4x3858cff4x1gx6335al16bx7cf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Build a great rail and logistics empire";

      };
    };

    "loosewheel"."lwcolorable" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcolorable";
      version = "2022-06-19";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcolorable";
        release = 12554;
        versionName = "2022-06-19";
        sha256 = "0c4ldfakwgd102yxpsribnwjrvqmi04lfypb8d4dhwsi8vd26fw8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Various colorable decorative blocks.";

      };
    };

    "loosewheel"."lwcomponents" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcomponents";
      version = "2022-09-19";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcomponents";
        release = 13940;
        versionName = "2022-09-19";
        sha256 = "1xnjcn96g47s1b7pd87s2mhrdy8jvwkk9c7d9ywg2fl2ac9bcc07";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Various components for mesecons and digilines.";

      };
    };

    "loosewheel"."lwcomponents_spawners" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcomponents_spawners";
      version = "2022-03-09";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcomponents_spawners";
        release = 11531;
        versionName = "2022-03-09";
        sha256 = "0jkf6fsmkzxrdcb1nf4g69a5fnigvr651p8i4vi36ghldyyv5rmh";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-or-later" ];
        description = "Register spawners for lwcomponents.";

      };
    };

    "loosewheel"."lwcomputers" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcomputers";
      version = "2022-06-19";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcomputers";
        release = 12556;
        versionName = "2022-06-19";
        sha256 = "0krdnnbdvdw24aa1qrb72s7gqsa3zynvf197gyrm51k67laq9jdi";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Adds programmable computers and robots, and sundry.";

      };
    };

    "loosewheel"."lwcomputers_software" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcomputers_software";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcomputers_software";
        release = 12575;
        versionName = "v1.0";
        sha256 = "0lap16qk12k8v8y2skd6pvphrrs05280pyl51vi3byffrglwnl07";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Software for LWComputers.";

      };
    };

    "loosewheel"."lwcreative_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwcreative_tools";
      version = "2022-08-24";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwcreative_tools";
        release = 13515;
        versionName = "2022-08-24";
        sha256 = "12aigyd43plap156xkdmc6yzx7f8vhxc2lzv9c9vfhn4hi56p069";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Tools for creative mode.";

      };
    };

    "loosewheel"."lwroad_tracks" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwroad_tracks";
      version = "2022-03-09";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwroad_tracks";
        release = 11532;
        versionName = "2022-03-09";
        sha256 = "039m2qsvbny9lz9s9b24k85ny2s239mkz6japprqamjgih4zb5i6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-2.1-only" ];
        description = "Cars and road tracks (function similar to rail carts).";

      };
    };

    "loosewheel"."lwscratch" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwscratch";
      version = "2022-03-09";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwscratch";
        release = 11533;
        versionName = "2022-03-09";
        sha256 = "0pk5z22n252dfnwjryzxw6ldhwbzf9di8clhxsv5rgapjpw7pgvq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Scratch programmable robots.";

      };
    };

    "loosewheel"."lwwires" = buildMinetestPackage rec {
      type = "mod";
      pname = "lwwires";
      version = "LWWires_v_1.0";
      src = fetchFromContentDB {
        author = "loosewheel";
        technicalName = "lwwires";
        release = 12356;
        versionName = "LWWires v 1.0";
        sha256 = "0zzzinfdj5agpb32lc4mmz0mxx3fli1m2p8a3fjax6jba74r4skh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Wires and bundle cables.";

      };
    };

    "louisroyer"."keyring" = buildMinetestPackage rec {
      type = "mod";
      pname = "keyring";
      version = "v1.3.1";
      src = fetchFromContentDB {
        author = "louisroyer";
        technicalName = "keyring";
        release = 12573;
        versionName = "v1.3.1";
        sha256 = "0v1q9pidpffsmb242sajip5ha3h0y6dnlj4di4xrpclfpapdx094";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds keyrings.";

      };
    };

    "louisroyer"."symmetric_crafts" = buildMinetestPackage rec {
      type = "mod";
      pname = "symmetric_crafts";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "louisroyer";
        technicalName = "symmetric_crafts";
        release = 12571;
        versionName = "v1.0.1";
        sha256 = "1ybf11pr62g4pmz7jwsl4nk4ky7q1dd97kzx96zqsrplqjqdb1ly";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Add vertical symmetry in crafts.";

      };
    };

    "louisroyer"."toolranks_extras" = buildMinetestPackage rec {
      type = "mod";
      pname = "toolranks_extras";
      version = "v1.4.3";
      src = fetchFromContentDB {
        author = "louisroyer";
        technicalName = "toolranks_extras";
        release = 12572;
        versionName = "v1.4.3";
        sha256 = "1yj5krrpiqbc0x513sdl7am1rsan5f7nai8nrsqz0aaw4f5m1bki";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Extends toolranks support.";

      };
    };

    "louisroyer"."virtual_key" = buildMinetestPackage rec {
      type = "mod";
      pname = "virtual_key";
      version = "v1.1.1";
      src = fetchFromContentDB {
        author = "louisroyer";
        technicalName = "virtual_key";
        release = 12574;
        versionName = "v1.1.1";
        sha256 = "1khnq1w7d6683x38x23hmb6i5zi228wq5q8m0p440pr4w6p584qq";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds virtual keys registerers.";

      };
    };

    "lucxmangajet"."minetest_presentations" = buildMinetestPackage rec {
      type = "mod";
      pname = "minetest_presentations";
      version = "Minetest_Presentations_0.5";
      src = fetchFromContentDB {
        author = "lucxmangajet";
        technicalName = "minetest_presentations";
        release = 6583;
        versionName = "Minetest Presentations 0.5";
        sha256 = "1g368p82cqim8yalnjnx7d3qgh5r6ny49d1yxd5fl5ry9rwsy689";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows displaying images downloadable at runtime and adds virtual presentations utilities.";

      };
    };

    "luk3yx"."advmarkers" = buildMinetestPackage rec {
      type = "mod";
      pname = "advmarkers";
      version = "2021-02-28";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "advmarkers";
        release = 6685;
        versionName = "2021-02-28";
        sha256 = "0ca2pln1qd9lsfd72a3i7p0k5wnbmh213njnrk6ly9kdw65xv0hh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows you to create and manage markers/waypoints.";

      };
    };

    "luk3yx"."blueprints" = buildMinetestPackage rec {
      type = "mod";
      pname = "blueprints";
      version = "2019-06-11";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "blueprints";
        release = 5749;
        versionName = "2019-06-11";
        sha256 = "0yakislfwg8w6h12r9h5pbl5m99mfff2kdi788djmaj1r0v24476";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows Minetest players to easily copy+paste nodes.";

      };
    };

    "luk3yx"."cloaking" = buildMinetestPackage rec {
      type = "mod";
      pname = "cloaking";
      version = "2022-04-13";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "cloaking";
        release = 11822;
        versionName = "2022-04-13";
        sha256 = "0zc3fskzfncha4kln83pqnzh3z48rrj4l6kfgd6msrbcy687niqr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows admins to become invisible and appear as if they are not in-game at all.";

      };
    };

    "luk3yx"."flow" = buildMinetestPackage rec {
      type = "mod";
      pname = "flow";
      version = "2022-10-18";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "flow";
        release = 14441;
        versionName = "2022-10-18";
        sha256 = "0b6wcxnf37n4h2j9jbbzdgqldrwa3p9xzmjjc4g5h8sz24l8aaq7";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-or-later" ];
        description = "A formspec library that automatically positions and sizes elements";

      };
    };

    "luk3yx"."formspec_ast" = buildMinetestPackage rec {
      type = "mod";
      pname = "formspec_ast";
      version = "2022-10-10";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "formspec_ast";
        release = 14277;
        versionName = "2022-10-10";
        sha256 = "1m500lw0n58ypi60vmb5cg0v2ynxd01nxgpinwxn62r7df8jywxp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A library to help other mods interpret formspecs.";

      };
    };

    "luk3yx"."fs51" = buildMinetestPackage rec {
      type = "mod";
      pname = "fs51";
      version = "2022-04-13";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "fs51";
        release = 11821;
        versionName = "2022-04-13";
        sha256 = "09gz5fm8flphnpsfw4z24snc13wdl0zfa377yla7jwp2dar3qwfx";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Compatibility layer for formspecs";

      };
    };

    "luk3yx"."hud_fs" = buildMinetestPackage rec {
      type = "mod";
      pname = "hud_fs";
      version = "2022-05-23";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "hud_fs";
        release = 12346;
        versionName = "2022-05-23";
        sha256 = "0yvp4ka6s9sw1na1phv6k31v61289sbhd9gv5ycpqxn10lcff9l0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A library to make HUDs from formspecs";

      };
    };

    "luk3yx"."money3" = buildMinetestPackage rec {
      type = "mod";
      pname = "money3";
      version = "2020-12-16";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "money3";
        release = 5753;
        versionName = "2020-12-16";
        sha256 = "1iv4skhbs9lr3fis1b8n1h9v02v06f3ddxnrn49qhr7l6vdgaqxz";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds /money.";

      };
    };

    "luk3yx"."prang" = buildMinetestPackage rec {
      type = "game";
      pname = "prang";
      version = "2022-10-09";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "prang";
        release = 14264;
        versionName = "2022-10-09";
        sha256 = "15aljfg3jgagxqvws5nzs8xk8fj45mycp8cw788144y1ygm1q4rn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "An unofficial port of PRANG!, a 2D arcade-style game.";

      };
    };

    "luk3yx"."snippets" = buildMinetestPackage rec {
      type = "mod";
      pname = "snippets";
      version = "2021-04-14";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "snippets";
        release = 7481;
        versionName = "2021-04-14";
        sha256 = "0jcxk0ravg4zljcl6r9anybrz8vyjg7yqdb387mks4r8bq08kl1p";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A way for admins to run and save lua snippets.";

      };
    };

    "luk3yx"."sscsm" = buildMinetestPackage rec {
      type = "mod";
      pname = "sscsm";
      version = "2022-07-10";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "sscsm";
        release = 12780;
        versionName = "2022-07-10";
        sha256 = "1dpar9nr61igssyl4jzdzfakq2hqc38qgcvcs4fp203yh6hks2ds";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "A server-sent CSM library.";

      };
    };

    "luk3yx"."stasis" = buildMinetestPackage rec {
      type = "mod";
      pname = "stasis";
      version = "2018-07-27";
      src = fetchFromContentDB {
        author = "luk3yx";
        technicalName = "stasis";
        release = 473;
        versionName = "2018-07-27";
        sha256 = "1anhrzigaslys8wjz6fl0v9f7szs01khw0bwlb7cczmcjxh4p6xd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows players to be put in stasis.";

      };
    };

    "malt2592"."dungeon_flora" = buildMinetestPackage rec {
      type = "mod";
      pname = "dungeon_flora";
      version = "1.0";
      src = fetchFromContentDB {
        author = "malt2592";
        technicalName = "dungeon_flora";
        release = 13467;
        versionName = "1.0";
        sha256 = "0rjbz6zzgyj6lzv80r3h4wai9pnmr83y418rqcvxp30ba7yqjd2g";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds flora to cobblestone dungeons";

      };
    };

    "marek"."mesecons_regs" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_regs";
      version = "v0.1";
      src = fetchFromContentDB {
        author = "marek";
        technicalName = "mesecons_regs";
        release = 4508;
        versionName = "v0.1";
        sha256 = "0g5rjsq43npcy5fa1ai2s30nq82ing7wn6lnc9g5frshgx65wvfb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds Latch and Flipflop circuits.";

      };
    };

    "marek"."mesecons_x" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_x";
      version = "v1.6";
      src = fetchFromContentDB {
        author = "marek";
        technicalName = "mesecons_x";
        release = 11016;
        versionName = "v1.6";
        sha256 = "1y81pj99sys1a1brn2ydr1jh81qvylgkg7bg4y3v4f3rvfz7mnm9";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds Latch, Flipflop, tools for automatic wireing, 3-input gates etc.";

      };
    };

    "markthesmeagol"."tides" = buildMinetestPackage rec {
      type = "mod";
      pname = "tides";
      version = "0.0.3";
      src = fetchFromContentDB {
        author = "markthesmeagol";
        technicalName = "tides";
        release = 871;
        versionName = "0.0.3";
        sha256 = "0gj6a795pk8c1qrbvv6ag67as9xfqsg6zd66pdwb7zk8lyl3l4md";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds tides, WARNING: will delete water sources above sea level";

      };
    };

    "mazes"."maidroid_ng" = buildMinetestPackage rec {
      type = "mod";
      pname = "maidroid_ng";
      version = "20220921";
      src = fetchFromContentDB {
        author = "mazes";
        technicalName = "maidroid_ng";
        release = 14004;
        versionName = "20220921";
        sha256 = "196kf3b3yxq6bi9zrjz4k0p9lw8cknhxbhb1smvnnnv5dsysjyzp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-2.1-or-later" ];
        description = "Inspired by littleMaidMob from another voxel game, it provides maid robots called \"maidroid\".";

          homepage = "https://gitlab.com/mazes_80/maidroid/";

      };
    };

    "micu"."micupack" = buildMinetestPackage rec {
      type = "mod";
      pname = "micupack";
      version = "2021-04-14";
      src = fetchFromContentDB {
        author = "micu";
        technicalName = "micupack";
        release = 7976;
        versionName = "2021-04-14";
        sha256 = "0m70yls1x9yqab8z77gf1sl3m27rnmpfpaccmjlsz1pj0c4wfmg1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Various devices and machines for experienced miners and TechPack engineers.";

      };
    };

    "mijutu"."deck" = buildMinetestPackage rec {
      type = "mod";
      pname = "deck";
      version = "2022-01-06";
      src = fetchFromContentDB {
        author = "mijutu";
        technicalName = "deck";
        release = 10484;
        versionName = "2022-01-06";
        sha256 = "01xnf7kvnd6fzj7qskfmd3nhnniyfvfngh03262y4wrsssbnkq5s";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC0-1.0" ];
        description = "Deck of cards and table blocks";

      };
    };

    "mineclone2-mods"."modname_tooltip" = buildMinetestPackage rec {
      type = "mod";
      pname = "modname_tooltip";
      version = "2.1";
      src = fetchFromContentDB {
        author = "mineclone2-mods";
        technicalName = "modname_tooltip";
        release = 11926;
        versionName = "2.1";
        sha256 = "098qzcnvx973xp4wbalv1x2mlmmv09zklbqchwr5xfd8jph70hbk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-or-later" ];
        description = "Modname Tooltip Minecraft mod for MineClone2";

          homepage = "https://github.com/mineclone2-mods/modname_tooltip";

      };
    };

    "mineclone2-mods"."void_totem" = buildMinetestPackage rec {
      type = "mod";
      pname = "void_totem";
      version = "1.3";
      src = fetchFromContentDB {
        author = "mineclone2-mods";
        technicalName = "void_totem";
        release = 12105;
        versionName = "1.3";
        sha256 = "1rfq2kq23bfwv8nnrcb00q9ha8ha1myrd0m0a7yd0lji4dcdv397";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."GPL-3.0-or-later" ];
        description = "A totem that prevents you from dying in the void.";

          homepage = "https://github.com/mineclone2-mods/void_totem";

      };
    };

    "missingtextureman101"."ben_randomizer" = buildMinetestPackage rec {
      type = "mod";
      pname = "ben_randomizer";
      version = "Initial";
      src = fetchFromContentDB {
        author = "missingtextureman101";
        technicalName = "ben_randomizer";
        release = 11472;
        versionName = "Initial";
        sha256 = "0sgzzicjsla1a0f4qgqf0dq9qazd0inpir6nx10753fdm7mvdl1j";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A game agnostic node-drop randomizer";

      };
    };

    "missingtextureman101"."bens_gear" = buildMinetestPackage rec {
      type = "mod";
      pname = "bens_gear";
      version = "2022-08-06";
      src = fetchFromContentDB {
        author = "missingtextureman101";
        technicalName = "bens_gear";
        release = 13075;
        versionName = "2022-08-06";
        sha256 = "10wa1rh4qs6s5zvv80sxn6apb1c46njl5q35q83b4c6rak8d4sk6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Attach tool parts to create new tools and add a whole new layer of strategy to your tool crafting!";

          homepage = "https://github.com/benjaminpants/bens_gear";

      };
    };

    "mixer"."glamorous_deaths" = buildMinetestPackage rec {
      type = "mod";
      pname = "glamorous_deaths";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "mixer";
        technicalName = "glamorous_deaths";
        release = 13517;
        versionName = "1.1.0";
        sha256 = "090d9blxzsmh5j1phspwx2almlmihb1s3aakb13ad8m3655k1l76";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Announce player demise via server-wide death messages";

      };
    };

    "mobilex1122"."ultra_colors" = buildMinetestPackage rec {
      type = "mod";
      pname = "ultra_colors";
      version = "ultra_colors_version_beta_2";
      src = fetchFromContentDB {
        author = "mobilex1122";
        technicalName = "ultra_colors";
        release = 6507;
        versionName = "ultra colors version beta 2";
        sha256 = "00781aqay0z238zrf1nyvchhmnyl2wiqv9dk9j429p3viqjda2r5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "mod with super bright colors blocks";

          homepage = "https://mobilex1122.github.io/ultracolors/index.html";

      };
    };

    "mooD_Slayer"."ksurvive" = buildMinetestPackage rec {
      type = "game";
      pname = "ksurvive";
      version = "0.0.7_-__Nobelisk_";
      src = fetchFromContentDB {
        author = "mooD_Slayer";
        technicalName = "ksurvive";
        release = 10346;
        versionName = "0.0.7 - 'Nobelisk'";
        sha256 = "1s3if3zbrnf8darasr6swm3sm5pkglhzakfbm0lwrj3f3dhpvjxd";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A game that changes much of MTG's gameplay.";

      };
    };

    "mooD_Slayer"."ksurvive2" = buildMinetestPackage rec {
      type = "game";
      pname = "ksurvive2";
      version = "v0.1.2";
      src = fetchFromContentDB {
        author = "mooD_Slayer";
        technicalName = "ksurvive2";
        release = 9524;
        versionName = "v0.1.2";
        sha256 = "0bmps3fyvyyyg7mf3xiny6w4rd9n7pzgbg647zgdyljympfhy804";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A game built 100% from scratch, including code, textures and sounds.";

      };
    };

    "mooD_Slayer"."xenozapper" = buildMinetestPackage rec {
      type = "mod";
      pname = "xenozapper";
      version = "0.9.1.2_-_Prerelease_Additions";
      src = fetchFromContentDB {
        author = "mooD_Slayer";
        technicalName = "xenozapper";
        release = 11069;
        versionName = "0.9.1.2 - Prerelease Additions";
        sha256 = "0l6qdavksfpsyzq0i202yln31i50bscymzxkpzxibimkhay1kw5k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "The Xeno-Zapper is an electroshock self-defense weapon used in self-defense against hostile alien fauna within melee range.";

      };
    };

    "mooshidungii"."insane_crafts" = buildMinetestPackage rec {
      type = "mod";
      pname = "insane_crafts";
      version = "Unknown_update_error_fix";
      src = fetchFromContentDB {
        author = "mooshidungii";
        technicalName = "insane_crafts";
        release = 13671;
        versionName = "Unknown update error fix";
        sha256 = "0xr1hcm31b7c1x4cl2f4rksadq2a0vnzhwfla21zd0ryfkqicsfd";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds special crafting recipies";

      };
    };

    "mt-mods"."abriflame" = buildMinetestPackage rec {
      type = "mod";
      pname = "abriflame";
      version = "2022-09-08";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "abriflame";
        release = 13756;
        versionName = "2022-09-08";
        sha256 = "12gb2ar3jlq36qfhm9jaxkh2iihzry0dj65dyb810z70l5li3kdx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds coloured fire through use of fire starter tool.";

      };
    };

    "mt-mods"."abriglass" = buildMinetestPackage rec {
      type = "mod";
      pname = "abriglass";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "abriglass";
        release = 14318;
        versionName = "2022-10-12";
        sha256 = "18nrwbw6rhli7kkwrlky6f2lvzyc822agqx9zi7nsp31290hric0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds coloured glass, patterned stained glass, glass lights and one way windows.";

      };
    };

    "mt-mods"."abripanes" = buildMinetestPackage rec {
      type = "mod";
      pname = "abripanes";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "abripanes";
        release = 13701;
        versionName = "2022-09-05";
        sha256 = "1l8hyvm3vwf8jwv4jp4l8pmq38mmnga6hkh2smbadn4gglzs96js";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds faintly glowing coloured glass panes which can be used for stained glass windows or for gentle lighting.";

      };
    };

    "mt-mods"."abritorch" = buildMinetestPackage rec {
      type = "mod";
      pname = "abritorch";
      version = "2022-09-08";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "abritorch";
        release = 13755;
        versionName = "2022-09-08";
        sha256 = "0nym7rb0bh6ahm8j22hz819r2ivlz476gs622f3cy4p65l2l0ahq";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "multicolored torches";

      };
    };

    "mt-mods"."beerchat" = buildMinetestPackage rec {
      type = "mod";
      pname = "beerchat";
      version = "2022-09-29";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "beerchat";
        release = 14096;
        versionName = "2022-09-29";
        sha256 = "1bqgs8y4ax63fj00hasfg14n0carz6xn8k0k2bwlamc2dg1p6yxp";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "standalone chat channel mod";

          homepage = "https://github.com/mt-mods/beerchat/";

      };
    };

    "mt-mods"."blox" = buildMinetestPackage rec {
      type = "mod";
      pname = "blox";
      version = "2022-01-23";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "blox";
        release = 10781;
        versionName = "2022-01-23";
        sha256 = "0kw1adc8lhdr1kcz4rd1fhd45dw8r0yz607fkv2r5qvva08rjbjk";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds lots of differently colored and textured blocks to Minetest.";

      };
    };

    "mt-mods"."body_pillow" = buildMinetestPackage rec {
      type = "mod";
      pname = "body_pillow";
      version = "1.0";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "body_pillow";
        release = 12149;
        versionName = "1.0";
        sha256 = "03i40qi1dyj7ig9sg6d6klb6m4jpw5xmh8pmv56s98lh9cnj1rak";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "adds body pillows";

      };
    };

    "mt-mods"."catcommands" = buildMinetestPackage rec {
      type = "mod";
      pname = "catcommands";
      version = "1.0";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "catcommands";
        release = 12146;
        versionName = "1.0";
        sha256 = "11zfki22q8g9p6v0qvrcwyhlplb13bqn53qkxsxpjrmfkhrix4ag";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "adds some useful commands for servers";

      };
    };

    "mt-mods"."illumination" = buildMinetestPackage rec {
      type = "mod";
      pname = "illumination";
      version = "2022-09-07";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "illumination";
        release = 13745;
        versionName = "2022-09-07";
        sha256 = "181lq0sdz0zfwg9l5hwiw286h34q464f0dhyvlgj72zq2p5r6bl8";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Causes players to emit light while holding any luminescent item.";

      };
    };

    "mt-mods"."one_for_all" = buildMinetestPackage rec {
      type = "mod";
      pname = "one_for_all";
      version = "1.0";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "one_for_all";
        release = 12148;
        versionName = "1.0";
        sha256 = "1il4a1563kvyq0r71j47n25rbc16zpyyk44z0h9k9cs6014nz7lx";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "bans all players if one dies";

      };
    };

    "mt-mods"."prefab" = buildMinetestPackage rec {
      type = "mod";
      pname = "prefab";
      version = "2022-03-02";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "prefab";
        release = 11474;
        versionName = "2022-03-02";
        sha256 = "0f85drlv0hww1j7yajijn8d535l9wymam058g9ra955bzp7w2dg2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "Adds pre-fabricated concrete elements.";

      };
    };

    "mt-mods"."steel" = buildMinetestPackage rec {
      type = "mod";
      pname = "steel";
      version = "2022-04-27";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "steel";
        release = 11986;
        versionName = "2022-04-27";
        sha256 = "1cq6b7jn6vwcrqs0b8m6qzqzaxc810vkc54fsb8p0npq6nf99dfh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-2.0-or-later" ];
        description = "Adds a range of steel materials that are recyclable.";

      };
    };

    "mt-mods"."technic_plus" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_plus";
      version = "1.2.2";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "technic_plus";
        release = 9520;
        versionName = "1.2.2";
        sha256 = "08zwh4jbzqxhllfhi99wyqlnvc2gp5ck2bz9m5bj1pjbr2g2m2n6";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Technic fork with focus on features and stability";

          homepage = "https://github.com/mt-mods/technic/blob/master/README.md";

      };
    };

    "mt-mods"."technic_plus_beta" = buildMinetestPackage rec {
      type = "mod";
      pname = "technic_plus_beta";
      version = "2022-08-05";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "technic_plus_beta";
        release = 13063;
        versionName = "2022-08-05";
        sha256 = "1i3kfhr3wsypgnjx0z1rig0l8cx2z3c9ysssyf3h7arms77imvhk";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "The technic modpack extends the Minetest game with many new elements, mainly constructable machines and tools.";

      };
    };

    "mt-mods"."telemosaic" = buildMinetestPackage rec {
      type = "mod";
      pname = "telemosaic";
      version = "1.0";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "telemosaic";
        release = 13107;
        versionName = "1.0";
        sha256 = "1lwbqszg3r2pzi0n3prmg5qwkv44cmm0k8nhyvn0djm0gahz26my";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A Minetest mod for user-generated teleportation pads.";

      };
    };

    "mt-mods"."travelnet" = buildMinetestPackage rec {
      type = "mod";
      pname = "travelnet";
      version = "3.3.1";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "travelnet";
        release = 8497;
        versionName = "3.3.1";
        sha256 = "1xhnnh1ll968ydcigdr9wibzp9ha2xali526mh5h06rq9z29vb4y";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."GPL-3.0-only" ];
        description = "Network of teleporter-boxes that allows easy travelling to other boxes on the same network.";

      };
    };

    "mt-mods"."wooden_bucket" = buildMinetestPackage rec {
      type = "mod";
      pname = "wooden_bucket";
      version = "2022-05-07";
      src = fetchFromContentDB {
        author = "mt-mods";
        technicalName = "wooden_bucket";
        release = 12166;
        versionName = "2022-05-07";
        sha256 = "1l6m1cv8yb8gzflx4jkamswc7mbd0629pwz09cjibbkf93gid00s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "adds wooden buckets";

      };
    };

    "mzs.112000"."morebiomes" = buildMinetestPackage rec {
      type = "mod";
      pname = "morebiomes";
      version = "2021-11-08";
      src = fetchFromContentDB {
        author = "mzs.112000";
        technicalName = "morebiomes";
        release = 9637;
        versionName = "2021-11-08";
        sha256 = "095f98hi5c3qgywa0cj2q50ywh99rmkynz43jpv5y16hfkzbci8q";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A simple mod adding a few biomes to Minetest Game";

      };
    };

    "mzs.112000"."wildflower_fields" = buildMinetestPackage rec {
      type = "mod";
      pname = "wildflower_fields";
      version = "2021-11-08";
      src = fetchFromContentDB {
        author = "mzs.112000";
        technicalName = "wildflower_fields";
        release = 9638;
        versionName = "2021-11-08";
        sha256 = "1l8b4l5r73mlb3hng6ms2c0fb2gam8b7ngvh6rgl48fmj92wqj1h";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds a wildflower field biome to Minetest Game.";

      };
    };

    "nac"."itemshelf" = buildMinetestPackage rec {
      type = "mod";
      pname = "itemshelf";
      version = "itemshelf__Fork_";
      src = fetchFromContentDB {
        author = "nac";
        technicalName = "itemshelf";
        release = 7805;
        versionName = "itemshelf (Fork)";
        sha256 = "11275vr9rr7km9q2vx2fqrf568vldg25v3sdqbirspyi2h2515gd";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Generic item shelf with 3D items on display";

      };
    };

    "narrnika"."factory_bridges" = buildMinetestPackage rec {
      type = "mod";
      pname = "factory_bridges";
      version = "2019-07-02";
      src = fetchFromContentDB {
        author = "narrnika";
        technicalName = "factory_bridges";
        release = 1623;
        versionName = "2019-07-02";
        sha256 = "0i4w8xxz3c3h5k2bm243vcp116j7y09d4m6q5l442cap2kf466xk";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds a steel bridges, railings and stairs in Minetest.";

      };
    };

    "neko259"."telegram" = buildMinetestPackage rec {
      type = "mod";
      pname = "telegram";
      version = "2019-10-12";
      src = fetchFromContentDB {
        author = "neko259";
        technicalName = "telegram";
        release = 6870;
        versionName = "2019-10-12";
        sha256 = "1hjm7ggsixnl0f5652r9zj9gcqs2fmc0129qi3b9sn7z7a7bxy4p";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "Integration with telegram messenger chat";

      };
    };

    "nekobit"."real_stamina" = buildMinetestPackage rec {
      type = "mod";
      pname = "real_stamina";
      version = "release";
      src = fetchFromContentDB {
        author = "nekobit";
        technicalName = "real_stamina";
        release = 13469;
        versionName = "release";
        sha256 = "10ycvllg23w5qxw8g5xzjwq8jq5jvxskzys86niin189akzvh0sb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-or-later" ];
        description = "Adds stamina and sprinting (no hunger!)";

      };
    };

    "nemokitty9"."kitores" = buildMinetestPackage rec {
      type = "mod";
      pname = "kitores";
      version = "launch_version_fixes";
      src = fetchFromContentDB {
        author = "nemokitty9";
        technicalName = "kitores";
        release = 7726;
        versionName = "launch version fixes";
        sha256 = "0i6d36fb74n7dlwlsv4x6kriccf5ljih71wm1x7a5n7k22f5g7xx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."Zlib" ];
        description = "Nemokitty9's own ore pack. Includes Tools!";

      };
    };

    "nemokitty9"."nk9mpd" = buildMinetestPackage rec {
      type = "mod";
      pname = "nk9mpd";
      version = "Nemokitty9_s_Music_Pack_v002";
      src = fetchFromContentDB {
        author = "nemokitty9";
        technicalName = "nk9mpd";
        release = 6971;
        versionName = "Nemokitty9's Music Pack v002";
        sha256 = "00skxx7qa913bpx8i4frn6h6bpkaxvkjpqaadd4bvrrdr679iav8";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Music Pack Containing Songs From Audiotool made by Nemokitty9 and other various artists from audiotool.";

      };
    };

    "nitro2012pl"."mesecons_soundblock" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecons_soundblock";
      version = "1.1";
      src = fetchFromContentDB {
        author = "nitro2012pl";
        technicalName = "mesecons_soundblock";
        release = 5149;
        versionName = "1.1";
        sha256 = "0aci3abb3nvjw08gy9d4sz18qva4b1dhkskhmzyi9x6cx3746vmh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" ];
        description = "Mesecons Soundblock";

      };
    };

    "niwla23"."batch_screwdriver" = buildMinetestPackage rec {
      type = "mod";
      pname = "batch_screwdriver";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "batch_screwdriver";
        release = 3179;
        versionName = "1.0.0";
        sha256 = "0ibwsxn4mkpcmks2qhkanngjrzmh5y7zcanh57x0y8ndzyw8pzm9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "With this you can rotate all nodes in a row at once";

      };
    };

    "niwla23"."bubbles" = buildMinetestPackage rec {
      type = "mod";
      pname = "bubbles";
      version = "Rolling";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "bubbles";
        release = 1083;
        versionName = "Rolling";
        sha256 = "1mfl8fda5wr88ydx1hkmmvv2fd1099p2y6dvv9rgy9zyc0d6am3d";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds bubble machines";

      };
    };

    "niwla23"."daymachine" = buildMinetestPackage rec {
      type = "mod";
      pname = "daymachine";
      version = "2.0_-_craftable";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "daymachine";
        release = 1776;
        versionName = "2.0 - craftable";
        sha256 = "0604l2dcawi94hfpm1fr2lxgz8cchrqs9c6apy6a6w497zpzl3d0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Make day by using one mese crystal!";

      };
    };

    "niwla23"."fireworks_redo" = buildMinetestPackage rec {
      type = "mod";
      pname = "fireworks_redo";
      version = "2.0.3.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "fireworks_redo";
        release = 4050;
        versionName = "2.0.3.1";
        sha256 = "144g7wn15cl5ap5vacfcs6xxnchd9qgcs3f69ah6yycayiq4vfa9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds some better looking fireworks";

      };
    };

    "niwla23"."killbutton" = buildMinetestPackage rec {
      type = "mod";
      pname = "killbutton";
      version = "1.1.0_-_changed_description";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "killbutton";
        release = 1789;
        versionName = "1.1.0 - changed description";
        sha256 = "02dhc8asahh5qqicwy9drwic705vpcgafrs5q42ffz6yf7wgy7g3";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Allows you to kill yourself from the UI";

      };
    };

    "niwla23"."lightdead" = buildMinetestPackage rec {
      type = "mod";
      pname = "lightdead";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "lightdead";
        release = 1096;
        versionName = "1.0.0";
        sha256 = "1rflly7155mwcgcrkyzrs91lk7a34xamjc7x13gy7dl9nzx1382c";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Spawns a lightning over the dedposition of a player when he dies";

      };
    };

    "niwla23"."parkour" = buildMinetestPackage rec {
      type = "mod";
      pname = "parkour";
      version = "1.0.2";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "parkour";
        release = 2165;
        versionName = "1.0.2";
        sha256 = "0d745qrnqxvcfd8vwmzj5ssym5k31lnms89aiq887vy7lcryb25z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Adds checkpoints and endpoints for parkours";

      };
    };

    "niwla23"."playerinfo" = buildMinetestPackage rec {
      type = "mod";
      pname = "playerinfo";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "playerinfo";
        release = 1429;
        versionName = "1.0.0";
        sha256 = "0qhsp5j4my8v1hwx82yj8ap3ip3vppjgf3arl65imzjw9sk5x3w4";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Players can set their info and others can see it";

      };
    };

    "niwla23"."rename" = buildMinetestPackage rec {
      type = "mod";
      pname = "rename";
      version = "Version_0.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "rename";
        release = 921;
        versionName = "Version 0.1";
        sha256 = "1dhf3c99jr2pw77h3hpqmynvnw6id46vxza5i137nxqb4ia6vd26";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This Mod can rename Items";

      };
    };

    "niwla23"."retro" = buildMinetestPackage rec {
      type = "txp";
      pname = "retro";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "retro";
        release = 1555;
        versionName = "0.0.1";
        sha256 = "05qn5lxdchy6ssdnscl100cz6xys1w41q3k6jbawvkswa0xjfm5d";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "A pack for those who like the first mt textures!";

      };
    };

    "niwla23"."runorfall" = buildMinetestPackage rec {
      type = "game";
      pname = "runorfall";
      version = "remove_dependencie";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "runorfall";
        release = 4155;
        versionName = "remove dependencie";
        sha256 = "0n2p994n6mhl1p71c1brc7qb6wvbxcmj0b3f0743j9gakxqzq6jp";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-3.0" ];
        description = "Like TNT run. Run on a platform as blocks fall down behind you, last one to fall down wins!";

      };
    };

    "niwla23"."shortnames" = buildMinetestPackage rec {
      type = "mod";
      pname = "shortnames";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "shortnames";
        release = 1166;
        versionName = "1.0.0";
        sha256 = "0wdahfdfa63clgfss72arja1rczkyzh2d07raskqrgw66ihmrsxv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds short number aliases to some nodes like in MC";

      };
    };

    "niwla23"."simple" = buildMinetestPackage rec {
      type = "txp";
      pname = "simple";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "simple";
        release = 1363;
        versionName = "0.0.1";
        sha256 = "0r69xajd0aqsdw4bqx61jspd6a7bsn7grjnkab54a1vr45zs8rng";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC0-1.0" ];
        description = "A simple texturepack";

      };
    };

    "niwla23"."spikes" = buildMinetestPackage rec {
      type = "mod";
      pname = "spikes";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "spikes";
        release = 2146;
        versionName = "1.0.1";
        sha256 = "0v5kwx5lrh3kq7zvb8647swnwsshb0ci7vx9fijapw86b7yb289q";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds wooden, steel and titanium spikes.";

      };
    };

    "niwla23"."troll" = buildMinetestPackage rec {
      type = "mod";
      pname = "troll";
      version = "0.0.3";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "troll";
        release = 1548;
        versionName = "0.0.3";
        sha256 = "12az1gy5x0sisn20bnpsvhs2d2gz4kk38w9yphz1wml4y0xl9xd5";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "This adds a lot of commands to troll! Its ver WIP";

      };
    };

    "niwla23"."upgrades" = buildMinetestPackage rec {
      type = "mod";
      pname = "upgrades";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "upgrades";
        release = 2144;
        versionName = "1.0.0";
        sha256 = "1sxwwjhiwm5w2sravls7m3f96z6jsdlj6g8a2zic9gaz9ksbha05";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds effects to players for a short time";

      };
    };

    "niwla23"."visible_sneak" = buildMinetestPackage rec {
      type = "mod";
      pname = "visible_sneak";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "visible_sneak";
        release = 1413;
        versionName = "1.0.0";
        sha256 = "0xzbmql1zb7kzg4ds3g4dplm6772diw3z4j66fqs9gbgkpk18izh";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod to make sneaking visible. The player gets smaller on sneak and the viewpoint is lower.";

      };
    };

    "niwla23"."vote_day" = buildMinetestPackage rec {
      type = "mod";
      pname = "vote_day";
      version = "0.0.1";
      src = fetchFromContentDB {
        author = "niwla23";
        technicalName = "vote_day";
        release = 1350;
        versionName = "0.0.1";
        sha256 = "1l1dz7h5rq38acw9fl1ik7vz6va5srykw80s1wx0n9qbsz8fwwkc";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This adds a command to vote for making day!";

      };
    };

    "nixnoxus"."moreinfo" = buildMinetestPackage rec {
      type = "mod";
      pname = "moreinfo";
      version = "moreinfo-1.2.0";
      src = fetchFromContentDB {
        author = "nixnoxus";
        technicalName = "moreinfo";
        release = 9269;
        versionName = "moreinfo-1.2.0";
        sha256 = "0mm5jf9d9fbhl9gmnjrv41kylj2nl938pz9hyylxzh4v3k3biv7v";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" spdx."LGPL-2.1-or-later" ];
        description = "Adds various infomation";

      };
    };

    "nolombic"."more_up_packs" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_up_packs";
      version = "R5";
      src = fetchFromContentDB {
        author = "nolombic";
        technicalName = "more_up_packs";
        release = 4743;
        versionName = "R5";
        sha256 = "0hnq7h0qfaqgsnksb607mai0kmhbrjhqkpb1rx09swh1xsb65y5l";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Upgrade your upgrade packs so you can have even higher stats!";

      };
    };

    "nonchip"."worstblockgame" = buildMinetestPackage rec {
      type = "game";
      pname = "worstblockgame";
      version = "0.2.0";
      src = fetchFromContentDB {
        author = "nonchip";
        technicalName = "worstblockgame";
        release = 5209;
        versionName = "0.2.0";
        sha256 = "1wil1r88pf5379lsmbp1q2ls7547vp19i3d653h0dkzm6pygv586";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "game including a wide (and growing) variety of mods, both ours and 3rd party";

      };
    };

    "nri"."nitro_digger" = buildMinetestPackage rec {
      type = "mod";
      pname = "nitro_digger";
      version = "Nitro_Digger";
      src = fetchFromContentDB {
        author = "nri";
        technicalName = "nitro_digger";
        release = 2012;
        versionName = "Nitro Digger";
        sha256 = "0mwrbdiix1cjsazfgrd5fq92nv4plir9w472pjskdswqw1grxign";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Adds a tool that removes nodes quickly.";

      };
    };

    "ntnsndr"."modpol" = buildMinetestPackage rec {
      type = "mod";
      pname = "modpol";
      version = "2022-08-27";
      src = fetchFromContentDB {
        author = "ntnsndr";
        technicalName = "modpol";
        release = 13575;
        versionName = "2022-08-27";
        sha256 = "0kf7cfsbbpayhmcvg5xxggq6flxhpv478874l7vh8x7nb7nsv90n";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Framework that enables diverse governance processes";

      };
    };

    "octacian"."chat3" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat3";
      version = "2019-02-08";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "chat3";
        release = 957;
        versionName = "2019-02-08";
        sha256 = "1xab2j23vxprjmjrrx2bcp8xv9rpr6xi48iw2vm08hgxq8hhxmfw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Makes chat on a populated server much easier to understand and keep up with.";

      };
    };

    "octacian"."hands" = buildMinetestPackage rec {
      type = "mod";
      pname = "hands";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "hands";
        release = 698;
        versionName = "1.0.0";
        sha256 = "10djj53byzbhk0zjhdd94cnw2480wiiqq0zn25mzla5dgjljg0hb";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Demonstration of Minetest's capability to dynamically change the player hand.";

      };
    };

    "octacian"."hardtrees" = buildMinetestPackage rec {
      type = "mod";
      pname = "hardtrees";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "hardtrees";
        release = 697;
        versionName = "1.0.0";
        sha256 = "1ck717gdbyb9sy5gim48lx4kbrybdxdng1r6vzwh67zbzjmhz2hp";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Require tools to break trees and introduce beginner-tier rock tools.";

      };
    };

    "octacian"."multihome" = buildMinetestPackage rec {
      type = "mod";
      pname = "multihome";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "multihome";
        release = 778;
        versionName = "1.0.0";
        sha256 = "137cd455hs4mx0a4nhqj5vyywylcqcyddhgmkca26fnhnm3sxrk2";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Allows setting a configurable number of home points in a world.";

      };
    };

    "octacian"."televator" = buildMinetestPackage rec {
      type = "mod";
      pname = "televator";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "televator";
        release = 695;
        versionName = "1.0.0";
        sha256 = "10gi69bp6rn42366d7if9nyk9z7a1iih7zpybq6hgg14hdgvc0rv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Televator allows you to create simple elevators in your worlds that work incredibly fast amidst lag and are relatively inexpensive to make.";

      };
    };

    "octacian"."tell" = buildMinetestPackage rec {
      type = "mod";
      pname = "tell";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "octacian";
        technicalName = "tell";
        release = 696;
        versionName = "1.0.0";
        sha256 = "13jqg88h8vv82d39pky5hm56imnl1qrzi37y1c3p4bn0qzrhwnr4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Message offline players";

      };
    };

    "orwell"."advtrains" = buildMinetestPackage rec {
      type = "mod";
      pname = "advtrains";
      version = "v2.4.1";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "advtrains";
        release = 9737;
        versionName = "v2.4.1";
        sha256 = "0rkayd48rvbwpmj8bibndw70a5r1g0qczv46ga4h3fswsygpfd3x";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "Adds good-looking, realistic trains with realistic rails. !! When updating, install basic_trains !!";

          homepage = "http://advtrains.de/";

      };
    };

    "orwell"."atchat" = buildMinetestPackage rec {
      type = "mod";
      pname = "atchat";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "atchat";
        release = 440;
        versionName = "v1.0";
        sha256 = "1y23x6j6l17rj3h7z7bf5prpis9ibfhjr1vfwvcrghbjq52xdb6k";
      };
      meta = src.meta // {
        license = [ spdx."BSD-2-Clause-FreeBSD" ];
        description = "Adds an alternative Private Message (PM) system";

      };
    };

    "orwell"."basic_trains" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_trains";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "basic_trains";
        release = 7737;
        versionName = "v1.0.1";
        sha256 = "1jj33mb95wivj4z18h664xhxmi79zxqljnq4jyfhddzgajww3j6b";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC-BY-SA-3.0" ];
        description = "Collection of basic trains for the Advanced Trains mod. Formerly included in main advtrains modpack (until 2.3.0)";

          homepage = "http://advtrains.de/wiki/doku.php?id=usage:trains:basic_trains";

      };
    };

    "orwell"."engrave" = buildMinetestPackage rec {
      type = "mod";
      pname = "engrave";
      version = "1.1";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "engrave";
        release = 194;
        versionName = "1.1";
        sha256 = "0n2vniaj4w495yq2f0daj611g7hznh7j788mwdcj746r8j49d9sf";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds an \"Engraving Table\" that allows to change the description of items";

      };
    };

    "orwell"."incrediblemaze" = buildMinetestPackage rec {
      type = "mod";
      pname = "incrediblemaze";
      version = "v1.2";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "incrediblemaze";
        release = 9739;
        versionName = "v1.2";
        sha256 = "0mp29nfwj3i7xlfg3bz4a8gy7g63grzv5287rh0gb1bj58kf3i6q";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This mod is a maze generator";

      };
    };

    "orwell"."mpd" = buildMinetestPackage rec {
      type = "mod";
      pname = "mpd";
      version = "1.1.3";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "mpd";
        release = 7546;
        versionName = "1.1.3";
        sha256 = "0w1xjgqyvbpqcfmq94i0iq833sg9rsmzr6kh62qy7pfgdddkabz5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" spdx."LGPL-2.1-only" ];
        description = "A background music mod";

      };
    };

    "orwell"."poshud" = buildMinetestPackage rec {
      type = "mod";
      pname = "poshud";
      version = "v1.1.2";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "poshud";
        release = 6981;
        versionName = "v1.1.2";
        sha256 = "0xqpbv1893k2isk1xpngvdjn875nlfwn9wdyn806y9k4kfq1bsgs";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Displays some information in the bottom-right corner of the screen.";

      };
    };

    "orwell"."unknownnode" = buildMinetestPackage rec {
      type = "mod";
      pname = "unknownnode";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "orwell";
        technicalName = "unknownnode";
        release = 437;
        versionName = "v1.0";
        sha256 = "1dhf9m73lwpxnqdjlzv3rxcq6f34xz7bk85h8c90ng6shad48s5b";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds a node that looks like an unknown node";

      };
    };

    "pampogokiraly"."cracked_castle" = buildMinetestPackage rec {
      type = "mod";
      pname = "cracked_castle";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "pampogokiraly";
        technicalName = "cracked_castle";
        release = 3770;
        versionName = "1.0.0";
        sha256 = "00fih7w380qbb8ifhrxd0arm01010gpxbmcim6k8aiwicb9y0w7y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Nodes to help you making an old broken castle!";

      };
    };

    "paramat"."flexrealm" = buildMinetestPackage rec {
      type = "mod";
      pname = "flexrealm";
      version = "2016-06-28";
      src = fetchFromContentDB {
        author = "paramat";
        technicalName = "flexrealm";
        release = 863;
        versionName = "2016-06-28";
        sha256 = "050sm4ggih3ncsj5p52xh0qsa0wgyv1gg7bp2dv94c0cv50ylabn";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."WTFPL" ];
        description = "Create worlds of varying shapes";

      };
    };

    "paramat"."mesecar" = buildMinetestPackage rec {
      type = "mod";
      pname = "mesecar";
      version = "2015-12-24";
      src = fetchFromContentDB {
        author = "paramat";
        technicalName = "mesecar";
        release = 864;
        versionName = "2015-12-24";
        sha256 = "0rwapqb6havv1rfy2n4wdw12kjfzyvp913igmbcl7yr8xrwx4q60";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Adds 4 styles of microcar: Car55, Nyancart, Mesecar and Oerkka.";

      };
    };

    "paramat"."snowdrift" = buildMinetestPackage rec {
      type = "mod";
      pname = "snowdrift";
      version = "2017-12-12";
      src = fetchFromContentDB {
        author = "paramat";
        technicalName = "snowdrift";
        release = 51;
        versionName = "2017-12-12";
        sha256 = "1gkxbz1z9r08al4p16jf2967sh2l09jj2h9qpvyignpxmz30ndzy";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Light-weight weather mod with snow, rain, and clouds.";

      };
    };

    "paramat"."watershed" = buildMinetestPackage rec {
      type = "mod";
      pname = "watershed";
      version = "2017-04-15";
      src = fetchFromContentDB {
        author = "paramat";
        technicalName = "watershed";
        release = 862;
        versionName = "2017-04-15";
        sha256 = "0p0gqarb2is82j5yvl98dwjpxln296qi52r7lwqwaa195havyg2x";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "A river / mountain range mapgen";

      };
    };

    "pauldpickell"."colorbrewer" = buildMinetestPackage rec {
      type = "mod";
      pname = "colorbrewer";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "pauldpickell";
        technicalName = "colorbrewer";
        release = 9706;
        versionName = "1.0.0";
        sha256 = "0wmd99590qass16i49sa5msmv2198cyh5bjkm77jd199apnc8j8s";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" ];
        description = "8-bit ColorBrewer palettes texture pack";

      };
    };

    "philipbenr"."castle" = buildMinetestPackage rec {
      type = "mod";
      pname = "castle";
      version = "g87e9fa2";
      src = fetchFromContentDB {
        author = "philipbenr";
        technicalName = "castle";
        release = 930;
        versionName = "g87e9fa2";
        sha256 = "1k40zrlm3fhipg8ydvwxzf0hk56w337816f1p74mvkk07xd80w66";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This is a modpack all about creating castles and castle dungeons.";

      };
    };

    "philipmi"."regrowing_fruits" = buildMinetestPackage rec {
      type = "mod";
      pname = "regrowing_fruits";
      version = "2022-03-26";
      src = fetchFromContentDB {
        author = "philipmi";
        technicalName = "regrowing_fruits";
        release = 11665;
        versionName = "2022-03-26";
        sha256 = "0bdwv2yi8gg2dzv1nxrsc3qkfgnqhz6idd4z6dv1aa2li6qa5fp1";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Fruits on trees from various mods will regrow.";

      };
    };

    "pl608"."more_fuels" = buildMinetestPackage rec {
      type = "mod";
      pname = "more_fuels";
      version = "2022-01-13";
      src = fetchFromContentDB {
        author = "pl608";
        technicalName = "more_fuels";
        release = 10598;
        versionName = "2022-01-13";
        sha256 = "1avj6hdyvwdk7n1fxmh3md9vwk822mb6jhagwi1bx210wv9md556";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds a few new fuels for use in furnaces such as gasoline and petrolium";

      };
    };

    "pl608"."random_stuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "random_stuff";
      version = "1.1.0";
      src = fetchFromContentDB {
        author = "pl608";
        technicalName = "random_stuff";
        release = 14514;
        versionName = "1.1.0";
        sha256 = "155s5hfwcmbmqxp8lzma8phkzfm1r0k7m30a1ykj0lziginhmzfv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A library that adds well... Random Stuff";

      };
    };

    "playduin"."bed_jumping" = buildMinetestPackage rec {
      type = "mod";
      pname = "bed_jumping";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "playduin";
        technicalName = "bed_jumping";
        release = 11195;
        versionName = "1.0.0";
        sha256 = "05y5qhifqkhhrg2h1w2a5f07wnpabyrc6bqisl0kvcpcfj9b6b1n";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "You may jump on the bed";

      };
    };

    "playduin"."fast_build_tool" = buildMinetestPackage rec {
      type = "mod";
      pname = "fast_build_tool";
      version = "0.1.0";
      src = fetchFromContentDB {
        author = "playduin";
        technicalName = "fast_build_tool";
        release = 8242;
        versionName = "0.1.0";
        sha256 = "1ylgjyag8ip6y0p1gpg1wswq0ids40f2xc810w7fqipy4s34gdyr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Tool for fast box building";

      };
    };

    "prestidigitator"."prestibags" = buildMinetestPackage rec {
      type = "mod";
      pname = "prestibags";
      version = "2013-03-07";
      src = fetchFromContentDB {
        author = "prestidigitator";
        technicalName = "prestibags";
        release = 2156;
        versionName = "2013-03-07";
        sha256 = "11jz6dqal6ld4kr2bzjcww6gcqn97mbk1px00vsa8mdk3nspjjgp";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Prestibags are simple bags that act like chests you can pick up.";

      };
    };

    "qPexLegendary"."localchat" = buildMinetestPackage rec {
      type = "mod";
      pname = "localchat";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "qPexLegendary";
        technicalName = "localchat";
        release = 5630;
        versionName = "1.0.0";
        sha256 = "15hf0s4phrpfiaws69xa6i807r2m4pi2c83hpba4va9zimmsv1lb";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Adds local and global chat";

      };
    };

    "qawsedrftgzh"."ski" = buildMinetestPackage rec {
      type = "mod";
      pname = "ski";
      version = "2021-06-20";
      src = fetchFromContentDB {
        author = "qawsedrftgzh";
        technicalName = "ski";
        release = 14461;
        versionName = "2021-06-20";
        sha256 = "06c1bh1g6nd86cw633qlw34rcyfnbzn11iky642y9n7g18zvsm13";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Go skiing, and have fun, and save your winter holidys";

      };
    };

    "rael5"."nether_mobs" = buildMinetestPackage rec {
      type = "mod";
      pname = "nether_mobs";
      version = "2019-12-21";
      src = fetchFromContentDB {
        author = "rael5";
        technicalName = "nether_mobs";
        release = 6364;
        versionName = "2019-12-21";
        sha256 = "0qhklh4wy9wcz0k5yz4y44vjs25zm5cmawgpcvgwzaj2il39av0f";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add monsters and dragons to your nether world.";

      };
    };

    "random_geek"."auroras" = buildMinetestPackage rec {
      type = "mod";
      pname = "auroras";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "random_geek";
        technicalName = "auroras";
        release = 7332;
        versionName = "v1.0.1";
        sha256 = "1324gv88s2pbd773m2vbv6yhdhz1idm3f0agj75vk7g66d9kzwnp";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Adds auroras (northern/southern lights) at night in cold places.";

      };
    };

    "random_geek"."cg_plus" = buildMinetestPackage rec {
      type = "mod";
      pname = "cg_plus";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "random_geek";
        technicalName = "cg_plus";
        release = 1214;
        versionName = "v1.0.1";
        sha256 = "0zs0b4wg1830kmizz5hxp3ysvr4qy9f65ag6ajvzhcgfg69fg19q";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Adds an intuitive and full-featured craft guide with auto-crafting to the player's inventory.";

      };
    };

    "random_geek"."meshport" = buildMinetestPackage rec {
      type = "mod";
      pname = "meshport";
      version = "v0.2.2";
      src = fetchFromContentDB {
        author = "random_geek";
        technicalName = "meshport";
        release = 10380;
        versionName = "v0.2.2";
        sha256 = "00gam8dipsjiwrff62gsbfm07hp010gjg41xmc7n0ka6j19r10vw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."LGPL-3.0-only" ];
        description = "Easily export areas in Minetest to meshes for 3D rendering.";

      };
    };

    "random_geek"."morelights" = buildMinetestPackage rec {
      type = "mod";
      pname = "morelights";
      version = "v1.3.0";
      src = fetchFromContentDB {
        author = "random_geek";
        technicalName = "morelights";
        release = 9580;
        versionName = "v1.3.0";
        sha256 = "0xcssqf056q8yf6nq48kirh5snibyfiibknm15z6ysshhwx3azki";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-3.0-only" ];
        description = "Provides flexible interior and exterior lighting options for different styles of builds.";

      };
    };

    "rdococ"."really_flat" = buildMinetestPackage rec {
      type = "mod";
      pname = "really_flat";
      version = "2022-02-03";
      src = fetchFromContentDB {
        author = "rdococ";
        technicalName = "really_flat";
        release = 11047;
        versionName = "2022-02-03";
        sha256 = "07hr772k082kh03mmpry3yvi06wk8m5hmhck1731jyagf1hy1sz3";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Generates superflat terrain in whatever material you choose.";

      };
    };

    "rdococ"."scriptblocks2" = buildMinetestPackage rec {
      type = "mod";
      pname = "scriptblocks2";
      version = "2022-08-02";
      src = fetchFromContentDB {
        author = "rdococ";
        technicalName = "scriptblocks2";
        release = 13013;
        versionName = "2022-08-02";
        sha256 = "1s4kxf083fmf8rqidm6kxj346gxvv6b4x49ahb57mkabh04b7c4x";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds nodes that can be used to build reusable programs.";

      };
    };

    "rdococ"."tone_bells" = buildMinetestPackage rec {
      type = "mod";
      pname = "tone_bells";
      version = "2022-04-19";
      src = fetchFromContentDB {
        author = "rdococ";
        technicalName = "tone_bells";
        release = 11887;
        versionName = "2022-04-19";
        sha256 = "05lp99gv1cq5cfds3bpnif1ib7fmxfw47i47lsjfxlyhwlf7zffv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A proof of concept alternative to note blocks for melodic exploration";

      };
    };

    "rheo"."action_queues" = buildMinetestPackage rec {
      type = "mod";
      pname = "action_queues";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "action_queues";
        release = 14321;
        versionName = "2022-10-12";
        sha256 = "0s0d32hrj3b7kb0mjvrkjp6xv14jkj8j4x0k88hig32ylaq7kjr5";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "library which adds a queue class and an API for queuing things for processing";

      };
    };

    "rheo"."bones" = buildMinetestPackage rec {
      type = "mod";
      pname = "bones";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "bones";
        release = 14322;
        versionName = "2022-10-12";
        sha256 = "1nz65whxi1vd1ixd9v5pmym1wz88wv7frqvnps2vcd35wri62cp6";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "the bones mod from minetest_game, but with updates to make them much more reliable";

      };
    };

    "rheo"."book_runner" = buildMinetestPackage rec {
      type = "mod";
      pname = "book_runner";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "book_runner";
        release = 14344;
        versionName = "2022-10-12";
        sha256 = "1kai5kn6jin4hnlxf83wba2fvq1kgkl7mcsfdsx38ascwjhi1lyh";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-4.0" ];
        description = "run a command and put the output in a book";

          homepage = "https://github.com/fluxionary/minetest-book_runner";

      };
    };

    "rheo"."boomstick" = buildMinetestPackage rec {
      type = "mod";
      pname = "boomstick";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "boomstick";
        release = 14323;
        versionName = "2022-10-12";
        sha256 = "0v789jh1mvizh3mp494jlzgb146f550kw64j089pm9mq12vb535n";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC0-1.0" ];
        description = "a tool for testing the behavior of tnt";

      };
    };

    "rheo"."bucket" = buildMinetestPackage rec {
      type = "mod";
      pname = "bucket";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "bucket";
        release = 14319;
        versionName = "2022-10-12";
        sha256 = "026wha4578r0dw498kgj6ypadcxlhgkx21s8avjziq27mfha4327";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "a bucket which functions like a normal tool.";

      };
    };

    "rheo"."builtin_overrides" = buildMinetestPackage rec {
      type = "mod";
      pname = "builtin_overrides";
      version = "2022-09-06";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "builtin_overrides";
        release = 13742;
        versionName = "2022-09-06";
        sha256 = "0y22bm7vrv1hypinja8ig9gbsfs54xdga8lbfbk83njp1zmhpk5p";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "minor QOL overrides for some builtin behaviors";

      };
    };

    "rheo"."craftsystem" = buildMinetestPackage rec {
      type = "mod";
      pname = "craftsystem";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "craftsystem";
        release = 14314;
        versionName = "2022-10-12";
        sha256 = "1aw1lv6c659kc6m86p1azqr3rmjykypfwm0dinhyx2lxby282rsq";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "API for craft registration which automatically deals w/ replacements";

      };
    };

    "rheo"."debuggery" = buildMinetestPackage rec {
      type = "mod";
      pname = "debuggery";
      version = "2022-10-16";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "debuggery";
        release = 14397;
        versionName = "2022-10-16";
        sha256 = "1x87pz4zjpdx4gd7r05hsn1mqnrqh7aifqxa4jjm8chqnxqca05c";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "debugging tools for server admins";

      };
    };

    "rheo"."digicolor" = buildMinetestPackage rec {
      type = "mod";
      pname = "digicolor";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "digicolor";
        release = 14324;
        versionName = "2022-10-12";
        sha256 = "1wr2p940k5nwvawd9r8v7g72891dii7k92d7hfh42482w90iwkam";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "node whose color can be set via digilines";

      };
    };

    "rheo"."futil" = buildMinetestPackage rec {
      type = "mod";
      pname = "futil";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "futil";
        release = 14470;
        versionName = "2022-10-19";
        sha256 = "1yxga6xbi1mv85fpbb35q5ksapvlwjib6v63xwbsacdybwakb1qz";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "flux's utility mod";

      };
    };

    "rheo"."hand_monoid" = buildMinetestPackage rec {
      type = "mod";
      pname = "hand_monoid";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "hand_monoid";
        release = 14330;
        versionName = "2022-10-12";
        sha256 = "19h5casjnj05kp6ijvv73g1fm3rzbpp41r905p8saw0fs1gcrqwq";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "monoid to manage changes to the player's hand";

      };
    };

    "rheo"."inventory_ores" = buildMinetestPackage rec {
      type = "mod";
      pname = "inventory_ores";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "inventory_ores";
        release = 14343;
        versionName = "2022-10-12";
        sha256 = "0vrn6vf40cis71yishw1d2wkq9j74i2bp4hs4ik7qnpx6xvdjchx";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-4.0" ];
        description = "shows where to find ores in an inventory manager.";

          homepage = "https://github.com/fluxionary/minetest-inventory_ores";

      };
    };

    "rheo"."item_magnet" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_magnet";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "item_magnet";
        release = 14325;
        versionName = "2022-10-12";
        sha256 = "0za6wgf5p733ng3xpfw317pnv713af0kp391960qvcalpwqrbyni";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC0-1.0" ];
        description = "An magnet for picking up items";

      };
    };

    "rheo"."mobs_balrog" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_balrog";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "mobs_balrog";
        release = 14315;
        versionName = "2022-10-12";
        sha256 = "1nxj1b25gbh4iwv2kjbqqhr255vgc3knfg6kmjm5ff745knbma2v";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "Adds balrogs.";

      };
    };

    "rheo"."mobs_mime" = buildMinetestPackage rec {
      type = "mod";
      pname = "mobs_mime";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "mobs_mime";
        release = 14327;
        versionName = "2022-10-12";
        sha256 = "0cl6s2hfmxd1486c23lzg7ya7ibfhf0avm3v99ay3zfhh8i5x5g1";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "Adds a monster mimicking its surrounding nodes.";

      };
    };

    "rheo"."modinfo" = buildMinetestPackage rec {
      type = "mod";
      pname = "modinfo";
      version = "2022-10-13";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "modinfo";
        release = 14362;
        versionName = "2022-10-13";
        sha256 = "10n4swa3ag6avs0q968qjyb3iilh2z64w0a38vlla5sky9srriys";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-4.0" ];
        description = "get info about the mods running on a server";

          homepage = "https://github.com/fluxionary/minetest-modinfo";

      };
    };

    "rheo"."name_monoid" = buildMinetestPackage rec {
      type = "mod";
      pname = "name_monoid";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "name_monoid";
        release = 13722;
        versionName = "2022-09-05";
        sha256 = "1h65g6jmnxpjw7bmifqp9447h6z36a0jvrpl2d07lgdvqi9fj0xv";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "player monoid for controlling the nametag";

      };
    };

    "rheo"."node_entity_queue" = buildMinetestPackage rec {
      type = "mod";
      pname = "node_entity_queue";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "node_entity_queue";
        release = 14317;
        versionName = "2022-10-12";
        sha256 = "1g946f1ix1xm3ws3yb2pmfz910zvddxwlm9vw6lzdfgx13ly1jx6";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "a queue for spreading out the generation of node entities over multiple server steps (smartshops, signs, itemframes, etc).";

      };
    };

    "rheo"."replacer" = buildMinetestPackage rec {
      type = "mod";
      pname = "replacer";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "replacer";
        release = 14471;
        versionName = "2022-10-19";
        sha256 = "1m4rrfy5a8zdh7nfqk82q7hpfq7mw258s4vx6ph74in88x0awgv2";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."GPL-3.0-or-later" ];
        description = "node replacement tool and node inspection tool which are simpler and make use of high-level API";

          homepage = "https://github.com/fluxionary/minetest-replacer_redo";

      };
    };

    "rheo"."scaffolding" = buildMinetestPackage rec {
      type = "mod";
      pname = "scaffolding";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "scaffolding";
        release = 14329;
        versionName = "2022-10-12";
        sha256 = "1sfchaa75828ik6ak0xdnrwnwaj9grdcci4vx6p54w8n6zjg0hrw";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."MIT" ];
        description = "scaffolding, to help in building projects.";

      };
    };

    "rheo"."silence" = buildMinetestPackage rec {
      type = "mod";
      pname = "silence";
      version = "2022-10-12";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "silence";
        release = 14313;
        versionName = "2022-10-12";
        sha256 = "16rg60dsmai3dikrf70wnwj5f101qp2w2hr9jkwwvdyf0hiwn3wk";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC0-1.0" ];
        description = "Adds a node to silence sounds";

      };
    };

    "rheo"."smartshop" = buildMinetestPackage rec {
      type = "mod";
      pname = "smartshop";
      version = "2022-10-19";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "smartshop";
        release = 14472;
        versionName = "2022-10-19";
        sha256 = "1awxh9yll18va4rbvpdlvsw63bwwddgy7dsy0wddg4i6v3prx711";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-SA-3.0" ];
        description = "A smarter and easier shop";

      };
    };

    "rheo"."verbana" = buildMinetestPackage rec {
      type = "mod";
      pname = "verbana";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "rheo";
        technicalName = "verbana";
        release = 13727;
        versionName = "2022-09-05";
        sha256 = "0wbm6pq94cbh4f80v3h5xw5hp5055pk7sf4higkwaw7gh04360sw";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" ];
        description = "verification and banning";

      };
    };

    "rlars"."railbuilder" = buildMinetestPackage rec {
      type = "mod";
      pname = "railbuilder";
      version = "0.8.3.1";
      src = fetchFromContentDB {
        author = "rlars";
        technicalName = "railbuilder";
        release = 13863;
        versionName = "0.8.3.1";
        sha256 = "1iid4hhjrycb5x4byrm4i61af78ivzrq70b36wslkhkivdnr47d7";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "This mod allows you to plan and build tunnels and rails for Advtrains.";

      };
    };

    "rnd"."basic_machines" = buildMinetestPackage rec {
      type = "mod";
      pname = "basic_machines";
      version = "2018-05-24";
      src = fetchFromContentDB {
        author = "rnd";
        technicalName = "basic_machines";
        release = 58;
        versionName = "2018-05-24";
        sha256 = "0yci0biz5xl4az5iqx65l1dk9d18v8azhk9bzfvl145v2kg3zldz";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Lightweight minetest automation mod/logic/electronics building.";

      };
    };

    "ronoaldo"."minenews" = buildMinetestPackage rec {
      type = "mod";
      pname = "minenews";
      version = "v2.3.0";
      src = fetchFromContentDB {
        author = "ronoaldo";
        technicalName = "minenews";
        release = 12102;
        versionName = "v2.3.0";
        sha256 = "0fbpay6fw2jd4dkqyi5ahw6gx6giykpan283fl14akfj5gcavnv5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Display localized server news when a player joins";

          homepage = "https://github.com/ronoaldo/minenews";

      };
    };

    "rubenwardy"."accountmgr" = buildMinetestPackage rec {
      type = "mod";
      pname = "accountmgr";
      version = "0.2.0";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "accountmgr";
        release = 12921;
        versionName = "0.2.0";
        sha256 = "1d7w5w6292nqxhf8gs22h9pflqznzl45g4pap4z92jc81kkdyysv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Automatically create accounts in bulk, and export to .CSV and .HTML (and .PDF)";

      };
    };

    "rubenwardy"."awards" = buildMinetestPackage rec {
      type = "mod";
      pname = "awards";
      version = "v3.4.1";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "awards";
        release = 6092;
        versionName = "v3.4.1";
        sha256 = "1f6ba2rpm1bgf4gm9gccbdfpi3ad4xvj8vnij8kdz41yby5vbdhr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds achievements";

      };
    };

    "rubenwardy"."capturetheflag" = buildMinetestPackage rec {
      type = "game";
      pname = "capturetheflag";
      version = "3.2.0";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "capturetheflag";
        release = 13559;
        versionName = "3.2.0";
        sha256 = "109f4w9pj72ndi28apw52bm0sa4ic20w7slnrssdsqbfz30jrx5z";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Two or more teams battle to snatch and return the enemy flags, before the enemy takes their own!";

      };
    };

    "rubenwardy"."classroom" = buildMinetestPackage rec {
      type = "mod";
      pname = "classroom";
      version = "0.3.2";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "classroom";
        release = 13684;
        versionName = "0.3.2";
        sha256 = "0dhnw07vkpvygssm8jlh17qlcxjwfy0vcnz583d3pmvfrp0p9rmm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "An easy way to manage students in-game, with support for bulk actions and macros.";

      };
    };

    "rubenwardy"."conquer" = buildMinetestPackage rec {
      type = "mod";
      pname = "conquer";
      version = "v0.4.0";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "conquer";
        release = 6724;
        versionName = "v0.4.0";
        sha256 = "028bqhq3zh8r42xykycdrkbsb35lg7zgfin942fy6s0vp8nwb155";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Command your troops to victory - an RTS mini-game";

      };
    };

    "rubenwardy"."lib_chatcmdbuilder" = buildMinetestPackage rec {
      type = "mod";
      pname = "lib_chatcmdbuilder";
      version = "2022-01-21";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "lib_chatcmdbuilder";
        release = 10727;
        versionName = "2022-01-21";
        sha256 = "19fvq40rqspfh8q2psl8dh4x9zvffydw4ar086g5dwn1k2fib0vr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A library to make registering chat commands easier";

      };
    };

    "rubenwardy"."nyancat" = buildMinetestPackage rec {
      type = "mod";
      pname = "nyancat";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "nyancat";
        release = 13697;
        versionName = "2022-09-05";
        sha256 = "0pc0hiqq7l563rgglvd9dmzpyx7lwj0n8wz87ipnhkqm2d8mw3p1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan nyan";

      };
    };

    "rubenwardy"."sfinv" = buildMinetestPackage rec {
      type = "mod";
      pname = "sfinv";
      version = "2022-08-01";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "sfinv";
        release = 12976;
        versionName = "2022-08-01";
        sha256 = "1jnm4k2l4574qz7bwva7pyyf4kpg4w61sh915sa3j75337h8bqkb";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A cleaner, simpler solution to having an advanced inventory";

      };
    };

    "rubenwardy"."smartfs" = buildMinetestPackage rec {
      type = "mod";
      pname = "smartfs";
      version = "2020-10-29";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "smartfs";
        release = 6291;
        versionName = "2020-10-29";
        sha256 = "11hygdl3wcx90kpfyqbxkgz32s9fkj6jzjkjc194gzx5d94g92k0";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "A library to allow mods to make Formspecs, a form of GUI, easily.";

      };
    };

    "rubenwardy"."vote" = buildMinetestPackage rec {
      type = "mod";
      pname = "vote";
      version = "2017-03-17";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "vote";
        release = 84;
        versionName = "2017-03-17";
        sha256 = "1dq8cwq016z125qcnp3djspkgr3rz17qzkyb3bi4wvfaj9byyyag";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds an API to allow players to vote";

      };
    };

    "rubenwardy"."vote_kick" = buildMinetestPackage rec {
      type = "mod";
      pname = "vote_kick";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "rubenwardy";
        technicalName = "vote_kick";
        release = 289;
        versionName = "1.0.0";
        sha256 = "0hi7dgibfxvpii128yhv28kc8sb7kwvpadmgzlli1rvkxvkns48h";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds kick voting using the vote API";

      };
    };

    "rudzik8"."mcl_cozy" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_cozy";
      version = "2022-05-16fix";
      src = fetchFromContentDB {
        author = "rudzik8";
        technicalName = "mcl_cozy";
        release = 12299;
        versionName = "2022-05-16fix";
        sha256 = "1malblxkwxvl7vipv85xda5fazab0hgp9dh58gj5j3y80fz72sdp";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Sit and lay using chat commands in MineClone 2 (5)";

      };
    };

    "rudzik8"."mcl_decor" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_decor";
      version = "1.3_02";
      src = fetchFromContentDB {
        author = "rudzik8";
        technicalName = "mcl_decor";
        release = 14174;
        versionName = "1.3_02";
        sha256 = "11nsanaywhq36zpgxbj0m8lb4f830dw9rvr849bbaz1p1jzsn1n0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."GPL-3.0-or-later" ];
        description = "Adds more decoration and furniture blocks to MineClone 2";

      };
    };

    "rudzik8"."mcl_emerald_stuff" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_emerald_stuff";
      version = "2022-02-21";
      src = fetchFromContentDB {
        author = "rudzik8";
        technicalName = "mcl_emerald_stuff";
        release = 11374;
        versionName = "2022-02-21";
        sha256 = "1yb6qi7vrgsafvgzb2snf23c4zrnxc3lckpnw85p1w16mdvxysvr";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds emerald tools and armor to Mineclone 2 (5)";

      };
    };

    "rudzik8"."mcl_morefood" = buildMinetestPackage rec {
      type = "mod";
      pname = "mcl_morefood";
      version = "2022-03-20";
      src = fetchFromContentDB {
        author = "rudzik8";
        technicalName = "mcl_morefood";
        release = 11605;
        versionName = "2022-03-20";
        sha256 = "035rdm4cc52frx644xakjw60ggqzazpyizw9i8pp6a3ql0261dgk";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."Unlicense" ];
        description = "Adds five more food items to Mineclone 2 (5)";

      };
    };

    "runs"."aquaz" = buildMinetestPackage rec {
      type = "mod";
      pname = "aquaz";
      version = "1.3.1";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "aquaz";
        release = 9940;
        versionName = "1.3.1";
        sha256 = "1q6p4fsp5mi2nxk0fpp76w3n8050zb4pd3lickfn6ys9q489g60s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Stuff for oceans";

      };
    };

    "runs"."climatez" = buildMinetestPackage rec {
      type = "mod";
      pname = "climatez";
      version = "1.25";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "climatez";
        release = 9314;
        versionName = "1.25";
        sha256 = "02wqgymqs0pf30l1p3mp0skqrxl8vgs55cdwj5rli6495kl0fkj0";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A weather mod";

      };
    };

    "runs"."cool_trees" = buildMinetestPackage rec {
      type = "mod";
      pname = "cool_trees";
      version = "4.23";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "cool_trees";
        release = 11238;
        versionName = "4.23";
        sha256 = "1grnig720zd38is4ca92cb41c21hsljqjjmb8hic05nkr4wm98rw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "It adds some cute trees.";

      };
    };

    "runs"."farbows" = buildMinetestPackage rec {
      type = "mod";
      pname = "farbows";
      version = "1.15";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "farbows";
        release = 4736;
        versionName = "1.15";
        sha256 = "1mkyngyvzc0qh7jvhw88m6a1bnbvlvxh0a67sx3l1mmxig3sz05w";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "It adds tree weapons: Wooden Bow, Mese Bow and Flaming Bow.";

      };
    };

    "runs"."fireworkz" = buildMinetestPackage rec {
      type = "mod";
      pname = "fireworkz";
      version = "1.5.2";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "fireworkz";
        release = 5853;
        versionName = "1.5.2";
        sha256 = "0qncbryrx2jxq8zyd01zphwcdw1hdmkjl1qy3ax9qyjhbj3rppf3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "This mod adds Fireworks to Minetest.";

      };
    };

    "runs"."jonez" = buildMinetestPackage rec {
      type = "mod";
      pname = "jonez";
      version = "3.2";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "jonez";
        release = 12689;
        versionName = "3.2";
        sha256 = "067xg8df656nh6b2mx1agkwplibpgzz25bcpz8n77kf36saz904p";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "You can create ancient archaeological structures.";

      };
    };

    "runs"."juanchi" = buildMinetestPackage rec {
      type = "game";
      pname = "juanchi";
      version = "4.10";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "juanchi";
        release = 11597;
        versionName = "4.10";
        sha256 = "0cvnya4j3yxdbl08amf0qhqzj8xfrp23wvckfcqb24byva3bcxf6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A game just for fun with blocks, animals and a lot of more.";

      };
    };

    "runs"."mahogany" = buildMinetestPackage rec {
      type = "mod";
      pname = "mahogany";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "mahogany";
        release = 1314;
        versionName = "v1.0";
        sha256 = "0wjh34q6x44ss5j74qbpwr4dkj3xrg90phdrgz4brnilm5fw6pwn";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "A jungle tree.";

      };
    };

    "runs"."petz" = buildMinetestPackage rec {
      type = "mod";
      pname = "petz";
      version = "z15";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "petz";
        release = 13796;
        versionName = "z15";
        sha256 = "0661i0vns2jmyzf89kbxhr1g069xzg565q2634bjiij5agpsw9bb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Very cute mascots: Kittens, puppies, duckies, lambs... Take care of them!";

      };
    };

    "runs"."pickp" = buildMinetestPackage rec {
      type = "mod";
      pname = "pickp";
      version = "1.3";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "pickp";
        release = 7104;
        versionName = "1.3";
        sha256 = "08zsyzk5xmbf1fg0irfykyi938dhjyv7pxi166s56hffnzr7p81w";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A Pickpocketing Mod for servers";

      };
    };

    "runs"."rainf" = buildMinetestPackage rec {
      type = "mod";
      pname = "rainf";
      version = "0.7";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "rainf";
        release = 10031;
        versionName = "0.7";
        sha256 = "1r8hjcff4i03ykmdixwh21z6f82649rccgp84bizqvrzikxm0ikj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Temperate Rainforest Biome";

      };
    };

    "runs"."rcbows" = buildMinetestPackage rec {
      type = "mod";
      pname = "rcbows";
      version = "2.2";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "rcbows";
        release = 4735;
        versionName = "2.2";
        sha256 = "0m8yvkq5y4ncyvcvivx8y5jv1w5s4jn7znxb6mmsh5zmrxqjn8yz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "This is only the API. Download the Farbows mod for the bows too.";

      };
    };

    "runs"."redw" = buildMinetestPackage rec {
      type = "mod";
      pname = "redw";
      version = "0.3";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "redw";
        release = 9980;
        versionName = "0.3";
        sha256 = "0qdx1fwqaxhna9c8xpkyb32lk0r92hqz9y0i6g830mrlyqf3qm6z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Redwood Forest Biome";

      };
    };

    "runs"."saltd" = buildMinetestPackage rec {
      type = "mod";
      pname = "saltd";
      version = "0.4";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "saltd";
        release = 8808;
        versionName = "0.4";
        sha256 = "0hsgq6ykkfy9rsxi3bkxdqza4h7b1g2pvky1qhsbv145vs9vfbxz";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "Salt Desert Biome";

      };
    };

    "runs"."samz" = buildMinetestPackage rec {
      type = "game";
      pname = "samz";
      version = "alpha8.2";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "samz";
        release = 13690;
        versionName = "alpha8.2";
        sha256 = "1qicmp8whvx10a9nlzvc5lwyyvf8s3gwjbacmaj1jzq74d9884yf";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-or-later" ];
        description = "A game for kids.";

          homepage = "http://keko.pro";

      };
    };

    "runs"."swaz" = buildMinetestPackage rec {
      type = "mod";
      pname = "swaz";
      version = "1.15";
      src = fetchFromContentDB {
        author = "runs";
        technicalName = "swaz";
        release = 9981;
        versionName = "1.15";
        sha256 = "0ln71i5y332kprl07jh25f9bmrz9hf4j5snal7lcx7h2vn7ixs50";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A cool swampy biome.";

      };
    };

    "sermow"."coloredblocks" = buildMinetestPackage rec {
      type = "mod";
      pname = "coloredblocks";
      version = "Colored_Blocks";
      src = fetchFromContentDB {
        author = "sermow";
        technicalName = "coloredblocks";
        release = 14275;
        versionName = "Colored Blocks";
        sha256 = "1y15zzvlcs7cx636766q8jazwkx5lpas8gp4504yws47b7php6a3";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Different vibrant colors of stone, stonebrick, and wood";

      };
    };

    "sfan5"."nuke" = buildMinetestPackage rec {
      type = "mod";
      pname = "nuke";
      version = "2.2";
      src = fetchFromContentDB {
        author = "sfan5";
        technicalName = "nuke";
        release = 1876;
        versionName = "2.2";
        sha256 = "1wgsyvbzj6l5pchnv1ilvnymr3x417brz64lyvv6jyn1wskxbmxg";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Additional types of TNT for all your explosive needs.";

      };
    };

    "sfan5"."worldedit" = buildMinetestPackage rec {
      type = "mod";
      pname = "worldedit";
      version = "2022-05-06";
      src = fetchFromContentDB {
        author = "sfan5";
        technicalName = "worldedit";
        release = 13367;
        versionName = "2022-05-06";
        sha256 = "0glq7ym8n97wdk8fsvwgfc7fzqm4692f8ncg2g0ljhdm28rbkzya";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "In-game world editor. Use it to repair griefing, or just create awesome buildings in seconds.";

      };
    };

    "shacknetisp"."realtime_elevator" = buildMinetestPackage rec {
      type = "mod";
      pname = "realtime_elevator";
      version = "2021-06-18";
      src = fetchFromContentDB {
        author = "shacknetisp";
        technicalName = "realtime_elevator";
        release = 8088;
        versionName = "2021-06-18";
        sha256 = "0w5s31hw0iggcnvnqxanvbjwgxnxc9ja67rkx5a32sws3r3qvyah";
      };
      meta = src.meta // {
        license = [ spdx."ISC" ];
        description = "Smooth entity-based elevators used for vertical transport without teleportation";

      };
    };

    "siegment"."loria" = buildMinetestPackage rec {
      type = "game";
      pname = "loria";
      version = "21w30h";
      src = fetchFromContentDB {
        author = "siegment";
        technicalName = "loria";
        release = 8599;
        versionName = "21w30h";
        sha256 = "13gw5vi834sgrxrmgw1a1gbfm8ivqpm2vjmr5v38k0nh6rr09179";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Survival in hardcore acid-alien sci-fi themed world ";

      };
    };

    "simondanerd"."playertracker" = buildMinetestPackage rec {
      type = "mod";
      pname = "playertracker";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "simondanerd";
        technicalName = "playertracker";
        release = 14381;
        versionName = "2021-01-29";
        sha256 = "0kqjqyavvzvk0kxk9zf7111zil95k3vvq69gvsl7k71wc72x0900";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Mod for any game which logs what users join, and records their IP address. Content saved as a txt file in the worlds directory.";

      };
    };

    "sirrobzeroone"."3d_armor_flyswim" = buildMinetestPackage rec {
      type = "mod";
      pname = "3d_armor_flyswim";
      version = "5.6.0.2_Release";
      src = fetchFromContentDB {
        author = "sirrobzeroone";
        technicalName = "3d_armor_flyswim";
        release = 13392;
        versionName = "5.6.0.2 Release";
        sha256 = "12h9w9v3208sbakn4h50l6vsag811ymizah4xq33haadwc5gvq1s";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Adds Flying and Swimming animations to base character model for 3d_armor";

      };
    };

    "sirrobzeroone"."comboblock" = buildMinetestPackage rec {
      type = "mod";
      pname = "comboblock";
      version = "5.5.0.1";
      src = fetchFromContentDB {
        author = "sirrobzeroone";
        technicalName = "comboblock";
        release = 12538;
        versionName = "5.5.0.1";
        sha256 = "0bhpn2j3k0pr5q1vlc0mj75abfspg7v5jbzyl6f74miv0bmfzz2i";
      };
      meta = src.meta // {
        license = [ spdx."Unlicense" ];
        description = "Allows the stacking of slabs vertically and horizontally";

      };
    };

    "sirrobzeroone"."worm_farm" = buildMinetestPackage rec {
      type = "mod";
      pname = "worm_farm";
      version = "Initial";
      src = fetchFromContentDB {
        author = "sirrobzeroone";
        technicalName = "worm_farm";
        release = 13023;
        versionName = "Initial";
        sha256 = "10fwy99bdabq4hqd9scz7vcscqcwnaypnrvz3m1zmc8rgh9yix29";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds a way for worms to be cultivated for fishing - designed for use with Ethereal";

      };
    };

    "sivarajansam"."discotrains" = buildMinetestPackage rec {
      type = "mod";
      pname = "discotrains";
      version = "Removed_Subway_trains_";
      src = fetchFromContentDB {
        author = "sivarajansam";
        technicalName = "discotrains";
        release = 3681;
        versionName = "Removed Subway trains ";
        sha256 = "16ggz3sc9n3np7jgf50z16gi2v77vbp7s5d3s5fmimjj4j3pxyp0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds colorful subway trains to advanced trains";

      };
    };

    "skbzk"."coalfromtrees" = buildMinetestPackage rec {
      type = "mod";
      pname = "coalfromtrees";
      version = "1.0";
      src = fetchFromContentDB {
        author = "skbzk";
        technicalName = "coalfromtrees";
        release = 7648;
        versionName = "1.0";
        sha256 = "0g1hllqhxqgcg1y1ap2cdjknzqf3n5b3fwj4ay5r7sg2aw1gbicf";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Cook trees to get coal";

      };
    };

    "skiscratcher"."coop_factions" = buildMinetestPackage rec {
      type = "mod";
      pname = "coop_factions";
      version = "2022-08-25";
      src = fetchFromContentDB {
        author = "skiscratcher";
        technicalName = "coop_factions";
        release = 13549;
        versionName = "2022-08-25";
        sha256 = "1qm8i5wfg95krik346760qpmvnhq1q2z4a5f8dkc1nq55ns11pq7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-2.0-only" ];
        description = "Adds factions, allowing players to team together";

      };
    };

    "skiscratcher"."electric_screwdriver" = buildMinetestPackage rec {
      type = "mod";
      pname = "electric_screwdriver";
      version = "0.1.1";
      src = fetchFromContentDB {
        author = "skiscratcher";
        technicalName = "electric_screwdriver";
        release = 13002;
        versionName = "0.1.1";
        sha256 = "0w2y717icck9ba1i1ilq7wbmsi6zgspbq5byqh9xg55kacbnryzy";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A supplement to screwdriver, to speed up placing blocks in a repetitive way";

      };
    };

    "snowyu"."country_flags" = buildMinetestPackage rec {
      type = "mod";
      pname = "country_flags";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "snowyu";
        technicalName = "country_flags";
        release = 13770;
        versionName = "v1.0.2";
        sha256 = "01pnyzaa9vd7lq1yn86ds1smnf9rls0xj0a94w6bvzcf9gia13w1";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add all country flags to pride_flags";

      };
    };

    "snowyu"."quiz" = buildMinetestPackage rec {
      type = "mod";
      pname = "quiz";
      version = "0.11.0";
      src = fetchFromContentDB {
        author = "snowyu";
        technicalName = "quiz";
        release = 13212;
        versionName = "0.11.0";
        sha256 = "0iy9li0ps7r9ycqa8hnmg514sc569z72g9g079n2ac08qf0w249w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "This mod requires players to answer question before they can play. If you answer correctly, you will get a award and continue to play, otherwise you will not be able to play.";

      };
    };

    "snowyu"."yaml" = buildMinetestPackage rec {
      type = "mod";
      pname = "yaml";
      version = "1.2.0";
      src = fetchFromContentDB {
        author = "snowyu";
        technicalName = "yaml";
        release = 12986;
        versionName = "1.2.0";
        sha256 = "1vjh489nczq6d43rzzbry0sqmlfij0wa4rr3zafdaiwr3d2f1f60";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Load or Save YAML config file";

      };
    };

    "sofar"."crops" = buildMinetestPackage rec {
      type = "mod";
      pname = "crops";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "crops";
        release = 176;
        versionName = "v1";
        sha256 = "00bhcj0rnpq2vjxxvd7fac6wkgdvah4pqc9phqwwc871bfx9yarp";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "This mod expands the basic set of farming-related crops that minetest_game offers.";

      };
    };

    "sofar"."emote" = buildMinetestPackage rec {
      type = "mod";
      pname = "emote";
      version = "2022-06-20";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "emote";
        release = 13167;
        versionName = "2022-06-20";
        sha256 = "1qiks1ixwg79dpfqgdr81nyxg8kjn8yfwnyjkjb55fypwx2msc1z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."LGPL-2.1-only" ];
        description = "Provides player emotes and an api to make the player model sit, lie down and perform other actions.";

      };
    };

    "sofar"."filter" = buildMinetestPackage rec {
      type = "mod";
      pname = "filter";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "filter";
        release = 178;
        versionName = "v1";
        sha256 = "1qs599mq783jdq541a3pmfajh7x0rlpkdgb6s7l455sr0xx9yx6b";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "A chat filter for servers, to warn/kick/ban on swearing";

      };
    };

    "sofar"."flowerpot" = buildMinetestPackage rec {
      type = "mod";
      pname = "flowerpot";
      version = "2022-04-17";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "flowerpot";
        release = 11857;
        versionName = "2022-04-17";
        sha256 = "18r8hpmk6ry21bag96cq441q1ddp2xzghva1ph64kxd4904xx7sq";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A stylish flowerpot that can contain most plants.";

      };
    };

    "sofar"."frame" = buildMinetestPackage rec {
      type = "mod";
      pname = "frame";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "frame";
        release = 177;
        versionName = "v1";
        sha256 = "0gr65sm296pgbl30jrh6jj03vqaxsm21ssis0rf4qdil66dssjfv";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-or-later" ];
        description = "A stylish item and node frame that causes no lag/server load.";

      };
    };

    "sofar"."fsc" = buildMinetestPackage rec {
      type = "mod";
      pname = "fsc";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "fsc";
        release = 187;
        versionName = "v1";
        sha256 = "0rml9l4gcdp1iqphfyph1y10vax9isi1plh0z3lcqhnan6nmj8qn";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Easier method for creating better and more secure formspecs.";

      };
    };

    "sofar"."inspector" = buildMinetestPackage rec {
      type = "mod";
      pname = "inspector";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "inspector";
        release = 179;
        versionName = "v1";
        sha256 = "0hyywyyhjn1w9pglmgqkcmyqn7wh6n4fidllisw0km2qldka0yrq";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "An in-game tool to inspect node parameters and metadata.";

      };
    };

    "sofar"."lightning" = buildMinetestPackage rec {
      type = "mod";
      pname = "lightning";
      version = "2017-02-20";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "lightning";
        release = 53;
        versionName = "2017-02-20";
        sha256 = "0spd2gq6wmf5h06nsfn7d3dw4539ybmwv73ly5dlxxd6z71w6746";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A mod that adds thunder and lightning effects.";

      };
    };

    "sofar"."luscious" = buildMinetestPackage rec {
      type = "mod";
      pname = "luscious";
      version = "2022-02-26";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "luscious";
        release = 13658;
        versionName = "2022-02-26";
        sha256 = "0f9xhw8y751dg174xi69b63mr45afsg9hdbbqk1cgzgrpl8ln95k";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Bring color into the mgv7 mapgen world.";

      };
    };

    "sofar"."mt2fa" = buildMinetestPackage rec {
      type = "mod";
      pname = "mt2fa";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "mt2fa";
        release = 185;
        versionName = "v1";
        sha256 = "12ra26hk091x1lj8sa46z6j9m1w6jd6jv0d5w502dxdw64y9gq60";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds server and player email confirmation to add an extra layer of security (2FA)";

      };
    };

    "sofar"."nightandday" = buildMinetestPackage rec {
      type = "mod";
      pname = "nightandday";
      version = "20190805";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "nightandday";
        release = 1727;
        versionName = "20190805";
        sha256 = "1gxm57l09ipbbspm70dyrzr776qv07h91kmxrmnq9knhn3l29f9n";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Allows you to have different day and night speeds.";

      };
    };

    "sofar"."pixelperfection" = buildMinetestPackage rec {
      type = "txp";
      pname = "pixelperfection";
      version = "2019-06-02";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "pixelperfection";
        release = 6376;
        versionName = "2019-06-02";
        sha256 = "0gvz4jy9w0nhmpl8biwk9n1gj8kmflx8mk2j90npfqirbzhsi20z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "16px texture pack by xssheep.";

      };
    };

    "sofar"."sedimentology" = buildMinetestPackage rec {
      type = "mod";
      pname = "sedimentology";
      version = "v1";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "sedimentology";
        release = 180;
        versionName = "v1";
        sha256 = "1gxxbmpbq4pnrdrfpkyavggqi48dznw4zyxbxxb5914s5pszmzyz";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "A mod that adds realistic erosion and degradation of rocks.";

      };
    };

    "sofar"."skybox" = buildMinetestPackage rec {
      type = "mod";
      pname = "skybox";
      version = "2022-01-03";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "skybox";
        release = 13160;
        versionName = "2022-01-03";
        sha256 = "1wqwymzm8iy672qib3ff5c7vbxhyd0sp1lymihmzzgy6hbgrw8bm";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Allows changing your sky to unimaginably epic scenes.";

      };
    };

    "sofar"."stamina" = buildMinetestPackage rec {
      type = "mod";
      pname = "stamina";
      version = "2021-10-13";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "stamina";
        release = 13133;
        versionName = "2021-10-13";
        sha256 = "1419lkazql5fm5588xxjl9xc3mmykr42qyhnhyl2w50m3q6282gg";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Adds stamina, sprinting, and hunger";

      };
    };

    "sofar"."warps" = buildMinetestPackage rec {
      type = "mod";
      pname = "warps";
      version = "2021-02-17";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "warps";
        release = 13147;
        versionName = "2021-02-17";
        sha256 = "1h7x7gk8gjn281xyhkp6n04llwg1srym1dac8x1gydpbh60r3523";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" ];
        description = "Warp locations and warp stones (portal stones)";

      };
    };

    "sofar"."yolo" = buildMinetestPackage rec {
      type = "mod";
      pname = "yolo";
      version = "20191015-2";
      src = fetchFromContentDB {
        author = "sofar";
        technicalName = "yolo";
        release = 2195;
        versionName = "20191015-2";
        sha256 = "08xkmdfsgzdhf11yzdranljy45m319zyirfs9q405609z1f3qr8r";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "You Only Live Once - AKA hardcore/permadeath mode - death is permanent.";

      };
    };

    "sorcerykid"."antigrief" = buildMinetestPackage rec {
      type = "mod";
      pname = "antigrief";
      version = "2019-04-09";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "antigrief";
        release = 4859;
        versionName = "2019-04-09";
        sha256 = "0sbdnk6a8hckd61jc5fd85hs19s6r4r8q17pivj9gdl6c1pdsf2v";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "An API for validating node and item placement via a simple callback mechanism.";

      };
    };

    "sorcerykid"."auth_rx" = buildMinetestPackage rec {
      type = "mod";
      pname = "auth_rx";
      version = "Version_2.13";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "auth_rx";
        release = 3153;
        versionName = "Version 2.13";
        sha256 = "1zb285kbxg7h5qrzx75s37d422p1dbl8wp1ryak9lck7ppjjjbyi";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Auth Redux is a drop-in replacement for the builtin authentication handler of Minetest";

      };
    };

    "sorcerykid"."auth_rx_lite" = buildMinetestPackage rec {
      type = "mod";
      pname = "auth_rx_lite";
      version = "Version_2.7";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "auth_rx_lite";
        release = 4972;
        versionName = "Version 2.7";
        sha256 = "1y6cp0mdzqglpv329zmslr3d21409mcd2w4d5sfxl392ddq6cy2k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Robust and lightweight authentication handler for use on servers";

          homepage = "https://github.com/sorcerykid/auth_rx/wiki";

      };
    };

    "sorcerykid"."beds" = buildMinetestPackage rec {
      type = "mod";
      pname = "beds";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "beds";
        release = 5138;
        versionName = "Version 1.0";
        sha256 = "1gc3wzl3ddww45mw3jg98wd9ilm9mpaqla2igcclnv441w3mvvsc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "A complete rewrite of the Beds mod with many additional features";

      };
    };

    "sorcerykid"."belfry" = buildMinetestPackage rec {
      type = "mod";
      pname = "belfry";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "belfry";
        release = 3126;
        versionName = "Version 1.0";
        sha256 = "01sggx3yv07ckz8q0vm9kq8i6v2p1my1nj9z96ajwvql7s3ds53b";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Adds a set of church bells that are chimed automatically at different periods.";

      };
    };

    "sorcerykid"."bitwise" = buildMinetestPackage rec {
      type = "mod";
      pname = "bitwise";
      version = "Version_1.2";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "bitwise";
        release = 3123;
        versionName = "Version 1.2";
        sha256 = "08bvxp7x07qm72m64lmpa03ws2sbr5yb2javhqh7br6j2i4ikp0l";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A pure-Lua implementation of common bit-manipulation functions";

      };
    };

    "sorcerykid"."chat_history" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_history";
      version = "Version_2.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "chat_history";
        release = 2587;
        versionName = "Version 2.0";
        sha256 = "0c3ghy93jibm2g0aqhl3h0r1iv5n2nbyc8g1sxxqi98hb7axzazy";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Interactive chat history viewer with a variety of message filtering options";

      };
    };

    "sorcerykid"."city_block" = buildMinetestPackage rec {
      type = "mod";
      pname = "city_block";
      version = "Version_2.2";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "city_block";
        release = 5154;
        versionName = "Version 2.2";
        sha256 = "0f3hb88hh5jkjyf7nkzj64789pr2ic1c63695py56zv43nkn516w";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Disables use of water and lava buckets within a designated area";

      };
    };

    "sorcerykid"."config" = buildMinetestPackage rec {
      type = "mod";
      pname = "config";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "config";
        release = 3228;
        versionName = "Version 1.1";
        sha256 = "0fbgh1ga9j0xps4cg97cc7isnak4qlqsx64qf7y343zh2rllkfyr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "API extension that allows seamless loading of mod configuration at runtime";

      };
    };

    "sorcerykid"."console" = buildMinetestPackage rec {
      type = "mod";
      pname = "console";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "console";
        release = 5260;
        versionName = "Version 1.1";
        sha256 = "1fffd7p6m1034ljb0sprlqfbbn5if70ymv0n1aig3zqyfcfd91bn";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" spdx."MIT" ];
        description = "Provides an in-game HUD to easily monitor debug output";

      };
    };

    "sorcerykid"."cronjob" = buildMinetestPackage rec {
      type = "mod";
      pname = "cronjob";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "cronjob";
        release = 4996;
        versionName = "Version 1.0";
        sha256 = "1sspn647wzp168my75pfp8jb2mwq92d913hk0vsmvd315nykqk12";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A more flexible alternative to the builtin minetest.after function";

      };
    };

    "sorcerykid"."dataminer" = buildMinetestPackage rec {
      type = "mod";
      pname = "dataminer";
      version = "Version_2.2";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "dataminer";
        release = 2589;
        versionName = "Version 2.2";
        sha256 = "07pnwvsgq3dkvxhv3p0xkz5nqyp31g12hs87vq1xcqf6hnaxhab9";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "DataMiner is an analytical tool for server operators with a feature-rich API for customized report generation";

      };
    };

    "sorcerykid"."extra_doors" = buildMinetestPackage rec {
      type = "mod";
      pname = "extra_doors";
      version = "Version_2.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "extra_doors";
        release = 627;
        versionName = "Version 2.0";
        sha256 = "162izdan7iskii49ss0q3sbdijpf02s5qxvqfahv14vq6vnr08q7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Extra Doors provides a range of interior and exterior doors for builders";

      };
    };

    "sorcerykid"."finder" = buildMinetestPackage rec {
      type = "mod";
      pname = "finder";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "finder";
        release = 4997;
        versionName = "Version 1.1";
        sha256 = "1l0dy6wg50qmfs256jfvyddybxm3fgyzg5796840rpyw7armrkxr";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Extends the Minetest API with search capabilities for entities";

      };
    };

    "sorcerykid"."formspecs" = buildMinetestPackage rec {
      type = "mod";
      pname = "formspecs";
      version = "Version_2.6";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "formspecs";
        release = 3152;
        versionName = "Version 2.6";
        sha256 = "1m4xdgjqyb7aqp848z2y8c1p7w01x59q29y20jfbafkydzzqh3bj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "ActiveFormspecs is a framework that abstracts the builtin formspec API of Minetest";

      };
    };

    "sorcerykid"."giftbox" = buildMinetestPackage rec {
      type = "mod";
      pname = "giftbox";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "giftbox";
        release = 14460;
        versionName = "2021-01-29";
        sha256 = "19bhj1q8mmdga020wf8krv68hxml6k3b6mrbzdl2y8a6npic2vyh";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "An assortment user-customizable presents for special occasions";

      };
    };

    "sorcerykid"."macro" = buildMinetestPackage rec {
      type = "mod";
      pname = "macro";
      version = "Version_2.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "macro";
        release = 2590;
        versionName = "Version 2.0";
        sha256 = "1rql6kkrlgscq7mqky0ap65z5kggf46m01ifvm6zynynz8pcggbl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Macro Crafting Manager provides a streamlined drag-and-drop interface for dividing and arranging item stacks within the craft-grid";

      };
    };

    "sorcerykid"."markup" = buildMinetestPackage rec {
      type = "mod";
      pname = "markup";
      version = "Version_1.3";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "markup";
        release = 3125;
        versionName = "Version 1.3";
        sha256 = "0ihcps363468qmpqrvg83d1w3s2vhn1vfmr80p9hx0qw9gxyshpl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Bedrock Markup Language is an extensible markup language and API for formspecs.";

      };
    };

    "sorcerykid"."ownership" = buildMinetestPackage rec {
      type = "mod";
      pname = "ownership";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "ownership";
        release = 5155;
        versionName = "Version 1.1";
        sha256 = "1zzhffqrym0cggdqhsrmwmhqshhrsn79fq2sf38298s6d0gr8k4w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "An efficient and flexible node-based protection scheme for multiplayer worlds";

      };
    };

    "sorcerykid"."plugins" = buildMinetestPackage rec {
      type = "mod";
      pname = "plugins";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "plugins";
        release = 4973;
        versionName = "Version 1.0";
        sha256 = "12ari5c7c31bc5xvj88afq9gfwclqfqxvcycvb8dy6lasc5frmm4";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Automated dependency management of helper functions within a distributed architecture";

          homepage = "http://plugins.mytuner.net/";

      };
    };

    "sorcerykid"."polygraph" = buildMinetestPackage rec {
      type = "mod";
      pname = "polygraph";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "polygraph";
        release = 2588;
        versionName = "Version 1.1";
        sha256 = "019x60kd31fask3wiwnxankrvl9gqrpzv5m22wq09nm9p9a751rj";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Polygraph is a formspec-based charting API, providing a rich set of output parameters and custom rendering hooks within an object-oriented framework.";

      };
    };

    "sorcerykid"."protector" = buildMinetestPackage rec {
      type = "mod";
      pname = "protector";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "protector";
        release = 4999;
        versionName = "Version 1.0";
        sha256 = "10vdlp6z7fjlj89a4yrg9ribbkwv5yk8zqkqdsh4g71bsn1ay6c3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "An efficient and flexible node-based protection scheme for multiplayer worlds";

      };
    };

    "sorcerykid"."scarlet" = buildMinetestPackage rec {
      type = "mod";
      pname = "scarlet";
      version = "Version_1.4";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "scarlet";
        release = 5257;
        versionName = "Version 1.4";
        sha256 = "0gbri729prf916b1k7rnpdbs0m99h6359xcic7sp0hvrbn9mdg90";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Scarlet is a thin-wrapper library that simplifies the layout of formspec elements.";

      };
    };

    "sorcerykid"."signs_rx" = buildMinetestPackage rec {
      type = "mod";
      pname = "signs_rx";
      version = "Version_1.2";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "signs_rx";
        release = 3128;
        versionName = "Version 1.2";
        sha256 = "103d999i0cxwlhr54pmnp130snzk5yn3ck7dwzkipj1m7acj0gbg";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Signs Redux is a complete rewrite of default signs that adds many new features";

      };
    };

    "sorcerykid"."stopwatch" = buildMinetestPackage rec {
      type = "mod";
      pname = "stopwatch";
      version = "Version_1.2";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "stopwatch";
        release = 618;
        versionName = "Version 1.2";
        sha256 = "05k295qgyshq7x388f466rqmlzr6f4cql4brcmjghbpg53kh6hvl";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Stopwatch is Lua-based benchmarking API for Minetest developers";

      };
    };

    "sorcerykid"."timekeeper" = buildMinetestPackage rec {
      type = "mod";
      pname = "timekeeper";
      version = "Version_1.1";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "timekeeper";
        release = 5258;
        versionName = "Version 1.1";
        sha256 = "15jrr58mcz5fk5gyrcvnmk9sckjc2zhplrcs39js8d8b1nz736kv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Timekeeper acts as a centralized dispatcher for all time-sensitive routines";

      };
    };

    "sorcerykid"."trophies" = buildMinetestPackage rec {
      type = "mod";
      pname = "trophies";
      version = "Version_1.0";
      src = fetchFromContentDB {
        author = "sorcerykid";
        technicalName = "trophies";
        release = 4998;
        versionName = "Version 1.0";
        sha256 = "1xw1wgkbagz2ns59pajflyrgm2f5dcn4q4dzwjiz2zqc38m287xs";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-3.0-only" ];
        description = "Showcase player achievements with a personalized gold cup";

      };
    };

    "spicemines"."pumpkin_pies" = buildMinetestPackage rec {
      type = "mod";
      pname = "pumpkin_pies";
      version = "2022-10-01";
      src = fetchFromContentDB {
        author = "spicemines";
        technicalName = "pumpkin_pies";
        release = 14131;
        versionName = "2022-10-01";
        sha256 = "1wrl8j446564jhw4vx2vvkdxs2w29394j3vlr1f0n8m148k86sb4";
      };
      meta = src.meta // {
        license = [ spdx."Apache-2.0" spdx."CC-BY-3.0" ];
        description = "Adds various recipes for making pumpkin pies.";

      };
    };

    "srifqi"."advancedban" = buildMinetestPackage rec {
      type = "mod";
      pname = "advancedban";
      version = "v0.3";
      src = fetchFromContentDB {
        author = "srifqi";
        technicalName = "advancedban";
        release = 1739;
        versionName = "v0.3";
        sha256 = "0js29ibd2d74lrqbksqw0gj1f0p9xfsgvjsdlv9236i09zrry449";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Advanced Ban: Ban a player based on its username";

      };
    };

    "srifqi"."banondie" = buildMinetestPackage rec {
      type = "mod";
      pname = "banondie";
      version = "2015-01-07";
      src = fetchFromContentDB {
        author = "srifqi";
        technicalName = "banondie";
        release = 8102;
        versionName = "2015-01-07";
        sha256 = "0kxfdwgsh8nyg8agagvcn516pw4vlkpgclazjz9ix5pzdjqjkdld";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Ban players upon death.";

      };
    };

    "srifqi"."superflat" = buildMinetestPackage rec {
      type = "mod";
      pname = "superflat";
      version = "1.5";
      src = fetchFromContentDB {
        author = "srifqi";
        technicalName = "superflat";
        release = 12193;
        versionName = "1.5";
        sha256 = "11vwz4074hykj12hbflhpmf70lx0c8rm8r8wq5qnqgfymn0pb1ff";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "(Yet Another) Superflat Map Generator: Customize world generation layer by layer";

      };
    };

    "stu"."3d_armor" = buildMinetestPackage rec {
      type = "mod";
      pname = "3d_armor";
      version = "2022-09-08";
      src = fetchFromContentDB {
        author = "stu";
        technicalName = "3d_armor";
        release = 13753;
        versionName = "2022-09-08";
        sha256 = "1l2g1flqwh2bb7lms49pj46ikj3dbikq3sa1518qarblalgi09wc";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Visible player armor & wielded items.";

      };
    };

    "stu"."classes" = buildMinetestPackage rec {
      type = "mod";
      pname = "classes";
      version = "2013-07-13";
      src = fetchFromContentDB {
        author = "stu";
        technicalName = "classes";
        release = 2157;
        versionName = "2013-07-13";
        sha256 = "1f5iq8n9b3gw6jgjkddi1910jwvzmzlgcwfpjpp4jbycxn76r6jw";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."WTFPL" ];
        description = "Playable character classes, currently include human, dwarf and elf.";

      };
    };

    "stu"."shooter" = buildMinetestPackage rec {
      type = "mod";
      pname = "shooter";
      version = "0.6.0";
      src = fetchFromContentDB {
        author = "stu";
        technicalName = "shooter";
        release = 1228;
        versionName = "0.6.0";
        sha256 = "1l651ihw9g1x4jsjgsc0kfkwl9afqv364y7xvdrdcj2p407cfdzd";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "First person shooter mod.";

      };
    };

    "stu"."wield3d" = buildMinetestPackage rec {
      type = "mod";
      pname = "wield3d";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "stu";
        technicalName = "wield3d";
        release = 13635;
        versionName = "2021-01-29";
        sha256 = "1n4bjma6ws4fvbihqbn8aylcsg7vwlb8a1493bmv8g93cdmqq66m";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "See the items other players are holding";

      };
    };

    "sunnysideup"."holidayhorrors" = buildMinetestPackage rec {
      type = "game";
      pname = "holidayhorrors";
      version = "2021-12-22";
      src = fetchFromContentDB {
        author = "sunnysideup";
        technicalName = "holidayhorrors";
        release = 10179;
        versionName = "2021-12-22";
        sha256 = "072g1n3wnyw08iyxgq9c5dcrz5vwwbl4lbn3xzkalrhrn40xxiz5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Survive the holidays!";

      };
    };

    "sunnysideup"."lakemaker" = buildMinetestPackage rec {
      type = "mod";
      pname = "lakemaker";
      version = "1.0";
      src = fetchFromContentDB {
        author = "sunnysideup";
        technicalName = "lakemaker";
        release = 7149;
        versionName = "1.0";
        sha256 = "0cra73vq5hmbjhjphhd5ipiwf7r6kqgxqfs8czgzv3x5c6jhampg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "A TNT block that makes lakes/bodies of water.";

      };
    };

    "sylvester_kruin"."subways" = buildMinetestPackage rec {
      type = "mod";
      pname = "subways";
      version = "2022-10-09";
      src = fetchFromContentDB {
        author = "sylvester_kruin";
        technicalName = "subways";
        release = 14273;
        versionName = "2022-10-09";
        sha256 = "1rkpxfg31nbffzqs8m3y7zdgmnr7wiicj3nzs9v0xfdbwyinqxzd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Nice subways for Advanced Trains.";

      };
    };

    "talas"."colourhop" = buildMinetestPackage rec {
      type = "game";
      pname = "colourhop";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "talas";
        technicalName = "colourhop";
        release = 11925;
        versionName = "1.2.1";
        sha256 = "1mkz899qrancfn00yz506f57b3syacmrwccm9ygwc0y4h80620p2";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-or-later" ];
        description = "Help the jumping blobs defeat the evil dragons and bring colour back to the world.";

      };
    };

    "techniX"."ham_radio" = buildMinetestPackage rec {
      type = "mod";
      pname = "ham_radio";
      version = "1.2.2";
      src = fetchFromContentDB {
        author = "techniX";
        technicalName = "ham_radio";
        release = 5373;
        versionName = "1.2.2";
        sha256 = "0sy55fp69cqnjligmlryfwkm6jglysq344bp0rgij1palmdm64pc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Radio transmitters, beacons, and receivers";

      };
    };

    "texmex"."commons" = buildMinetestPackage rec {
      type = "mod";
      pname = "commons";
      version = "rolling";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "commons";
        release = 295;
        versionName = "rolling";
        sha256 = "0bvqc1wqh4yqgf4qhyzw58r43gm2wld4bskkfyr42x356zclw0cj";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Abolishes private property by melting the solid chest locks into air.";

      };
    };

    "texmex"."good_morning_craft" = buildMinetestPackage rec {
      type = "txp";
      pname = "good_morning_craft";
      version = "2019-03-05";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "good_morning_craft";
        release = 1118;
        versionName = "2019-03-05";
        sha256 = "1477daw59km0sa8vcm6p78iwwcvbqai77az9wvx0ffm53dzmx9h8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-NC-SA-3.0" spdx."CC-BY-SA-4.0" ];
        description = "A simple yet quirky texture pack by Louis Durrant";

      };
    };

    "texmex"."hbsprint" = buildMinetestPackage rec {
      type = "mod";
      pname = "hbsprint";
      version = "Use_inventory_image_for_nodes_without_tiles_for_particles";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "hbsprint";
        release = 6550;
        versionName = "Use inventory_image for nodes without tiles for particles";
        sha256 = "054b7japyc4002mxmp0na06d4hpqmqsqny6f5dbrr6ddlw8i70pk";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "A flexible sprint mod supporting stamina, hunger and monoids.";

      };
    };

    "texmex"."item_drop" = buildMinetestPackage rec {
      type = "mod";
      pname = "item_drop";
      version = "Fix_error_when_picking_up_a_node_with_deprecated_tile_definition___40_";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "item_drop";
        release = 14225;
        versionName = "Fix error when picking up a node with deprecated tile definition (#40)";
        sha256 = "091xirav8hfxdfc3wsrq7sl23345kni73xh4mwikfjknjgwr6b16";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "This mod adds Minecraft like drop/pick up of items to Minetest.";

      };
    };

    "texmex"."opening_hours" = buildMinetestPackage rec {
      type = "mod";
      pname = "opening_hours";
      version = "rolling";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "opening_hours";
        release = 298;
        versionName = "rolling";
        sha256 = "13y9c2mbkqb3iclhqa3infn7m0ykb84df17i9363460s0a6h1z2v";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Limits the days and hours a server is open to players.";

      };
    };

    "texmex"."sling" = buildMinetestPackage rec {
      type = "mod";
      pname = "sling";
      version = "rolling";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "sling";
        release = 128;
        versionName = "rolling";
        sha256 = "18bm1rqmzpj6y2njizlz5qaihd2a0k54nf6l021yh30xrvpk2yms";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Sling enables item stack and single item throwing of any item.";

      };
    };

    "texmex"."snowsong" = buildMinetestPackage rec {
      type = "mod";
      pname = "snowsong";
      version = "2019-07-01";
      src = fetchFromContentDB {
        author = "texmex";
        technicalName = "snowsong";
        release = 1613;
        versionName = "2019-07-01";
        sha256 = "0rl8g2ghh42fx9p7qrfz1g3h7pmj5k9wnbn7zycampym31zv7nw8";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "SnowSong, the EPIC Sound Pack";

      };
    };

    "theFox"."benchmark_engine" = buildMinetestPackage rec {
      type = "mod";
      pname = "benchmark_engine";
      version = "first_release";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "benchmark_engine";
        release = 1569;
        versionName = "first release";
        sha256 = "11i7jwgqhzpijfb1gmwj4p60j53893vc82mj53ivmfa6av0bb88c";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Engine for running benchmarks ingame.";

      };
    };

    "theFox"."chat_tools" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_tools";
      version = "2018-08-04";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "chat_tools";
        release = 505;
        versionName = "2018-08-04";
        sha256 = "04k1spgrdp10xg3v6i4ahfh6x799ip6m5p2ra6pam8srx6zmhi3m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "chat commands that people might need";

      };
    };

    "theFox"."factory" = buildMinetestPackage rec {
      type = "mod";
      pname = "factory";
      version = "3.4.0";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "factory";
        release = 4574;
        versionName = "3.4.0";
        sha256 = "1vhz2hc7gyxnw4z31r5lly5zp3zv5cjk7bzirpm1br2di441d3yv";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Industrialization for minetest";

      };
    };

    "theFox"."journal" = buildMinetestPackage rec {
      type = "mod";
      pname = "journal";
      version = "v1.1.0";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "journal";
        release = 5119;
        versionName = "v1.1.0";
        sha256 = "1930bq1ikkfx9yc4kbl8746ghqvc4alx9j6r9f2sq94yg2qxln7c";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Do you want to add story to your game? Make your protagonist write notes into his Journal.";

          homepage = "https://github.com/theFox6/journal_modpack/wiki";

      };
    };

    "theFox"."metavectors" = buildMinetestPackage rec {
      type = "mod";
      pname = "metavectors";
      version = "first_release";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "metavectors";
        release = 1568;
        versionName = "first release";
        sha256 = "11y00xqgfbkxzkacz442aq1mr33ymkd7x0zqdbrsm6x8xghh6fpi";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "vectors using metatables to make coding easier";

      };
    };

    "theFox"."microexpansion" = buildMinetestPackage rec {
      type = "mod";
      pname = "microexpansion";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "microexpansion";
        release = 7371;
        versionName = "v1.0.1";
        sha256 = "01v3l8gb2axxk3ng8sys7l9zhzgmw0a7nhs9prnd9xggwq9yfb7z";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A storage managing solution to get an overview over all your items.";

      };
    };

    "theFox"."modutil" = buildMinetestPackage rec {
      type = "mod";
      pname = "modutil";
      version = "v3.1";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "modutil";
        release = 11764;
        versionName = "v3.1";
        sha256 = "0dvqnj6h0qcx0rdxn6j4yhns9v3jbw051rjcy27zviikdwh3azh0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Providing some utilities that can be used by other mods.";

      };
    };

    "theFox"."pirate_story" = buildMinetestPackage rec {
      type = "mod";
      pname = "pirate_story";
      version = "v1.1";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "pirate_story";
        release = 3273;
        versionName = "v1.1";
        sha256 = "1s1x1wxzaz5kwm2nqbnpqq9xndcglvw8myjvyzh4rs5jgy1mpz6w";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "a story about a wannabe pirate";

      };
    };

    "theFox"."useful_contraptions" = buildMinetestPackage rec {
      type = "mod";
      pname = "useful_contraptions";
      version = "2018-09-09";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "useful_contraptions";
        release = 621;
        versionName = "2018-09-09";
        sha256 = "143km5m8bz1alg203z52s6q64dmcjqflf41dvf7kw9vcnrfh0gsb";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Some useful contraptions / machines.";

      };
    };

    "theFox"."weather" = buildMinetestPackage rec {
      type = "mod";
      pname = "weather";
      version = "v1.5";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "weather";
        release = 5343;
        versionName = "v1.5";
        sha256 = "1irkgp7fi6lh6dm8h4vmjkx1s642293s5q0glhg98ldiia5zrwhn";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A weather mod for minetest.";

      };
    };

    "theFox"."working_villages" = buildMinetestPackage rec {
      type = "mod";
      pname = "working_villages";
      version = "v1.5.2";
      src = fetchFromContentDB {
        author = "theFox";
        technicalName = "working_villages";
        release = 11763;
        versionName = "v1.5.2";
        sha256 = "1pd7x08sv0jd7hhv4s6is89prcnbmbhpj6zbn922jcmf28y7sh0k";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "A mod adding villager NPCs that are doing predefined work.";

      };
    };

    "the_raven_262"."furniture" = buildMinetestPackage rec {
      type = "mod";
      pname = "furniture";
      version = "2022-10-17";
      src = fetchFromContentDB {
        author = "the_raven_262";
        technicalName = "furniture";
        release = 14422;
        versionName = "2022-10-17";
        sha256 = "003qdflv38pdah199xzkpna6q110dr8yq93llj1fks0idvcpr03j";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."LGPL-2.1-or-later" ];
        description = "Creates furniture collections";

      };
    };

    "the_raven_262"."skygen" = buildMinetestPackage rec {
      type = "mod";
      pname = "skygen";
      version = "2022-09-07";
      src = fetchFromContentDB {
        author = "the_raven_262";
        technicalName = "skygen";
        release = 13747;
        versionName = "2022-09-07";
        sha256 = "0w3sa22dlm61jc07q1hrsk4gi9bxm58pqa04477wib3kc3z9yfvx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds the biome adaptive sky, sky-changing server-wide events and a skybox frontend. Currently only supports the MTG biomes.";

      };
    };

    "thediamondlego"."multitool" = buildMinetestPackage rec {
      type = "mod";
      pname = "multitool";
      version = "BUG_FIX";
      src = fetchFromContentDB {
        author = "thediamondlego";
        technicalName = "multitool";
        release = 1164;
        versionName = "BUG FIX";
        sha256 = "1mzbmfxvb6k4cmiabqj7pqkr5mm5hl1r38qrj5cmc49jc78sd2j5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Adds a new tool that does the job of all the other tools(except hoe and screwdriver). Also has bouble the durability of a diamond tool!";

      };
    };

    "thehumanarachnid"."infinite_wood" = buildMinetestPackage rec {
      type = "mod";
      pname = "infinite_wood";
      version = "Infinite_Wood";
      src = fetchFromContentDB {
        author = "thehumanarachnid";
        technicalName = "infinite_wood";
        release = 13003;
        versionName = "Infinite Wood";
        sha256 = "14d7cn9w6d5jn1jppbxwrc4qxxmqwijnidmn7mlpjwbg81csb5na";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "You can now get infinite wood in survival";

      };
    };

    "thomasthespacefox"."modern_ish" = buildMinetestPackage rec {
      type = "mod";
      pname = "modern_ish";
      version = "2.2.0";
      src = fetchFromContentDB {
        author = "thomasthespacefox";
        technicalName = "modern_ish";
        release = 5944;
        versionName = "2.2.0";
        sha256 = "0a3bgpc4f7ir7nn29zflwwa2afbfv5p9pal61mnk02sgm457v3h1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A collection of modern-ish odds and ends.";

      };
    };

    "threehymns"."unified_inventory_themes" = buildMinetestPackage rec {
      type = "mod";
      pname = "unified_inventory_themes";
      version = "1.03";
      src = fetchFromContentDB {
        author = "threehymns";
        technicalName = "unified_inventory_themes";
        release = 11691;
        versionName = "1.03";
        sha256 = "0j742j0i9x1jmhkxyad62rkmz3yv95ly913miv8m50zb5k4kvar8";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Adds a new theme to the unified_inventory. Support for multiple themes may come later.";

      };
    };

    "tinneh"."defaultpack_remastered" = buildMinetestPackage rec {
      type = "txp";
      pname = "defaultpack_remastered";
      version = "0.21";
      src = fetchFromContentDB {
        author = "tinneh";
        technicalName = "defaultpack_remastered";
        release = 13507;
        versionName = "0.21";
        sha256 = "1mc0cvh8as31hpr7gwvi75gdx16gx0jmzrwmmh178y7n4wxyk210";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "~Remastered version of the Minetest Game default texture pack – aims for a smoother and realistic look";

      };
    };

    "ulla"."cannabis" = buildMinetestPackage rec {
      type = "mod";
      pname = "cannabis";
      version = "2022-01-03";
      src = fetchFromContentDB {
        author = "ulla";
        technicalName = "cannabis";
        release = 10421;
        versionName = "2022-01-03";
        sha256 = "1pr5g5kaidii93cm6iakb5l0n0bcq3ykjyb5nm8csihn4ad3bimg";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "Hemp with all possible utility see readme.md | La canapa e tutti i suoi usi guardare il readme.md";

      };
    };

    "ulla"."jukeloopbox" = buildMinetestPackage rec {
      type = "mod";
      pname = "jukeloopbox";
      version = "2022-08-21";
      src = fetchFromContentDB {
        author = "ulla";
        technicalName = "jukeloopbox";
        release = 13478;
        versionName = "2022-08-21";
        sha256 = "0lycnxmq2acha268r0l5gv8j0k6i6zgnshvqwywgvx1vfq3mf5l7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "A simple jukebox that can be used for small looped tracks, or simply to listen to music ";

      };
    };

    "ulla"."nodeu" = buildMinetestPackage rec {
      type = "mod";
      pname = "nodeu";
      version = "NodeU";
      src = fetchFromContentDB {
        author = "ulla";
        technicalName = "nodeu";
        release = 12999;
        versionName = "NodeU";
        sha256 = "1bqamp38b6wsbi0ymgj86zdc57i06hcdrvimbfi5if1qqzch0mg6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "metal blocks stair railing coloured";

          homepage = "https://forum.minetest.net/viewtopic.php?f=9&t=20042&hilit=nodeu";

      };
    };

    "ulla"."ponti" = buildMinetestPackage rec {
      type = "mod";
      pname = "ponti";
      version = "2022-08-20";
      src = fetchFromContentDB {
        author = "ulla";
        technicalName = "ponti";
        release = 13447;
        versionName = "2022-08-20";
        sha256 = "04cm438hsrhbp8lslafn5iag42d0yfzhra5kkhky9l8h9bpm07ky";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "brige/door";

      };
    };

    "ulla"."summer" = buildMinetestPackage rec {
      type = "mod";
      pname = "summer";
      version = "V22.08.20";
      src = fetchFromContentDB {
        author = "ulla";
        technicalName = "summer";
        release = 13442;
        versionName = "V22.08.20";
        sha256 = "0ql1g3ss044qzjm6vr9y2nyajhl2mgq5j9ip8byqnj7dcg4z32i7";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "SUMMER";

      };
    };

    "v-rob"."bridger" = buildMinetestPackage rec {
      type = "mod";
      pname = "bridger";
      version = "1.1";
      src = fetchFromContentDB {
        author = "v-rob";
        technicalName = "bridger";
        release = 8569;
        versionName = "1.1";
        sha256 = "0q4n61w8iigww9bg46z5w48bi3flqva92q5apzsb3r72pbkk1788";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds a large number of advanced nodes conducive to building large, industrial bridges.";

      };
    };

    "v-rob"."glass_stained" = buildMinetestPackage rec {
      type = "mod";
      pname = "glass_stained";
      version = "1.0";
      src = fetchFromContentDB {
        author = "v-rob";
        technicalName = "glass_stained";
        release = 6066;
        versionName = "1.0";
        sha256 = "1h4xvikdyk1hpg15gbkh2yi8a3hbljyar9xpnm8zqi8hyg40iz6y";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds fancy and highly adaptable stained glass and spiked iron railing.";

      };
    };

    "v-rob"."slats" = buildMinetestPackage rec {
      type = "mod";
      pname = "slats";
      version = "1.0";
      src = fetchFromContentDB {
        author = "v-rob";
        technicalName = "slats";
        release = 6068;
        versionName = "1.0";
        sha256 = "14sk2pfi7yjnycdcd59dclwc11s0f5wlpsj2cfdpbd9qgknwjyyc";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "Adds decorative slats that have a lot of uses.";

      };
    };

    "v-rob"."walls_all" = buildMinetestPackage rec {
      type = "mod";
      pname = "walls_all";
      version = "2017-07-26";
      src = fetchFromContentDB {
        author = "v-rob";
        technicalName = "walls_all";
        release = 12989;
        versionName = "2017-07-26";
        sha256 = "06kn9hbqnjda9dp0wja6a46zwczsc2wav0cshsh4sg2fa6ppskf6";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds wall variants for every type of stone material.";

      };
    };

    "webdesigner97"."streets" = buildMinetestPackage rec {
      type = "mod";
      pname = "streets";
      version = "2018-02-04";
      src = fetchFromContentDB {
        author = "webdesigner97";
        technicalName = "streets";
        release = 105;
        versionName = "2018-02-04";
        sha256 = "0rr4m07gapgqqxz59p02v2qx5ycpg3la1dd88cwfc99idhl4lvjq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds modern roads to Minetest.";

      };
    };

    "wilkgr76"."admin_toys" = buildMinetestPackage rec {
      type = "mod";
      pname = "admin_toys";
      version = "2018-07-08";
      src = fetchFromContentDB {
        author = "wilkgr76";
        technicalName = "admin_toys";
        release = 363;
        versionName = "2018-07-08";
        sha256 = "1vz0lhfh87vs1jiwxsf7wz731z3jnyd8812dz17dl7x9kraxm3wc";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."WTFPL" ];
        description = "Tools for admins to have fun with cheating and otherwise rule-breaking players";

      };
    };

    "wowiamdiamonds"."unifiedbricks" = buildMinetestPackage rec {
      type = "mod";
      pname = "unifiedbricks";
      version = "2022-05-30";
      src = fetchFromContentDB {
        author = "wowiamdiamonds";
        technicalName = "unifiedbricks";
        release = 13165;
        versionName = "2022-05-30";
        sha256 = "0nqy2irdzc2larx8k3k8qi040jyjb88d4jr9amv3r5377wkykzl3";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "This mod allows the user to re-color default bricks using Unified Dyes, and provides some pattern variations as well.";

      };
    };

    "wsor4035"."c64_16px" = buildMinetestPackage rec {
      type = "txp";
      pname = "c64_16px";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "c64_16px";
        release = 13459;
        versionName = "1.0.0";
        sha256 = "18jk8hx8bh8yj82hd3mh490wq6ycfzkbif0d56847w2nh0sm70ps";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "c64 styled texture pack";

      };
    };

    "wsor4035"."farlands_reloaded" = buildMinetestPackage rec {
      type = "game";
      pname = "farlands_reloaded";
      version = "2022-03-27";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "farlands_reloaded";
        release = 11666;
        versionName = "2022-03-27";
        sha256 = "0z0vimrcwzmwnlf0p910yyypxrry6jhqqlk8v307p68m8plcznpb";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "a game";

      };
    };

    "wsor4035"."liquid_restriction" = buildMinetestPackage rec {
      type = "mod";
      pname = "liquid_restriction";
      version = "make_liquid_list_more_game_agnostic";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "liquid_restriction";
        release = 9588;
        versionName = "make liquid list more game agnostic";
        sha256 = "0bb5fzmm6ppim5z7xgaf5m2z62rp5wpy702bvcpqi1g7n5y7izix";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "restricts liquid use to a privilege";

      };
    };

    "wsor4035"."minekart" = buildMinetestPackage rec {
      type = "game";
      pname = "minekart";
      version = "2021-10-11";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "minekart";
        release = 9477;
        versionName = "2021-10-11";
        sha256 = "0gw3gr8zm81kmcx0pkq7i5hi3wyhgljlxfqb65r6sl8g6qns5k5w";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Racing game, with procedurally generated tracks";

      };
    };

    "wsor4035"."pick_axe_tweaks" = buildMinetestPackage rec {
      type = "mod";
      pname = "pick_axe_tweaks";
      version = "2021-09-30";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "pick_axe_tweaks";
        release = 9404;
        versionName = "2021-09-30";
        sha256 = "0vi7zbhs8l7cnn53bpdkk9wig2z4algrzjhswqsw8vsb086aksdw";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds the ability for pick axes to place light nodes on right click";

      };
    };

    "wsor4035"."shadowmute" = buildMinetestPackage rec {
      type = "mod";
      pname = "shadowmute";
      version = "2022-07-22";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "shadowmute";
        release = 12886;
        versionName = "2022-07-22";
        sha256 = "09jq5dfy1xkknlmijrbazvm12nimb14r7hsxd2rvx29nqqbfy8jm";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "allows muting and shadow muting players";

      };
    };

    "wsor4035"."tool_tweaks" = buildMinetestPackage rec {
      type = "txp";
      pname = "tool_tweaks";
      version = "1.0.0";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "tool_tweaks";
        release = 5837;
        versionName = "1.0.0";
        sha256 = "1xvr6h01xqhi163lcsyq4qgkwd6qybgdpl4aa46vklkmi6825y74";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" ];
        description = "simple adjustments to mtg tools";

      };
    };

    "wsor4035"."worldedit_maze" = buildMinetestPackage rec {
      type = "mod";
      pname = "worldedit_maze";
      version = "2021-10-17";
      src = fetchFromContentDB {
        author = "wsor4035";
        technicalName = "worldedit_maze";
        release = 9509;
        versionName = "2021-10-17";
        sha256 = "0hk9whjlr133849565ngv61r39f26381nsbn1q3cixvm709pcm48";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "A maze generator";

      };
    };

    "x2048"."cinematic" = buildMinetestPackage rec {
      type = "mod";
      pname = "cinematic";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "x2048";
        technicalName = "cinematic";
        release = 7122;
        versionName = "v1.0";
        sha256 = "03a3wd7lac7h617f8nj43my2apwfqv5q4w59hh5h0sp68pav26r9";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Commands for cinematic camera moves.";

      };
    };

    "x2048"."shadows" = buildMinetestPackage rec {
      type = "mod";
      pname = "shadows";
      version = "Alpha_3";
      src = fetchFromContentDB {
        author = "x2048";
        technicalName = "shadows";
        release = 7655;
        versionName = "Alpha 3";
        sha256 = "0dvrn6c957jch62kgjfy3k309b303djgyyl9dl75sx9h6cad9kb3";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC0-1.0" ];
        description = "Adds sunlight shadows to your world";

      };
    };

    "x2048"."terraform" = buildMinetestPackage rec {
      type = "mod";
      pname = "terraform";
      version = "1.2.1";
      src = fetchFromContentDB {
        author = "x2048";
        technicalName = "terraform";
        release = 7656;
        versionName = "1.2.1";
        sha256 = "0sr77pjqmjw2br1r9a722a9acl8csnrkw0f903avb5hdd6yys4lq";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC0-1.0" ];
        description = "Adds terraforming tools to your creative toolbox (WIP)";

      };
    };

    "x5dragonfire"."city_commoditymarket" = buildMinetestPackage rec {
      type = "mod";
      pname = "city_commoditymarket";
      version = "2022-2-17";
      src = fetchFromContentDB {
        author = "x5dragonfire";
        technicalName = "city_commoditymarket";
        release = 11341;
        versionName = "2022-2-17";
        sha256 = "0flcjjmys91kv8lqmhpxx2b2v3h89xszg1kqm2l2xn4rvpyxqnr6";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Adds simple CommodityMarkets for city's towns etc.";

      };
    };

    "xXNicoXx"."chat_filter" = buildMinetestPackage rec {
      type = "mod";
      pname = "chat_filter";
      version = "2021-01-29";
      src = fetchFromContentDB {
        author = "xXNicoXx";
        technicalName = "chat_filter";
        release = 7401;
        versionName = "2021-01-29";
        sha256 = "1r2g6c41cbdha3avasjvd1j914k6n68hhadmzjnfaa9y2dsmk0rq";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Minetest Chat Filter a simple but usefull minetest chatfilter mod made by xXNicoXx";

      };
    };

    "xXNicoXx"."wings" = buildMinetestPackage rec {
      type = "mod";
      pname = "wings";
      version = "2021-08-29";
      src = fetchFromContentDB {
        author = "xXNicoXx";
        technicalName = "wings";
        release = 9164;
        versionName = "2021-08-29";
        sha256 = "0r7v10g5jqkxg00pi3rxm58wz6apvkzg91rz3nyxbng05387432l";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Wings is a mod whiche allows server owners to give players fly privs while holding the wings (Like binoculars) made by xXNicoxx";

      };
    };

    "xenonca"."drawstruct" = buildMinetestPackage rec {
      type = "mod";
      pname = "drawstruct";
      version = "2021-09-26";
      src = fetchFromContentDB {
        author = "xenonca";
        technicalName = "drawstruct";
        release = 9363;
        versionName = "2021-09-26";
        sha256 = "1di719yws3cj4kc87ifbhmn8l31wqlpfzq5qkmynajh74j701y5a";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Draw or generate random structures";

          homepage = "https://xenonca.gitlab.io/content";

      };
    };

    "xenonca"."limited_lives" = buildMinetestPackage rec {
      type = "mod";
      pname = "limited_lives";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "xenonca";
        technicalName = "limited_lives";
        release = 13240;
        versionName = "v1.0";
        sha256 = "0066x3wdaby1g9ncn5ig9abqp1rwfbs7667yrixknmp5glihp83v";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."MIT" ];
        description = "Limits the times players can die.";

          homepage = "https://xenonca.gitlab.io/content/";

      };
    };

    "xenonca"."luckydude" = buildMinetestPackage rec {
      type = "game";
      pname = "luckydude";
      version = "1.3_Improve_Code";
      src = fetchFromContentDB {
        author = "xenonca";
        technicalName = "luckydude";
        release = 10139;
        versionName = "1.3 Improve Code";
        sha256 = "1g701kswjdl2nfjzdc712xmcrgaahs6q5jafz3d6jq5rck4zx0i3";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Can you guess which cube to hit last?";

          homepage = "https://xenonca.gitlab.io/content";

      };
    };

    "xenonca"."luckysweeper" = buildMinetestPackage rec {
      type = "game";
      pname = "luckysweeper";
      version = "0.6";
      src = fetchFromContentDB {
        author = "xenonca";
        technicalName = "luckysweeper";
        release = 10307;
        versionName = "0.6";
        sha256 = "1rnsvg94baz3jhqzzwzq35g5nazagxcl9r003yfyz5c1qckpb0q5";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."LGPL-2.1-only" ];
        description = "Proof of concept of a minesweeper game using the MTE.";

          homepage = "https://xenonca.gitlab.io/content";

      };
    };

    "xenonca"."mese_trains" = buildMinetestPackage rec {
      type = "mod";
      pname = "mese_trains";
      version = "v1.0_-_First_Release";
      src = fetchFromContentDB {
        author = "xenonca";
        technicalName = "mese_trains";
        release = 14198;
        versionName = "v1.0 - First Release";
        sha256 = "1nvpf01hhzf6y0r9h6q4fgbhv8nl6bdqhb0hdcwx94p3sns9qn6b";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."LGPL-2.1-only" ];
        description = "Some more trains for the advtrains mod.";

          homepage = "https://xenonca.gitlab.io/content";

      };
    };

    "xevin"."horadric_cube" = buildMinetestPackage rec {
      type = "mod";
      pname = "horadric_cube";
      version = "1.0.1";
      src = fetchFromContentDB {
        author = "xevin";
        technicalName = "horadric_cube";
        release = 14379;
        versionName = "1.0.1";
        sha256 = "110kbkjplbza3mgddxsisjbm9xmmcvvlr08mgwczp0h6m8c91csg";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."MIT" ];
        description = "An artifact that can transmute items";

      };
    };

    "yaman"."alter" = buildMinetestPackage rec {
      type = "game";
      pname = "alter";
      version = "2022-05-27";
      src = fetchFromContentDB {
        author = "yaman";
        technicalName = "alter";
        release = 12378;
        versionName = "2022-05-27";
        sha256 = "0354d40w414mjr3p8i5nnqr2qv9s0ybzsw8j8xc7ljdxh94q41wm";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-or-later" spdx."CC-BY-3.0" ];
        description = "A challenging puzzle game in a dystopian future.";

      };
    };

    "ymte"."spawn_chunk" = buildMinetestPackage rec {
      type = "mod";
      pname = "spawn_chunk";
      version = "1.0-RC6";
      src = fetchFromContentDB {
        author = "ymte";
        technicalName = "spawn_chunk";
        release = 14234;
        versionName = "1.0-RC6";
        sha256 = "1ng2b8gz1mnf2jyk70kvpf0qb121h72ix0qdb53wynmlbri02lw5";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Limits the player and its actions to the spawn chunk";

      };
    };

    "yw05"."train_remote" = buildMinetestPackage rec {
      type = "mod";
      pname = "train_remote";
      version = "rev17";
      src = fetchFromContentDB {
        author = "yw05";
        technicalName = "train_remote";
        release = 12055;
        versionName = "rev17";
        sha256 = "08jax7yacl41jb1q1jp3x22crg3xwy23f0q1a07pl06b680iv7sz";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "This mod allows you to remotely control trains. This is the implementation by Y. Wang.";

      };
    };

    "zaners123"."computertest" = buildMinetestPackage rec {
      type = "mod";
      pname = "computertest";
      version = "2022-01-05";
      src = fetchFromContentDB {
        author = "zaners123";
        technicalName = "computertest";
        release = 10465;
        versionName = "2022-01-05";
        sha256 = "1zhgfh4c1frbmanbw41c5ywsp8fmippgar45kkdb2jsspwvw35jy";
      };
      meta = src.meta // {
        license = [ spdx."MPL-2.0" ];
        description = "A ComputerCraft-inspired mod! Program them with LUA and watch them work!";

      };
    };

    "zayuim"."isabellaii" = buildMinetestPackage rec {
      type = "txp";
      pname = "isabellaii";
      version = "2019-03-15";
      src = fetchFromContentDB {
        author = "zayuim";
        technicalName = "isabellaii";
        release = 1187;
        versionName = "2019-03-15";
        sha256 = "15vdci2hq27i97vg3xjb54dd13nv7mlca5n0rxj4948y5rmmg820";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-2.0-only" spdx."CC-BY-3.0" ];
        description = "A moody texture pack by \"Bonemouse\"";

      };
    };

    "zeuner"."edutest" = buildMinetestPackage rec {
      type = "mod";
      pname = "edutest";
      version = "2020-04-12";
      src = fetchFromContentDB {
        author = "zeuner";
        technicalName = "edutest";
        release = 4602;
        versionName = "2020-04-12";
        sha256 = "0v4bczic2l5r0vqcnfq2b6rv1c2m8cg8pv4q6dz4m7j9hnjgycv5";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" spdx."CC0-1.0" ];
        description = "Provides a GUI frontend for the educational staff.";

      };
    };

    "zeuner"."edutest_chatcommands" = buildMinetestPackage rec {
      type = "mod";
      pname = "edutest_chatcommands";
      version = "2020-03-30";
      src = fetchFromContentDB {
        author = "zeuner";
        technicalName = "edutest_chatcommands";
        release = 4603;
        versionName = "2020-03-30";
        sha256 = "115sln3qzyzyc0my9vxg1x8k7z05bl3saihd45n4k6il68qsdikg";
      };
      meta = src.meta // {
        license = [ spdx."AGPL-3.0-only" ];
        description = "Provides chatcommands for the educational staff.";

      };
    };

    "zorman2000"."itemshelf" = buildMinetestPackage rec {
      type = "mod";
      pname = "itemshelf";
      version = "1.1";
      src = fetchFromContentDB {
        author = "zorman2000";
        technicalName = "itemshelf";
        release = 13969;
        versionName = "1.1";
        sha256 = "0iv1k6zlfbpml00ymiqxbf0fwyh32y82d5nprw2981xyjxm5j7li";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Generic item shelf with 3D items on display";

      };
    };

    "Excalibur_Zero"."brazier" = buildMinetestPackage rec {
      type = "mod";
      pname = "brazier";
      version = "2020-03-30";
      src = fetchFromContentDB {
        author = "Excalibur Zero";
        technicalName = "brazier";
        release = 8087;
        versionName = "2020-03-30";
        sha256 = "1d4i3zsg02jjfzjgk1z7iv2glv1syiwlqrbzwfbk641j833px1gm";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Fire braziers that cause flames to erupt one node above them that don't fade right away when are near flames or are punched.";

      };
    };

    "Gael_de_Sailly"."biomegen" = buildMinetestPackage rec {
      type = "mod";
      pname = "biomegen";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "Gael de Sailly";
        technicalName = "biomegen";
        release = 8705;
        versionName = "v1.0";
        sha256 = "005mnmnhp9vl20xp4w5lcwn6swai0wzjh2801nb10ix2pz8hbq3n";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Library to provide biomes and decorations for compatible Lua mapgens.";

      };
    };

    "Gael_de_Sailly"."mapfix" = buildMinetestPackage rec {
      type = "mod";
      pname = "mapfix";
      version = "2022-06-27";
      src = fetchFromContentDB {
        author = "Gael de Sailly";
        technicalName = "mapfix";
        release = 13168;
        versionName = "2022-06-27";
        sha256 = "1q7dhwna0h5jm4xngzm67bf64bh7mr0vxvwjgjaksv61djvznilg";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "Fix some map errors (flow and light problems)";

      };
    };

    "Gael_de_Sailly"."mapgen_rivers" = buildMinetestPackage rec {
      type = "mod";
      pname = "mapgen_rivers";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "Gael de Sailly";
        technicalName = "mapgen_rivers";
        release = 10569;
        versionName = "v1.0.2";
        sha256 = "00g0v92irhwmljp5zz0szspkj1s5d0wb9xqhagzg9llb9sykvbds";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-3.0-only" ];
        description = "Map generator focused on realistic rivers and landscapes, using physical equations.";

      };
    };

    "Gael_de_Sailly"."valleys_mapgen" = buildMinetestPackage rec {
      type = "mod";
      pname = "valleys_mapgen";
      version = "2.3";
      src = fetchFromContentDB {
        author = "Gael de Sailly";
        technicalName = "valleys_mapgen";
        release = 274;
        versionName = "2.3";
        sha256 = "1jj5c66vwsdkqasaj0jxyxmpwvxkijxqj9gk8iz9v26jkbqz8scw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-2.0-only" ];
        description = "A map generator with valleys, rivers, mountains and many plants.";

      };
    };

    "Grizzly_Adam"."bbq" = buildMinetestPackage rec {
      type = "mod";
      pname = "bbq";
      version = "2018-06-05";
      src = fetchFromContentDB {
        author = "Grizzly Adam";
        technicalName = "bbq";
        release = 226;
        versionName = "2018-06-05";
        sha256 = "1rr5lf709pn7bgvcb7ib2qskkx625ysvw672vn8p38binn79xiql";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-2.0-only" ];
        description = "Adds advanced BBQ items.";

      };
    };

    "Hugues_Ross"."cartographer" = buildMinetestPackage rec {
      type = "mod";
      pname = "cartographer";
      version = "1.2";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "cartographer";
        release = 11903;
        versionName = "1.2";
        sha256 = "0x70gsvn9lrrjjfmxrfcivl9m29nn4b0crpc5zqqsax5bn20qnaj";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "A mapmaking API. Needs additional mods to function.";

      };
    };

    "Hugues_Ross"."cartographer_minetest_game" = buildMinetestPackage rec {
      type = "mod";
      pname = "cartographer_minetest_game";
      version = "1.1";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "cartographer_minetest_game";
        release = 11904;
        versionName = "1.1";
        sha256 = "0jlbjhjfabpxwh3jyiyg59vy2z6rkkrcifwr4m9p69g33l95wwrx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds regional maps that you can craft and place (Minetest Game version)";

      };
    };

    "Hugues_Ross"."cartographer_repixture" = buildMinetestPackage rec {
      type = "mod";
      pname = "cartographer_repixture";
      version = "1.2";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "cartographer_repixture";
        release = 12096;
        versionName = "1.2";
        sha256 = "0k98q745s6nvs6ncpgzniksq5pgf80wyqvlqzr1fhwagqimi3mfp";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" spdx."GPL-3.0-only" ];
        description = "Adds regional maps that you can craft and place (Repixture version)";

      };
    };

    "Hugues_Ross"."fly_b_gone" = buildMinetestPackage rec {
      type = "mod";
      pname = "fly_b_gone";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "fly_b_gone";
        release = 2385;
        versionName = "v1.0.1";
        sha256 = "0fyqdb0v366ashvr23mnka4bfrx7dw72nk39rngn7qa1sx4j9dln";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "Hides butterflies/fireflies";

          homepage = "https://www.huguesross.net/";

      };
    };

    "Hugues_Ross"."mtg_craft_reverser" = buildMinetestPackage rec {
      type = "mod";
      pname = "mtg_craft_reverser";
      version = "v1.0";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "mtg_craft_reverser";
        release = 2927;
        versionName = "v1.0";
        sha256 = "10yzmm31i7vqsv4f719n2nqkhl1rzczjyldjaybvyx6ij0z61di5";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "Makes crafting recipes in Minetest Game reversible";

          homepage = "https://www.huguesross.net";

      };
    };

    "Hugues_Ross"."rpg16" = buildMinetestPackage rec {
      type = "txp";
      pname = "rpg16";
      version = "v1.4.2";
      src = fetchFromContentDB {
        author = "Hugues Ross";
        technicalName = "rpg16";
        release = 12636;
        versionName = "v1.4.2";
        sha256 = "1kwj0af8n8yvcvgwg1n0bbbwgsx34yj8gjp3fdszh2fili3zsi43";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-4.0" ];
        description = "A simple texturepack reminiscent of classic RPGs";

          homepage = "https://www.huguesross.net";

      };
    };

    "Hybrid_Dog"."bookmarks" = buildMinetestPackage rec {
      type = "mod";
      pname = "bookmarks";
      version = "v1.1.0";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "bookmarks";
        release = 9486;
        versionName = "v1.1.0";
        sha256 = "10qdcq0v80a7dr0ish7s8bahjjk7x1i9ji11p8z4y1i1sgxxz5il";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add commands to manage public positions of interest";

      };
    };

    "Hybrid_Dog"."cave_lighting" = buildMinetestPackage rec {
      type = "mod";
      pname = "cave_lighting";
      version = "v1.0.2";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "cave_lighting";
        release = 10200;
        versionName = "v1.0.2";
        sha256 = "0lhlip8kv0cqh0awh3yhshyip9xmkg0095ha8dgkkm68cnb7js1s";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Add two chatcommands to automatically light up dark places (e.g. caves) with lighting nodes such as torches.";

      };
    };

    "Hybrid_Dog"."connected_chests" = buildMinetestPackage rec {
      type = "mod";
      pname = "connected_chests";
      version = "2021-03-11";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "connected_chests";
        release = 8095;
        versionName = "2021-03-11";
        sha256 = "1yqgy29civbziaibr1scmxwldw72km8y0qdiqwdahk7478swz3j9";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Allows making bigger default chests.";

      };
    };

    "Hybrid_Dog"."function_delayer" = buildMinetestPackage rec {
      type = "mod";
      pname = "function_delayer";
      version = "2021-10-10";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "function_delayer";
        release = 12282;
        versionName = "2021-10-10";
        sha256 = "0ybip7bll17rgvpd7r2if510m2l9shxfvzkgzrmzlrqxdsmlpl1h";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Allows executing functions after a delay to reduce possible lag (EDD scheduler?)";

      };
    };

    "Hybrid_Dog"."glow_pack" = buildMinetestPackage rec {
      type = "mod";
      pname = "glow_pack";
      version = "v1.0.0";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "glow_pack";
        release = 10202;
        versionName = "v1.0.0";
        sha256 = "0h9z9dj1qqcb5dmq5sg34jj064l4imxsmc37llhv9qifyckg7yy6";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds glowing stone and lantern.";

      };
    };

    "Hybrid_Dog"."nether" = buildMinetestPackage rec {
      type = "mod";
      pname = "nether";
      version = "v2.0.0";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "nether";
        release = 13454;
        versionName = "v2.0.0";
        sha256 = "0759dmnrqfi5zyym5cffsdyb2blqb8m11ha9mijigm2h292qhfjw";
      };
      meta = src.meta // {
        license = [ spdx."GPL-3.0-only" ];
        description = "The underworld for Minetest.";

      };
    };

    "Hybrid_Dog"."nyanland" = buildMinetestPackage rec {
      type = "mod";
      pname = "nyanland";
      version = "2020-10-17";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "nyanland";
        release = 8085;
        versionName = "2020-10-17";
        sha256 = "1pwz50jipb5k1j23qd6f2aiif3cfz86rkl4jrx7f8ab56khrc7qx";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-SA-3.0" spdx."GPL-3.0-only" ];
        description = "Adds a nyanland in the sky";

      };
    };

    "Hybrid_Dog"."riesenpilz" = buildMinetestPackage rec {
      type = "mod";
      pname = "riesenpilz";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "riesenpilz";
        release = 10212;
        versionName = "v1.0.1";
        sha256 = "1yc8a1y5xa6g7s3h0ax5z54a9w9cmi37h9zzylxkkhqgzjjh32jd";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Add mushrooms and giant mushrooms.";

      };
    };

    "Hybrid_Dog"."sumpf" = buildMinetestPackage rec {
      type = "mod";
      pname = "sumpf";
      version = "v1.0.1__Changed_License";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "sumpf";
        release = 5446;
        versionName = "v1.0.1: Changed License";
        sha256 = "12k1zjjk9vgygsma3ykmnk73m8xy762j6scxmkbbwx4h6m0wkwc1";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-3.0" spdx."MIT" ];
        description = "Adds swamps";

      };
    };

    "Hybrid_Dog"."superpick" = buildMinetestPackage rec {
      type = "mod";
      pname = "superpick";
      version = "v1.0.1";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "superpick";
        release = 13463;
        versionName = "v1.0.1";
        sha256 = "10zx8vqbbdy42zxyq6lx62bxn33fjjgfy0pcdl0li1hxlw5lw8kl";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "A tool to remove any pointable node and reveal debug information";

      };
    };

    "Hybrid_Dog"."titanium" = buildMinetestPackage rec {
      type = "mod";
      pname = "titanium";
      version = "2022-09-05";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "titanium";
        release = 13699;
        versionName = "2022-09-05";
        sha256 = "08qfm892k8z5dbbxlf3rz9xd898i9s3sslazfy9mqcic7cq6avl4";
      };
      meta = src.meta // {
        license = [ spdx."WTFPL" ];
        description = "Adds titanium which is very strong and lasts for a long time. ";

      };
    };

    "Hybrid_Dog"."treecapitator" = buildMinetestPackage rec {
      type = "mod";
      pname = "treecapitator";
      version = "First_official_release";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "treecapitator";
        release = 9305;
        versionName = "First official release";
        sha256 = "0yq67swbc649h782w87g9bbjbx58y93qapfvkmhps0bff0xjjkwz";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" spdx."MIT" ];
        description = "It works like the timber mod but it destroys the leaves and the fruits, too.";

      };
    };

    "Hybrid_Dog"."vector_extras" = buildMinetestPackage rec {
      type = "mod";
      pname = "vector_extras";
      version = "v0.0.1";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "vector_extras";
        release = 10198;
        versionName = "v0.0.1";
        sha256 = "0s41y03zkbidg1lwh7gzl17dci29qy3zmp1af84s4g8xi4b57vq9";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Adds more vector functions.";

      };
    };

    "Hybrid_Dog"."we_undo" = buildMinetestPackage rec {
      type = "mod";
      pname = "we_undo";
      version = "First_release";
      src = fetchFromContentDB {
        author = "Hybrid Dog";
        technicalName = "we_undo";
        release = 9288;
        versionName = "First release";
        sha256 = "09h0g2bbnhx1m0mz27mx75l0gs1jbn5vkpjp1qzyjpwg3p1dmbai";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Undo and Redo executed WorldEdit chat commands";

      };
    };

    "LC_Creations"."luablock" = buildMinetestPackage rec {
      type = "mod";
      pname = "luablock";
      version = "2022-08-31";
      src = fetchFromContentDB {
        author = "LC Creations";
        technicalName = "luablock";
        release = 13650;
        versionName = "2022-08-31";
        sha256 = "1y0j05wkq9b8hqfrw2nqdsdz81kr8v3n42r8yrh4h8h7iyp5qsqh";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds blocks that can execute lua code. Admin purposes only.";

      };
    };

    "LC_Creations"."online_shop" = buildMinetestPackage rec {
      type = "mod";
      pname = "online_shop";
      version = "Online_Shopping_v1.0";
      src = fetchFromContentDB {
        author = "LC Creations";
        technicalName = "online_shop";
        release = 7829;
        versionName = "Online Shopping v1.0";
        sha256 = "012jdvwfi6safgnsya38pslk3mv67n28ml7a79w7641qh49fy58h";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Allows players to buy and trade anywhere.";

      };
    };

    "LC_Creations"."powerrangers_modpack" = buildMinetestPackage rec {
      type = "mod";
      pname = "powerrangers_modpack";
      version = "2022-08-23";
      src = fetchFromContentDB {
        author = "LC Creations";
        technicalName = "powerrangers_modpack";
        release = 13491;
        versionName = "2022-08-23";
        sha256 = "1wa433nd5y16irx6m77c0zla42bs5096ps8yr8lg5k2lglzjgrkf";
      };
      meta = src.meta // {
        license = [ spdx."LGPL-2.1-only" ];
        description = "Adds power rangers and an API to create your own.";

      };
    };

    "Mr._Rar"."edit" = buildMinetestPackage rec {
      type = "mod";
      pname = "edit";
      version = "2022-07-30";
      src = fetchFromContentDB {
        author = "Mr. Rar";
        technicalName = "edit";
        release = 12954;
        versionName = "2022-07-30";
        sha256 = "1g1yz6zdqrya9m578wwd3n0k7pbd7k971sd3ds08849czsk1gkna";
      };
      meta = src.meta // {
        license = [ spdx."CC0-1.0" ];
        description = "Allows copying, pasting, filling, deleting, opening and saving 3D areas";

      };
    };

    "Mr._Rar"."edit_skin" = buildMinetestPackage rec {
      type = "mod";
      pname = "edit_skin";
      version = "2022-10-04";
      src = fetchFromContentDB {
        author = "Mr. Rar";
        technicalName = "edit_skin";
        release = 14190;
        versionName = "2022-10-04";
        sha256 = "1xh49nndbhpxiqmag0x2z7m13pqa435vsch0cnvm4c9x7d58cr9r";
      };
      meta = src.meta // {
        license = [ spdx."CC-BY-4.0" spdx."MIT" ];
        description = "Advanced player skin customization";

      };
    };

    "Skamiz_Kazzarch"."touch" = buildMinetestPackage rec {
      type = "mod";
      pname = "touch";
      version = "2021-09-17";
      src = fetchFromContentDB {
        author = "Skamiz Kazzarch";
        technicalName = "touch";
        release = 14448;
        versionName = "2021-09-17";
        sha256 = "085ds8rbrf7gbfzn8xw33krlqmxvqhvpr9yds7c8z8yslmgkp7p0";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "Orient yourself in the darkness by touch.";

      };
    };

    "domtron_vox"."skillsframework" = buildMinetestPackage rec {
      type = "mod";
      pname = "skillsframework";
      version = "0.4";
      src = fetchFromContentDB {
        author = "domtron vox";
        technicalName = "skillsframework";
        release = 210;
        versionName = "0.4";
        sha256 = "1hqcn84ypxs8mzi82rb36fgh84fjfcb7s0gwsrqxja6z5jw15r4m";
      };
      meta = src.meta // {
        license = [ spdx."MIT" ];
        description = "SkillsFramework provides an API for creating and managing skills.";

      };
    };

}

