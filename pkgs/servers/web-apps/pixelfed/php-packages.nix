{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-eb0c6e4e142224a10b08f49ebf87f32611d162b2";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/eb0c6e4e142224a10b08f49ebf87f32611d162b2";
          sha256 = "10fnazz3gv51i6dngrc6hbcmzwrvl6mmd2z44rrdbzz3ry8v3vc9";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-1d3e952ea2f45bb0d42d7f873d1b4957bb6362c4";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/1d3e952ea2f45bb0d42d7f873d1b4957bb6362c4";
          sha256 = "1yymdd50m30qjd6pclph8g4mrl40j0qg9hi3z72i1lb3chacz93c";
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
        name = "beyondcode-laravel-websockets-fee9a81e42a096d2aaca216ce91acf6e25d8c06d";
        src = fetchurl {
          url = "https://api.github.com/repos/beyondcode/laravel-websockets/zipball/fee9a81e42a096d2aaca216ce91acf6e25d8c06d";
          sha256 = "1sxszc0q41wj9a04waap1sjpmz4sp0ji7dndlslaym4ml3x8mjf5";
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
    "carbonphp/carbon-doctrine-types" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "carbonphp-carbon-doctrine-types-67a77972b9f398ae7068dabacc39c08aeee170d5";
        src = fetchurl {
          url = "https://api.github.com/repos/CarbonPHP/carbon-doctrine-types/zipball/67a77972b9f398ae7068dabacc39c08aeee170d5";
          sha256 = "1li7qzj2cb0l6m41l8fya1p3izc8g23y3gpm4dy006pz07pmhr20";
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
        name = "dasprid-enum-6faf451159fb8ba4126b925ed2d78acfce0dc016";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/6faf451159fb8ba4126b925ed2d78acfce0dc016";
          sha256 = "1c3c7zdmpd5j1pw9am0k3mj8n17vy6xjhsh2qa7c0azz0f21jk4j";
        };
      };
    };
    "defuse/php-encryption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "defuse-php-encryption-f53396c2d34225064647a05ca76c1da9d99e5828";
        src = fetchurl {
          url = "https://api.github.com/repos/defuse/php-encryption/zipball/f53396c2d34225064647a05ca76c1da9d99e5828";
          sha256 = "1g4mnnw9nmg1v8zq04d56v5n4m6vr3rsjbqdbny9d2f4c8xd4pqz";
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
        name = "doctrine-dbal-0ac3c270590e54910715e9a1a044cc368df282b2";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/0ac3c270590e54910715e9a1a044cc368df282b2";
          sha256 = "1qf6nhrrn7hdxqvym9l3mxj1sb0fmx2h1s3yi4mjkkb4ri5hcmm8";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-4f2d4f2836e7ec4e7a8625e75c6aa916004db931";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/4f2d4f2836e7ec4e7a8625e75c6aa916004db931";
          sha256 = "1kxy6s4v9prkfvsnggm10kk0yyqsyd2vk238zhvv3c9il300h8sk";
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
        name = "doctrine-inflector-f9301a5b2fb1216b2b08f02ba04dc45423db6bff";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/f9301a5b2fb1216b2b08f02ba04dc45423db6bff";
          sha256 = "1kdq3sbwrzwprxr36cdw9m1zlwn15c0nz6i7mw0sq9mhnd2sgbrb";
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
        name = "dragonmantank-cron-expression-adfb1f505deb6384dc8b39804c5065dd3c8c8c0a";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/adfb1f505deb6384dc8b39804c5065dd3c8c8c0a";
          sha256 = "1gw2bnsh8ca5plfpyyyz1idnx7zxssg6fbwl7niszck773zrm5ca";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-ebaaf5be6c0286928352e054f2d5125608e5405e";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/ebaaf5be6c0286928352e054f2d5125608e5405e";
          sha256 = "02n4sh0gywqzsl46n9q8hqqgiyva2gj4lxdz9fw4pvhkm1s27wd6";
        };
      };
    };
    "evenement/evenement" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "evenement-evenement-0a16b0d71ab13284339abb99d9d2bd813640efbc";
        src = fetchurl {
          url = "https://api.github.com/repos/igorw/evenement/zipball/0a16b0d71ab13284339abb99d9d2bd813640efbc";
          sha256 = "1gbm1nha3h8hhqlqxdrgmrwh35xld0by1si7qg2944g5wggfxpad";
        };
      };
    };
    "ezyang/htmlpurifier" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ezyang-htmlpurifier-bbc513d79acf6691fa9cf10f192c90dd2957f18c";
        src = fetchurl {
          url = "https://api.github.com/repos/ezyang/htmlpurifier/zipball/bbc513d79acf6691fa9cf10f192c90dd2957f18c";
          sha256 = "0jg5aw2x872hlxnvz9ck8z322rfdxs86rhzj5lh0q9j7cm377v4a";
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
    "fgrosse/phpasn1" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fgrosse-phpasn1-42060ed45344789fb9f21f9f1864fc47b9e3507b";
        src = fetchurl {
          url = "https://api.github.com/repos/fgrosse/PHPASN1/zipball/42060ed45344789fb9f21f9f1864fc47b9e3507b";
          sha256 = "0ps35qg86v4khkz14dj9z2qny0irwba3n0z26nqn24p41zrcv8xl";
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
        name = "firebase-php-jwt-a49db6f0a5033aef5143295342f1c95521b075ff";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/a49db6f0a5033aef5143295342f1c95521b075ff";
          sha256 = "0rgr90jbp1469pwib3n1yd2by2y3xsc0c5acpzs9iskfcn132swk";
        };
      };
    };
    "fruitcake/php-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-php-cors-3d158f36e7875e2f040f37bc0573956240a5a38b";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/php-cors/zipball/3d158f36e7875e2f040f37bc0573956240a5a38b";
          sha256 = "1pdq0dxrmh4yj48y9azrld10qmz1w3vbb9q81r85fvgl62l2kiww";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-fbd48bce38f73f8a4ec8583362e732e4095e5862";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/fbd48bce38f73f8a4ec8583362e732e4095e5862";
          sha256 = "1mzahy4df8d45qm716crs45rp5j7k31r0jhkmbrrvqsvapnmj9ip";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-41042bc7ab002487b876a0683fc8dce04ddce104";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/41042bc7ab002487b876a0683fc8dce04ddce104";
          sha256 = "0awhhka285kk0apv92n0a0yfbihi2ddnx3qr1c7s97asgxfnwxsv";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-bbff78d96034045e58e13dedd6ad91b5d1253223";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/bbff78d96034045e58e13dedd6ad91b5d1253223";
          sha256 = "1p0bry118c3lichkz8lag37ndvvhbd2nf0k9kzwi8gz1bzf9d45f";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-45b30f99ac27b5ca93cb4831afe16285f57b8221";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/45b30f99ac27b5ca93cb4831afe16285f57b8221";
          sha256 = "0k60pzfpxd6q1rhr9gbf53j0hm9wj5p5spkc0zfyia4b8f8pgmdm";
        };
      };
    };
    "guzzlehttp/uri-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-uri-template-ecea8feef63bd4fef1f037ecb288386999ecc11c";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/uri-template/zipball/ecea8feef63bd4fef1f037ecb288386999ecc11c";
          sha256 = "0r3cbb2pgsy4nawbylc0nbski2r9dkl335ay5m4i82yglspl9zz4";
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
        name = "jaybizzle-crawler-detect-97e9fe30219e60092e107651abb379a38b342921";
        src = fetchurl {
          url = "https://api.github.com/repos/JayBizzle/Crawler-Detect/zipball/97e9fe30219e60092e107651abb379a38b342921";
          sha256 = "0ywqamhyilrlb1sli00i2gnaw2hyjpbb9pkxb8nxx7dr1a4v8x7q";
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
    "laravel-notification-channels/webpush" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-notification-channels-webpush-b31f7d807d30c80e7391063291ebfe9683bb7de5";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel-notification-channels/webpush/zipball/b31f7d807d30c80e7391063291ebfe9683bb7de5";
          sha256 = "1vdalwjcncf3xz44j85bkb709c9mlnjqsxrhsvjmlkabwn2zi4aj";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-c581caa233e380610b34cc491490bfa147a3b62b";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/c581caa233e380610b34cc491490bfa147a3b62b";
          sha256 = "1np37vczzj08vfkx413b247w3y8cmfbgj6a1fmpyaannfjp97m9k";
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
        name = "laravel-horizon-bdf58c84b592b83f62262cc6ca98b0debbbc308b";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/horizon/zipball/bdf58c84b592b83f62262cc6ca98b0debbbc308b";
          sha256 = "0r2qyqsz27jnfr43i1qxfl57hqv5wn0jf8b95xjc0k8izz7p0z2k";
        };
      };
    };
    "laravel/passport" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-passport-966bc8e477d08c86a11dc4c5a86f85fa0abdb89b";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/passport/zipball/966bc8e477d08c86a11dc4c5a86f85fa0abdb89b";
          sha256 = "1y7i9ahjgj575bvywqr7ikm9kfaa3s9bkp4x0s2cjrvcra4fpwnx";
        };
      };
    };
    "laravel/prompts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-prompts-e1379d8ead15edd6cc4369c22274345982edc95a";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/prompts/zipball/e1379d8ead15edd6cc4369c22274345982edc95a";
          sha256 = "16nb9i939sgfwm11dhi9n1dgwldh4ylhr4p8qdp5f05crvmybc02";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-3dbf8a8e914634c48d389c1234552666b3d43754";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/3dbf8a8e914634c48d389c1234552666b3d43754";
          sha256 = "1vvayh1bzbw16xj8ash4flibkgn5afwn64nfwmjdi7lcr48cw65q";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-b936d415b252b499e8c3b1f795cd4fc20f57e1f3";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/b936d415b252b499e8c3b1f795cd4fc20f57e1f3";
          sha256 = "1vggdik2nby6a9avwgylgihhwyglm0mdwm703bwv7ilwx0dsx1i7";
        };
      };
    };
    "laravel/ui" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-ui-eb532ea096ca1c0298c87c19233daf011fda743a";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/ui/zipball/eb532ea096ca1c0298c87c19233daf011fda743a";
          sha256 = "0n79mcly7rzka7m50r41nkil4ia5d0x5jihxdn790shqm0mcdxw8";
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
        name = "lcobucci-jwt-0ba88aed12c04bd2ed9924f500673f32b67a6211";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/jwt/zipball/0ba88aed12c04bd2ed9924f500673f32b67a6211";
          sha256 = "0icvs7glzsb3j63fsa0j6d210hj5vaw3n6crzjdczdhiiz71hs0r";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-3669d6d5f7a47a93c08ddff335e6d945481a1dd5";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/3669d6d5f7a47a93c08ddff335e6d945481a1dd5";
          sha256 = "1rbaydy1n1c1schskbabzd4nx57nvwpnzqapsfxjm6kyihca1nr3";
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
        name = "league-flysystem-d18526ee587f265f091f47bb83f1d9a001ef6f36";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/d18526ee587f265f091f47bb83f1d9a001ef6f36";
          sha256 = "1anzfh9fzfnim68dqlyil4c6a61y6dppl4sk1drx4mbms5ds9473";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-9808919ee5d819730d9582d4e1673e8d195c38d8";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/9808919ee5d819730d9582d4e1673e8d195c38d8";
          sha256 = "1339ix4nqkk54bfnms18fz853s9ngsgjvkjdln1ff045m7dm4svi";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-42dfb4eaafc4accd248180f0dd66f17073b40c4c";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/42dfb4eaafc4accd248180f0dd66f17073b40c4c";
          sha256 = "12xf0qnj3nr521is0dxi6b8rs6bn660nsj97dqzrf0givqny5g1q";
        };
      };
    };
    "league/iso3166" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-iso3166-11703e0313f34920add11c0228f0dd43ebd10f9a";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/iso3166/zipball/11703e0313f34920add11c0228f0dd43ebd10f9a";
          sha256 = "1rhvyki2za32k8z23bacq02apbhbk3vdg0d52wvjdvlsr4n402gv";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-b6a5854368533df0295c5761a0253656a2e52d9e";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/b6a5854368533df0295c5761a0253656a2e52d9e";
          sha256 = "0bsqha9c0pyb5l78iiv1klrpqmhki6nh9x73pgnmh7sphh6ilygj";
        };
      };
    };
    "league/oauth2-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-server-ab7714d073844497fd222d5d0a217629089936bc";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-server/zipball/ab7714d073844497fd222d5d0a217629089936bc";
          sha256 = "1p4lvibdfi458bv778qzbah3b1lkhdvd9hiws040ky8jizfs6c2g";
        };
      };
    };
    "league/uri" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-bf414ba956d902f5d98bf9385fcf63954f09dce5";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri/zipball/bf414ba956d902f5d98bf9385fcf63954f09dce5";
          sha256 = "1rwwf77s2i2jlz7d8ylp695z25lwadp66868b82si151y0mm5qy3";
        };
      };
    };
    "league/uri-interfaces" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-interfaces-bd8c487ec236930f7bbc42b8d374fa882fbba0f3";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri-interfaces/zipball/bd8c487ec236930f7bbc42b8d374fa882fbba0f3";
          sha256 = "13zy4pk2rphm5cmv08sksdxwlh3kwflsc13nr8i4nzmnj8m32zpr";
        };
      };
    };
    "minishlink/web-push" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "minishlink-web-push-ec034f1e287cd1e74235e349bd017d71a61e9d8d";
        src = fetchurl {
          url = "https://api.github.com/repos/web-push-libs/web-push-php/zipball/ec034f1e287cd1e74235e349bd017d71a61e9d8d";
          sha256 = "1v8gr9wkhbqybb7fi8bmyhvp9i8bjpjx63bcsbyqf1aw9nrfnpcv";
        };
      };
    };
    "mobiledetect/mobiledetectlib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mobiledetect-mobiledetectlib-96aaebcf4f50d3d2692ab81d2c5132e425bca266";
        src = fetchurl {
          url = "https://api.github.com/repos/serbanghita/Mobile-Detect/zipball/96aaebcf4f50d3d2692ab81d2c5132e425bca266";
          sha256 = "0s4sj600kaiaxnsjxh27jq62b3iwydp0bg5zxjqd2l3rgh8xy879";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-c915e2634718dbc8a4a15c61b0e62e7a44e14448";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/c915e2634718dbc8a4a15c61b0e62e7a44e14448";
          sha256 = "1sqqjdg75vc578zrm6xklmk9928l4dc7csjvlpln331b8rnai8hs";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-bbb69a935c2cbb0c03d7f481a238027430f6440b";
        src = fetchurl {
          url = "https://api.github.com/repos/jmespath/jmespath.php/zipball/bbb69a935c2cbb0c03d7f481a238027430f6440b";
          sha256 = "1ksjdc2icgafkx16j05ir3vk1ryhgdr2l41wpfd6nhzzk42smiwb";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-a6885fcbad2ec4360b0e200ee0da7d9b7c90786b";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/a6885fcbad2ec4360b0e200ee0da7d9b7c90786b";
          sha256 = "0j4x43v58jmgmfqcx0sfjh5rc1n9an2wdnmbp4yhbdnb1nhxg9z3";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-0462f0166e823aad657c9224d0f849ecac1ba10a";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/0462f0166e823aad657c9224d0f849ecac1ba10a";
          sha256 = "0x2pz3mjnx78ndxm5532ld3kwzs9p43l4snk4vjbwnqiqgcpqwn7";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-a9d127dd6a203ce6d255b2e2db49759f7506e015";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/a9d127dd6a203ce6d255b2e2db49759f7506e015";
          sha256 = "0py2072z0rmpzf1ylk7rf2k040lv3asnk2icf97qm384cjw9dzrp";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-a6303e50c90c355c7eeee2c4a8b27fe8dc8fef1d";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/a6303e50c90c355c7eeee2c4a8b27fe8dc8fef1d";
          sha256 = "0a5a6fzgvcgxn5kc1mxa5grxmm8c1ax91pjr3gxpkji7nyc1zh1y";
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
        name = "nyholm-psr7-aa5fc277a4f5508013d571341ade0c3886d4d00e";
        src = fetchurl {
          url = "https://api.github.com/repos/Nyholm/psr7/zipball/aa5fc277a4f5508013d571341ade0c3886d4d00e";
          sha256 = "00r9sy7ncrjdc71kqis4vc6q1ksbh97g3fhf97gf5jg9j6pq27lg";
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
        name = "phpoption-phpoption-80735db690fe4fc5c76dfa7f9b770634285fa820";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/80735db690fe4fc5c76dfa7f9b770634285fa820";
          sha256 = "1f9hzyjnam157lb7iw9r8f5cnjjsiqam9mnkpqmba73g1668xn9s";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-28d8f438a0064c9de80857e3270d071495544640";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/28d8f438a0064c9de80857e3270d071495544640";
          sha256 = "0i9275yhwbv9g1bxfy4cp71jy8j8kp1kd6r3zzfp59agkl5hklwv";
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
        name = "predis-predis-b1d3255ed9ad4d7254f9f9bba386c99f4bb983d1";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/b1d3255ed9ad4d7254f9f9bba386c99f4bb983d1";
          sha256 = "0pylca7in1fm6vyrfdp12pqamp7y09cr5mc8hyr1m22r9f6m82l9";
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
        name = "psr-http-client-bb5906edc1c324c9a05aa0873d40117941e5fa90";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/bb5906edc1c324c9a05aa0873d40117941e5fa90";
          sha256 = "1dfyjqj1bs2n2zddk8402v6rjq93fq26hwr0rjh53m11wy1wagsx";
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
        name = "psy-psysh-128fa1b608be651999ed9789c95e6e2a31b5802b";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/128fa1b608be651999ed9789c95e6e2a31b5802b";
          sha256 = "0lrmqw53kzgdldxiy2aj0dawdzz5cbsxqz9p47ca3c0ggnszlk1p";
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
        name = "ramsey-uuid-5f0df49ae5ad6efb7afa69e6bfab4e5b1e080d8e";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/5f0df49ae5ad6efb7afa69e6bfab4e5b1e080d8e";
          sha256 = "0gnpj6jsmwr5azxq8ymp0zpscgxcwld7ps2q9rbkbndr9f9cpkkg";
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
        name = "react-dns-c134600642fa615b46b41237ef243daa65bb64ec";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/dns/zipball/c134600642fa615b46b41237ef243daa65bb64ec";
          sha256 = "0p3slkj1p3gzsv2162y7x5j9ys3b2kslxl3vn2bcq341z1jic0jb";
        };
      };
    };
    "react/event-loop" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-event-loop-bbe0bd8c51ffc05ee43f1729087ed3bdf7d53354";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/event-loop/zipball/bbe0bd8c51ffc05ee43f1729087ed3bdf7d53354";
          sha256 = "0g2l68nsmf80wdam602xp1m8w2dvl9qm5rzdvssgn8hq9fil60iv";
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
        name = "react-promise-e563d55d1641de1dea9f5e84f3cccc66d2bfe02c";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise/zipball/e563d55d1641de1dea9f5e84f3cccc66d2bfe02c";
          sha256 = "0bwwnpwkf75wybkl22gv88gv9shc1yq45sdd6p2azp6xqjwcrmnr";
        };
      };
    };
    "react/socket" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-socket-21591111d3ea62e31f2254280ca0656bc2b1bda6";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/socket/zipball/21591111d3ea62e31f2254280ca0656bc2b1bda6";
          sha256 = "08wqhxj2zv52df303005m4g1i36j6ypxl26gim1fbvyfnagvb0fw";
        };
      };
    };
    "react/stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-stream-6fbc9672905c7d5a885f2da2fc696f65840f4a66";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/stream/zipball/6fbc9672905c7d5a885f2da2fc696f65840f4a66";
          sha256 = "0hgkbjgdl8633w36praw2xjk8y7rib1vawzbvkssclampcg41cxh";
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
        name = "spatie-db-dumper-bbd5ae0f331d47e6534eb307e256c11a65c8e24a";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/db-dumper/zipball/bbd5ae0f331d47e6534eb307e256c11a65c8e24a";
          sha256 = "0g2r7539wglkggm3mz1mx0lgkxx43icsdr2n76hylannm595dnrx";
        };
      };
    };
    "spatie/image-optimizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-image-optimizer-62f7463483d1bd975f6f06025d89d42a29608fe1";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/image-optimizer/zipball/62f7463483d1bd975f6f06025d89d42a29608fe1";
          sha256 = "0fzr4qyk7vzrv2nrwmm5fk3zfbgx0927mnkjq0knjz1qfng1kr4b";
        };
      };
    };
    "spatie/laravel-backup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-backup-b79f790cc856e67cce012abf34bf1c9035085dc1";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-backup/zipball/b79f790cc856e67cce012abf34bf1c9035085dc1";
          sha256 = "0lyab2cjvz454dbipzxfyvsspz0gq70ywpl5i944f70mn6lbv4dm";
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
        name = "spatie-laravel-package-tools-cc7c991555a37f9fa6b814aa03af73f88026a83d";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-package-tools/zipball/cc7c991555a37f9fa6b814aa03af73f88026a83d";
          sha256 = "1xbyaizfvkcdrlpcs5ci30arnydckdga4a78xsfx8ylia606gcg4";
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
        name = "spatie-temporary-directory-efc258c9f4da28f0c7661765b8393e4ccee3d19c";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/temporary-directory/zipball/efc258c9f4da28f0c7661765b8393e4ccee3d19c";
          sha256 = "16xb80zhrkrg2p9b1yrcdigkz11z5msvnkac8dd429d5r2r4zfx9";
        };
      };
    };
    "spomky-labs/base64url" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spomky-labs-base64url-7752ce931ec285da4ed1f4c5aa27e45e097be61d";
        src = fetchurl {
          url = "https://api.github.com/repos/Spomky-Labs/base64url/zipball/7752ce931ec285da4ed1f4c5aa27e45e097be61d";
          sha256 = "04xjhggcf6zc80ikva0flqis16q9b5lywld73g007m3y8b97q23l";
        };
      };
    };
    "stevebauman/purify" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "stevebauman-purify-ce8d10c0dfe804d90470ff819b84d891037cd6bc";
        src = fetchurl {
          url = "https://api.github.com/repos/stevebauman/purify/zipball/ce8d10c0dfe804d90470ff819b84d891037cd6bc";
          sha256 = "0iqbqvvpd23z65ap24arjvppqj5d9rpz7fs3i5sqim0490dj8hav";
        };
      };
    };
    "symfony/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-ac2d25f97b17eec6e19760b6b9962a4f7c44356a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache/zipball/ac2d25f97b17eec6e19760b6b9962a4f7c44356a";
          sha256 = "0gq6a5z3r2900vnv37wcjk597pqbsz7ib13ykm182l7lwlq4j3z7";
        };
      };
    };
    "symfony/cache-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-contracts-1d74b127da04ffa87aa940abe15446fa89653778";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache-contracts/zipball/1d74b127da04ffa87aa940abe15446fa89653778";
          sha256 = "0n8zxm1qqlgzhk3f23s2bjll6il7qkszh1kr9p7hx895vp0rnk9c";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-a550a7c99daeedef3f9d23fb82e3531525ff11fd";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/a550a7c99daeedef3f9d23fb82e3531525ff11fd";
          sha256 = "0fsdnj89ikiaqc3ag6nmkd5iz06659i465qvz62b5lw4zw5zg6d1";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-d036c6c0d0b09e24a14a35f8292146a658f986e4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/d036c6c0d0b09e24a14a35f8292146a658f986e4";
          sha256 = "0pvgk0m2g8n6scwfwwmxj6dyqx2854zrkxizyfhpa8ikhh9a6kwj";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-7c3aff79d10325257a001fcf92d991f24fc967cf";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/7c3aff79d10325257a001fcf92d991f24fc967cf";
          sha256 = "0p0c2942wjq1bb06y9i8gw6qqj7sin5v5xwsvl0zdgspbr7jk1m9";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-c873490a1c97b3a0a4838afc36ff36c112d02788";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c873490a1c97b3a0a4838afc36ff36c112d02788";
          sha256 = "0ac4a1zwi1fsisld4rq340y93pimzzlwja3ckx6r7yipb2yzkhib";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-d76d2632cfc2206eecb5ad2b26cd5934082941b6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/d76d2632cfc2206eecb5ad2b26cd5934082941b6";
          sha256 = "0gwi98335dll70dr9g7r5ll9sjx9yy079sdmwsyv82xpg8k72x5i";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-a76aed96a42d2b521153fb382d418e30d18b59df";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/a76aed96a42d2b521153fb382d418e30d18b59df";
          sha256 = "1w49s1q6xhcmkgd3xkyjggiwys0wvyny0p3018anvdi0k86zg678";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-11d736e97f116ac375a81f96e662911a34cd50ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/11d736e97f116ac375a81f96e662911a34cd50ce";
          sha256 = "0p0k05jilm3pfckzilfdpwjvmjppwb2dsg4ym9mxk7520qni8msj";
        };
      };
    };
    "symfony/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-5c584530b77aa10ae216989ffc48b4bedc9c0b29";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client/zipball/5c584530b77aa10ae216989ffc48b4bedc9c0b29";
          sha256 = "1adz59a11rd6zfp3nxaj4fq275sg0b1hh5rz6b9h93fd0ndx7ng5";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-1ee70e699b41909c209a0c930f11034b93578654";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client-contracts/zipball/1ee70e699b41909c209a0c930f11034b93578654";
          sha256 = "181m2alsmj9v8wkzn210g6v41nl2fx519f674p7r9q0m22ivk2ca";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-44a6d39a9cc11e154547d882d5aac1e014440771";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/44a6d39a9cc11e154547d882d5aac1e014440771";
          sha256 = "0zabky2ic9rn7mk9dfkwi86amixr1qywfr2hld6n2s0vchw9iv37";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-2953274c16a229b3933ef73a6898e18388e12e1b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/2953274c16a229b3933ef73a6898e18388e12e1b";
          sha256 = "0mbr9g6cr62iyf7r4m12p1v65xf21hc3az0gj400bks3w6gv5gxy";
        };
      };
    };
    "symfony/mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailer-ca8dcf8892cdc5b4358ecf2528429bb5e706f7ba";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailer/zipball/ca8dcf8892cdc5b4358ecf2528429bb5e706f7ba";
          sha256 = "16xpdz8gqri3m4xky31581m1gm07ivhxc9krz7f0crc4vpyzv7yp";
        };
      };
    };
    "symfony/mailgun-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mailgun-mailer-72d2f72f2016e559d0152188bef5a5dc9ebf5ec7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mailgun-mailer/zipball/72d2f72f2016e559d0152188bef5a5dc9ebf5ec7";
          sha256 = "1d5r62pksbdaffg3w89a8rfk5rxzdg1wg9wlqfszfm12kdg3d4gk";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-ca4f58b2ef4baa8f6cecbeca2573f88cd577d205";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/ca4f58b2ef4baa8f6cecbeca2573f88cd577d205";
          sha256 = "0lcq2avf9c8r35lhnbp8v5z5pypls4xxhz9pq5grn2x8n57h9fhk";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-ea208ce43cbb04af6867b4fdddb1bdbf84cc28cb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/ea208ce43cbb04af6867b4fdddb1bdbf84cc28cb";
          sha256 = "0ynkrpl3hb448dhab1injwwzfx68l75yn9zgc7lgqwbx60dvhqm3";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-875e90aeea2777b6f135677f618529449334a612";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/875e90aeea2777b6f135677f618529449334a612";
          sha256 = "19j8qcbp525q7i61c2lhj6z2diysz45q06d990fvjby15cn0id0i";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-ecaafce9f77234a6a449d29e49267ba10499116d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/ecaafce9f77234a6a449d29e49267ba10499116d";
          sha256 = "0f42w4975rakhysnmhsyw6n3rjg6rjg7b7x8gs1n0qfdb6wc8m3q";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8c4ad05dd0120b6a53c1ca374dca2ad0a1c4ed92";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8c4ad05dd0120b6a53c1ca374dca2ad0a1c4ed92";
          sha256 = "0msah2ii2174xh47v5x9vq1b1xn38yyx03sr3pa2rq3a849wi7nh";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-42292d99c55abe617799667f454222c54c60e229";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/42292d99c55abe617799667f454222c54c60e229";
          sha256 = "1m3l12y0lid3i0zy3m1jrk0z3zy8wpa7nij85zk2h5vbf924jnwa";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-70f4aebd92afca2f865444d30a4d2151c13c3179";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/70f4aebd92afca2f865444d30a4d2151c13c3179";
          sha256 = "10j5ipx16p6rybkpawqscpr2wcnby4270rbdj1qchr598wkvi0kb";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-6caa57379c4aec19c0a12a38b59b26487dcfe4b5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/6caa57379c4aec19c0a12a38b59b26487dcfe4b5";
          sha256 = "05yfindyip9lbfr5apxkz6m0mlljrc9z6qylpxr6k5nkivlrcn9x";
        };
      };
    };
    "symfony/polyfill-php83" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php83-b0f46ebbeeeda3e9d2faebdfbf4b4eae9b59fa11";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php83/zipball/b0f46ebbeeeda3e9d2faebdfbf4b4eae9b59fa11";
          sha256 = "0z0xk1ghssa5qknp7cm3phdam77q4n46bkiwfpc5jkparkq958yb";
        };
      };
    };
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-9c44518a5aff8da565c8a55dbe85d2769e6f630e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/9c44518a5aff8da565c8a55dbe85d2769e6f630e";
          sha256 = "0w6mphwcz3n1qz0dc6nld5xqb179dvfcwys6r4nj4gjv5nm2nji0";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-191703b1566d97a5425dc969e4350d32b8ef17aa";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/191703b1566d97a5425dc969e4350d32b8ef17aa";
          sha256 = "0z2qbb0l0m1js7vgwmcjmgz479ssbpv9smdc3nymyrwfzbb0m117";
        };
      };
    };
    "symfony/psr-http-message-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-psr-http-message-bridge-581ca6067eb62640de5ff08ee1ba6850a0ee472e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/psr-http-message-bridge/zipball/581ca6067eb62640de5ff08ee1ba6850a0ee472e";
          sha256 = "1x9zyp5kmr1vdb457varl32bsr34j8ibcj1hd5kn5601wx6b1hf5";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-0c95c164fdba18b12523b75e64199ca3503e6d40";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/0c95c164fdba18b12523b75e64199ca3503e6d40";
          sha256 = "0vq86glzh42k3m8v3swp4wppbby75q4s098ajm3rqlaj2ky4iv06";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-b3313c2dbffaf71c8de2934e2ea56ed2291a3838";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/b3313c2dbffaf71c8de2934e2ea56ed2291a3838";
          sha256 = "1blpfzdflh4yl1wqvd94acavlvdn6nrnyssrpsm9286wzh6a6n4k";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-b45fcf399ea9c3af543a92edf7172ba21174d809";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/b45fcf399ea9c3af543a92edf7172ba21174d809";
          sha256 = "1vwwfm5wwalyrfrs8w68cwjfwglhpmvfpilsrz1hd1ilf5j5dh3d";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-b1035dbc2a344b21f8fa8ac451c7ecec4ea45f37";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/b1035dbc2a344b21f8fa8ac451c7ecec4ea45f37";
          sha256 = "1qkyl84pql3b163ldk5w5pv21yqq6frk1bbrgjic7fxji58j6qfv";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-dee0c6e5b4c07ce851b462530088e64b255ac9c5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/dee0c6e5b4c07ce851b462530088e64b255ac9c5";
          sha256 = "0dwfy3qd1w6pdlcxnxgdjnwpb5zv9wxd488bdss0db6pfr43zqwx";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-8092dd1b1a41372110d06374f99ee62f7f0b9a92";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/8092dd1b1a41372110d06374f99ee62f7f0b9a92";
          sha256 = "0wa5ja89lzf4is5393smfxswq1dkyiyrj6qcd32cs9hnrik9rw0q";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-c40f7d17e91d8b407582ed51a2bbf83c52c367f6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/c40f7d17e91d8b407582ed51a2bbf83c52c367f6";
          sha256 = "0idnivgds7w523bf4d6p3frqy21vzqmjpsjrw9grvs5gq7rzlz2x";
        };
      };
    };
    "symfony/var-exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-exporter-2d08ca6b9cc704dce525615d1e6d1788734f36d9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-exporter/zipball/2d08ca6b9cc704dce525615d1e6d1788734f36d9";
          sha256 = "1iw2mg0626pmpk4rdv1c2chyp15h64xvgap6mgnvrhr5sfxg1qrc";
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
        name = "vlucas-phpdotenv-2cf9fb6054c2bb1d59d1f3817706ecdb9d2934c4";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/2cf9fb6054c2bb1d59d1f3817706ecdb9d2934c4";
          sha256 = "0zb5gm5i6rnmm9zc4mi3wkkhpgciaa76w8jyxnw914xwq1xqzivx";
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
    "web-token/jwt-core" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "web-token-jwt-core-4d956e786a4e35d54c74787ebff840a0311c5e83";
        src = fetchurl {
          url = "https://api.github.com/repos/web-token/jwt-core/zipball/4d956e786a4e35d54c74787ebff840a0311c5e83";
          sha256 = "0ldajzhq9s7hwln07sga973yj65g7y9s30x8f3i6yi408zrih4pf";
        };
      };
    };
    "web-token/jwt-key-mgmt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "web-token-jwt-key-mgmt-bf6dec304f2a718d70f7316e498c612317c59e08";
        src = fetchurl {
          url = "https://api.github.com/repos/web-token/jwt-key-mgmt/zipball/bf6dec304f2a718d70f7316e498c612317c59e08";
          sha256 = "0n4pfxn6452zpjzvqr50bjfa8fdjmfjv4yfq5ldppa7m5sxnhfcs";
        };
      };
    };
    "web-token/jwt-signature" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "web-token-jwt-signature-14b71230d9632564e356b785366ad36880964190";
        src = fetchurl {
          url = "https://api.github.com/repos/web-token/jwt-signature/zipball/14b71230d9632564e356b785366ad36880964190";
          sha256 = "1lnnq4iwxrpw3db1pnxasv23pil4lz4p0iipzjzidzr226wa0l8i";
        };
      };
    };
    "web-token/jwt-signature-algorithm-ecdsa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "web-token-jwt-signature-algorithm-ecdsa-e09159600f19832cf4a68921e7299e564bc0eaf9";
        src = fetchurl {
          url = "https://api.github.com/repos/web-token/jwt-signature-algorithm-ecdsa/zipball/e09159600f19832cf4a68921e7299e564bc0eaf9";
          sha256 = "0pzvyp0g8r6gh7fij864gmamlavb8skkiby83x91khrdm3ch856y";
        };
      };
    };
    "web-token/jwt-util-ecc" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "web-token-jwt-util-ecc-b2337052dbee724d710c1fdb0d3609835a5f8609";
        src = fetchurl {
          url = "https://api.github.com/repos/web-token/jwt-util-ecc/zipball/b2337052dbee724d710c1fdb0d3609835a5f8609";
          sha256 = "0pn2qbb016kxvklck271xgl7fjcvvrrk1j9lnx95a3p9mz81lsrs";
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
        name = "brianium-paratest-8083a421cee7dad847ee7c464529043ba30de380";
        src = fetchurl {
          url = "https://api.github.com/repos/paratestphp/paratest/zipball/8083a421cee7dad847ee7c464529043ba30de380";
          sha256 = "1m8ms7aylxryn2332dv58amnd3x0l1k9nvvd20i4whc1z8sydnsf";
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
        name = "fakerphp-faker-e3daa170d00fde61ea7719ef47bb09bb8f1d9b01";
        src = fetchurl {
          url = "https://api.github.com/repos/FakerPHP/Faker/zipball/e3daa170d00fde61ea7719ef47bb09bb8f1d9b01";
          sha256 = "1n99cfc737xcyvip3k9j1f5iy91bh1m64xg404xa7gvzlgpdnm7n";
        };
      };
    };
    "fidry/cpu-core-counter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fidry-cpu-core-counter-85193c0b0cb5c47894b5eaec906e946f054e7077";
        src = fetchurl {
          url = "https://api.github.com/repos/theofidry/cpu-core-counter/zipball/85193c0b0cb5c47894b5eaec906e946f054e7077";
          sha256 = "1yc7l1jn509n5k6bxs7zdm6322m71ghwz8q164kprcfmqmlb8i9v";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-a139776fa3f5985a50b509f2a02ff0f709d2a546";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/a139776fa3f5985a50b509f2a02ff0f709d2a546";
          sha256 = "18sfx7s3936q7i4hhn08lr5728c6bqyfqji6kzczjzhlyqkbys10";
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
        name = "laravel-telescope-64da53ee46b99ef328458eaed32202b51e325a11";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/telescope/zipball/64da53ee46b99ef328458eaed32202b51e325a11";
          sha256 = "1sgsmdnz4k36pqiw4dkynf68r11fcbbjl9r47361p9dgppj1n8wn";
        };
      };
    };
    "mockery/mockery" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mockery-mockery-b8e0bb7d8c604046539c1115994632c74dcb361e";
        src = fetchurl {
          url = "https://api.github.com/repos/mockery/mockery/zipball/b8e0bb7d8c604046539c1115994632c74dcb361e";
          sha256 = "1fbz87008ffn35k7wgwsx3g5pdrjsc9pygza71as9bmbkxkryjlr";
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
        name = "phpunit-php-code-coverage-6a3a87ac2bbe33b25042753df8195ba4aa534c76";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/6a3a87ac2bbe33b25042753df8195ba4aa534c76";
          sha256 = "1bh1bxnnvxdjfm0chza9znkn1b5jncvr794xj3npvdm9szbbkyg8";
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
        name = "phpunit-phpunit-05017b80304e0eb3f31d90194a563fd53a6021f1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/phpunit/zipball/05017b80304e0eb3f31d90194a563fd53a6021f1";
          sha256 = "1027h6phxp8bxjmn8586idpzalyg60i8ihwgjg3pm4za93dz8llk";
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
        name = "sebastian-diff-74be17022044ebaaecfdf0c5cd504fc9cd5a7131";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/74be17022044ebaaecfdf0c5cd504fc9cd5a7131";
          sha256 = "0f90471bi8lkmffms3bc2dnggqv8a81y1f4gi7p3r5120328mjm0";
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
        name = "sebastian-global-state-bde739e7565280bda77be70044ac1047bc007e34";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/global-state/zipball/bde739e7565280bda77be70044ac1047bc007e34";
          sha256 = "0lk9hbvrma0jm4z2nm8dr94w0pinlnp6wzcczcm1cjkm4zx0yabw";
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
        name = "theseer-tokenizer-b2ad5003ca10d4ee50a12da31de12a5774ba6b96";
        src = fetchurl {
          url = "https://api.github.com/repos/theseer/tokenizer/zipball/b2ad5003ca10d4ee50a12da31de12a5774ba6b96";
          sha256 = "03yw81yj8m9dzbifx0zj455jw59fwbiqidaqq2vyh56a6k5sdkgb";
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
