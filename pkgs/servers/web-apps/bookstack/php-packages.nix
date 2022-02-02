{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-3942776a8c99209908ee0b287746263725685732";
        src = fetchurl {
          url = https://api.github.com/repos/awslabs/aws-crt-php/zipball/3942776a8c99209908ee0b287746263725685732;
          sha256 = "0g4vjln6s1419ydljn5m64kzid0b7cplbc0nwn3y4cj72408fyiz";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-9f9591bff3dc0b2bc5400eb81e2e22228f2e4c95";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/9f9591bff3dc0b2bc5400eb81e2e22228f2e4c95;
          sha256 = "1zmrxj2l7m8lqfjramj442m1cbyl68d9ryaj024sf0ivmxp0va7q";
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
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-ca57d18f028f84f777b2168cd1911b0dee2343ae";
        src = fetchurl {
          url = https://api.github.com/repos/brick/math/zipball/ca57d18f028f84f777b2168cd1911b0dee2343ae;
          sha256 = "1nr1grrb9g5g3ihx94yk0amp8zx8prkkvg2934ygfc3rrv03cq9w";
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
        name = "doctrine-dbal-a4b37db6f186b6843474189b424aed6a7cc5de4b";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/a4b37db6f186b6843474189b424aed6a7cc5de4b;
          sha256 = "1dq56lxipanpq0w4igjlyy8shnf7am5pr0713fzcn9192c8mj7lm";
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
        name = "doctrine-inflector-8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/inflector/zipball/8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89;
          sha256 = "1l83jbj4k59m1agi041gzx1rxix1wzxw9mvnivmg1hqr158149n7";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-9c50f840f257bbb941e6f4a0e94ccf5db5c3f76c";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/lexer/zipball/9c50f840f257bbb941e6f4a0e94ccf5db5c3f76c;
          sha256 = "0cczszzlzws2fbc66npl93x8ayqv4bqls4rpkxg1zylcvf8f3cw8";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-de4aad040737a89fae2129cdeb0f79c45513128d";
        src = fetchurl {
          url = https://api.github.com/repos/dompdf/dompdf/zipball/de4aad040737a89fae2129cdeb0f79c45513128d;
          sha256 = "1isjhijd3lxsl0k9lzgp7rzqcak3hb7w04cy4pn62wpxckhcc30i";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-be85b3f05b46c39bbc0d95f6c071ddff669510fa";
        src = fetchurl {
          url = https://api.github.com/repos/dragonmantank/cron-expression/zipball/be85b3f05b46c39bbc0d95f6c071ddff669510fa;
          sha256 = "09k5cj8bay6jkphjl5ngfx7qb17dxnlvpf6918a9ms8am731s2a6";
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
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-a63e5e8f26ebbebf8ed3c5c691637325512eb0dc";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/a63e5e8f26ebbebf8ed3c5c691637325512eb0dc;
          sha256 = "0hc9zfh3i7br30831grccm4wny9dllpswhaw8hdn988mvg5xrdy0";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-0690bde05318336c7221785f2a932467f98b64ca";
        src = fetchurl {
          url = https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/0690bde05318336c7221785f2a932467f98b64ca;
          sha256 = "0a6kj3vxmhr1wh2kggmrl6y41hkg19jc0iq8qw095lf11mr4bd83";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-ee0a041b1760e6a53d2a39c8c34115adc2af2c79";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/guzzle/zipball/ee0a041b1760e6a53d2a39c8c34115adc2af2c79;
          sha256 = "0wa63kw5fr5jhy2cv1g28qy9rsgwhn902447mzmgz17qjx72lzrb";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/promises/zipball/fe752aedc9fd8fcca3fe7ad05d419d32998a06da;
          sha256 = "09ivi77y49bpc2sy3xhvgq22rfh2fhv921mn8402dv0a8bdprf56";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-089edd38f5b8abba6cb01567c2a8aaa47cec4c72";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/089edd38f5b8abba6cb01567c2a8aaa47cec4c72;
          sha256 = "1k29gax82rf82sbw2cbcp4qn3s3096csvmw9848l94q6ryc4j2rb";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-744ebba495319501b873a4e48787759c72e3fb8c";
        src = fetchurl {
          url = https://api.github.com/repos/Intervention/image/zipball/744ebba495319501b873a4e48787759c72e3fb8c;
          sha256 = "1h0w1gmnsb54k2y12vdhardssz9l3fqddln08fx9spwva1w4ms59";
        };
      };
    };
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-5126fb5b335ec929a226314d40cd8dad497c3d67";
        src = fetchurl {
          url = https://api.github.com/repos/KnpLabs/snappy/zipball/5126fb5b335ec929a226314d40cd8dad497c3d67;
          sha256 = "1j5bdj3sbww43nfgk7pasmyciwqdi92vj6pykw8f2xaq9c3i75p9";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-8949a2e46b0f274f39c61eee8d5de1dc6a1f686b";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/8949a2e46b0f274f39c61eee8d5de1dc6a1f686b;
          sha256 = "1whbj4a427ri6b09ncq7lsp9bad5lw8kzdip0bsjz82vk9dlp4gh";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-25de3be1bca1b17d52ff0dc02b646c667ac7266c";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/serializable-closure/zipball/25de3be1bca1b17d52ff0dc02b646c667ac7266c;
          sha256 = "1fk4zbvlc3qcw50pbs1qw5hgc8a3xgv4hn185ghq5kmmxm3q84p6";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-4e6f7e40de9a54ad641de5b8e29cdf1e73842e10";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/socialite/zipball/4e6f7e40de9a54ad641de5b8e29cdf1e73842e10;
          sha256 = "13sxn99lrbqdw9affj9z861i3xnrblpp293aa4jcc6bzif6sx1mp";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-5f2f9815b7631b9f586a3de7933c25f9327d4073";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/tinker/zipball/5f2f9815b7631b9f586a3de7933c25f9327d4073;
          sha256 = "1msw0c39f5fj59ymlf1266a1fcng6qgv9b45gcy6f99w7583bf3a";
        };
      };
    };
    "laravel/ui" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-ui-9a1e52442dd238647905b98d773d59e438eb9f9d";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/ui/zipball/9a1e52442dd238647905b98d773d59e438eb9f9d;
          sha256 = "15rvsrma458pjbdy4991fnx01zhpzsf8h8rgsr79i0s2jivxi877";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/commonmark/zipball/2b8185c13bc9578367a5bf901881d1c1b5bbd09b;
          sha256 = "14hp7vmqag9jh89rcq1mi3hyw01rkmypdbw2p3zsnjq2p8wwh4r5";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-094defdb4a7001845300334e7c1ee2335925ef99";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/094defdb4a7001845300334e7c1ee2335925ef99;
          sha256 = "0dn71b1pwikbwz1cmmz9k1fc8k1fsmah3gy8sqxbz7czhqn5qiva";
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
        name = "league-html-to-markdown-4d0394e120dc14b0d5c52fd1755fd48656da2ec9";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/html-to-markdown/zipball/4d0394e120dc14b0d5c52fd1755fd48656da2ec9;
          sha256 = "0my5k4cf5m3qb6bgq07dyq3347xm64sd1f83nr14ny3w31vb43cm";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-aa70e813a6ad3d1558fc927863d47309b4c23e69";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/mime-type-detection/zipball/aa70e813a6ad3d1558fc927863d47309b4c23e69;
          sha256 = "0k2kccf1v0002bb083p1ncmm8fbyflnkjx45808sxlkrxggzqcy3";
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
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-2334c249907190c132364f5dae0287ab8666aa19";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth2-client/zipball/2334c249907190c132364f5dae0287ab8666aa19;
          sha256 = "12a3mpv3x5jy1nnpzx25z80chzhjxk8sgvn5x02pzk5dlw8kbzhz";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-fd4380d6fc37626e2f799f29d91195040137eba9";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/fd4380d6fc37626e2f799f29d91195040137eba9;
          sha256 = "1k56si01sjl93mxq1pk599yqqqhldqz34qi73y5jaga0m9iq07wk";
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
        name = "nesbot-carbon-626ec8cbb724cd3c3400c3ed8f730545b744e3f4";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/626ec8cbb724cd3c3400c3ed8f730545b744e3f4;
          sha256 = "1mqqx7102l3adfm473jcvgnhqp1gm194y8jf1k2qmy1i2nwxnxi7";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-210577fe3cf7badcc5814d99455df46564f3c077";
        src = fetchurl {
          url = https://api.github.com/repos/nikic/PHP-Parser/zipball/210577fe3cf7badcc5814d99455df46564f3c077;
          sha256 = "191ijb7bybqnl1jayx6bipqh91dc9acg9zsbh89fk4h1ff87b1qp";
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
        name = "paragonie-constant_time_encoding-9229e15f2e6ba772f0c55dd6986c563b937170a8";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/constant_time_encoding/zipball/9229e15f2e6ba772f0c55dd6986c563b937170a8;
          sha256 = "1cn71hyvjd100w0dyqibjxwkc8wn5525jmpv5fyh1ag04lr5ld90";
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
        name = "phenx-php-font-lib-dd448ad1ce34c63d09baccd05415e361300c35b4";
        src = fetchurl {
          url = https://api.github.com/repos/dompdf/php-font-lib/zipball/dd448ad1ce34c63d09baccd05415e361300c35b4;
          sha256 = "0l20inbvipjdg9fdd32v8b7agjyvcs0rpqswcylld64vbm2sf3il";
        };
      };
    };
    "phenx/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-svg-lib-5fa61b65e612ce1ae15f69b3d223cb14ecc60e32";
        src = fetchurl {
          url = https://api.github.com/repos/PhenX/php-svg-lib/zipball/5fa61b65e612ce1ae15f69b3d223cb14ecc60e32;
          sha256 = "1ppi3hs2r4cbd6b2xwf4znci6hpbs8469kqxk3msf7vi6vfnybbj";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
        src = fetchurl {
          url = https://api.github.com/repos/schmittjoh/php-option/zipball/eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15;
          sha256 = "1lk50y8jj2mzbwc2mxfm2xdasxf4axya72nv8wfc1vyz9y5ys3li";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-89bfb45bd8b1abc3b37e910d57f5dbd3174f40fb";
        src = fetchurl {
          url = https://api.github.com/repos/phpseclib/phpseclib/zipball/89bfb45bd8b1abc3b37e910d57f5dbd3174f40fb;
          sha256 = "1ahr00g5bpvgjw36ps32aadyvnrsar94p06kar4pxvls4cmixldl";
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
        name = "predis-predis-a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
        src = fetchurl {
          url = https://api.github.com/repos/predis/predis/zipball/a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e;
          sha256 = "109j0chyqmr0rzfn25843yacfnm438z94rpxlx1hvhcigfspjhvf";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-d11b50ad223250cf17b86e38383413f5a6764bf8";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/cache/zipball/d11b50ad223250cf17b86e38383413f5a6764bf8;
          sha256 = "06i2k3dx3b4lgn9a4v1dlgv8l9wcl4kl7vzhh63lbji0q96hv8qz";
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
    "psr/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-event-dispatcher-dbefd12671e8a14ec7f180cab83036ed26714bb0";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/event-dispatcher/zipball/dbefd12671e8a14ec7f180cab83036ed26714bb0;
          sha256 = "05nicsd9lwl467bsv4sn44fjnnvqvzj1xqw2mmz9bac9zm66fsjd";
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
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be;
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
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
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-570292577277f06f590635381a7f761a6cf4f026";
        src = fetchurl {
          url = https://api.github.com/repos/bobthecow/psysh/zipball/570292577277f06f590635381a7f761a6cf4f026;
          sha256 = "0q8db5hs7p6s7yv8ry1cb6fiz0xsbks6524zjcxdciqsg2zmnkd1";
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
    "ramsey/collection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-collection-cccc74ee5e328031b15640b51056ee8d3bb66c0a";
        src = fetchurl {
          url = https://api.github.com/repos/ramsey/collection/zipball/cccc74ee5e328031b15640b51056ee8d3bb66c0a;
          sha256 = "1i2ga25aj80cci3di58qm17l588lzgank8wqhdbq0dcb3cg6cgr6";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
        src = fetchurl {
          url = https://api.github.com/repos/ramsey/uuid/zipball/fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df;
          sha256 = "1fhjsyidsj95x5dd42z3hi5qhzii0hhhxa7xvc5jj7spqjdbqln4";
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
        name = "sabberworm-php-css-parser-e41d2140031d533348b2192a83f02d8dd8a71d30";
        src = fetchurl {
          url = https://api.github.com/repos/sabberworm/PHP-CSS-Parser/zipball/e41d2140031d533348b2192a83f02d8dd8a71d30;
          sha256 = "0slqh0ra9cwk1pm4q7bqhndynir0yxypzrxb2vrfzfkmnh0rm02c";
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
        name = "socialiteproviders-manager-4e63afbd26dc45ff263591de2a0970436a6a0bf9";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Manager/zipball/4e63afbd26dc45ff263591de2a0970436a6a0bf9;
          sha256 = "1056ilack76b0zsqv7i1znidg5nyd9iznvznh5x7vsryspjvx358";
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-9b23e02ff711de42e513aa55f768a4f1c67c0e41";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/9b23e02ff711de42e513aa55f768a4f1c67c0e41;
          sha256 = "01i53v1pcr3nfpydpy0ka5jrdyygpi4vc5w24022913nfjqg3bqm";
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
        name = "ssddanbrown-htmldiff-58f81857c02b50b199273edb4cc339876b5a4038";
        src = fetchurl {
          url = https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/58f81857c02b50b199273edb4cc339876b5a4038;
          sha256 = "0ixsi2s1igvciwnal1v2w654n4idbfs8ipyiixch7k5nzxl4g7wm";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8a5d5072dca8f48460fce2f4131fcc495eec654c";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8a5d5072dca8f48460fce2f4131fcc495eec654c;
          sha256 = "1p9m4fw9y9md9a7msbmnc0hpdrky8dwrllnyg1qf1cdyp9d70x1d";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-a2c6b7ced2eb7799a35375fb9022519282b5405e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/a2c6b7ced2eb7799a35375fb9022519282b5405e;
          sha256 = "1p5327f6mj68xhpwaylg2rqwl6s93xsi7x2j7vf3hz2jaz950hzf";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-cfcbee910e159df402603502fe387e8b677c22fd";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/cfcbee910e159df402603502fe387e8b677c22fd;
          sha256 = "1wc2kwbfrkyp6imsykpwxrppi0yyjwir26apmp9bac49i9iwlc3f";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-6f981ee24cf69ee7ce9736146d1c57c2780598a8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/deprecation-contracts/zipball/6f981ee24cf69ee7ce9736146d1c57c2780598a8;
          sha256 = "05jws1g4kcs297bwf5d72z47m2263i2jqpivi3yv8kf50kdjjzba";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-e0c0dd0f9d4120a20158fc9aec2367d07d38bc56";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/e0c0dd0f9d4120a20158fc9aec2367d07d38bc56;
          sha256 = "1visp8ll71dpll7zdw0163k760a85b1fkvay2z8v9r9v0v4cbs2i";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-27d39ae126352b9fa3be5e196ccf4617897be3eb";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/27d39ae126352b9fa3be5e196ccf4617897be3eb;
          sha256 = "01gl3av34p4jk71xjw6bjfsycb0fh02ll1bn3h3jdknzgkg2lsg4";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-66bea3b09be61613cd3b4043a65a8ec48cfa6d2a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/66bea3b09be61613cd3b4043a65a8ec48cfa6d2a;
          sha256 = "03bx5j7xh5bv1v17nlaw9wnbad66bzwp5w7npg8w2b01my49phfy";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-e77046c252be48c48a40816187ed527703c8f76c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/e77046c252be48c48a40816187ed527703c8f76c;
          sha256 = "0l47a4vzss8lc1c10wjzxgl39cqa0cz9ifvg27f2jbcz4chzw81x";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-ce952af52877eaf3eab5d0c08cc0ea865ed37313";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/ce952af52877eaf3eab5d0c08cc0ea865ed37313;
          sha256 = "0mccw3ahm731q4xxqll1n4xvp0ap7958vws3ycfz5177rvm00a83";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-35b7e9868953e0d1df84320bb063543369e43ef5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/35b7e9868953e0d1df84320bb063543369e43ef5;
          sha256 = "18mav4pf91cb7h8blac7cgrasb4dw91pi4x0gwvz7g56c8pbxhms";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-1bfd938cf9562822c05c4d00e8f92134d3c8e42d";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/1bfd938cf9562822c05c4d00e8f92134d3c8e42d;
          sha256 = "0wpy8vj0dvga726aqc8wij75z2b0vlvv9l9fb0y6bjbhrv0r303m";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-30885182c981ab175d4d034db0f6f469898070ab";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/30885182c981ab175d4d034db0f6f469898070ab;
          sha256 = "0dfh24f8g048vbj88vx0lvw48nq5dsamy5kva72ab1h7vw9hvpwb";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-f1aed619e28cb077fc83fac8c4c0383578356e40";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/f1aed619e28cb077fc83fac8c4c0383578356e40;
          sha256 = "0fjx1a0kvkj0677nc6h49phqlk0hsgkzbs401lmhj6b6cdc7hvzp";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-81b86b50cf841a64252b439e738e97f4a34e2783";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/81b86b50cf841a64252b439e738e97f4a34e2783;
          sha256 = "1dxymfi577yridk6dn8v2z1hyrpaxr8sp4g6dxxy913ilf6igx7r";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-749045c69efb97c70d25d7463abba812e91f3a44";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/749045c69efb97c70d25d7463abba812e91f3a44;
          sha256 = "0ni1zlnp5xpxyzbax7v3mn20x35i69nsmch2sx322cs6dwb0ggbn";
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
        name = "symfony-polyfill-mbstring-0abb51d2f102e00a4eefcf46ba7fec406d245825";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/0abb51d2f102e00a4eefcf46ba7fec406d245825;
          sha256 = "1z17f7465fn778ak68mzz5kg2ql1n6ghgqh3827n9mcipwbp4k58";
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
        name = "symfony-polyfill-php73-cc5db0e22b3cb4111010e48785a97f670b350ca5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/cc5db0e22b3cb4111010e48785a97f670b350ca5;
          sha256 = "04z6fah8rn5b01w78j0vqa0jys4mvji66z4ql6wk1r1bf6j0048y";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-57b712b08eddb97c762a8caa32c84e037892d2e9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/57b712b08eddb97c762a8caa32c84e037892d2e9;
          sha256 = "0dpa53wj3l84f273cnphlps23k09789z8g1znd4h4c7ly6dlqx14";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-5de4ba2d41b15f9bd0e19b2ab9674135813ec98f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php81/zipball/5de4ba2d41b15f9bd0e19b2ab9674135813ec98f;
          sha256 = "0igxnmib8vkjp9x81j66hl4pf8i0nj86k4hdh8gzcymq01si0mxm";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-2b3ba8722c4aaf3e88011be5e7f48710088fb5e4";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/2b3ba8722c4aaf3e88011be5e7f48710088fb5e4;
          sha256 = "19sigkavzq6p2z0ffy852icdn5gr2hd8wpcdcf0y8y9kl706q58d";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-9eeae93c32ca86746e5d38f3679e9569981038b1";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/9eeae93c32ca86746e5d38f3679e9569981038b1;
          sha256 = "193vj08r1v3ghvid6jggqy62ip3n56mbwzpai3ldjhm8v8qdc9bs";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc;
          sha256 = "0c1vq6jv2jc37i9m1ndpbv7g75blgvf1s44vk65nb1jdk3hrbrd1";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-e6a5d5ecf6589c5247d18e0e74e30b11dfd51a3d";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/string/zipball/e6a5d5ecf6589c5247d18e0e74e30b11dfd51a3d;
          sha256 = "1nra32wf543vrjb2jh9lxd9zwsb2dkf2z6ra1nr7ihl2sdaxc4i1";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-ff8bb2107b6a549dc3c5dd9c498dcc82c9c098ca";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/ff8bb2107b6a549dc3c5dd9c498dcc82c9c098ca;
          sha256 = "0y82nga2xllq5q0jm72qlcl0kdhpafg89i4337y8bshwjmhgaim2";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-d28150f0f44ce854e942b671fc2620a98aae1b1e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation-contracts/zipball/d28150f0f44ce854e942b671fc2620a98aae1b1e;
          sha256 = "0gwqxhrzb9dzsqvqr9lc3whzl8wwlfhwskr0wdwqri4pq5mspb2w";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-1b56c32c3679002b3a42384a580e16e2600f41c1";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/1b56c32c3679002b3a42384a580e16e2600f41c1;
          sha256 = "02hj0lc11vygcwl4p56fv2qvnlxnx6iy7872mr6f1dcpw40nm7ps";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-da444caae6aca7a19c0c140f68c6182e337d5b1c";
        src = fetchurl {
          url = https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/da444caae6aca7a19c0c140f68c6182e337d5b1c;
          sha256 = "13lzhf1kswg626b8zd23z4pa7sg679si368wcg6pklqvijnn0any";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-264dce589e7ce37a7ba99cb901eed8249fbec92f";
        src = fetchurl {
          url = https://api.github.com/repos/vlucas/phpdotenv/zipball/264dce589e7ce37a7ba99cb901eed8249fbec92f;
          sha256 = "0z2q376k3rww8qb9jdywm3fj386pqmcx7rg6msd3zdrjxfbqcqnl";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "voku-portable-ascii-87337c91b9dfacee02452244ee14ab3c43bc485a";
        src = fetchurl {
          url = https://api.github.com/repos/voku/portable-ascii/zipball/87337c91b9dfacee02452244ee14ab3c43bc485a;
          sha256 = "1j2xpbv7xiwxwb6gfc3h6imc6xcbyb2jw3h8wgfnpvjl5yfbi4xb";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-6964c76c7804814a842473e0c8fd15bab0f18e25";
        src = fetchurl {
          url = https://api.github.com/repos/webmozarts/assert/zipball/6964c76c7804814a842473e0c8fd15bab0f18e25;
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
