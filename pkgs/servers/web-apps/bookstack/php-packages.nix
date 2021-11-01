{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-949feb83cc0db46f07b12aa3128d47be3b9cca63";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/949feb83cc0db46f07b12aa3128d47be3b9cca63;
          sha256 = "1zppyh58317ai78dcvy5gnhxgaga421j69zzsv2vkjs1sgj4zw1w";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-f73543ac4e1def05f1a70bcd1525c8a157a1ad09";
        src = fetchurl {
          url = https://api.github.com/repos/Bacon/BaconQrCode/zipball/f73543ac4e1def05f1a70bcd1525c8a157a1ad09;
          sha256 = "1df22bfrc8q62qz8brrs8p2rmmv5gsaxdyjrd2ln6d6j7i4jkjpk";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-5b99e1f94157d74e450f4c97e8444fcaffa2144b";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/5b99e1f94157d74e450f4c97e8444fcaffa2144b;
          sha256 = "1r82fzrnjrjy5jgpyc071miiw1rwhwys9ccj81gs3yydq9hi4crw";
        };
      };
    };
    "barryvdh/laravel-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-snappy-1903ab84171072b6bff8d98eb58d38b2c9aaf645";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/laravel-snappy/zipball/1903ab84171072b6bff8d98eb58d38b2c9aaf645;
          sha256 = "1awr5kwj482qsh5wpg0q44fjqi7a9q26ghcc9wp1n9zm97y0rx7a";
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dasprid-enum-5abf82f213618696dda8e3bf6f64dd042d8542b2";
        src = fetchurl {
          url = https://api.github.com/repos/DASPRiD/Enum/zipball/5abf82f213618696dda8e3bf6f64dd042d8542b2;
          sha256 = "0rs7i1xiwhssy88s7bwnp5ri5fi2xy3fl7pw6l5k27xf2f1hv7q6";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-331b4d5dbaeab3827976273e9356b3b453c300ce";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/cache/zipball/331b4d5dbaeab3827976273e9356b3b453c300ce;
          sha256 = "1ksr3460a5dpqgq5kgy2l7kdz7fairpvmip8nwaz9y833r5hnnyz";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-8dd39d2ead4409ce652fd4f02621060f009ea5e4";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/8dd39d2ead4409ce652fd4f02621060f009ea5e4;
          sha256 = "107k0qr3m34cjxy00yhdjmd8liqa8wg729zj4z2jifz26niiy8qs";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-9504165960a1f83cc1480e2be1dd0a0478561314";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/deprecations/zipball/9504165960a1f83cc1480e2be1dd0a0478561314;
          sha256 = "04kpbzk5iw86imspkg7dgs54xx877k9b5q0dfg2h119mlfkvxil6";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-41370af6a30faa9dc0368c4a6814d596e81aba7f";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/event-manager/zipball/41370af6a30faa9dc0368c4a6814d596e81aba7f;
          sha256 = "0pn2aiwl4fvv6fcwar9alng2yrqy8bzc58n4bkp6y2jnpw5gp4m8";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-9cf661f4eb38f7c881cac67c75ea9b00bf97b210";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/inflector/zipball/9cf661f4eb38f7c881cac67c75ea9b00bf97b210;
          sha256 = "0gkaw5aqkdppd7cz1n46kdms0bv8kzbnpjh75jnhv98p9fik7f24";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-e864bbf5904cb8f5bb334f99209b48018522f042";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/lexer/zipball/e864bbf5904cb8f5bb334f99209b48018522f042;
          sha256 = "11lg9fcy0crb8inklajhx3kyffdbx7xzdj8kwl21xsgq9nm9iwvv";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-8768448244967a46d6e67b891d30878e0e15d25c";
        src = fetchurl {
          url = https://api.github.com/repos/dompdf/dompdf/zipball/8768448244967a46d6e67b891d30878e0e15d25c;
          sha256 = "0mgsry4mq5bx6b74h3akay1bp03rnsl8ppcjxjkfjlq4svq7m5yf";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-65b2d8ee1f10915efb3b55597da3404f096acba2";
        src = fetchurl {
          url = https://api.github.com/repos/dragonmantank/cron-expression/zipball/65b2d8ee1f10915efb3b55597da3404f096acba2;
          sha256 = "07yqbhf6n4d818gvla60mgg23gichwiafd5ypd70w4b4dlbcxcpl";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-0dbf5d78455d4d6a41d186da50adc1122ec066f4";
        src = fetchurl {
          url = https://api.github.com/repos/egulias/EmailValidator/zipball/0dbf5d78455d4d6a41d186da50adc1122ec066f4;
          sha256 = "00kwb8rhk1fq3a1i152xniipk3y907q1v5r3szqbkq5rz82dwbck";
        };
      };
    };
    "facade/flare-client-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-flare-client-php-47b639dc02bcfdfc4ebb83de703856fa01e35f5f";
        src = fetchurl {
          url = https://api.github.com/repos/facade/flare-client-php/zipball/47b639dc02bcfdfc4ebb83de703856fa01e35f5f;
          sha256 = "1chpfxmnlpl98cg127i70ari7nb3w83l91l119hc2fhyjk0zrcy5";
        };
      };
    };
    "facade/ignition" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-fca0cbe5f900f94773d821b481c16d4ea3503491";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition/zipball/fca0cbe5f900f94773d821b481c16d4ea3503491;
          sha256 = "0kqjavny0k8j337jxk4nwzbrfzc3hxka8jklk9a90yx4vnxxyjqb";
        };
      };
    };
    "facade/ignition-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-contracts-3c921a1cdba35b68a7f0ccffc6dffc1995b18267";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition-contracts/zipball/3c921a1cdba35b68a7f0ccffc6dffc1995b18267;
          sha256 = "1nsjwd1k9q8qmfvh7m50rs42yxzxyq4f56r6dq205gwcmqsjb2j0";
        };
      };
    };
    "fideloper/proxy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fideloper-proxy-c073b2bd04d1c90e04dc1b787662b558dd65ade0";
        src = fetchurl {
          url = https://api.github.com/repos/fideloper/TrustedProxy/zipball/c073b2bd04d1c90e04dc1b787662b558dd65ade0;
          sha256 = "05jzgjj4fy5p1smqj41b5qxj42zn0mnczvsaacni4fmq174mz4gy";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-15ead64e9828f0fc90932114429c4f7923570cb1";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/15ead64e9828f0fc90932114429c4f7923570cb1;
          sha256 = "1ca4l4nxcjgn6a2w3d0w1xlgskmq8mfk7mb8xvcbmlgg29k2z0vq";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-7008573787b430c1c1f650e3722d9bba59967628";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/guzzle/zipball/7008573787b430c1c1f650e3722d9bba59967628;
          sha256 = "10fiv9ifhz5vg78z4xa41dkwic5ql4m6xf8bglyvpw3x7b76l81m";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-8e7d04f1f6450fef59366c399cfad4b9383aa30d";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/promises/zipball/8e7d04f1f6450fef59366c399cfad4b9383aa30d;
          sha256 = "158wd8nmvvl386c24lkr4jkwdhqpdj0dxdbjwh8iv6a2rgccjr2q";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-dc960a912984efb74d0a90222870c72c87f10c91";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/dc960a912984efb74d0a90222870c72c87f10c91;
          sha256 = "06nc60wf8k6kcl89kprk04khsrrik5lnis615mx4a0m0pjn8bliz";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-0925f10b259679b5d8ca58f3a2add9255ffcda45";
        src = fetchurl {
          url = https://api.github.com/repos/Intervention/image/zipball/0925f10b259679b5d8ca58f3a2add9255ffcda45;
          sha256 = "0kqd9j0kjv62i56cfnh0n1zvghq1hcknq8sa602px9lvp7k2978s";
        };
      };
    };
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-7bac60fb729147b7ccd8532c07df3f52a4afa8a4";
        src = fetchurl {
          url = https://api.github.com/repos/KnpLabs/snappy/zipball/7bac60fb729147b7ccd8532c07df3f52a4afa8a4;
          sha256 = "0qbywknz3zwhk91yaqd5p6nf48hzk1zmyqgrc9nb9ys2v6wy6njz";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-49aa211f2dd1d419bfd9dbbd6f590d57a1dfda58";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/49aa211f2dd1d419bfd9dbbd6f590d57a1dfda58;
          sha256 = "0x30liyv4rfsk183b8857nxdhiginf30zz132jwyp408b1pswgqb";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-fd0f6a3dd963ca480b598649b54f92d81a43617f";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/socialite/zipball/fd0f6a3dd963ca480b598649b54f92d81a43617f;
          sha256 = "08x0pn4ib5nhh9jkkb5brf8yj0fq6v6gn1qg97hss3mvnhazk5wx";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-c4228d11e30d7493c6836d20872f9582d8ba6dcf";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/commonmark/zipball/c4228d11e30d7493c6836d20872f9582d8ba6dcf;
          sha256 = "0x18k1qmvskd5x1b3jkkmig6l734sxffj5xyfb82yrzgpw9lrld5";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-18634df356bfd4119fe3d6156bdb990c414c14ea";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/18634df356bfd4119fe3d6156bdb990c414c14ea;
          sha256 = "1cy0xmnl3ck7cb6ibl9jjw5pmbw15mww5q06vacgq5lnx8r5w700";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-4e25cc0582a36a786c31115e419c6e40498f6972";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/4e25cc0582a36a786c31115e419c6e40498f6972;
          sha256 = "1q2vkgyaz7h6z3q0z3v3l5rsvhv4xc45prgzr214cgm656i2h1ab";
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-html-to-markdown-c4dbebbebe0fe454b6b38e6c683a977615bd7dc2";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/html-to-markdown/zipball/c4dbebbebe0fe454b6b38e6c683a977615bd7dc2;
          sha256 = "0d6233c4b8lzk7a9ylw7ck7rpai9l983z7dc0551p7q7b716x0pk";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-3b9dff8aaf7323590c1d2e443db701eb1f9aa0d3";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/mime-type-detection/zipball/3b9dff8aaf7323590c1d2e443db701eb1f9aa0d3;
          sha256 = "0pmq486v2nf6672y2z53cyb3mfrxcc8n7z2ilpzz9zkkf2yb990j";
        };
      };
    };
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-88dd16b0cff68eb9167bfc849707d2c40ad91ddc";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth1-client/zipball/88dd16b0cff68eb9167bfc849707d2c40ad91ddc;
          sha256 = "1b0zza3qxqgn57105wbfw2fzphj3l3f7iqh7v3w98pdvaiapaf5d";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-71312564759a7db5b789296369c1a264efc43aad";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/71312564759a7db5b789296369c1a264efc43aad;
          sha256 = "1q799qbidn3wdqvj3492lia261vawyjjwxcx7wik8g9kxwn6pmkj";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-9b87907a81b87bc76d19a7fb2d61e61486ee9edb";
        src = fetchurl {
          url = https://api.github.com/repos/jmespath/jmespath.php/zipball/9b87907a81b87bc76d19a7fb2d61e61486ee9edb;
          sha256 = "1ig3gi6f8gisagcn876598ps48s86s6m0c82diyksylarg3yn0yd";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-369c0e2737c56a0f39c946dd261855255a6fccbe";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/369c0e2737c56a0f39c946dd261855255a6fccbe;
          sha256 = "08n219hyp0zsr4j433ail3iaribv07jskws95z45yivasl63g8wa";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-f7c45764dfe4ba5f2618d265a6f1f9c72732e01d";
        src = fetchurl {
          url = https://api.github.com/repos/nunomaduro/collision/zipball/f7c45764dfe4ba5f2618d265a6f1f9c72732e01d;
          sha256 = "1cazbjxl5rqw4cl783nrymhcvjhvwwwjswr5w0si1wfhmpvr349q";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-f30f5062f3653c4d2082892d207f4dc3e577d979";
        src = fetchurl {
          url = https://api.github.com/repos/onelogin/php-saml/zipball/f30f5062f3653c4d2082892d207f4dc3e577d979;
          sha256 = "0nl431rx1gngc2g92w4hjf2y26vjvscgbrwhq0m6kzm9kq043qzh";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-06e2ebd25f2869e54a306dda991f7db58066f7f6";
        src = fetchurl {
          url = https://api.github.com/repos/opis/closure/zipball/06e2ebd25f2869e54a306dda991f7db58066f7f6;
          sha256 = "0fpa1w0rmwywj67jgaldmw563p7gycahs8gpkpjvrra9zhhj4yyc";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/constant_time_encoding/zipball/f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c;
          sha256 = "1r1xj3j7s5mskw5gh3ars4dfhvcn7d252gdqgpif80026kj5fvrp";
        };
      };
    };
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-996434e5492cb4c3edcb9168db6fbb1359ef965a";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/random_compat/zipball/996434e5492cb4c3edcb9168db6fbb1359ef965a;
          sha256 = "0ky7lal59dihf969r1k3pb96ql8zzdc5062jdbg69j6rj0scgkyx";
        };
      };
    };
    "phenx/php-font-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-font-lib-ca6ad461f032145fff5971b5985e5af9e7fa88d8";
        src = fetchurl {
          url = https://api.github.com/repos/PhenX/php-font-lib/zipball/ca6ad461f032145fff5971b5985e5af9e7fa88d8;
          sha256 = "0grirw04sfg38fd4h0yaks43s49cxr5bisrr4ligjig2q3rjai31";
        };
      };
    };
    "phenx/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-svg-lib-5fa61b65e612ce1ae15f69b3d223cb14ecc60e32";
        src = fetchurl {
          url = https://api.github.com/repos/PhenX/php-svg-lib/zipball/5fa61b65e612ce1ae15f69b3d223cb14ecc60e32;
          sha256 = "1jbkn7wm82y6pbyb7gx989k4yaprsc7xpa49nn4ywscmkz7ckd5y";
        };
      };
    };
    "php-parallel-lint/php-console-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-color-b6af326b2088f1ad3b264696c9fd590ec395b49e";
        src = fetchurl {
          url = https://api.github.com/repos/php-parallel-lint/PHP-Console-Color/zipball/b6af326b2088f1ad3b264696c9fd590ec395b49e;
          sha256 = "030449mkpxs35y8dk336ls3bfdq3zjnxswnk5khlg45z5147cr3k";
        };
      };
    };
    "php-parallel-lint/php-console-highlighter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-highlighter-21bf002f077b177f056d8cb455c5ed573adfdbb8";
        src = fetchurl {
          url = https://api.github.com/repos/php-parallel-lint/PHP-Console-Highlighter/zipball/21bf002f077b177f056d8cb455c5ed573adfdbb8;
          sha256 = "013phmp5n6hp6mvlpbqbrih0zd8h7xc152dpzxxf49b0jczxh8y4";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-5455cb38aed4523f99977c4a12ef19da4bfe2a28";
        src = fetchurl {
          url = https://api.github.com/repos/schmittjoh/php-option/zipball/5455cb38aed4523f99977c4a12ef19da4bfe2a28;
          sha256 = "009q2afjkjl8psisr8jsw9k08qnkb0f4hgd6izrjmm06bd7bk9ah";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-26c4c5cf30a2844ba121760fd7301f8ad240100b";
        src = fetchurl {
          url = https://api.github.com/repos/antonioribeiro/google2fa/zipball/26c4c5cf30a2844ba121760fd7301f8ad240100b;
          sha256 = "1jmc7s3hbczvb0h4kfmya67l969nfww3lmc4slvzsz0zd769434h";
        };
      };
    };
    "predis/predis" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "predis-predis-b240daa106d4e02f0c5b7079b41e31ddf66fddf8";
        src = fetchurl {
          url = https://api.github.com/repos/predis/predis/zipball/b240daa106d4e02f0c5b7079b41e31ddf66fddf8;
          sha256 = "0wbsmq5c449vwfvsriyjwqaq5sjf9kw2chr4f2xlh3vqc4kw720j";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-8622567409010282b7aeebe4bb841fe98b58dcaf";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/container/zipball/8622567409010282b7aeebe4bb841fe98b58dcaf;
          sha256 = "0qfvyfp3mli776kb9zda5cpc8cazj3prk0bg0gm254kwxyfkfrwn";
        };
      };
    };
    "psr/http-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621;
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363;
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-d49695b909c3b7628b6289db5479a1c204601f11";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/d49695b909c3b7628b6289db5479a1c204601f11;
          sha256 = "0sb0mq30dvmzdgsnqvw3xh4fb4bqjncx72kf8n622f94dd48amln";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b;
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
        };
      };
    };
    "ralouphie/getallheaders" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ralouphie-getallheaders-120b605dfeb996808c31b6477290a714d356e822";
        src = fetchurl {
          url = https://api.github.com/repos/ralouphie/getallheaders/zipball/120b605dfeb996808c31b6477290a714d356e822;
          sha256 = "1bv7ndkkankrqlr2b4kw7qp3fl0dxi6bp26bnim6dnlhavd6a0gg";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-be2451bef8147b7352a28fb4cddb08adc497ada3";
        src = fetchurl {
          url = https://api.github.com/repos/ramsey/uuid/zipball/be2451bef8147b7352a28fb4cddb08adc497ada3;
          sha256 = "0jab9jc8yfsbd8ws1y47zmp13ivkmficiwf6xxgxrzmj6ihb8ah4";
        };
      };
    };
    "robrichards/xmlseclibs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "robrichards-xmlseclibs-f8f19e58f26cdb42c54b214ff8a820760292f8df";
        src = fetchurl {
          url = https://api.github.com/repos/robrichards/xmlseclibs/zipball/f8f19e58f26cdb42c54b214ff8a820760292f8df;
          sha256 = "01zlpm36rrdj310cfmiz2fnabszxd3fq80fa8x8j3f9ki7dvhh5y";
        };
      };
    };
    "sabberworm/php-css-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sabberworm-php-css-parser-d217848e1396ef962fb1997cf3e2421acba7f796";
        src = fetchurl {
          url = https://api.github.com/repos/sabberworm/PHP-CSS-Parser/zipball/d217848e1396ef962fb1997cf3e2421acba7f796;
          sha256 = "17jkly8k02p54qa004spikakxis8syjw3vhwgrsi9g1cb4wsg3g9";
        };
      };
    };
    "scrivo/highlight.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "scrivo-highlight.php-05996fcc61e97978d76ca7d1ac14b65e7cd26f91";
        src = fetchurl {
          url = https://api.github.com/repos/scrivo/highlight.php/zipball/05996fcc61e97978d76ca7d1ac14b65e7cd26f91;
          sha256 = "13pj4nbja3vzxkzb101vlgpziz2ha4xh8xyf58syw7cmc4a5djmf";
        };
      };
    };
    "socialiteproviders/discord" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-discord-c6eddeb07ace7473e82d02d4db852dfacf5ef574";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Discord/zipball/c6eddeb07ace7473e82d02d4db852dfacf5ef574;
          sha256 = "1w8m7jmlsdk94cqckgd75mwblh3jj6j16w3g4hzysyms25g091xc";
        };
      };
    };
    "socialiteproviders/gitlab" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-gitlab-a8f67d3b02c9ee8c70c25c6728417c0eddcbbb9d";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/GitLab/zipball/a8f67d3b02c9ee8c70c25c6728417c0eddcbbb9d;
          sha256 = "1blv2h69dmm0r0djz3h0l0cxkxmzd1fzgg13r3npxx7c80xjpw3a";
        };
      };
    };
    "socialiteproviders/manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-manager-0f5e82af0404df0080bdc5c105cef936c1711524";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Manager/zipball/0f5e82af0404df0080bdc5c105cef936c1711524;
          sha256 = "0ppmln72khli94ylnsjarnhzkqzpkc32pn3zf3ljahm1yghccczx";
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-64779ec21db0bee3111039a67c0fa0ab550a3462";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/64779ec21db0bee3111039a67c0fa0ab550a3462;
          sha256 = "00jjj7jwmhf2nypwwnmv5rbw6mw0phdlcz8rxybxzy72p2v51m1c";
        };
      };
    };
    "socialiteproviders/okta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-okta-e3ef9f23c7d2f86b3b16a174b82333cf4e2459e8";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Okta/zipball/e3ef9f23c7d2f86b3b16a174b82333cf4e2459e8;
          sha256 = "1a3anw5di5nqiabvqpmsjv5x0jasmsn4y876qsv77gazxja880ng";
        };
      };
    };
    "socialiteproviders/slack" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-slack-2b781c95daf06ec87a8f3deba2ab613d6bea5e8d";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Slack/zipball/2b781c95daf06ec87a8f3deba2ab613d6bea5e8d;
          sha256 = "1xilg7l1wc1vgwyakhfl8dpvgkjqx90g4khvzi411j9xa2wvpprh";
        };
      };
    };
    "socialiteproviders/twitch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-twitch-7accf30ae7a3139b757b4ca8f34989c09a3dbee7";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Twitch/zipball/7accf30ae7a3139b757b4ca8f34989c09a3dbee7;
          sha256 = "089i4fwxb32zmbxib0544jfs48wzjyp7bsqss2bf2xx89dsrx4ah";
        };
      };
    };
    "ssddanbrown/htmldiff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-htmldiff-f60d5cc278b60305ab980a6665f46117c5b589c0";
        src = fetchurl {
          url = https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/f60d5cc278b60305ab980a6665f46117c5b589c0;
          sha256 = "12h3swr8rjf5w78kfgwzkf0zb59b4a8mjwf65fgcgvjg115wha9x";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-15f7faf8508e04471f666633addacf54c0ab5933";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/15f7faf8508e04471f666633addacf54c0ab5933;
          sha256 = "1xiisdaxlmkzi16szh7lm3ay9vr9pdz0q2ah7vqaqrm2b4mwd90g";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-a3f7189a0665ee33b50e9e228c46f50f5acbed22";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/a3f7189a0665ee33b50e9e228c46f50f5acbed22;
          sha256 = "09f41pcx2dlyfbgsphz8976hzr3vvb7i1cx8qq9s96z1l7syq4mf";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-5194f18bd80d106f11efa8f7cd0fbdcc3af96ce6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/5194f18bd80d106f11efa8f7cd0fbdcc3af96ce6;
          sha256 = "0mjphps4rp52l01nhxjdzv0866k0vs3y2jdms0g3z2y1rwb95nz6";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-2f9160e92eb64c95da7368c867b663a8e34e980c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/2f9160e92eb64c95da7368c867b663a8e34e980c;
          sha256 = "0vw2g71q11w7jz500dp9srkj4hmx50d7m693gk0dlgmnrgx51kkl";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-5f38c8804a9e97d23e0c8d63341088cd8a22d627";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/deprecation-contracts/zipball/5f38c8804a9e97d23e0c8d63341088cd8a22d627;
          sha256 = "11k6a8v9b6p0j788fgykq6s55baba29lg37fwvmn4igxxkfwmbp3";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-51f98f7aa99f00f3b1da6bafe934e67ae6ba6dc5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/51f98f7aa99f00f3b1da6bafe934e67ae6ba6dc5;
          sha256 = "1qy8j16crb271pz6frjxyy2b41f1ap8w2mwb2n5zr3gmg0iqm487";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-2fe81680070043c4c80e7cedceb797e34f377bac";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/2fe81680070043c4c80e7cedceb797e34f377bac;
          sha256 = "0qf59l1a1h25hl6bp1wwfl5s825f8ybw2jiwhalw7gfnrx8x68fb";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-84e23fdcd2517bf37aecbd16967e83f0caee25a7";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/84e23fdcd2517bf37aecbd16967e83f0caee25a7;
          sha256 = "1pcfrlc0rg8vdnp23y3y1p5qzng5nxf5i2c36g9x9f480xrnc1fw";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-70362f1e112280d75b30087c7598b837c1b468b6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/70362f1e112280d75b30087c7598b837c1b468b6;
          sha256 = "0f75c5mjig5ypigb4s1av3w67xizx6pl15wrqbyxa39a9qq58x6v";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-7e82f6084d7cae521a75ef2cb5c9457bbda785f4";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-client-contracts/zipball/7e82f6084d7cae521a75ef2cb5c9457bbda785f4;
          sha256 = "04mszmb94y0xjs0cwqxzhpf65kfqhhqznldifbxvrrlxb9nn23qc";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-09b3202651ab23ac8dcf455284a48a3500e56731";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/09b3202651ab23ac8dcf455284a48a3500e56731;
          sha256 = "1kvh2hy9ng9dlivc9ippzg3h3jrqfpv1ygvrz6s9padsprw8j8ag";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-87f7ea4a8a7a30c967e26001de99f12943bf57ae";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/87f7ea4a8a7a30c967e26001de99f12943bf57ae;
          sha256 = "0i17fnvqmz5zvhgq3l1kjxr1xsmkwx09vn2sqcqxbvrl79qlncjf";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-ae887cb3b044658676129f5e97aeb7e9eb69c2d8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/ae887cb3b044658676129f5e97aeb7e9eb69c2d8;
          sha256 = "049fazdf4rw6488bxbv902frcpqdkasbpmk7jdnywpbdhy4pz4c9";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce;
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-63b5bb7db83e5673936d6e3b8b3e022ff6474933";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/63b5bb7db83e5673936d6e3b8b3e022ff6474933;
          sha256 = "1jyjsjprsgb3r6cbc4x1wg1q1zqakqm8a62ah5lppxnjgq1sgjc5";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-65bd267525e82759e7d8c4e8ceea44f398838e65";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/65bd267525e82759e7d8c4e8ceea44f398838e65;
          sha256 = "1cx2cjx0vzni297l7avd3cb1q4c8d2hylkvdqcjlpxjqdimn4jkn";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8;
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-9174a3d80210dca8daa7f31fec659150bbeabfc6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/9174a3d80210dca8daa7f31fec659150bbeabfc6;
          sha256 = "17bhba3093di6xgi8f0cnf3cdd7fnbyp9l76d9y33cym6213ayx1";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9a142215a36a3888e30d0a9eeea9766764e96976";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php72/zipball/9a142215a36a3888e30d0a9eeea9766764e96976;
          sha256 = "06ipbcvrxjzgvraf2z9fwgy0bzvzjvs5z1j67grg1gb15x3d428b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010;
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-1100343ed1a92e3a38f9ae122fc0eb21602547be";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/1100343ed1a92e3a38f9ae122fc0eb21602547be;
          sha256 = "0kwk2qgwswsmbfp1qx31ahw3lisgyivwhw5dycshr5v2iwwx3rhi";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-13d3161ef63a8ec21eeccaaf9a4d7f784a87a97d";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/13d3161ef63a8ec21eeccaaf9a4d7f784a87a97d;
          sha256 = "1h41y2k100fmrjz90m0vafpfgg2da6byy9m6vf1j9q41bhv6zccl";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-9ddf033927ad9f30ba2bfd167a7b342cafa13e8e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/9ddf033927ad9f30ba2bfd167a7b342cafa13e8e;
          sha256 = "1l3b5z0kn7f9q0whrm2wnxv0l038w3la75bf95pbs74szlnibfhz";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/f040a30e04b57fbcc9c6cbcf4dbaa96bd318b9bb;
          sha256 = "1i573rmajc33a9nrgwgc4k3svg29yp9xv17gp133rd1i705hwv1y";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-db0ba1e85280d8ff11e38d53c70f8814d4d740f5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/db0ba1e85280d8ff11e38d53c70f8814d4d740f5;
          sha256 = "08qxma91sffj8vqzb8dshwsxqf80y9kym3bsxx3gz05ksi01hk1d";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-95c812666f3e91db75385749fe219c5e494c7f95";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation-contracts/zipball/95c812666f3e91db75385749fe219c5e494c7f95;
          sha256 = "073l1pbmwbkaviwwjq9ypb1w7dk366nn2vn1vancbal0zqk0zx7b";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-7f65c44c2ce80d3a0fcdb6385ee0ad535e45660c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/7f65c44c2ce80d3a0fcdb6385ee0ad535e45660c;
          sha256 = "0hz1gn1zdbpfcx5wll7ysdimckia7fzaf26mv3z1zy567vsx9fc1";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-b43b05cf43c1b6d849478965062b6ef73e223bb5";
        src = fetchurl {
          url = https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/b43b05cf43c1b6d849478965062b6ef73e223bb5;
          sha256 = "0lc6jviz8faqxxs453dbqvfdmm6l2iczxla22v2r6xhakl58pf3w";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-5e679f7616db829358341e2d5cccbd18773bdab8";
        src = fetchurl {
          url = https://api.github.com/repos/vlucas/phpdotenv/zipball/5e679f7616db829358341e2d5cccbd18773bdab8;
          sha256 = "05j5wj1hry30vaqna4a232gjlibp89ha3ibhy04x5lbm0c98b73q";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "bookstack";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "MIT";
  };
}
