{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "asm89/stack-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "asm89-stack-cors-73e5b88775c64ccc0b84fb60836b30dc9d92ac4a";
        src = fetchurl {
          url = "https://api.github.com/repos/asm89/stack-cors/zipball/73e5b88775c64ccc0b84fb60836b30dc9d92ac4a";
          sha256 = "1idpisw39ba2dic9jl2s2yrkdgbyny9dfxf0qdr5i0wfvvlmbdih";
        };
      };
    };
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
        name = "aws-aws-sdk-php-42ca7ade60a775fc5eb103d4631df3d366b48a29";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/42ca7ade60a775fc5eb103d4631df3d366b48a29";
          sha256 = "07bcpwsx0by2h5bgrd3bjl6fndzgpbsnaz9g65ga4yb5d36799br";
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
        name = "buzz-laravel-h-captcha-502a4a15953cde6e0a17df6fec1459a565504d9b";
        src = fetchurl {
          url = "https://api.github.com/repos/thinhbuzz/laravel-h-captcha/zipball/502a4a15953cde6e0a17df6fec1459a565504d9b";
          sha256 = "1ki38b3cjxgydn3845d9a7zrxdiqmdq5ahsl7r3nwcf0m0xj9yby";
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
        name = "doctrine-dbal-c480849ca3ad6706a39c970cdfe6888fa8a058b8";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/c480849ca3ad6706a39c970cdfe6888fa8a058b8";
          sha256 = "15j98h80li6m1aj53p8ddy0lkbkanc5kdy6xrikpdd6zhmsfgq9k";
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
        name = "doctrine-event-manager-95aa4cb529f1e96576f3fda9f5705ada4056a520";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/95aa4cb529f1e96576f3fda9f5705ada4056a520";
          sha256 = "0xi2s28jmmvrndg1yd0r5s10d9a0q6j2dxdbazvcbws9waf0yrvj";
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
        name = "firebase-php-jwt-4dd1e007f22a927ac77da5a3fbb067b42d3bc224";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/4dd1e007f22a927ac77da5a3fbb067b42d3bc224";
          sha256 = "0wl5glq7bzqrph6pm6js05qnydp0rlchc494cjhbv54rawyb6wfs";
        };
      };
    };
    "fruitcake/laravel-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-laravel-cors-783a74f5e3431d7b9805be8afb60fd0a8f743534";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/laravel-cors/zipball/783a74f5e3431d7b9805be8afb60fd0a8f743534";
          sha256 = "13mqhjks048fb5042l0rfrr52rz7knp9gjn8qviw9cx76kllw2c9";
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
        name = "guzzlehttp-guzzle-b50a2a1251152e43f6a37f0fa053e730a67d25ba";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/b50a2a1251152e43f6a37f0fa053e730a67d25ba";
          sha256 = "0cy828r0kafx58jh0k1cy17y77qh248d9kfk9ncn9pyq2q5v9p9p";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-b94b2807d85443f9719887892882d0329d1e2598";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/b94b2807d85443f9719887892882d0329d1e2598";
          sha256 = "1vvac7y5ax955qjg7dyjmaw3vab9v2lypjygap0040rv3z4x9vz8";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-3cf1b6d4f0c820a2cf8bcaec39fc698f3443b5cf";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/3cf1b6d4f0c820a2cf8bcaec39fc698f3443b5cf";
          sha256 = "1zgnykvv9fz2adava0gb2sm8wgnxkqj1jy2fky1v6vk1r7xdmr3j";
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
        name = "laravel-framework-9239128cfb4d22afefb64060dfecf53e82987267";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/9239128cfb4d22afefb64060dfecf53e82987267";
          sha256 = "1lpkhhhga9g5njig1qf8n2fs0szni5al19cr3ilnlqhy55dmmrb6";
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
        name = "laravel-horizon-b49be302566365e0e4d517aac9995a8fe20b580e";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/horizon/zipball/b49be302566365e0e4d517aac9995a8fe20b580e";
          sha256 = "0q2f9q670cfxnzdaij4g5h1h5nd8xjh72hksqcxl469nxnnz0f16";
        };
      };
    };
    "laravel/passport" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-passport-4bfdb9610575a0c84a6810701f4fd45fb8ab3888";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/passport/zipball/4bfdb9610575a0c84a6810701f4fd45fb8ab3888";
          sha256 = "0nkp1gkvyp16i1cpb7wn5slbichyv12rpjfq35s7riyaynhbpkzr";
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
        name = "laravel-ui-65ec5c03f7fee2c8ecae785795b829a15be48c2c";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/ui/zipball/65ec5c03f7fee2c8ecae785795b829a15be48c2c";
          sha256 = "0hr8kkbxvxxidnw86r1i92938wajhskv68zjn1627h1i16b10ysm";
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
        name = "lcobucci-jwt-4d7de2fe0d51a96418c0d04004986e410e87f6b4";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/jwt/zipball/4d7de2fe0d51a96418c0d04004986e410e87f6b4";
          sha256 = "0ripqfq90zf5xgap22zkhw2n5m8ip872lj39bd7fvwcchfjc5rx0";
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
        name = "league-flysystem-81e87e74dd5213795c7846d65089712d2dda90ce";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/81e87e74dd5213795c7846d65089712d2dda90ce";
          sha256 = "1lhcl71nbbkq27ssd92ilwbjicddnlwwf4ggihxwwv213847bdl9";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-645e14e4a80bd2da8b01e57388e7296a695a80c2";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/645e14e4a80bd2da8b01e57388e7296a695a80c2";
          sha256 = "0dqyjdxwcdfb2jmi4739mz2g6rgnkana5lfbm3a4hz9xnxlw77wq";
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
        name = "league-oauth2-server-eed31d86d8cc8e6e9c9f58fbb2113494f8b41e24";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-server/zipball/eed31d86d8cc8e6e9c9f58fbb2113494f8b41e24";
          sha256 = "19rz6gbvm3hj2l3hcwhdaqqgw5k3yr0yp47bl0bd7pm0wc4hdqk0";
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
        name = "monolog-monolog-f259e2b15fb95494c83f52d3caad003bbf5ffaa1";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/f259e2b15fb95494c83f52d3caad003bbf5ffaa1";
          sha256 = "0lz7lgr1bcxsh4c63z8k26bxawkx14h689wgdiap8992rf97kbk2";
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
        name = "nesbot-carbon-496712849902241f04902033b0441b269effe001";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/496712849902241f04902033b0441b269effe001";
          sha256 = "1bs1a0cji8fyjw7bys23da6162hymwps0pzm0mqib5rx4g0f1v0x";
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
        name = "nikic-php-parser-6bb5176bc4af8bcb7d926f88718db9b96a2d4290";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/6bb5176bc4af8bcb7d926f88718db9b96a2d4290";
          sha256 = "1q7a8wmjn9x28v5snxxriiih3vj12aqc3za0w6pdhbxs9ywxsg9n";
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
        name = "nyholm-psr7-f734364e38a876a23be4d906a2a089e1315be18a";
        src = fetchurl {
          url = "https://api.github.com/repos/Nyholm/psr7/zipball/f734364e38a876a23be4d906a2a089e1315be18a";
          sha256 = "0w8i5l1qg8dkc1zsyz1gpwn2awgkhlm295l1b8smmzabqdc65dcx";
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
        name = "paragonie-sodium_compat-cb15e403ecbe6a6cc515f855c310eb6b1872a933";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/sodium_compat/zipball/cb15e403ecbe6a6cc515f855c310eb6b1872a933";
          sha256 = "01jxl868i8bkx5szgp2fp6mi438ani80bqkdcc7rnn9z22lrsm78";
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
    "php-http/message-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-http-message-factory-a478cb11f66a6ac48d8954216cfed9aa06a501a1";
        src = fetchurl {
          url = "https://api.github.com/repos/php-http/message-factory/zipball/a478cb11f66a6ac48d8954216cfed9aa06a501a1";
          sha256 = "13drpc83bq332hz0b97whibkm7jpk56msq4yppw9nmrchzwgy7cs";
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
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363";
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
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
        name = "psy-psysh-722317c9f5627e588788e340f29b923e58f92f54";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/722317c9f5627e588788e340f29b923e58f92f54";
          sha256 = "122fc66rcv2jwpw2c8di471r4yxcm1289wvpsnadaq345nj3v4bd";
        };
      };
    };
    "pusher/pusher-php-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pusher-pusher-php-server-4ace4873873b06c25cecb2dd6d9fdcbf2f20b640";
        src = fetchurl {
          url = "https://api.github.com/repos/pusher/pusher-http-php/zipball/4ace4873873b06c25cecb2dd6d9fdcbf2f20b640";
          sha256 = "0kkzhazdxqr6j225gyrbzmxfjc9zz89nckxbmx97bx8p4lrpdk9k";
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
        name = "ramsey-uuid-433b2014e3979047db08a17a205f410ba3869cf2";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/433b2014e3979047db08a17a205f410ba3869cf2";
          sha256 = "1yvdbbgblnzzv1zjzwggpayfb8n2kpbwki9dnxc42g4wrxissb8j";
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
        name = "react-event-loop-187fb56f46d424afb6ec4ad089269c72eec2e137";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/event-loop/zipball/187fb56f46d424afb6ec4ad089269c72eec2e137";
          sha256 = "1nnxfdnigzx7zdc521s0fy4467z809dmw8488ig7r1yypv4ri1yc";
        };
      };
    };
    "react/http" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-http-aa7512ee17258c88466de30f9cb44ec5f9df3ff3";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/http/zipball/aa7512ee17258c88466de30f9cb44ec5f9df3ff3";
          sha256 = "08zwgskkf7c3ixqf70r4xld0lrcdj1nk4l2jg994z8pyi2j3biyq";
        };
      };
    };
    "react/promise" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-234f8fd1023c9158e2314fa9d7d0e6a83db42910";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise/zipball/234f8fd1023c9158e2314fa9d7d0e6a83db42910";
          sha256 = "0p3n6jzlny75qcqwvrz0920ry3p902nq4v64cpg9ndd0g79dbdz4";
        };
      };
    };
    "react/promise-stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-stream-e6d2805e09ad50c4896f65f5e8705fe4ee7731a3";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise-stream/zipball/e6d2805e09ad50c4896f65f5e8705fe4ee7731a3";
          sha256 = "0vkxqznj221qgqdndag9gx8dvmaqki37r7ipl6jwgn11hw8xpka9";
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
        name = "spatie-db-dumper-129b8254b2c9f10881a754a692bd9507b09a1893";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/db-dumper/zipball/129b8254b2c9f10881a754a692bd9507b09a1893";
          sha256 = "0q0xi4kcqlsghy8pmlr7sx7h6fbrwxbrrhnppsfnczjbkx5y76fv";
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
        name = "spatie-laravel-backup-f073c8c9f5715272060e4bdceecedd02c29005f9";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-backup/zipball/f073c8c9f5715272060e4bdceecedd02c29005f9";
          sha256 = "1p1v7wag0iqkq6h256k1xqmgf50wx4iygzi12wf942g6sgsf1yll";
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
        name = "spatie-laravel-package-tools-bab62023a4745a61170ad5424184533685e73c2d";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-package-tools/zipball/bab62023a4745a61170ad5424184533685e73c2d";
          sha256 = "0y4zfyk6v12kkkgz4sp00h1n8gqsr1idir5blcvzy3f540wxl30y";
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
        name = "spatie-temporary-directory-e2818d871783d520b319c2d38dc37c10ecdcde20";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/temporary-directory/zipball/e2818d871783d520b319c2d38dc37c10ecdcde20";
          sha256 = "18zay4l05sh21zfnbs0l6l12192j4y0mn2yfvnsyhm617kr14vgj";
        };
      };
    };
    "stevebauman/purify" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "stevebauman-purify-e56289062ed8a25c78c88f35e9106f00d01369c1";
        src = fetchurl {
          url = "https://api.github.com/repos/stevebauman/purify/zipball/e56289062ed8a25c78c88f35e9106f00d01369c1";
          sha256 = "0bqzk203c526sdz8dgpvm3kffxk9x67xy1qbjl4p13fl4cwyi8wb";
        };
      };
    };
    "symfony/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-01a36b32f930018764bcbde006fbbe421fa6b61e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache/zipball/01a36b32f930018764bcbde006fbbe421fa6b61e";
          sha256 = "1i484nh0zy4nbq8p3j1wdw7jiz6rs387w8gyrhligfvhv6kkfd2f";
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
        name = "symfony-console-cbad09eb8925b6ad4fb721c7a179344dc4a19d45";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/cbad09eb8925b6ad4fb721c7a179344dc4a19d45";
          sha256 = "0373y1dqy8mschqqhw2hvv906i1nc68h4yd5jm1dj4rf8qrynplb";
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
        name = "symfony-error-handler-61e90f94eb014054000bc902257d2763fac09166";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/61e90f94eb014054000bc902257d2763fac09166";
          sha256 = "1kxm9pzvvlrd2b1gwbq9b45qgq6sckl0xr078cis7vsbhw9kwbkn";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-404b307de426c1c488e5afad64403e5f145e82a5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/404b307de426c1c488e5afad64403e5f145e82a5";
          sha256 = "0262hqisnnv3mzb7gn6yjyvr8dhgsqrs18a19s72nwcj0cs7k6mi";
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
        name = "symfony-http-client-0a5be6cbc570ae23b51b49d67341f378629d78e4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client/zipball/0a5be6cbc570ae23b51b49d67341f378629d78e4";
          sha256 = "1jkgy3k4g2x33952vnbw8n5lv6986fbq8qallpsl8rfcczyzliq3";
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
        name = "symfony-http-foundation-5fc3038d4a594223f9ea42e4e985548f3fcc9a3b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/5fc3038d4a594223f9ea42e4e985548f3fcc9a3b";
          sha256 = "13wn8kgxakp9133sjgvn2bfr51r5rxymm6d8vhs8kjxxgkx050l5";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-ca0680ad1e2d678536cc20e0ae33f9e4e5d2becd";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/ca0680ad1e2d678536cc20e0ae33f9e4e5d2becd";
          sha256 = "14b700kcw4ibz9hackx9wvghmv5rnks18vhr4vjb5zskfdajp4qd";
        };
      };
    };
    "symfony/mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailer-e4f84c633b72ec70efc50b8016871c3bc43e691e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailer/zipball/e4f84c633b72ec70efc50b8016871c3bc43e691e";
          sha256 = "15bi1vy4162mv0k49wscdshwznjmmcwr9g7g03jgadanjq4afyzj";
        };
      };
    };
    "symfony/mailgun-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailgun-mailer-9e27b8ec2f6ee7575c6229a61be1578a5a4b21ee";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailgun-mailer/zipball/9e27b8ec2f6ee7575c6229a61be1578a5a4b21ee";
          sha256 = "14ny9mqvl8lqfa049cvxd0zqiqssidk82794sg80g6cl1irmj6rp";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-62e341f80699badb0ad70b31149c8df89a2d778e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/62e341f80699badb0ad70b31149c8df89a2d778e";
          sha256 = "1l56y494n4phiyafcgc7sa8vfxzsvz6lbzxhnqirdgv19y4zvbim";
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
        name = "symfony-process-680e8a2ea6b3f87aecc07a6a65a203ae573d1902";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/680e8a2ea6b3f87aecc07a6a65a203ae573d1902";
          sha256 = "16g99h6ir2mf3v0kciqckjgjg4x8sqyl2b6r7rf9bw1rnfmh3xk7";
        };
      };
    };
    "symfony/psr-http-message-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-psr-http-message-bridge-a125b93ef378c492e274f217874906fb9babdebb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/psr-http-message-bridge/zipball/a125b93ef378c492e274f217874906fb9babdebb";
          sha256 = "1c23bv3j2zwbxklizvkvkzrgn2fd1164qb0smgswa15pshwmr0gw";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-fa643fa4c56de161f8bc8c0492a76a60140b50e4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/fa643fa4c56de161f8bc8c0492a76a60140b50e4";
          sha256 = "1kv9ijzligl3y6z6hwkk5kjf8h8lff5fh6y0f1ws1ivwxrid8r33";
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
        name = "symfony-string-67b8c1eec78296b85dc1c7d9743830160218993d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/67b8c1eec78296b85dc1c7d9743830160218993d";
          sha256 = "1jvxxb6f5mf1hl1fl6pr46b0g79w8zinqxgw40c871lxw8xmk6hy";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-90db1c6138c90527917671cd9ffa9e8b359e3a73";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/90db1c6138c90527917671cd9ffa9e8b359e3a73";
          sha256 = "1fwg6fwlkjv2zxxg7mjxp9i9c3slxfdiixykpl3r9rsddjvpvyjr";
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
        name = "symfony-var-dumper-cf8d4ca1ddc1e3cc242375deb8fc23e54f5e2a1e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/cf8d4ca1ddc1e3cc242375deb8fc23e54f5e2a1e";
          sha256 = "1l771q02a9m4j09dv96y4g1fb9lpmfxnz2hy11hmz57afscl3m7s";
        };
      };
    };
    "symfony/var-exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-exporter-86062dd0103530e151588c8f60f5b85a139f1442";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-exporter/zipball/86062dd0103530e151588c8f60f5b85a139f1442";
          sha256 = "1w13ww6qr7bra2c8j2da6wzrr96agp1ks4b81g1h8psyybvb48m6";
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
  devPackages = {
    "brianium/paratest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brianium-paratest-51691208db882922c55d6c465be3e7d95028c449";
        src = fetchurl {
          url = "https://api.github.com/repos/paratestphp/paratest/zipball/51691208db882922c55d6c465be3e7d95028c449";
          sha256 = "0gmp7zg3lfvsg4lqsh3q5zxl00iz004d5qbvnmya6y97skig2ja6";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-c6222283fa3f4ac679f8b9ced9a4e23f163e80d0";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/instantiator/zipball/c6222283fa3f4ac679f8b9ced9a4e23f163e80d0";
          sha256 = "059ahw73z0m24cal4f805j6h1i53f90mrmjr7s4f45yfxgwcqvcn";
        };
      };
    };
    "fakerphp/faker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fakerphp-faker-92efad6a967f0b79c499705c69b662f738cc9e4d";
        src = fetchurl {
          url = "https://api.github.com/repos/FakerPHP/Faker/zipball/92efad6a967f0b79c499705c69b662f738cc9e4d";
          sha256 = "0yxl4vicv0yc5jxsfslxkhh7fjgryg3anmpvdvbqim2df5wv4pqg";
        };
      };
    };
    "fidry/cpu-core-counter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fidry-cpu-core-counter-b58e5a3933e541dc286cc91fc4f3898bbc6f1623";
        src = fetchurl {
          url = "https://api.github.com/repos/theofidry/cpu-core-counter/zipball/b58e5a3933e541dc286cc91fc4f3898bbc6f1623";
          sha256 = "154qkm931w5d3dy202w455wxfa0wsjx7mmfj23mb36zpp1gck19j";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-e864ac957acd66e1565f25efda61e37791a5db0b";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/e864ac957acd66e1565f25efda61e37791a5db0b";
          sha256 = "1q6lx0d2h1372flsh7qqacyb9gljhhlnasgbvydhil11v1mai50g";
        };
      };
    };
    "hamcrest/hamcrest-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "hamcrest-hamcrest-php-8c3d0a3f6af734494ad8f6fbbee0ba92422859f3";
        src = fetchurl {
          url = "https://api.github.com/repos/hamcrest/hamcrest-php/zipball/8c3d0a3f6af734494ad8f6fbbee0ba92422859f3";
          sha256 = "1ixmmpplaf1z36f34d9f1342qjbcizvi5ddkjdli6jgrbla6a6hr";
        };
      };
    };
    "jean85/pretty-package-versions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jean85-pretty-package-versions-ae547e455a3d8babd07b96966b17d7fd21d9c6af";
        src = fetchurl {
          url = "https://api.github.com/repos/Jean85/pretty-package-versions/zipball/ae547e455a3d8babd07b96966b17d7fd21d9c6af";
          sha256 = "07s7hl7705vgmyr5m7czja4426rsqrxqh8m362irn29vbc35k6q8";
        };
      };
    };
    "laravel/telescope" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-telescope-fafad2e32883eb9dc03b646d0f82b2987e8af880";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/telescope/zipball/fafad2e32883eb9dc03b646d0f82b2987e8af880";
          sha256 = "1pr1a4b07nmwj05ck4c7c1ip1hhr32blr9pwcvapyrh862vv5p13";
        };
      };
    };
    "mockery/mockery" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mockery-mockery-e92dcc83d5a51851baf5f5591d32cb2b16e3684e";
        src = fetchurl {
          url = "https://api.github.com/repos/mockery/mockery/zipball/e92dcc83d5a51851baf5f5591d32cb2b16e3684e";
          sha256 = "0dvkr0ff37cn6s72s7sqw26j6i5fja780x980zhl099frflkw5s9";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-7284c22080590fb39f2ffa3e9057f10a4ddd0e0c";
        src = fetchurl {
          url = "https://api.github.com/repos/myclabs/DeepCopy/zipball/7284c22080590fb39f2ffa3e9057f10a4ddd0e0c";
          sha256 = "16k44y94bcr439bsxm5158xvmlyraph2c6n17qa5y29b04jqdw5j";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-f05978827b9343cba381ca05b8c7deee346b6015";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/collision/zipball/f05978827b9343cba381ca05b8c7deee346b6015";
          sha256 = "09bpw23vq3yyilrkd6k798igrg0ypryxpw2bfbdgjvjwhs4ndf29";
        };
      };
    };
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-97803eca37d319dfa7826cc2437fc020857acb53";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/manifest/zipball/97803eca37d319dfa7826cc2437fc020857acb53";
          sha256 = "107dsj04ckswywc84dvw42kdrqd4y6yvb2qwacigyrn05p075c1w";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/version/zipball/4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
          sha256 = "0mdbzh1y0m2vvpf54vw7ckcbcf1yfhivwxgc9j9rbb7yifmlyvsg";
        };
      };
    };
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-443bc6912c9bd5b409254a40f4b0f4ced7c80ea1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/443bc6912c9bd5b409254a40f4b0f4ced7c80ea1";
          sha256 = "18v2xs142pw4dl9l6imcmkdvv5m18zd36ar41i586f4mg8d961d1";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
          sha256 = "1407d8f1h35w4sdikq2n6cz726css2xjvlyr1m4l9a53544zxcnr";
        };
      };
    };
    "phpunit/php-invoker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-invoker-5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-invoker/zipball/5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
          sha256 = "1vqnnjnw94mzm30n9n5p2bfgd3wd5jah92q6cj3gz1nf0qigr4fh";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
          sha256 = "0ff87yzywizi6j2ps3w0nalpx16mfyw3imzn6gj9jjsfwc2bb8lq";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-timer/zipball/5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
          sha256 = "0g1g7yy4zk1bidyh165fsbqx5y8f1c8pxikvcahzlfsr9p2qxk6a";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-86e761949019ae83f49240b2f2123fb5ab3b2fc5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/phpunit/zipball/86e761949019ae83f49240b2f2123fb5ab3b2fc5";
          sha256 = "1jqsw5qd5cv07fzpbw6m31314s2b64zwz0hz3g83179yf5h4r99z";
        };
      };
    };
    "sebastian/cli-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-cli-parser-442e7c7e687e42adc03470c7b668bc4b2402c0b2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/cli-parser/zipball/442e7c7e687e42adc03470c7b668bc4b2402c0b2";
          sha256 = "074qzdq19k9x4svhq3nak5h348xska56v1sqnhk1aj0jnrx02h37";
        };
      };
    };
    "sebastian/code-unit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-1fc9f64c0927627ef78ba436c9b17d967e68e120";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit/zipball/1fc9f64c0927627ef78ba436c9b17d967e68e120";
          sha256 = "04vlx050rrd54mxal7d93pz4119pas17w3gg5h532anfxjw8j7pm";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
          sha256 = "1h1jbzz3zak19qi4mab2yd0ddblpz7p000jfyxfwd2ds0gmrnsja";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-fa0f136dd2334583309d32b62544682ee972b51a";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/comparator/zipball/fa0f136dd2334583309d32b62544682ee972b51a";
          sha256 = "0m8ibkwaxw2q5v84rlvy7ylpkddscsa8hng0cjczy4bqpqavr83w";
        };
      };
    };
    "sebastian/complexity" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-complexity-739b35e53379900cc9ac327b2147867b8b6efd88";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/complexity/zipball/739b35e53379900cc9ac327b2147867b8b6efd88";
          sha256 = "1y4yz8n8hszbhinf9ipx3pqyvgm7gz0krgyn19z0097yq3bbq8yf";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-3461e3fccc7cfdfc2720be910d3bd73c69be590d";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/3461e3fccc7cfdfc2720be910d3bd73c69be590d";
          sha256 = "0967nl6cdnr0v0z83w4xy59agn60kfv8gb41aw3fpy1n2wpp62dj";
        };
      };
    };
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-830c43a844f1f8d5b7a1f6d6076b784454d8b7ed";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/environment/zipball/830c43a844f1f8d5b7a1f6d6076b784454d8b7ed";
          sha256 = "02045n3in01zk571v1phyhj0b2mvnvx8qnlqvw4j33r7qdd4clzn";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-ac230ed27f0f98f597c8a2b6eb7ac563af5e5b9d";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/exporter/zipball/ac230ed27f0f98f597c8a2b6eb7ac563af5e5b9d";
          sha256 = "1a6yj8v8rwj3igip8xysdifvbd7gkzmwrj9whdx951pdq7add46j";
        };
      };
    };
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-0ca8db5a5fc9c8646244e629625ac486fa286bf2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/global-state/zipball/0ca8db5a5fc9c8646244e629625ac486fa286bf2";
          sha256 = "1csrfa5b7ivza712lfmbywp9jhwf4ls5lc0vn812xljkj7w24kg1";
        };
      };
    };
    "sebastian/lines-of-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-lines-of-code-c1c2e997aa3146983ed888ad08b15470a2e22ecc";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/lines-of-code/zipball/c1c2e997aa3146983ed888ad08b15470a2e22ecc";
          sha256 = "0fay9s5cm16gbwr7qjihwrzxn7sikiwba0gvda16xng903argbk0";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-5c9eeac41b290a3712d88851518825ad78f45c71";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/5c9eeac41b290a3712d88851518825ad78f45c71";
          sha256 = "11853z07w8h1a67wsjy3a6ir5x7khgx6iw5bmrkhjkiyvandqcn1";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
          sha256 = "0g5m1fswy6wlf300x1vcipjdljmd3vh05hjqhqfc91byrjbk4rsg";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-e75bd0f07204fec2a0af9b0f3cfe97d05f92efc1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/e75bd0f07204fec2a0af9b0f3cfe97d05f92efc1";
          sha256 = "1ag6ysxffhxyg7g4rj9xjjlwq853r4x92mmin4f09hn5mqn9f0l1";
        };
      };
    };
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
          sha256 = "0p5s8rp7mrhw20yz5wx1i4k8ywf0h0ximcqan39n9qnma1dlnbyr";
        };
      };
    };
    "sebastian/type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-type-75e2c2a32f5e0b3aef905b9ed0b179b953b3d7c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/type/zipball/75e2c2a32f5e0b3aef905b9ed0b179b953b3d7c7";
          sha256 = "0bvfvb62qbpy2hzxs4bjzb0xhks6h3cp6qx96z4qlyz6wl2fa1w5";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-c6c1022351a901512170118436c764e473f6de8c";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/version/zipball/c6c1022351a901512170118436c764e473f6de8c";
          sha256 = "1bs7bwa9m0fin1zdk7vqy5lxzlfa9la90lkl27sn0wr00m745ig1";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-34a41e998c2183e22995f158c581e7b5e755ab9e";
        src = fetchurl {
          url = "https://api.github.com/repos/theseer/tokenizer/zipball/34a41e998c2183e22995f158c581e7b5e755ab9e";
          sha256 = "1za4a017kjb4rw2ydglip4bp5q2y7mfiycj3fvnp145i84jc7n0q";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "pixelfed-pixelfed";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-only";
  };
}
