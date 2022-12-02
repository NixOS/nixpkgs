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
        name = "aws-aws-sdk-php-337e447997148b9e5024c2d0ae69618b1cbf80d6";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/337e447997148b9e5024c2d0ae69618b1cbf80d6";
          sha256 = "1pwghj67zah616cvdrbs2fwgwn99jhxi95mdfq6l2jhpy59gymkc";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-d70c840f68657ce49094b8d91f9ee0cc07fbf66c";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/d70c840f68657ce49094b8d91f9ee0cc07fbf66c";
          sha256 = "0k2z8a6qz5xg1p85vwcp58yqbiw8bmnp3hg2pjcaqlimnf65v058";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
          sha256 = "0xvaq6mp9s8nxlpfisa50fr8rjb6vmivxdbr985q9vydadh1dsv2";
        };
      };
    };
    "barryvdh/laravel-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-snappy-2c18a3602981bc6f25b32908cf8aaa05952ab2f7";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-snappy/zipball/2c18a3602981bc6f25b32908cf8aaa05952ab2f7";
          sha256 = "1h3s9g9n1rk3iji0p9m3g21gakjxnp4ciqwd5cdbj0wnh9k7gi2h";
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
        name = "doctrine-dbal-f38ee8aaca2d58ee88653cb34a6a3880c23f38a5";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/f38ee8aaca2d58ee88653cb34a6a3880c23f38a5";
          sha256 = "09kv9g6693gr3i2wbfc1riyzgfkm5kkamhzfj4skrsw14pvacsgf";
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
        name = "doctrine-lexer-c268e882d4dbdd85e36e4ad69e02dc284f89d229";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/c268e882d4dbdd85e36e4ad69e02dc284f89d229";
          sha256 = "12g069nljl3alyk15884nd1jc4mxk87isqsmfj7x6j2vxvk9qchs";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-c5310df0e22c758c85ea5288175fc6cd777bc085";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/c5310df0e22c758c85ea5288175fc6cd777bc085";
          sha256 = "1h9y3v02qdijc6hmi7p8x626jlhkjd2pcck9mkcmm5sz9xzqhdwb";
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
        name = "filp-whoops-f7948baaa0330277c729714910336383286305da";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/f7948baaa0330277c729714910336383286305da";
          sha256 = "1l70lq27h072ria2pgmf9dp3h5awszirqd1khlcknl4w1hww3swv";
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-a878d45c1914464426dc94da61c9e1d36ae262a8";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/a878d45c1914464426dc94da61c9e1d36ae262a8";
          sha256 = "1xayas92b467yixpc79l7ydgspy3s76cpfddv7lrvd691y11g1vb";
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
        name = "guzzlehttp-psr7-67c26b443f348a51926030c83481b85718457d3d";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/67c26b443f348a51926030c83481b85718457d3d";
          sha256 = "09avh5xzmzwfpa5xv9zw90ypyfrhpyhszbli395prgh3llnrx9wg";
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
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-5126fb5b335ec929a226314d40cd8dad497c3d67";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/5126fb5b335ec929a226314d40cd8dad497c3d67";
          sha256 = "1j5bdj3sbww43nfgk7pasmyciwqdi92vj6pykw8f2xaq9c3i75p9";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-7411d9fa71c1b0fd73a33e225f14512b74e6c81e";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/7411d9fa71c1b0fd73a33e225f14512b74e6c81e";
          sha256 = "0pdxr823p52cf284yfqwncii52g4zgk2gw5prn774h26v42dwaqw";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-47afb7fae28ed29057fdca37e16a84f90cc62fae";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/47afb7fae28ed29057fdca37e16a84f90cc62fae";
          sha256 = "1mfj1jszq1mssxfh68y3s43sq90bpj25a2kpj0djbmcrccgwd46z";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-1cd1682b709b8808a5b5dbb68179a58d1342aa7b";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/1cd1682b709b8808a5b5dbb68179a58d1342aa7b";
          sha256 = "0h37rw9ndh56dh71d8jaxidpnyr7xs42nnim88aaxas304j7jdwa";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-5062061b4924af3392225dd482ca7b4d85d8b8ef";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/5062061b4924af3392225dd482ca7b4d85d8b8ef";
          sha256 = "0smv55xbj6pk223v3nfd0fi5n4l8v85c4pra98ahq3615xma3k8c";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
          sha256 = "14hp7vmqag9jh89rcq1mi3hyw01rkmypdbw2p3zsnjq2p8wwh4r5";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-3239285c825c152bcc315fe0e87d6b55f5972ed1";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/3239285c825c152bcc315fe0e87d6b55f5972ed1";
          sha256 = "0p1cirl7j9b3gvbp264d08abfnrki89jr7rx0cbw0bjw1apf4spz";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-af286f291ebab6877bac0c359c6c2cb017eb061d";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/af286f291ebab6877bac0c359c6c2cb017eb061d";
          sha256 = "1dyj1cvf2pbvkdw9i53qg6lycxv0di85qnjzcvy5lphrxambifxy";
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-html-to-markdown-e0fc8cf07bdabbcd3765341ecb50c34c271d64e1";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/e0fc8cf07bdabbcd3765341ecb50c34c271d64e1";
          sha256 = "1a7ab0xafjwd5hmkmixc3ijwrrncb2qncy9b52jbnzspv1vjav1h";
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
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-d6365b901b5c287dd41f143033315e2f777e1167";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth1-client/zipball/d6365b901b5c287dd41f143033315e2f777e1167";
          sha256 = "0hkh8l7884g8ssja1biwfb59x0jj951lwk6kmiacjqvyvzs07qmx";
        };
      };
    };
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-2334c249907190c132364f5dae0287ab8666aa19";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/2334c249907190c132364f5dae0287ab8666aa19";
          sha256 = "12a3mpv3x5jy1nnpzx25z80chzhjxk8sgvn5x02pzk5dlw8kbzhz";
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "masterminds-html5-897eb517a343a2281f11bc5556d6548db7d93947";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/897eb517a343a2281f11bc5556d6548db7d93947";
          sha256 = "12fmcgsrmh0f0llnpcvk33mrs4067nw246ci5619rr79ijy3yc0k";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-720488632c590286b88b80e62aa3d3d551ad4a50";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/720488632c590286b88b80e62aa3d3d551ad4a50";
          sha256 = "0wg1y0mghhib6cp9gcavbs6ajfs9rgxc2ssipqb5yfwfkkbwrif6";
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
        name = "nesbot-carbon-ad35dd71a6a212b98e4b87e97389b6fa85f0e347";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/ad35dd71a6a212b98e4b87e97389b6fa85f0e347";
          sha256 = "1a7qlk82jfxnf84v4vwwgs9b325mb07whkc5vxrqjjjp8krncxbi";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-f59bbe44bf7d96f24f3e2b4ddc21cd52c1d2adbc";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/f59bbe44bf7d96f24f3e2b4ddc21cd52c1d2adbc";
          sha256 = "0lsw925jy1y1vvsx5da6abn1ky7g6whaxx9g524jgqgbaljrjhxm";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-b22a57ebd13e838b90df5d3346090bc37056409d";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/b22a57ebd13e838b90df5d3346090bc37056409d";
          sha256 = "1bi65bi04a26zmaz7ms0qyg6i86k4cd9g8qs7dp1pphpvflgz461";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-3d81e4309d2a927abbe66df935f4bb60082805ad";
        src = fetchurl {
          url = "https://api.github.com/repos/opis/closure/zipball/3d81e4309d2a927abbe66df935f4bb60082805ad";
          sha256 = "0hqs6rdkkcggswrgjlispkby2yg4hwn63bl2ma62lnmpfbpwn0sd";
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
    "phenx/php-font-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-font-lib-dd448ad1ce34c63d09baccd05415e361300c35b4";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-font-lib/zipball/dd448ad1ce34c63d09baccd05415e361300c35b4";
          sha256 = "0l20inbvipjdg9fdd32v8b7agjyvcs0rpqswcylld64vbm2sf3il";
        };
      };
    };
    "phenx/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-svg-lib-76876c6cf3080bcb6f249d7d59705108166a6685";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/76876c6cf3080bcb6f249d7d59705108166a6685";
          sha256 = "0bjynrs81das9f9jwd5jgsxx9gjv2m6c0mkvlgx4w1f4pgbvwsf5";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-dc5ff11e274a90cc1c743f66c9ad700ce50db9ab";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/dc5ff11e274a90cc1c743f66c9ad700ce50db9ab";
          sha256 = "12i9gc2q75iv6c0x87zj3j499pl8k0wzh3yzvgrhg97nhbdhab5c";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-dbc2307d5c69aeb22db136c52e91130d7f2ca761";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/dbc2307d5c69aeb22db136c52e91130d7f2ca761";
          sha256 = "1xpb0wi54rg33w7w357l6vh1kg9yh0pwabhmf8r9ih35s05n58a9";
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
        name = "predis-predis-a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
          sha256 = "109j0chyqmr0rzfn25843yacfnm438z94rpxlx1hvhcigfspjhvf";
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
        name = "psr-container-513e0666f7216c7459170d56df27dfcefe1689ea";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/513e0666f7216c7459170d56df27dfcefe1689ea";
          sha256 = "00yvj3b5ls2l1d0sk38g065raw837rw65dx1sicggjnkr85vmfzz";
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
        name = "psy-psysh-1acec99d6684a54ff92f8b548a4e41b566963778";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/1acec99d6684a54ff92f8b548a4e41b566963778";
          sha256 = "169v5160qhq07n3mvhifrgvjqrbm0306nn2ibiqwrcfqyyhq43z0";
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
        name = "socialiteproviders-manager-738276dfbc2b68a9145db7b3df1588d53db528a1";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/738276dfbc2b68a9145db7b3df1588d53db528a1";
          sha256 = "0d7ayh72cdxkslmgdgj0d6rkqghyhbdhdhkiz9064virm7fa5ii0";
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-7522b27cd8518706b50e03b40a396fb0a6891feb";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/7522b27cd8518706b50e03b40a396fb0a6891feb";
          sha256 = "0nlxyvcn3vc273rq9cp2yhm72mqfj31csnla5bqsaqdshzfk8pna";
        };
      };
    };
    "socialiteproviders/okta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-okta-7c0b7522423943131f680e74123b71ccd3989541";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Okta/zipball/7c0b7522423943131f680e74123b71ccd3989541";
          sha256 = "1hly2f06k6jxjxz36swa3b0g285ni556k3wz089f3lxyrnhwnkdf";
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
        name = "ssddanbrown-htmldiff-58f81857c02b50b199273edb4cc339876b5a4038";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/58f81857c02b50b199273edb4cc339876b5a4038";
          sha256 = "0ixsi2s1igvciwnal1v2w654n4idbfs8ipyiixch7k5nzxl4g7wm";
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
        name = "symfony-console-ea59bb0edfaf9f28d18d8791410ee0355f317669";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/ea59bb0edfaf9f28d18d8791410ee0355f317669";
          sha256 = "1qvr9av4c9kac5q2lpwiwq269rq5pxdvnvb32asysifw30zd5j3d";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-c1681789f059ab756001052164726ae88512ae3d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/c1681789f059ab756001052164726ae88512ae3d";
          sha256 = "1v1kpfqc4njdpqqa668vkz7mqxsklzbsf62pcgdvkbg724ck4zis";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
          sha256 = "09k869asjb7cd3xh8i5ps824k5y6v510sbpzfalndwy3knig9fig";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-539cf1428b8442303c6e876ad7bf5a7babd91091";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/539cf1428b8442303c6e876ad7bf5a7babd91091";
          sha256 = "0x2r3kpip9cmdn5d47isamyas13sl43y50wfk23zwj5vh70qgh5s";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-8e6ce1cc0279e3ff3c8ff0f43813bc88d21ca1bc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/8e6ce1cc0279e3ff3c8ff0f43813bc88d21ca1bc";
          sha256 = "10vdzpy7gvmy0w4lpr4h4xj2gr224k5llc7f356x1jzbijxg8ckh";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-f98b54df6ad059855739db6fcbc2d36995283fe1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/f98b54df6ad059855739db6fcbc2d36995283fe1";
          sha256 = "114zpsd8vac016a0ppf5ag5lmgllrha7nwln8vvhq9282r79xhsl";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-7872a66f57caffa2916a584db1aa7f12adc76f8c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/7872a66f57caffa2916a584db1aa7f12adc76f8c";
          sha256 = "111qy05azqwj14v0k034lwd970slx081x56pnicyxsbg3yc9wmnp";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-75bd663ff2db90141bfb733682459d5bbe9e29c3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/75bd663ff2db90141bfb733682459d5bbe9e29c3";
          sha256 = "195w56aicv57nmcwsai6jklicb9qqak4imk4xwsgc3i98yw3md2w";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-fc63c8c3e1036d424820cc993a4ea163778dc5c7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/fc63c8c3e1036d424820cc993a4ea163778dc5c7";
          sha256 = "0z1cg1ac1r00c0i5apvk8rrglwswcy6gx9w9v5kmk7ajijnk583m";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-1c118b253bb3495d81e95a6e3ec6c2766a98a0c4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/1c118b253bb3495d81e95a6e3ec6c2766a98a0c4";
          sha256 = "1r06lijy4zbqppyfnvnq2arbjn0dwzb1d14lcy5wsbh3k3bgpsvq";
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
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-927013f3aac555983a5059aada98e1907d842695";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/927013f3aac555983a5059aada98e1907d842695";
          sha256 = "1qmnzd3r2l35rx84r8ai0596dywsj7q5y3dngaf1vsz16k5ig409";
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
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-9e8ecb5f92152187c4799efd3c96b78ccab18ff9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/9e8ecb5f92152187c4799efd3c96b78ccab18ff9";
          sha256 = "1p0jr92x323pl4frjbhmziyk5g1zig1g30i1v1p0wfli2sq8h5mb";
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
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-707403074c8ea6e2edaf8794b0157a0bfa52157a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/707403074c8ea6e2edaf8794b0157a0bfa52157a";
          sha256 = "05qrjfnnnz402l11wm0ydblrip7hjll12yqxmh2wd02b0s8dj29f";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-6e75fe6874cbc7e4773d049616ab450eff537bf1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/6e75fe6874cbc7e4773d049616ab450eff537bf1";
          sha256 = "0jzymj7jh9zm376p3ydq6adid9cxd8fmmk2hdnyjk30chsb37yfw";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-5c9b129efe9abce9470e384bf65d8a7e262eee69";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/5c9b129efe9abce9470e384bf65d8a7e262eee69";
          sha256 = "0pa3zqqsa9jf362zdhg8jhppv1z7nnj6hq65dym473p1c3zwyfxb";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
          sha256 = "0lh0vxy0h4wsjmnlf42s950bicsvkzz6brqikfnfb5kmvi0xhcm6";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-571334ce9f687e3e6af72db4d3b2a9431e4fd9ed";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/571334ce9f687e3e6af72db4d3b2a9431e4fd9ed";
          sha256 = "1hwji8pwsfb79sdrigbisxs0cjnhs1qbm6rrflhqyhpviwvbhyqx";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-f0ed07675863aa6e3939df8b1bc879450b585cab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/f0ed07675863aa6e3939df8b1bc879450b585cab";
          sha256 = "0a6y9glxjaiflprlr3fk8qgjdhqmqzjf912pq1qbn0lmc7f0y8pr";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
          sha256 = "1z1514i3gsxdisyayzh880i8rj954qim7c183cld91kvvqcqi7x0";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-6894d06145fefebd9a4c7272baa026a1c394a430";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/6894d06145fefebd9a4c7272baa026a1c394a430";
          sha256 = "055s38szlhpxrhv1kjawsm5rwh6dr7drk9jpyj6a5r0g4jn63m72";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-4348a3a06651827a27d989ad1d13efec6bb49b19";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/4348a3a06651827a27d989ad1d13efec6bb49b19";
          sha256 = "0fs2w9hw0drf1hszidrmplrph7ay8m8pv58pqv26v0228m4l6vlm";
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
        name = "voku-portable-ascii-87337c91b9dfacee02452244ee14ab3c43bc485a";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/87337c91b9dfacee02452244ee14ab3c43bc485a";
          sha256 = "1j2xpbv7xiwxwb6gfc3h6imc6xcbyb2jw3h8wgfnpvjl5yfbi4xb";
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
  name = "bookstack";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "MIT";
  };
}

