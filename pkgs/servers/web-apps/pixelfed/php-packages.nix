{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-1926277fc71d253dfa820271ac5987bdb193ccf5";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/1926277fc71d253dfa820271ac5987bdb193ccf5";
          sha256 = "037rdpys895vmk80zgb6r2c77ss2l545qsfma7q55kx9jm39habl";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-f481134d37b8303fa2e82ca7fe2a3124144057f6";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/f481134d37b8303fa2e82ca7fe2a3124144057f6";
          sha256 = "0ym593x000cm7yjsav0i53sq36np8d4r1j1zhbhfc06765s0x05q";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-8674e51bb65af933a5ffaf1c308a660387c35c22";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/8674e51bb65af933a5ffaf1c308a660387c35c22";
          sha256 = "0hb0w6m5rwzghw2im3yqn6ly2kvb3jgrv8jwra1lwd0ik6ckrngl";
        };
      };
    };
    "beyondcode/laravel-websockets" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "beyondcode-laravel-websockets-9ab87be1d96340979e67b462ea5fd6a8b06e6a02";
        src = fetchurl {
          url = "https://api.github.com/repos/beyondcode/laravel-websockets/zipball/9ab87be1d96340979e67b462ea5fd6a8b06e6a02";
          sha256 = "08iz2v882v0nhh23w92nv8yb66kbp03f2nqhz4y5nik04l3kyhrs";
        };
      };
    };
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-ca57d18f028f84f777b2168cd1911b0dee2343ae";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/ca57d18f028f84f777b2168cd1911b0dee2343ae";
          sha256 = "1nr1grrb9g5g3ihx94yk0amp8zx8prkkvg2934ygfc3rrv03cq9w";
        };
      };
    };
    "buzz/laravel-h-captcha" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "buzz-laravel-h-captcha-f2db3734203876ef1f69ba4dc0f4d9d71462f534";
        src = fetchurl {
          url = "https://api.github.com/repos/thinhbuzz/laravel-h-captcha/zipball/f2db3734203876ef1f69ba4dc0f4d9d71462f534";
          sha256 = "1zpjn2h2181g25acp9j40ll6yigqwpkhvwavxf2dgg08rw76z50h";
        };
      };
    };
    "cboden/ratchet" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cboden-ratchet-5012dc954541b40c5599d286fd40653f5716a38f";
        src = fetchurl {
          url = "https://api.github.com/repos/ratchetphp/Ratchet/zipball/5012dc954541b40c5599d286fd40653f5716a38f";
          sha256 = "0bi118mhc74cb4695kdhnh9k3im75zh3fvll12mzz7hfjmsivs17";
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dasprid-enum-8e6b6ea76eabbf19ea2bf5b67b98e1860474012f";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/8e6b6ea76eabbf19ea2bf5b67b98e1860474012f";
          sha256 = "0cckq42c9iyjfv7xmy6rl4xj3dn80v9k8qzc3ppdjm4wgj43rrkz";
        };
      };
    };
    "defuse/php-encryption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "defuse-php-encryption-77880488b9954b7884c25555c2a0ea9e7053f9d2";
        src = fetchurl {
          url = "https://api.github.com/repos/defuse/php-encryption/zipball/77880488b9954b7884c25555c2a0ea9e7053f9d2";
          sha256 = "1lcvpg56nw72cxyh6sga7fx94qw9l0l1y78z7y7ny3hgdniwhihx";
        };
      };
    };
    "dflydev/dot-access-data" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-dot-access-data-f41715465d65213d644d3141a6a93081be5d3549";
        src = fetchurl {
          url = "https://api.github.com/repos/dflydev/dflydev-dot-access-data/zipball/f41715465d65213d644d3141a6a93081be5d3549";
          sha256 = "1vgbjrq8qh06r26y5nlxfin4989r3h7dib1jifb2l3cjdn1r5bmj";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-1ca8f21980e770095a31456042471a57bc4c68fb";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/1ca8f21980e770095a31456042471a57bc4c68fb";
          sha256 = "1p8ia9g3mqz71bv4x8q1ng1fgcidmyksbsli1fjbialpgjk9k1ss";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-b4bd1cfbd2b916951696d82e57d054394d84864c";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/b4bd1cfbd2b916951696d82e57d054394d84864c";
          sha256 = "04qiilphjk1zx4j5pwjh0svi90ad7vrb94h3x02wscfracxbwhjz";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
          sha256 = "1sk1f020n0w7p7r4rsi7wnww85vljrim1i5h9wb0qiz2c4l8jj09";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-750671534e0241a7c50ea5b43f67e23eb5c96f32";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/750671534e0241a7c50ea5b43f67e23eb5c96f32";
          sha256 = "1inhh3k8ai8d6rhx5xsbdx0ifc3yjjfrahi0cy1npz9nx3383cfh";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-d9d313a36c872fd6ee06d9a6cbcf713eaa40f024";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/d9d313a36c872fd6ee06d9a6cbcf713eaa40f024";
          sha256 = "1z6y0mxqadarw76whppcl0h0cj7p5n6k7mxihggavq46i2wf7nhj";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-84a527db05647743d50373e0ec53a152f2cde568";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/84a527db05647743d50373e0ec53a152f2cde568";
          sha256 = "1wn3p8vjq3hqzn0k6dmwxdj2ykwk3653h5yw7a57avz9qkb86z70";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-782ca5968ab8b954773518e9e49a6f892a34b2a8";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/782ca5968ab8b954773518e9e49a6f892a34b2a8";
          sha256 = "18pxn1v3b2yhwzky22p4wn520h89rcrihl7l6hd0p769vk1b2qg9";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-3a85486b709bc384dae8eb78fb2eec649bdb64ff";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/3a85486b709bc384dae8eb78fb2eec649bdb64ff";
          sha256 = "1vbwd4fgg6910pfy0dpzkaf5djwzpx5nqr43hy2qpmkp11mkbbxw";
        };
      };
    };
    "evenement/evenement" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "evenement-evenement-531bfb9d15f8aa57454f5f0285b18bec903b8fb7";
        src = fetchurl {
          url = "https://api.github.com/repos/igorw/evenement/zipball/531bfb9d15f8aa57454f5f0285b18bec903b8fb7";
          sha256 = "02mi1lrga41caa25whr6sj9hmmlfjp10l0d0fq8kc3d4483pm9rr";
        };
      };
    };
    "ezyang/htmlpurifier" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ezyang-htmlpurifier-523407fb06eb9e5f3d59889b3978d5bfe94299c8";
        src = fetchurl {
          url = "https://api.github.com/repos/ezyang/htmlpurifier/zipball/523407fb06eb9e5f3d59889b3978d5bfe94299c8";
          sha256 = "1g65bndiwd2dmq5p6f29lh66x8lwxhpp1pmd619qbm8bnsy7hvki";
        };
      };
    };
    "facade/ignition-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-contracts-3c921a1cdba35b68a7f0ccffc6dffc1995b18267";
        src = fetchurl {
          url = "https://api.github.com/repos/facade/ignition-contracts/zipball/3c921a1cdba35b68a7f0ccffc6dffc1995b18267";
          sha256 = "1nsjwd1k9q8qmfvh7m50rs42yxzxyq4f56r6dq205gwcmqsjb2j0";
        };
      };
    };
    "fig/http-message-util" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fig-http-message-util-9d94dc0154230ac39e5bf89398b324a86f63f765";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message-util/zipball/9d94dc0154230ac39e5bf89398b324a86f63f765";
          sha256 = "1cbhchmvh8alqdaf31rmwldyrpi5cgmzgair1gnjv6nxn99m3pqf";
        };
      };
    };
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-e94e7353302b0c11ec3cfff7180cd0b1743975d2";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/e94e7353302b0c11ec3cfff7180cd0b1743975d2";
          sha256 = "1iv1252x141m7nhhxzg2bawfyzsvaprhlclhlyhacra9pd5ng61y";
        };
      };
    };
    "fruitcake/php-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-php-cors-58571acbaa5f9f462c9c77e911700ac66f446d4e";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/php-cors/zipball/58571acbaa5f9f462c9c77e911700ac66f446d4e";
          sha256 = "18xm69q4dk9zqfwgp938y2byhlyy9lr5x5qln4k2mg8cq8xr2sm1";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-672eff8cf1d6fe1ef09ca0f89c4b287d6a3eb831";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/672eff8cf1d6fe1ef09ca0f89c4b287d6a3eb831";
          sha256 = "156zbfs19r9g543phlpjwhqin3k2x4dsvr5p0wk7rk4j0wwp8l2v";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-fb7566caccf22d74d1ab270de3551f72a58399f5";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/fb7566caccf22d74d1ab270de3551f72a58399f5";
          sha256 = "0cmpq50s5xi9sg1dygllrhwj5dz5bxxj83xkvjspz63751xr51cs";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-67ab6e18aaa14d753cc148911d273f6e6cb6721e";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/67ab6e18aaa14d753cc148911d273f6e6cb6721e";
          sha256 = "0y3md6lkpk60kvmi607mgj29cfjg2bljc5nhfh3qf9hzk6c1b2j6";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-b635f279edd83fc275f822a1188157ffea568ff6";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/b635f279edd83fc275f822a1188157ffea568ff6";
          sha256 = "0734h3r8db06hcffagr8s7bxhjkvlfzvqg1klwmqidflwdwk7yj1";
        };
      };
    };
    "guzzlehttp/uri-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-uri-template-b945d74a55a25a949158444f09ec0d3c120d69e2";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/uri-template/zipball/b945d74a55a25a949158444f09ec0d3c120d69e2";
          sha256 = "02vd4r2di8xh9n5awfjy1lyb7vn5gkaynbiiqilm8did0r89qdhf";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-04be355f8d6734c826045d02a1079ad658322dad";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/04be355f8d6734c826045d02a1079ad658322dad";
          sha256 = "1cbg43hm2jgwb7gm1r9xcr4cpx8ng1zr93zx6shk9xhjlssnv0bx";
        };
      };
    };
    "jaybizzle/crawler-detect" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jaybizzle-crawler-detect-62d0e6b38f6715c673e156ffb0fc894791de3452";
        src = fetchurl {
          url = "https://api.github.com/repos/JayBizzle/Crawler-Detect/zipball/62d0e6b38f6715c673e156ffb0fc894791de3452";
          sha256 = "19wqayfrb38609hn90bb3y7zkr9rmpk17w7a430gxg6408hrpfm7";
        };
      };
    };
    "jenssegers/agent" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jenssegers-agent-daa11c43729510b3700bc34d414664966b03bffe";
        src = fetchurl {
          url = "https://api.github.com/repos/jenssegers/agent/zipball/daa11c43729510b3700bc34d414664966b03bffe";
          sha256 = "0f0wy69w9mdsajfgriwlnpqhqxp83q44p6ggcd6h1bi8ri3h0897";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-9e6dcff23ab1d4b522bef56074c31625cf077576";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/9e6dcff23ab1d4b522bef56074c31625cf077576";
          sha256 = "0nw3isfjmwqs1a4n3qvw0kvsg6jsrx5wcapkxdbcfp2lha0sbmld";
        };
      };
    };
    "laravel/helpers" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-helpers-4dd0f9436d3911611622a6ced8329a1710576f60";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/helpers/zipball/4dd0f9436d3911611622a6ced8329a1710576f60";
          sha256 = "1vqfrxf9q2mmgj5ckfnayryx0ia1fvyp6jpp8b689wb4a4vgpa8c";
        };
      };
    };
    "laravel/horizon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-horizon-4f762b1bd47b51f0557da84873a208410de9eece";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/horizon/zipball/4f762b1bd47b51f0557da84873a208410de9eece";
          sha256 = "0f9bxc63kqf1ljs1hv5g8h7j337wdy1xs0bcv45dwmh49f1fzkwm";
        };
      };
    };
    "laravel/passport" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-passport-48a03ffbfce7217b7ceba2c8e685ae8caa68db10";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/passport/zipball/48a03ffbfce7217b7ceba2c8e685ae8caa68db10";
          sha256 = "1lnz22l2jxixbhk0833kvx04xh97q0vz5rqc8dzggim22mdrpd0c";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-f23fe9d4e95255dacee1bf3525e0810d1a1b0f37";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/f23fe9d4e95255dacee1bf3525e0810d1a1b0f37";
          sha256 = "0dyvqph5q1lb6gl6ga4b1xkziqzj6s2ia5pbd7h40anm4sh3z8dl";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-04a2d3bd0d650c0764f70bf49d1ee39393e4eb10";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/04a2d3bd0d650c0764f70bf49d1ee39393e4eb10";
          sha256 = "06rivrmcf8m8hm4vn9s7wwpfmgl89p73b78dm0qx26rs0lpr36p0";
        };
      };
    };
    "laravel/ui" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-ui-a58ec468db4a340b33f3426c778784717a2c144b";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/ui/zipball/a58ec468db4a340b33f3426c778784717a2c144b";
          sha256 = "0qrfr7rbi5b90inx3xf5yy5p9h38rs9b2567p2vh3711w4kqjmqd";
        };
      };
    };
    "lcobucci/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lcobucci-clock-039ef98c6b57b101d10bd11d8fdfda12cbd996dc";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/clock/zipball/039ef98c6b57b101d10bd11d8fdfda12cbd996dc";
          sha256 = "03hlh6vl04jhhjkk6ps4wikypkg849wq8pdg221359l82ivz16hg";
        };
      };
    };
    "lcobucci/jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lcobucci-jwt-47bdb0e0b5d00c2f89ebe33e7e384c77e84e7c34";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/jwt/zipball/47bdb0e0b5d00c2f89ebe33e7e384c77e84e7c34";
          sha256 = "0bkkf98iflgdpryxm270wwgzw9id627h2iszjgw7ddkibn14lgq3";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-d44a24690f16b8c1808bf13b1bd54ae4c63ea048";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/d44a24690f16b8c1808bf13b1bd54ae4c63ea048";
          sha256 = "1qx99m1qa2g3l6r2fim3rak6qh28zjj8sqjj86nq743dm3yszygw";
        };
      };
    };
    "league/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-config-754b3604fb2984c71f4af4a9cbe7b57f346ec1f3";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/config/zipball/754b3604fb2984c71f4af4a9cbe7b57f346ec1f3";
          sha256 = "0yjb85cd0qa0mra995863dij2hmcwk9x124vs8lrwiylb0l3mn8s";
        };
      };
    };
    "league/event" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-event-d2cc124cf9a3fab2bb4ff963307f60361ce4d119";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/event/zipball/d2cc124cf9a3fab2bb4ff963307f60361ce4d119";
          sha256 = "1fc8aj0mpbrnh3b93gn8pypix28nf2gfvi403kfl7ibh5iz6ds5l";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-a141d430414fcb8bf797a18716b09f759a385bed";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/a141d430414fcb8bf797a18716b09f759a385bed";
          sha256 = "0w476nkv4izdrh8dn4g58lrqnfwrp8ijhj6fj8d8cpvr81kq0wiv";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-d8de61ee10b6a607e7996cff388c5a3a663e8c8a";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/d8de61ee10b6a607e7996cff388c5a3a663e8c8a";
          sha256 = "0hr11wwn2c2f26w0kj5yanx17ln17plk0si8yajkd470z3ssprwj";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-543f64c397fefdf9cfeac443ffb6beff602796b3";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/543f64c397fefdf9cfeac443ffb6beff602796b3";
          sha256 = "1f44jgjip7pgnjafwlazmbv9jap3xsw3jfzhgakbsa4bkx3aavr2";
        };
      };
    };
    "league/iso3166" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-iso3166-74a08ffe08d4e0dd8ab0aac8c34ea5a641d57669";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/iso3166/zipball/74a08ffe08d4e0dd8ab0aac8c34ea5a641d57669";
          sha256 = "0mh0rz7imb3zwi7lfhxinwfwqlrn7anp1xhskx6pg19w3jjm5rn4";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
          sha256 = "1a63nvqd6cz3vck3y8vjswn6c3cfwh13p0cn0ci5pqdf0bgjvvfz";
        };
      };
    };
    "league/oauth2-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-server-43cd4d406906c6be5c8de2cee9bd3ad3753544ef";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-server/zipball/43cd4d406906c6be5c8de2cee9bd3ad3753544ef";
          sha256 = "01amlk9r8srsk3603d56qswbq81hvksyw6jbn3i8f97l7fsdvaa9";
        };
      };
    };
    "league/uri" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-a700b4656e4c54371b799ac61e300ab25a2d1d39";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri/zipball/a700b4656e4c54371b799ac61e300ab25a2d1d39";
          sha256 = "1sjh26mapy1jrlryp6c55s7ghsamwabak1psz5lfs5d7z06vbasy";
        };
      };
    };
    "league/uri-interfaces" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-interfaces-00e7e2943f76d8cb50c7dfdc2f6dee356e15e383";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri-interfaces/zipball/00e7e2943f76d8cb50c7dfdc2f6dee356e15e383";
          sha256 = "01jllf6n9fs4yjcf6sjc4ivqp7k7dkqhbpz354bq9mr14njsjv6x";
        };
      };
    };
    "mobiledetect/mobiledetectlib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mobiledetect-mobiledetectlib-fc9cccd4d3706d5a7537b562b59cc18f9e4c0cb1";
        src = fetchurl {
          url = "https://api.github.com/repos/serbanghita/Mobile-Detect/zipball/fc9cccd4d3706d5a7537b562b59cc18f9e4c0cb1";
          sha256 = "1qmkrbdrfnxgd7lcgw7g30r8qc6yg1c9lkdam54zhgxhcc2ryxqs";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-9b5daeaffce5b926cac47923798bba91059e60e2";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/9b5daeaffce5b926cac47923798bba91059e60e2";
          sha256 = "18nll4p6fh5zmw2wgzgp4lznkqqr6d598663rrji424dfpv55233";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-9b87907a81b87bc76d19a7fb2d61e61486ee9edb";
        src = fetchurl {
          url = "https://api.github.com/repos/jmespath/jmespath.php/zipball/9b87907a81b87bc76d19a7fb2d61e61486ee9edb";
          sha256 = "1ig3gi6f8gisagcn876598ps48s86s6m0c82diyksylarg3yn0yd";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-c1001b3bc75039b07f38a79db5237c4c529e04c8";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/c1001b3bc75039b07f38a79db5237c4c529e04c8";
          sha256 = "0w5gk7b05pfsbf091plfr0ag6sx6h90sckz1phr46kd6cnrzk3rh";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-abbdbb70e0245d5f3bf77874cea1dfb0c930d06f";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/abbdbb70e0245d5f3bf77874cea1dfb0c930d06f";
          sha256 = "16i8gim0jpmmbq0pp4faw8kn2448yvpgsd1zvipbv9xrk37vah5q";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-cacdbf5a91a657ede665c541eda28941d4b09c1e";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/cacdbf5a91a657ede665c541eda28941d4b09c1e";
          sha256 = "0v3as5xdmr9j7d4q4ly18f7g8g0sjcy25l4ispsdp60byldi7m8h";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-11e2663a5bc9db5d714eedb4277ee300403b4a9e";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/11e2663a5bc9db5d714eedb4277ee300403b4a9e";
          sha256 = "1kkz11dsc11zhflc8wxjxxa8xjww371nwkmjf7ncn0spjf6hx4g5";
        };
      };
    };
    "nunomaduro/termwind" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-termwind-8ab0b32c8caa4a2e09700ea32925441385e4a5dc";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/termwind/zipball/8ab0b32c8caa4a2e09700ea32925441385e4a5dc";
          sha256 = "1g75vpq7014s5yd6bvj78b88ia31slkikdhjv8iprz987qm5dnl7";
        };
      };
    };
    "nyholm/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nyholm-psr7-3cb4d163b58589e47b35103e8e5e6a6a475b47be";
        src = fetchurl {
          url = "https://api.github.com/repos/Nyholm/psr7/zipball/3cb4d163b58589e47b35103e8e5e6a6a475b47be";
          sha256 = "1wbg5fcqkv8bg1ll0ndxp3jmi353sz6cd6gzdldbh35p1b2mp4jm";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-58c3f47f650c94ec05a151692652a868995d2938";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/58c3f47f650c94ec05a151692652a868995d2938";
          sha256 = "0i9km0lzvc7df9758fm1p3y0679pzvr5m9x3mrz0d2hxlppsm764";
        };
      };
    };
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-996434e5492cb4c3edcb9168db6fbb1359ef965a";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a";
          sha256 = "0ky7lal59dihf969r1k3pb96ql8zzdc5062jdbg69j6rj0scgkyx";
        };
      };
    };
    "paragonie/sodium_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-sodium_compat-e592a3e06d1fa0d43988c7c7d9948ca836f644b6";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/sodium_compat/zipball/e592a3e06d1fa0d43988c7c7d9948ca836f644b6";
          sha256 = "0jp8il8mx5ylfx03wqa068437xidrrcgwsfcwxi9qbafhds3mhnm";
        };
      };
    };
    "pbmedia/laravel-ffmpeg" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pbmedia-laravel-ffmpeg-820e7f1290918233a59d85f25bc78796dc3f57bb";
        src = fetchurl {
          url = "https://api.github.com/repos/protonemedia/laravel-ffmpeg/zipball/820e7f1290918233a59d85f25bc78796dc3f57bb";
          sha256 = "1lp7wz2jrfwcnzpi1nv1rixqqmr244lqbjz6zw3p6pxkb50wdwsd";
        };
      };
    };
    "php-ffmpeg/php-ffmpeg" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-ffmpeg-php-ffmpeg-eace6f174ff6d206ba648483ebe59760f7f6a0e1";
        src = fetchurl {
          url = "https://api.github.com/repos/PHP-FFMpeg/PHP-FFMpeg/zipball/eace6f174ff6d206ba648483ebe59760f7f6a0e1";
          sha256 = "0x0cp8r8vdcsyj92wyfk4khq6w5a6522imqyf83q00xf9fcxgm0a";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-dd3a383e599f49777d8b628dadbb90cae435b87e";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/dd3a383e599f49777d8b628dadbb90cae435b87e";
          sha256 = "029gpfa66hwg395jvf7swcvrj085wsw5fw6041nrl5kbc36fvwlb";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-665d289f59e646a259ebf13f29be7f6f54cab24b";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/665d289f59e646a259ebf13f29be7f6f54cab24b";
          sha256 = "15l7plmvgq51dly43vsqa66v03m93hcfndapmmjrqywqhb2g4jwv";
        };
      };
    };
    "pixelfed/fractal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-fractal-faff10c9f3e3300b1571ef41926f933a9cce4782";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/fractal/zipball/faff10c9f3e3300b1571ef41926f933a9cce4782";
          sha256 = "054zbf39ghxk7xydphikxpgkw7hivxmjqzwpcqnpw2vpn3giwfay";
        };
      };
    };
    "pixelfed/laravel-snowflake" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-laravel-snowflake-69255870dcbf949feac889dfc09180a6fef77f6d";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/laravel-snowflake/zipball/69255870dcbf949feac889dfc09180a6fef77f6d";
          sha256 = "1wsgl9066z1zs751msqn5ydc6mz9m22wchy56qk9igjnjmk6g2pj";
        };
      };
    };
    "pixelfed/zttp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-zttp-e78af39d75171f360ab4c32eed1c7a71b67b5e3b";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/zttp/zipball/e78af39d75171f360ab4c32eed1c7a71b67b5e3b";
          sha256 = "0rm4rfkx9kirjfyx0rpvhl7885w4b576f0dra9wjxjz6l3gk2bp0";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-80c3d801b31fe165f8fe99ea085e0a37834e1be3";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa/zipball/80c3d801b31fe165f8fe99ea085e0a37834e1be3";
          sha256 = "0qfjgkl02ifc0zicv3d5d6zs8mwpq68bg211jy3psgghnqpxyhlm";
        };
      };
    };
    "predis/predis" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "predis-predis-a77a43913a74f9331f637bb12867eb8e274814e5";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/a77a43913a74f9331f637bb12867eb8e274814e5";
          sha256 = "17xby6nk7nv1gww7hgsd1rzm40ghxx6xg6pfb3zqm40vsg25grrg";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/aa5030cfa5405eccfdcb1083ce040c2cb8d253bf";
          sha256 = "07rnyjwb445sfj30v5ny3gfsgc1m7j7cyvwjgs2cm9slns1k1ml8";
        };
      };
    };
    "psr/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-clock-e41a24703d4560fd0acb709162f73b8adfc3aa0d";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/clock/zipball/e41a24703d4560fd0acb709162f73b8adfc3aa0d";
          sha256 = "0wz5b8hgkxn3jg88cb3901hj71axsj0fil6pwl413igghch6i8kj";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-c71ecc56dfe541dbd90c5360474fbc405f8d5963";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/c71ecc56dfe541dbd90c5360474fbc405f8d5963";
          sha256 = "1mvan38yb65hwk68hl0p7jymwzr4zfnaxmwjbw7nj3rsknvga49i";
        };
      };
    };
    "psr/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-event-dispatcher-dbefd12671e8a14ec7f180cab83036ed26714bb0";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/event-dispatcher/zipball/dbefd12671e8a14ec7f180cab83036ed26714bb0";
          sha256 = "05nicsd9lwl467bsv4sn44fjnnvqvzj1xqw2mmz9bac9zm66fsjd";
        };
      };
    };
    "psr/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-client-0955afe48220520692d2d09f7ab7e0f93ffd6a31";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/0955afe48220520692d2d09f7ab7e0f93ffd6a31";
          sha256 = "09r970lfpwil861gzm47446ck1s6km6ijibkxl13p1ymwdchnv6m";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-e616d01114759c4c489f93b099585439f795fe35";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/e616d01114759c4c489f93b099585439f795fe35";
          sha256 = "1vzimn3h01lfz0jx0lh3cy9whr3kdh103m1fw07qric4pnnz5kx8";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-cb6ce4845ce34a8ad9e68117c10ee90a29919eba";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/cb6ce4845ce34a8ad9e68117c10ee90a29919eba";
          sha256 = "1s87sajxsxl30ciqyhx0vir2pai63va4ssbnq7ki6s050i4vm80h";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-fe5ea303b0887d5caefd3d431c3e61ad47037001";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/fe5ea303b0887d5caefd3d431c3e61ad47037001";
          sha256 = "0a0rwg38vdkmal3nwsgx58z06qkfl85w2yvhbgwg45anr0b3bhmv";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-764e0b3939f5ca87cb904f570ef9be2d78a07865";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/764e0b3939f5ca87cb904f570ef9be2d78a07865";
          sha256 = "0hgcanvd9gqwkaaaq41lh8fsfdraxmp2n611lvqv69jwm1iy76g8";
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-4f00ee9e236fa6a48f4560d1300b9c961a70a7ec";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/4f00ee9e236fa6a48f4560d1300b9c961a70a7ec";
          sha256 = "10754cxjwjf818g7i3vyd4jk0sy8r3i36jxpqk38n70ckasdd7w0";
        };
      };
    };
    "pusher/pusher-php-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pusher-pusher-php-server-416e68dd5f640175ad5982131c42a7a666d1d8e9";
        src = fetchurl {
          url = "https://api.github.com/repos/pusher/pusher-http-php/zipball/416e68dd5f640175ad5982131c42a7a666d1d8e9";
          sha256 = "13vrpfrpq7g92fshlb5s0pmpyxihmx4267cm1szrwpvza50iirqs";
        };
      };
    };
    "ralouphie/getallheaders" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ralouphie-getallheaders-120b605dfeb996808c31b6477290a714d356e822";
        src = fetchurl {
          url = "https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822";
          sha256 = "1bv7ndkkankrqlr2b4kw7qp3fl0dxi6bp26bnim6dnlhavd6a0gg";
        };
      };
    };
    "ramsey/collection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-collection-a4b48764bfbb8f3a6a4d1aeb1a35bb5e9ecac4a5";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/a4b48764bfbb8f3a6a4d1aeb1a35bb5e9ecac4a5";
          sha256 = "0y5s9rbs023sw94yzvxr8fn9rr7xw03f08zmc9n9jl49zlr5s52p";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-60a4c63ab724854332900504274f6150ff26d286";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/60a4c63ab724854332900504274f6150ff26d286";
          sha256 = "1w1i50pbd18awmvzqjkbszw79dl09912ibn95qm8lxr4nsjvbb27";
        };
      };
    };
    "ratchet/rfc6455" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ratchet-rfc6455-7c964514e93456a52a99a20fcfa0de242a43ccdb";
        src = fetchurl {
          url = "https://api.github.com/repos/ratchetphp/RFC6455/zipball/7c964514e93456a52a99a20fcfa0de242a43ccdb";
          sha256 = "1jw7by1y4aky6v1xjr7fl2y4bwag57mnfqqsbn8sxcz99q0yjzlb";
        };
      };
    };
    "react/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-cache-d47c472b64aa5608225f47965a484b75c7817d5b";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/cache/zipball/d47c472b64aa5608225f47965a484b75c7817d5b";
          sha256 = "0qz43ah5jrbixbzndzx70vyfg5mxg0qsha0bhc136jrrgp9sk4sp";
        };
      };
    };
    "react/dns" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-dns-a5427e7dfa47713e438016905605819d101f238c";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/dns/zipball/a5427e7dfa47713e438016905605819d101f238c";
          sha256 = "1dr6hwkxdmkg8pnj497v4x566fyn92h3qrkbfvgsrmhi3cc3gidb";
        };
      };
    };
    "react/event-loop" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-event-loop-6e7e587714fff7a83dcc7025aee42ab3b265ae05";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/event-loop/zipball/6e7e587714fff7a83dcc7025aee42ab3b265ae05";
          sha256 = "0f71ahram6w45ksnvscgsgw163m1wylipnpvc4a7gmwzncl9fkw7";
        };
      };
    };
    "react/http" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-http-bb3154dbaf2dfe3f0467f956a05f614a69d5f1d0";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/http/zipball/bb3154dbaf2dfe3f0467f956a05f614a69d5f1d0";
          sha256 = "012idw77hrkdhcxh6vb3mfq0i21zbwqkibmrmh9ln5x4c3z4yn7a";
        };
      };
    };
    "react/promise" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-f913fb8cceba1e6644b7b90c4bfb678ed8a3ef38";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise/zipball/f913fb8cceba1e6644b7b90c4bfb678ed8a3ef38";
          sha256 = "1awzjaryj6lyi5wn0rmzwf5wyn1lg5wl3c6jp88i1gc9mp50g0n4";
        };
      };
    };
    "react/promise-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-timer-aa7a73c74b8d8c0f622f5982ff7b0351bc29e495";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise-timer/zipball/aa7a73c74b8d8c0f622f5982ff7b0351bc29e495";
          sha256 = "1a7l9by70ygpp101arn217zvrpaddzsm2fywxd0nzc964jcq5mgd";
        };
      };
    };
    "react/socket" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-socket-81e1b4d7f5450ebd8d2e9a95bb008bb15ca95a7b";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/socket/zipball/81e1b4d7f5450ebd8d2e9a95bb008bb15ca95a7b";
          sha256 = "0s22mfcima1plb5i10dy8kd9zz4h0apxk9s8frydc3kd27vl6fvv";
        };
      };
    };
    "react/stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-stream-7a423506ee1903e89f1e08ec5f0ed430ff784ae9";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/stream/zipball/7a423506ee1903e89f1e08ec5f0ed430ff784ae9";
          sha256 = "1vcn792785hg0991vz3fhdmwl5y47z4g7hvly04y03zmbc0qx0mf";
        };
      };
    };
    "ringcentral/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ringcentral-psr7-360faaec4b563958b673fb52bbe94e37f14bc686";
        src = fetchurl {
          url = "https://api.github.com/repos/ringcentral/psr7/zipball/360faaec4b563958b673fb52bbe94e37f14bc686";
          sha256 = "1j59spmy83gyzc05wl2j92ly51d67bpvgd7nmxma8a8j8vrh063w";
        };
      };
    };
    "spatie/db-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-db-dumper-3b9fd47899bf6a59d3452392121c9ce675d55d34";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/db-dumper/zipball/3b9fd47899bf6a59d3452392121c9ce675d55d34";
          sha256 = "0w9maf9gz8s76whxfq93wm1r795j82l76y0xypqabrr3kngkmzas";
        };
      };
    };
    "spatie/image-optimizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-image-optimizer-d997e01ba980b2769ddca2f00badd3b80c2a2512";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/image-optimizer/zipball/d997e01ba980b2769ddca2f00badd3b80c2a2512";
          sha256 = "0pqyx30ylwsgdh1rz946crjphb0p4qvdvkw4lcbq99g6v36p7ngk";
        };
      };
    };
    "spatie/laravel-backup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-backup-a743a8bc21e388e5cc1bceff676859180f018771";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-backup/zipball/a743a8bc21e388e5cc1bceff676859180f018771";
          sha256 = "1k7vygfjf784a6wnr5w3qhzgh7vz7hgvrshb4b994yk4f8ggr3hk";
        };
      };
    };
    "spatie/laravel-image-optimizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-image-optimizer-cd8945e47b9fd01bc7b770eecd57c56f46c47422";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-image-optimizer/zipball/cd8945e47b9fd01bc7b770eecd57c56f46c47422";
          sha256 = "0zp3dnnj3l9xsz4f3w2c7pk20mvq8dcfy2zc943hlr5ffz7bjg6x";
        };
      };
    };
    "spatie/laravel-package-tools" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-package-tools-efab1844b8826443135201c4443690f032c3d533";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-package-tools/zipball/efab1844b8826443135201c4443690f032c3d533";
          sha256 = "1527wh9gyb5k066fmmyngvyy2ldkmc34glqx2dk9swflc1jfjgpb";
        };
      };
    };
    "spatie/laravel-signal-aware-command" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-signal-aware-command-46cda09a85aef3fd47fb73ddc7081f963e255571";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-signal-aware-command/zipball/46cda09a85aef3fd47fb73ddc7081f963e255571";
          sha256 = "1h4qa1zrpwr6ly5lwvsjb60wya92ys608xij9x01v3nm69r99939";
        };
      };
    };
    "spatie/temporary-directory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-temporary-directory-0c804873f6b4042aa8836839dca683c7d0f71831";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/temporary-directory/zipball/0c804873f6b4042aa8836839dca683c7d0f71831";
          sha256 = "007vxm2x1anrlnzwhrqyk4nw7yflaicfhr4q9wlp5bhy7d3ixljr";
        };
      };
    };
    "stevebauman/purify" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "stevebauman-purify-7b63762b05db9eadc36d7e8b74cf58fa64bfa527";
        src = fetchurl {
          url = "https://api.github.com/repos/stevebauman/purify/zipball/7b63762b05db9eadc36d7e8b74cf58fa64bfa527";
          sha256 = "08l5qhx7awd64mivxwhim1vm007h5l244g3ssshz56i44qqji673";
        };
      };
    };
    "symfony/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-1ce7ed8e7ca6948892b6a3a52bb60cf2b04f7c94";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache/zipball/1ce7ed8e7ca6948892b6a3a52bb60cf2b04f7c94";
          sha256 = "0n9f8snanv7gxgi7kwjq8z3isjirhjc44ciw2ss3glij63864rwj";
        };
      };
    };
    "symfony/cache-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-contracts-eeb71f04b6f7f34ca6d15633df82e014528b1632";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache-contracts/zipball/eeb71f04b6f7f34ca6d15633df82e014528b1632";
          sha256 = "13dcrpy31arn3v1kns83zndhbyzngwc7ic3vc5c6x7kmv23s5l0x";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-5aa03db8ef0a5457c316ec580e69562d97734c77";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/5aa03db8ef0a5457c316ec580e69562d97734c77";
          sha256 = "1dc90j27brsidzp025rz3jkk3ir1qyk9chlp2b6vbg617yyr8ipk";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-aedf3cb0f5b929ec255d96bbb4909e9932c769e0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/aedf3cb0f5b929ec255d96bbb4909e9932c769e0";
          sha256 = "1sr492i55w1shyzp365a2xb50fsb0arkf2idckd8icck54k3zdgf";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-e2d1534420bd723d0ef5aec58a22c5fe60ce6f5e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/e2d1534420bd723d0ef5aec58a22c5fe60ce6f5e";
          sha256 = "1z7akdycl5ar42vs1kc00ggm5rbqw0lx7i3acbcbfhnwmdxsmcxh";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-e847ba47e7a8f9708082990cb40ab4ff0440a11e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/e847ba47e7a8f9708082990cb40ab4ff0440a11e";
          sha256 = "1ffx7y5pcsxwb95jxdir8kx06p27bkf2bs7c7qbqmlkb6srga1pg";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-04046f35fd7d72f9646e721fc2ecb8f9c67d3339";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/04046f35fd7d72f9646e721fc2ecb8f9c67d3339";
          sha256 = "1va0impcvcmbf3v8xpjkwrm0l5w14pb2n2fs2k29xp23xjd7lnil";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-0ad3b6f1e4e2da5690fefe075cd53a238646d8dd";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/0ad3b6f1e4e2da5690fefe075cd53a238646d8dd";
          sha256 = "0yqg0h2kf4mij39nisshvg5gssn6aqyqphngi05z6jfd0q89a46x";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-20808dc6631aecafbe67c186af5dcb370be3a0eb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/20808dc6631aecafbe67c186af5dcb370be3a0eb";
          sha256 = "113yidfp8sjkv200kx4pi81zn0v0r9gmq8dw7p3zvhc23k1hinh8";
        };
      };
    };
    "symfony/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-39f679c12648cc43bd9f0db12cc69b82041b91a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client/zipball/39f679c12648cc43bd9f0db12cc69b82041b91a1";
          sha256 = "1mn4nf6hwxdgb0x8xmrfmgbayyr1hy613w632ag8rj582bfmag6z";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-df2ecd6cb70e73c1080e6478aea85f5f4da2c48b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client-contracts/zipball/df2ecd6cb70e73c1080e6478aea85f5f4da2c48b";
          sha256 = "0ch1kzfxszbaw75rrn9x8f26rx1ikjnygdckhgs8cgn5y1ivp0im";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-df27f4191a4292d01fd062296e09cbc8b657cb57";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/df27f4191a4292d01fd062296e09cbc8b657cb57";
          sha256 = "1kdzs427q1qxbd3209fpwas3dq40ihjm0skbh6avxarwsyw9vfwk";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-954a1a3b178309b216261eedc735c079709e4ab3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/954a1a3b178309b216261eedc735c079709e4ab3";
          sha256 = "1iga2bbshrm7d9m90bxmqkh5crzwzziqfyw3g62b6z01iwrp1k42";
        };
      };
    };
    "symfony/mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailer-bfcfa015c67e19c6fdb7ca6fe70700af1e740a17";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailer/zipball/bfcfa015c67e19c6fdb7ca6fe70700af1e740a17";
          sha256 = "1i6q57w3jhfy69z86jyqvjwx7y50rl8z3y7n6gc1kafw97g1yyn8";
        };
      };
    };
    "symfony/mailgun-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailgun-mailer-2c9d47b11cc154d2db3f571030cd965d128de1a8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailgun-mailer/zipball/2c9d47b11cc154d2db3f571030cd965d128de1a8";
          sha256 = "0ppsp07mkj382s4h4wh1g5f0w104a4brw6vl3dwr6kjciakxc3hd";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-b6c137fc53a9f7c4c951cd3f362b3734c7a97723";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/b6c137fc53a9f7c4c951cd3f362b3734c7a97723";
          sha256 = "1cy2xp4hw8lz3d1n5qc5q5afpzk2y7n0kkn0gl68dnn5ffd06xmr";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-5bbc823adecdae860bb64756d639ecfec17b050a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/5bbc823adecdae860bb64756d639ecfec17b050a";
          sha256 = "0vyv70z1yi2is727d1mkb961w5r1pb1v3wy1pvdp30h8ffy15wk6";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-511a08c03c1960e08a883f4cffcacd219b758354";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/511a08c03c1960e08a883f4cffcacd219b758354";
          sha256 = "0ifsgsyxf0z0nkynqvr5259dm5dsmbgdpvyi5zfvy8935mi0ki0i";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-639084e360537a19f9ee352433b84ce831f3d2da";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/639084e360537a19f9ee352433b84ce831f3d2da";
          sha256 = "1i2wcsbfbwdyrx8545yrrvbdaf4l2393pjvg9266q74611j6pzxj";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-19bd1e4fcd5b91116f14d8533c57831ed00571b6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/19bd1e4fcd5b91116f14d8533c57831ed00571b6";
          sha256 = "1d80jph5ykiw6ydv8fwd43s0aglh24qc1yrzds2f3aqanpbk1gr2";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-8ad114f6b39e2c98a8b0e3bd907732c207c2b534";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/8ad114f6b39e2c98a8b0e3bd907732c207c2b534";
          sha256 = "1ym84qp609i50lv4vkd4yz99y19kaxd5kmpdnh66mxx1a4a104mi";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-869329b1e9894268a8a61dabb69153029b7a8c97";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/869329b1e9894268a8a61dabb69153029b7a8c97";
          sha256 = "1h0lbh8d41sa4fymmw03yzws3v3z0lz4lv1kgcld7r53i2m3wfwp";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-7a6ff3f1959bb01aefccb463a0f2cd3d3d2fd936";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/7a6ff3f1959bb01aefccb463a0f2cd3d3d2fd936";
          sha256 = "16yydk7rsknlasrpn47n4b4js8svvp4rxzw99dkav52wr3cqmcwd";
        };
      };
    };
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-f3cf1a645c2734236ed1e2e671e273eeb3586166";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/f3cf1a645c2734236ed1e2e671e273eeb3586166";
          sha256 = "1pjh861iwlf71frm9f9i7acw4bbiq40gkh96a5wd09nfd2c3w7mc";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-97ae9721bead9d1a39b5650e2f4b7834b93b539c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/97ae9721bead9d1a39b5650e2f4b7834b93b539c";
          sha256 = "0z5hip2ackw8a97fkf6a5zz7rd8sfv72qj44w4zyw776br0rcviw";
        };
      };
    };
    "symfony/psr-http-message-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-psr-http-message-bridge-28a732c05bbad801304ad5a5c674cf2970508993";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/psr-http-message-bridge/zipball/28a732c05bbad801304ad5a5c674cf2970508993";
          sha256 = "0mbs6d1f05n7ws4nyw3w748q5qp7c28i7d96q9c4lyc6cvxbl12n";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-69062e2823f03b82265d73a966999660f0e1e404";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/69062e2823f03b82265d73a966999660f0e1e404";
          sha256 = "03nzrw3kvraf3cyn31hmpvnip4aihj84234i5qh5iv59jzpz517p";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-a8c9cedf55f314f3a186041d19537303766df09a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/a8c9cedf55f314f3a186041d19537303766df09a";
          sha256 = "0gk4mpvm0v8a98p641wdxdvcinl4366fiqadq0za3w37zrwals53";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-193e83bbd6617d6b2151c37fff10fa7168ebddef";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/193e83bbd6617d6b2151c37fff10fa7168ebddef";
          sha256 = "1478grgcbh5vwylwnx89bzjrws5akm8h7kmm7j4h741wvhzv45j6";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-64113df3e8b009f92fad63014f4ec647e65bc927";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/64113df3e8b009f92fad63014f4ec647e65bc927";
          sha256 = "18w8yp5l1w0rcrnmm020y4my898ncxldhf7s94875vk7xks69nby";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-dfec258b9dd17a6b24420d464c43bffe347441c8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/dfec258b9dd17a6b24420d464c43bffe347441c8";
          sha256 = "1ns37kz4fc2z0kdzhk9kchsxffy5h7ls43z4carv2vzrkgzml8lx";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-d30c72a63897cfa043e1de4d4dd2ffa9ecefcdc0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/d30c72a63897cfa043e1de4d4dd2ffa9ecefcdc0";
          sha256 = "0lg3qxa011mvg41xznm69jqc6l02ysvw9jm48bb63gn1j70zy6ba";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-7d10f2a5a452bda385692fc7d38cd6eccfebe756";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/7d10f2a5a452bda385692fc7d38cd6eccfebe756";
          sha256 = "1sb6mjh88rd5ycqkkq0rcx0kplvyvyxf2xa1avyv9f8hjlcyydhv";
        };
      };
    };
    "symfony/var-exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-exporter-9a07920c2058bafee921ce4d90aeef2193837d63";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-exporter/zipball/9a07920c2058bafee921ce4d90aeef2193837d63";
          sha256 = "1vggk9ya9b2703i0qj70bvqp00c3dbddmcg7sax8c8a0hq308r7m";
        };
      };
    };
    "tightenco/collect" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tightenco-collect-d7381736dca44ac17d0805a25191b094e5a22446";
        src = fetchurl {
          url = "https://api.github.com/repos/tighten/collect/zipball/d7381736dca44ac17d0805a25191b094e5a22446";
          sha256 = "0qzsr8q6x7ncwdpbp0w652gl260rwynxvrnsjvj86vjkbc4s0y8w";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-c42125b83a4fa63b187fdf29f9c93cb7733da30c";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/c42125b83a4fa63b187fdf29f9c93cb7733da30c";
          sha256 = "0ckk04hwwz0fdkfr20i7xrhdjcnnw1b0liknbb81qyr1y4b7x3dd";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-1a7ea2afc49c3ee6d87061f5a233e3a035d0eae7";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/1a7ea2afc49c3ee6d87061f5a233e3a035d0eae7";
          sha256 = "13h4xyxhdjn1n7xcxbcdhj20rv5fsaigbsbz61x2i224hj76620a";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "voku-portable-ascii-b56450eed252f6801410d810c8e1727224ae0743";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/b56450eed252f6801410d810c8e1727224ae0743";
          sha256 = "0gwlv1hr6ycrf8ik1pnvlwaac8cpm8sa1nf4d49s8rp4k2y5anyl";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-11cb2199493b2f8a3b53e7f19068fc6aac760991";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/11cb2199493b2f8a3b53e7f19068fc6aac760991";
          sha256 = "18qiza1ynwxpi6731jx1w5qsgw98prld1lgvfk54z92b1nc7psix";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "pixelfed";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-only";
  };
}
