{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-3942776a8c99209908ee0b287746263725685732";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/3942776a8c99209908ee0b287746263725685732";
          sha256 = "0g4vjln6s1419ydljn5m64kzid0b7cplbc0nwn3y4cj72408fyiz";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-58fa9d8b522b0afa260299179ff950c783ff0ee1";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/58fa9d8b522b0afa260299179ff950c783ff0ee1";
          sha256 = "1d0v1q2c206jfdkci9d5b5sf94a0nbdh472n3hqlh11pb1lzp3fz";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-f73543ac4e1def05f1a70bcd1525c8a157a1ad09";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/f73543ac4e1def05f1a70bcd1525c8a157a1ad09";
          sha256 = "1df22bfrc8q62qz8brrs8p2rmmv5gsaxdyjrd2ln6d6j7i4jkjpk";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-5b99e1f94157d74e450f4c97e8444fcaffa2144b";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/5b99e1f94157d74e450f4c97e8444fcaffa2144b";
          sha256 = "1r82fzrnjrjy5jgpyc071miiw1rwhwys9ccj81gs3yydq9hi4crw";
        };
      };
    };
    "barryvdh/laravel-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-snappy-1903ab84171072b6bff8d98eb58d38b2c9aaf645";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-snappy/zipball/1903ab84171072b6bff8d98eb58d38b2c9aaf645";
          sha256 = "1awr5kwj482qsh5wpg0q44fjqi7a9q26ghcc9wp1n9zm97y0rx7a";
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
    "composer/package-versions-deprecated" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-package-versions-deprecated-b174585d1fe49ceed21928a945138948cb394600";
        src = fetchurl {
          url = "https://api.github.com/repos/composer/package-versions-deprecated/zipball/b174585d1fe49ceed21928a945138948cb394600";
          sha256 = "0m5hd3wfaka53n51b9aavyifwc2bdyr3jwywpkmpyrlmmn67c8ax";
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dasprid-enum-5abf82f213618696dda8e3bf6f64dd042d8542b2";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/5abf82f213618696dda8e3bf6f64dd042d8542b2";
          sha256 = "0rs7i1xiwhssy88s7bwnp5ri5fi2xy3fl7pw6l5k27xf2f1hv7q6";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-331b4d5dbaeab3827976273e9356b3b453c300ce";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/331b4d5dbaeab3827976273e9356b3b453c300ce";
          sha256 = "1ksr3460a5dpqgq5kgy2l7kdz7fairpvmip8nwaz9y833r5hnnyz";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-5d54f63541d7bed1156cb5c9b79274ced61890e4";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/5d54f63541d7bed1156cb5c9b79274ced61890e4";
          sha256 = "1mqrijv0rrrcil2wcb5jvryfcl9phskbk4llj5gsf1hmrj0pfsgq";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-9504165960a1f83cc1480e2be1dd0a0478561314";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/9504165960a1f83cc1480e2be1dd0a0478561314";
          sha256 = "04kpbzk5iw86imspkg7dgs54xx877k9b5q0dfg2h119mlfkvxil6";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-41370af6a30faa9dc0368c4a6814d596e81aba7f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/41370af6a30faa9dc0368c4a6814d596e81aba7f";
          sha256 = "0pn2aiwl4fvv6fcwar9alng2yrqy8bzc58n4bkp6y2jnpw5gp4m8";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
          sha256 = "1l83jbj4k59m1agi041gzx1rxix1wzxw9mvnivmg1hqr158149n7";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-e864bbf5904cb8f5bb334f99209b48018522f042";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/e864bbf5904cb8f5bb334f99209b48018522f042";
          sha256 = "11lg9fcy0crb8inklajhx3kyffdbx7xzdj8kwl21xsgq9nm9iwvv";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-de4aad040737a89fae2129cdeb0f79c45513128d";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/de4aad040737a89fae2129cdeb0f79c45513128d";
          sha256 = "1isjhijd3lxsl0k9lzgp7rzqcak3hb7w04cy4pn62wpxckhcc30i";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-7a8c6e56ab3ffcc538d05e8155bb42269abf1a0c";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/7a8c6e56ab3ffcc538d05e8155bb42269abf1a0c";
          sha256 = "0pl9zrj9254qbwr7vyiilzhmb7bq2ss631iwvlq1mqky2bwinj2l";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-0dbf5d78455d4d6a41d186da50adc1122ec066f4";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/0dbf5d78455d4d6a41d186da50adc1122ec066f4";
          sha256 = "00kwb8rhk1fq3a1i152xniipk3y907q1v5r3szqbkq5rz82dwbck";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-f056f1fe935d9ed86e698905a957334029899895";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/f056f1fe935d9ed86e698905a957334029899895";
          sha256 = "1qqznxsrlvjlnxlnr786a39igvq3pslxrvm5ks1v09ni88w44g7g";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-0690bde05318336c7221785f2a932467f98b64ca";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/0690bde05318336c7221785f2a932467f98b64ca";
          sha256 = "0a6kj3vxmhr1wh2kggmrl6y41hkg19jc0iq8qw095lf11mr4bd83";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-ee0a041b1760e6a53d2a39c8c34115adc2af2c79";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/ee0a041b1760e6a53d2a39c8c34115adc2af2c79";
          sha256 = "0wa63kw5fr5jhy2cv1g28qy9rsgwhn902447mzmgz17qjx72lzrb";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
          sha256 = "09ivi77y49bpc2sy3xhvgq22rfh2fhv921mn8402dv0a8bdprf56";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-089edd38f5b8abba6cb01567c2a8aaa47cec4c72";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/089edd38f5b8abba6cb01567c2a8aaa47cec4c72";
          sha256 = "1k29gax82rf82sbw2cbcp4qn3s3096csvmw9848l94q6ryc4j2rb";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-9a8cc99d30415ec0b3f7649e1647d03a55698545";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/9a8cc99d30415ec0b3f7649e1647d03a55698545";
          sha256 = "1fvfhxr8jyh6jjg3imacgvddgn222g822fq5p9yz8lqlw2ymcfnz";
        };
      };
    };
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-349c2e872bbeb15dff825a17dd92ea9c6ae4120e";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/349c2e872bbeb15dff825a17dd92ea9c6ae4120e";
          sha256 = "12fsslr3k1zn7rw9xnma3pvlmm4qvrapizhn4il4zqcmw51lgnl7";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-83fe447ae964dc5f1f829d25fa2f6042d9099834";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/83fe447ae964dc5f1f829d25fa2f6042d9099834";
          sha256 = "0843j6am2fmnyvgydd9fkc7fnjbj63ii25mnrbi6xnzqniq2lrrz";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-25de3be1bca1b17d52ff0dc02b646c667ac7266c";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/25de3be1bca1b17d52ff0dc02b646c667ac7266c";
          sha256 = "1fk4zbvlc3qcw50pbs1qw5hgc8a3xgv4hn185ghq5kmmxm3q84p6";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-b5c67f187ddcf15529ff7217fa735b132620dfac";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/b5c67f187ddcf15529ff7217fa735b132620dfac";
          sha256 = "0sryq8a6sr7n1b1cajdnd4xkwhfygkb6a7s4b176vvh64lps3nn9";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-a9ddee4761ec8453c584e393b393caff189a3e42";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/a9ddee4761ec8453c584e393b393caff189a3e42";
          sha256 = "1kzwwkxx1lzx6x85z29dd8a35jz3qw416p797s203vidayynn731";
        };
      };
    };
    "laravel/ui" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-ui-b3e804559bf3973ecca160a4ae1068e6c7c167c6";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/ui/zipball/b3e804559bf3973ecca160a4ae1068e6c7c167c6";
          sha256 = "1mf6f7508b3943bsb75x6myh62ry6r5n2iqicdiw3kv5f87c1c5a";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-c4228d11e30d7493c6836d20872f9582d8ba6dcf";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/c4228d11e30d7493c6836d20872f9582d8ba6dcf";
          sha256 = "0x18k1qmvskd5x1b3jkkmig6l734sxffj5xyfb82yrzgpw9lrld5";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-094defdb4a7001845300334e7c1ee2335925ef99";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/094defdb4a7001845300334e7c1ee2335925ef99";
          sha256 = "0dn71b1pwikbwz1cmmz9k1fc8k1fsmah3gy8sqxbz7czhqn5qiva";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-4e25cc0582a36a786c31115e419c6e40498f6972";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/4e25cc0582a36a786c31115e419c6e40498f6972";
          sha256 = "1q2vkgyaz7h6z3q0z3v3l5rsvhv4xc45prgzr214cgm656i2h1ab";
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-html-to-markdown-4d0394e120dc14b0d5c52fd1755fd48656da2ec9";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/4d0394e120dc14b0d5c52fd1755fd48656da2ec9";
          sha256 = "0my5k4cf5m3qb6bgq07dyq3347xm64sd1f83nr14ny3w31vb43cm";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-aa70e813a6ad3d1558fc927863d47309b4c23e69";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/aa70e813a6ad3d1558fc927863d47309b4c23e69";
          sha256 = "0k2kccf1v0002bb083p1ncmm8fbyflnkjx45808sxlkrxggzqcy3";
        };
      };
    };
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-88dd16b0cff68eb9167bfc849707d2c40ad91ddc";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth1-client/zipball/88dd16b0cff68eb9167bfc849707d2c40ad91ddc";
          sha256 = "1b0zza3qxqgn57105wbfw2fzphj3l3f7iqh7v3w98pdvaiapaf5d";
        };
      };
    };
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-badb01e62383430706433191b82506b6df24ad98";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/badb01e62383430706433191b82506b6df24ad98";
          sha256 = "1j2bmvy39k8wafisxdc0xn58gga5w9jpwp5hqjy51sk1s2ssws8i";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-fd4380d6fc37626e2f799f29d91195040137eba9";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/fd4380d6fc37626e2f799f29d91195040137eba9";
          sha256 = "1k56si01sjl93mxq1pk599yqqqhldqz34qi73y5jaga0m9iq07wk";
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
        name = "nesbot-carbon-8c2a18ce3e67c34efc1b29f64fe61304368259a2";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/8c2a18ce3e67c34efc1b29f64fe61304368259a2";
          sha256 = "0ld6pm7sj7myqs1xa9c2bh9l0v2qcr7lcv590sy0mqn0fcx2gqr5";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-210577fe3cf7badcc5814d99455df46564f3c077";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/210577fe3cf7badcc5814d99455df46564f3c077";
          sha256 = "191ijb7bybqnl1jayx6bipqh91dc9acg9zsbh89fk4h1ff87b1qp";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-f30f5062f3653c4d2082892d207f4dc3e577d979";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/f30f5062f3653c4d2082892d207f4dc3e577d979";
          sha256 = "0nl431rx1gngc2g92w4hjf2y26vjvscgbrwhq0m6kzm9kq043qzh";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-06e2ebd25f2869e54a306dda991f7db58066f7f6";
        src = fetchurl {
          url = "https://api.github.com/repos/opis/closure/zipball/06e2ebd25f2869e54a306dda991f7db58066f7f6";
          sha256 = "0fpa1w0rmwywj67jgaldmw563p7gycahs8gpkpjvrra9zhhj4yyc";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c";
          sha256 = "1r1xj3j7s5mskw5gh3ars4dfhvcn7d252gdqgpif80026kj5fvrp";
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
    "phenx/php-font-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-font-lib-ca6ad461f032145fff5971b5985e5af9e7fa88d8";
        src = fetchurl {
          url = "https://api.github.com/repos/PhenX/php-font-lib/zipball/ca6ad461f032145fff5971b5985e5af9e7fa88d8";
          sha256 = "0kl9lks1kpniby8dn8racjcjp6xjnhl3065y7ivarbl6ni6hyyxw";
        };
      };
    };
    "phenx/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-svg-lib-5fa61b65e612ce1ae15f69b3d223cb14ecc60e32";
        src = fetchurl {
          url = "https://api.github.com/repos/PhenX/php-svg-lib/zipball/5fa61b65e612ce1ae15f69b3d223cb14ecc60e32";
          sha256 = "1ppi3hs2r4cbd6b2xwf4znci6hpbs8469kqxk3msf7vi6vfnybbj";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
          sha256 = "1lk50y8jj2mzbwc2mxfm2xdasxf4axya72nv8wfc1vyz9y5ys3li";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-89bfb45bd8b1abc3b37e910d57f5dbd3174f40fb";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/89bfb45bd8b1abc3b37e910d57f5dbd3174f40fb";
          sha256 = "1ahr00g5bpvgjw36ps32aadyvnrsar94p06kar4pxvls4cmixldl";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-26c4c5cf30a2844ba121760fd7301f8ad240100b";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa/zipball/26c4c5cf30a2844ba121760fd7301f8ad240100b";
          sha256 = "1jmc7s3hbczvb0h4kfmya67l969nfww3lmc4slvzsz0zd769434h";
        };
      };
    };
    "predis/predis" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "predis-predis-c50c3393bb9f47fa012d0cdfb727a266b0818259";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/c50c3393bb9f47fa012d0cdfb727a266b0818259";
          sha256 = "09riabf99jmxydrqn8cm6nsw3fbp307fqcpc9iw4ag2qfhwm2v73";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-d11b50ad223250cf17b86e38383413f5a6764bf8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/d11b50ad223250cf17b86e38383413f5a6764bf8";
          sha256 = "06i2k3dx3b4lgn9a4v1dlgv8l9wcl4kl7vzhh63lbji0q96hv8qz";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-8622567409010282b7aeebe4bb841fe98b58dcaf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/8622567409010282b7aeebe4bb841fe98b58dcaf";
          sha256 = "0qfvyfp3mli776kb9zda5cpc8cazj3prk0bg0gm254kwxyfkfrwn";
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
        name = "psr-log-d49695b909c3b7628b6289db5479a1c204601f11";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/d49695b909c3b7628b6289db5479a1c204601f11";
          sha256 = "0sb0mq30dvmzdgsnqvw3xh4fb4bqjncx72kf8n622f94dd48amln";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-a0d9981aa07ecfcbea28e4bfa868031cca121e7d";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/a0d9981aa07ecfcbea28e4bfa868031cca121e7d";
          sha256 = "1gsmnqshrc97phlinhiina9465lw0ir3xcfl4lbn4f9lm7nxzzs2";
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
        name = "ramsey-collection-cccc74ee5e328031b15640b51056ee8d3bb66c0a";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/cccc74ee5e328031b15640b51056ee8d3bb66c0a";
          sha256 = "1i2ga25aj80cci3di58qm17l588lzgank8wqhdbq0dcb3cg6cgr6";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
          sha256 = "1fhjsyidsj95x5dd42z3hi5qhzii0hhhxa7xvc5jj7spqjdbqln4";
        };
      };
    };
    "robrichards/xmlseclibs" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "robrichards-xmlseclibs-f8f19e58f26cdb42c54b214ff8a820760292f8df";
        src = fetchurl {
          url = "https://api.github.com/repos/robrichards/xmlseclibs/zipball/f8f19e58f26cdb42c54b214ff8a820760292f8df";
          sha256 = "01zlpm36rrdj310cfmiz2fnabszxd3fq80fa8x8j3f9ki7dvhh5y";
        };
      };
    };
    "sabberworm/php-css-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sabberworm-php-css-parser-e41d2140031d533348b2192a83f02d8dd8a71d30";
        src = fetchurl {
          url = "https://api.github.com/repos/sabberworm/PHP-CSS-Parser/zipball/e41d2140031d533348b2192a83f02d8dd8a71d30";
          sha256 = "0slqh0ra9cwk1pm4q7bqhndynir0yxypzrxb2vrfzfkmnh0rm02c";
        };
      };
    };
    "socialiteproviders/discord" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-discord-c6eddeb07ace7473e82d02d4db852dfacf5ef574";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Discord/zipball/c6eddeb07ace7473e82d02d4db852dfacf5ef574";
          sha256 = "1w8m7jmlsdk94cqckgd75mwblh3jj6j16w3g4hzysyms25g091xc";
        };
      };
    };
    "socialiteproviders/gitlab" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-gitlab-a8f67d3b02c9ee8c70c25c6728417c0eddcbbb9d";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/GitLab/zipball/a8f67d3b02c9ee8c70c25c6728417c0eddcbbb9d";
          sha256 = "1blv2h69dmm0r0djz3h0l0cxkxmzd1fzgg13r3npxx7c80xjpw3a";
        };
      };
    };
    "socialiteproviders/manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-manager-0f5e82af0404df0080bdc5c105cef936c1711524";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/0f5e82af0404df0080bdc5c105cef936c1711524";
          sha256 = "0ppmln72khli94ylnsjarnhzkqzpkc32pn3zf3ljahm1yghccczx";
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-9b23e02ff711de42e513aa55f768a4f1c67c0e41";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/9b23e02ff711de42e513aa55f768a4f1c67c0e41";
          sha256 = "01i53v1pcr3nfpydpy0ka5jrdyygpi4vc5w24022913nfjqg3bqm";
        };
      };
    };
    "socialiteproviders/okta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-okta-e3ef9f23c7d2f86b3b16a174b82333cf4e2459e8";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Okta/zipball/e3ef9f23c7d2f86b3b16a174b82333cf4e2459e8";
          sha256 = "1a3anw5di5nqiabvqpmsjv5x0jasmsn4y876qsv77gazxja880ng";
        };
      };
    };
    "socialiteproviders/slack" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-slack-2b781c95daf06ec87a8f3deba2ab613d6bea5e8d";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Slack/zipball/2b781c95daf06ec87a8f3deba2ab613d6bea5e8d";
          sha256 = "1xilg7l1wc1vgwyakhfl8dpvgkjqx90g4khvzi411j9xa2wvpprh";
        };
      };
    };
    "socialiteproviders/twitch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-twitch-7accf30ae7a3139b757b4ca8f34989c09a3dbee7";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Twitch/zipball/7accf30ae7a3139b757b4ca8f34989c09a3dbee7";
          sha256 = "089i4fwxb32zmbxib0544jfs48wzjyp7bsqss2bf2xx89dsrx4ah";
        };
      };
    };
    "ssddanbrown/htmldiff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-htmldiff-f60d5cc278b60305ab980a6665f46117c5b589c0";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/f60d5cc278b60305ab980a6665f46117c5b589c0";
          sha256 = "12h3swr8rjf5w78kfgwzkf0zb59b4a8mjwf65fgcgvjg115wha9x";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8a5d5072dca8f48460fce2f4131fcc495eec654c";
        src = fetchurl {
          url = "https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8a5d5072dca8f48460fce2f4131fcc495eec654c";
          sha256 = "1p9m4fw9y9md9a7msbmnc0hpdrky8dwrllnyg1qf1cdyp9d70x1d";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-9130e1a0fc93cb0faadca4ee917171bd2ca9e5f4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/9130e1a0fc93cb0faadca4ee917171bd2ca9e5f4";
          sha256 = "19b1457cnn8ijbwd4mha6nxhvcsd4kh7dn72klixykj2kvqh0hvg";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-44b933f98bb4b5220d10bed9ce5662f8c2d13dcc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/44b933f98bb4b5220d10bed9ce5662f8c2d13dcc";
          sha256 = "0h05a4jfv64vgbw40r7f0ndz617hmml5kn7wck38fb31mmrprbak";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-6f981ee24cf69ee7ce9736146d1c57c2780598a8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/6f981ee24cf69ee7ce9736146d1c57c2780598a8";
          sha256 = "05jws1g4kcs297bwf5d72z47m2263i2jqpivi3yv8kf50kdjjzba";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-1e3cb3565af49cd5f93e5787500134500a29f0d9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/1e3cb3565af49cd5f93e5787500134500a29f0d9";
          sha256 = "1qqgn6ksg7bimcvf5f821zmfhp9zd5x9c9bibvg3qzfzd22zmk11";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-27d39ae126352b9fa3be5e196ccf4617897be3eb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/27d39ae126352b9fa3be5e196ccf4617897be3eb";
          sha256 = "01gl3av34p4jk71xjw6bjfsycb0fh02ll1bn3h3jdknzgkg2lsg4";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-66bea3b09be61613cd3b4043a65a8ec48cfa6d2a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/66bea3b09be61613cd3b4043a65a8ec48cfa6d2a";
          sha256 = "03bx5j7xh5bv1v17nlaw9wnbad66bzwp5w7npg8w2b01my49phfy";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-d2f29dac98e96a98be467627bd49c2efb1bc2590";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/d2f29dac98e96a98be467627bd49c2efb1bc2590";
          sha256 = "10ham5wrdsmxp8mrzwmxc87dw33fpacrbcaynm5w4v0z1sbvwkpb";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-5dad3780023a707f4c24beac7d57aead85c1ce3c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/5dad3780023a707f4c24beac7d57aead85c1ce3c";
          sha256 = "0szcq1x9zil11axgjlhcnw3vw48md5k02k3h01sxd8ywlzkjyaz0";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-2bdace75c9d6a6eec7e318801b7dc87a72375052";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/2bdace75c9d6a6eec7e318801b7dc87a72375052";
          sha256 = "1gwpzi97ih9gzddlw8ihyndkyi137r3hyycyb55l01yfq1wl7la1";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-d4365000217b67c01acff407573906ff91bcfb34";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/d4365000217b67c01acff407573906ff91bcfb34";
          sha256 = "12q2b5xbc0pyhfn0wyfnjf5sklnsrkafy2yg7d4fb3d8vliv4zzf";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce";
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-63b5bb7db83e5673936d6e3b8b3e022ff6474933";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/63b5bb7db83e5673936d6e3b8b3e022ff6474933";
          sha256 = "1jyjsjprsgb3r6cbc4x1wg1q1zqakqm8a62ah5lppxnjgq1sgjc5";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-16880ba9c5ebe3642d1995ab866db29270b36535";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/16880ba9c5ebe3642d1995ab866db29270b36535";
          sha256 = "0pb57756kvdxksqy2nndf8q7c91p2dzhysa52x2rbhba869760fv";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-65bd267525e82759e7d8c4e8ceea44f398838e65";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/65bd267525e82759e7d8c4e8ceea44f398838e65";
          sha256 = "1cx2cjx0vzni297l7avd3cb1q4c8d2hylkvdqcjlpxjqdimn4jkn";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-9174a3d80210dca8daa7f31fec659150bbeabfc6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/9174a3d80210dca8daa7f31fec659150bbeabfc6";
          sha256 = "17bhba3093di6xgi8f0cnf3cdd7fnbyp9l76d9y33cym6213ayx1";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9a142215a36a3888e30d0a9eeea9766764e96976";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/9a142215a36a3888e30d0a9eeea9766764e96976";
          sha256 = "06ipbcvrxjzgvraf2z9fwgy0bzvzjvs5z1j67grg1gb15x3d428b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010";
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-1100343ed1a92e3a38f9ae122fc0eb21602547be";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/1100343ed1a92e3a38f9ae122fc0eb21602547be";
          sha256 = "0kwk2qgwswsmbfp1qx31ahw3lisgyivwhw5dycshr5v2iwwx3rhi";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-e66119f3de95efc359483f810c4c3e6436279436";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/e66119f3de95efc359483f810c4c3e6436279436";
          sha256 = "0hg340da7m0yipj2bj5hxhd3mqidz767ivg7w85r8vwz3mr9k1p3";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-5be20b3830f726e019162b26223110c8f47cf274";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/5be20b3830f726e019162b26223110c8f47cf274";
          sha256 = "03pwf12al7mg2sz3waiqxnqliyzszwiyvzb1f51c1hl57zbj9zz4";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-9eeae93c32ca86746e5d38f3679e9569981038b1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/9eeae93c32ca86746e5d38f3679e9569981038b1";
          sha256 = "193vj08r1v3ghvid6jggqy62ip3n56mbwzpai3ldjhm8v8qdc9bs";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc";
          sha256 = "0c1vq6jv2jc37i9m1ndpbv7g75blgvf1s44vk65nb1jdk3hrbrd1";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-9ffaaba53c61ba75a3c7a3a779051d1e9ec4fd2d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/9ffaaba53c61ba75a3c7a3a779051d1e9ec4fd2d";
          sha256 = "1ml6zra6bynqgi0rqfkz65lgmp0wiay93simx7882wxrcxfkljqf";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-8c82cd35ed861236138d5ae1c78c0c7ebcd62107";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/8c82cd35ed861236138d5ae1c78c0c7ebcd62107";
          sha256 = "0yh933f222v98bmvni0rxmvhqlhb1pa6ncwrvf06gly36sl6zkij";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-d28150f0f44ce854e942b671fc2620a98aae1b1e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/d28150f0f44ce854e942b671fc2620a98aae1b1e";
          sha256 = "0gwqxhrzb9dzsqvqr9lc3whzl8wwlfhwskr0wdwqri4pq5mspb2w";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-2366ac8d8abe0c077844613c1a4f0c0a9f522dcc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/2366ac8d8abe0c077844613c1a4f0c0a9f522dcc";
          sha256 = "0ii4p4rkvrshvdix855p0jwb1snll275286swy95l59m6i76wzy1";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-da444caae6aca7a19c0c140f68c6182e337d5b1c";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/da444caae6aca7a19c0c140f68c6182e337d5b1c";
          sha256 = "13lzhf1kswg626b8zd23z4pa7sg679si368wcg6pklqvijnn0any";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-264dce589e7ce37a7ba99cb901eed8249fbec92f";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/264dce589e7ce37a7ba99cb901eed8249fbec92f";
          sha256 = "0z2q376k3rww8qb9jdywm3fj386pqmcx7rg6msd3zdrjxfbqcqnl";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "voku-portable-ascii-80953678b19901e5165c56752d087fc11526017c";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/80953678b19901e5165c56752d087fc11526017c";
          sha256 = "112sz1jl55l3qm3041ijyzxy7qbv0sa6535hx6sp7nk2c76wjq0d";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-6964c76c7804814a842473e0c8fd15bab0f18e25";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/6964c76c7804814a842473e0c8fd15bab0f18e25";
          sha256 = "17xqhb2wkwr7cgbl4xdjf7g1vkal17y79rpp6xjpf1xgl5vypc64";
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
