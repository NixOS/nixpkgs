{
  composerEnv,
  fetchurl,
  fetchgit ? null,
  fetchhg ? null,
  fetchsvn ? null,
  noDev ? false,
}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-0ea1f04ec5aa9f049f97e012d1ed63b76834a31b";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/0ea1f04ec5aa9f049f97e012d1ed63b76834a31b";
          sha256 = "1xx5yhq99z752pagij5djja4812p4s711188j8qk8wi0dl7331zm";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-731cd73062909594c5f7443413c4c4c40ed1c25c";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/731cd73062909594c5f7443413c4c4c40ed1c25c";
          sha256 = "1bs6l34j3r1nr7750ssrannbi8x5pdwknlzhmqx84xajm9imiqcp";
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
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-f510c0a40911935b77b86859eb5223d58d660df1";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/f510c0a40911935b77b86859eb5223d58d660df1";
          sha256 = "1cgj6qfjjl76jyjxxkdmnzl0sc8y3pkvcw91lpjdlp4jnqlq31by";
        };
      };
    };
    "carbonphp/carbon-doctrine-types" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "carbonphp-carbon-doctrine-types-99f76ffa36cce3b70a4a6abce41dba15ca2e84cb";
        src = fetchurl {
          url = "https://api.github.com/repos/CarbonPHP/carbon-doctrine-types/zipball/99f76ffa36cce3b70a4a6abce41dba15ca2e84cb";
          sha256 = "0vkhwbprqlcg4awdknaycbfydb4spk7vd1v0nxbq06zx22dmphaz";
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
        name = "doctrine-dbal-b05e48a745f722801f55408d0dbd8003b403dbbd";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/b05e48a745f722801f55408d0dbd8003b403dbbd";
          sha256 = "0bca75y1wadpab0ns31s3wbvvxsq108i8jfyrh4xnifl56wb8pvh";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-dfbaa3c2d2e9a9df1118213f3b8b0c597bb99fab";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/dfbaa3c2d2e9a9df1118213f3b8b0c597bb99fab";
          sha256 = "1qydhnf94wgjlrgzydjcz31rr5f87pg3vlkkd0gynggw1ycgkkcg";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-b680156fa328f1dfd874fd48c7026c41570b9c6e";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/b680156fa328f1dfd874fd48c7026c41570b9c6e";
          sha256 = "135zcwnlfijxzv3x5qn1zs3jmybs1n2q64pbs5gbjwmsdgrxhzsi";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-5817d0659c5b50c9b950feb9af7b9668e2c436bc";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/5817d0659c5b50c9b950feb9af7b9668e2c436bc";
          sha256 = "0yj0f6w0v35d0xdhy4bf7hsjrkjjxsglc879rdciybsk6vz70g96";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-31ad66abc0fc9e1a1f2d9bc6a42668d2fbbcd6dd";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/31ad66abc0fc9e1a1f2d9bc6a42668d2fbbcd6dd";
          sha256 = "1yaznxpd1d8h3ij262hx946nqvhzsgjmafdgnxbaiarc6nslww25";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-c20247574601700e1f7c8dab39310fca1964dc52";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/c20247574601700e1f7c8dab39310fca1964dc52";
          sha256 = "01r93dlglgvd1dnpq0jpjajr0vwkv56zyi9xafw423lyg2ghn3n0";
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
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-500501c2ce893c824c801da135d02661199f60c5";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/500501c2ce893c824c801da135d02661199f60c5";
          sha256 = "1dnn4r2yrckai5f88riix9ws615007x6x9i6j7621kmy5a05xaiq";
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
    "intervention/gif" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-gif-3a2b5f8a8856e8877cdab5c47e51aab2d4cb23a3";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/gif/zipball/3a2b5f8a8856e8877cdab5c47e51aab2d4cb23a3";
          sha256 = "1b2ljm2pi03p0jzkvl2da2bqv60xniyasgz0wv3xi9qjxv7abbx6";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-d428433aa74836ab75e8d4a5241628bebb7f4077";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/d428433aa74836ab75e8d4a5241628bebb7f4077";
          sha256 = "0qglsydy5672kl1f12pp185zw4vk30jh151bgjvyakggwiabds57";
        };
      };
    };
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-98468898b50c09f26d56d905b79b0f52a2215da6";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/98468898b50c09f26d56d905b79b0f52a2215da6";
          sha256 = "158fsqrnqw0my381f8cfvy5savcvlmpazfbn8j5ds26mldv59csa";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-590afea38e708022662629fbf5184351fa82cf08";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/590afea38e708022662629fbf5184351fa82cf08";
          sha256 = "0gnp0khw8a1rydrv06pi4sssx6fyvdwvcqsgjh8rjcbcs39f1ii5";
        };
      };
    };
    "laravel/prompts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-prompts-9bc4df7c699b0452c6b815e64a2d84b6d7f99400";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/prompts/zipball/9bc4df7c699b0452c6b815e64a2d84b6d7f99400";
          sha256 = "05hf1r10l8fbxy4wy4g4sjwqvd28liq5n4gjyhsc54kj2jp5bba0";
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
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-c7b0193a3753a29aff8ce80aa2f511917e6ed68a";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/c7b0193a3753a29aff8ce80aa2f511917e6ed68a";
          sha256 = "0aym6n2ljqwfxrm5s3h7q98xggnblhk5q4whn46wyyvclqysj2bs";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-502e0fe3f0415d06d5db1f83a472f0f3b754bafe";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/502e0fe3f0415d06d5db1f83a472f0f3b754bafe";
          sha256 = "13l5lm6xz9qad3nmld8sjr4bznh82z8s4kr8kkd8d8a1ai6jd0aq";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-91c24291965bd6d7c46c46a12ba7492f83b1cadf";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/91c24291965bd6d7c46c46a12ba7492f83b1cadf";
          sha256 = "1i7yqcp4hdzz1k6qga96jwp9qpw7dxlfr5miw48zyym60ndk9n02";
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
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-e611adab2b1ae2e3072fa72d62c62f52c2bf1f0c";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/e611adab2b1ae2e3072fa72d62c62f52c2bf1f0c";
          sha256 = "18sackbf9pfbpr03dd5z8vfcqsqhz1sajj2pp2wddz3srcf3zxk5";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-22071ef1604bc776f5ff2468ac27a752514665c8";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/22071ef1604bc776f5ff2468ac27a752514665c8";
          sha256 = "1yhrnw4alf5cf3bwyd3nxcrmwcih6hkmc2l3f6nmhksiza89b9cv";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-13f22ea8be526ea58c2ddff9e158ef7c296e4f40";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/13f22ea8be526ea58c2ddff9e158ef7c296e4f40";
          sha256 = "1cpi818r6nizp965hiba9zhrfjr9gbyqms3f4r4hzd19d73p6l60";
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-html-to-markdown-0b4066eede55c48f38bcee4fb8f0aa85654390fd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/0b4066eede55c48f38bcee4fb8f0aa85654390fd";
          sha256 = "0cd0sv99albdkrj4hmrbb76ji366dsl4jcpsr9gmrrpy3jxi2h7a";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-ce0f4d1e8a6f4eb0ddff33f57c69c50fd09f4301";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/ce0f4d1e8a6f4eb0ddff33f57c69c50fd09f4301";
          sha256 = "1yvjnqb6wv6kxfs21qw31yqcb653dz2xw9g646y2g9via33fxvpd";
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
        name = "league-oauth2-client-160d6274b03562ebeb55ed18399281d8118b76c8";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/160d6274b03562ebeb55ed18399281d8118b76c8";
          sha256 = "1vyd8c64armlaf9zmpjx2gy0nvv4mhzy5qk9k26k75wa9ffh482s";
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "masterminds-html5-f5ac2c0b0a2eefca70b2ce32a5809992227e75a6";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/f5ac2c0b0a2eefca70b2ce32a5809992227e75a6";
          sha256 = "1fbicmaw79rycpywbbxm2fs3lnmb1a7jvfx6d9sb6nvfhsy924fx";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-4b18b21a5527a3d5ffdac2fd35d3ab25a9597654";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/4b18b21a5527a3d5ffdac2fd35d3ab25a9597654";
          sha256 = "1k7ggaygbcm3ls9pkwm5qmf3a1b5i1bd953jy839km0lh4gz637s";
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
        name = "nesbot-carbon-afd46589c216118ecd48ff2b95d77596af1e57ed";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/afd46589c216118ecd48ff2b95d77596af1e57ed";
          sha256 = "17sz76kydaf5n74qgqz36yxbmg4lwcbcv6kpjxrqfqfrb65sz5b6";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-a6d3a6d1f545f01ef38e60f375d1cf1f4de98188";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/a6d3a6d1f545f01ef38e60f375d1cf1f4de98188";
          sha256 = "0byhgs7jv0kybv0x3xycvi0x2gh7009a3dfgs02yqzzjbbwvrzgz";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-d3ad0aa3b9f934602cb3e3902ebccf10be34d218";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/d3ad0aa3b9f934602cb3e3902ebccf10be34d218";
          sha256 = "11df93i9xkwkfq33hqf2x562a36sibzpc6rkbblz2r10mna6qw6q";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-139676794dc1e9231bf7bcd123cfc0c99182cb13";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/139676794dc1e9231bf7bcd123cfc0c99182cb13";
          sha256 = "1z4bvxvxs09099i3khiydmzy8lqjvk8kdani2qipmkq9vzf9pq56";
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
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-d3b5172f137db2f412239432d77253ceaaa1e939";
        src = fetchurl {
          url = "https://api.github.com/repos/SAML-Toolkits/php-saml/zipball/d3b5172f137db2f412239432d77253ceaaa1e939";
          sha256 = "0hhsww74494bh7xk1d0cyr04yr2fggsscfs9z522k6md780pz85m";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-52a0d99e69f56b9ec27ace92ba56897fe6993105";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/52a0d99e69f56b9ec27ace92ba56897fe6993105";
          sha256 = "1ja5b3fm5v665igrd37vs28zdipbh1xgh57lil2iaggvh1b8kh4x";
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
        name = "phenx-php-font-lib-a1681e9793040740a405ac5b189275059e2a9863";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-font-lib/zipball/a1681e9793040740a405ac5b189275059e2a9863";
          sha256 = "0xb28w943pg0xb5mmm2jd74vr14k2lwh40azpfv0p4ghfg16v3jp";
        };
      };
    };
    "phenx/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phenx-php-svg-lib-46b25da81613a9cf43c83b2a8c2c1bdab27df691";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/46b25da81613a9cf43c83b2a8c2c1bdab27df691";
          sha256 = "1bpkank11plq1xwxv5psn8ip4pk9qxffmgf71k0bzq26xa2b2v8b";
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
        name = "phpseclib-phpseclib-cfa2013d0f68c062055180dd4328cc8b9d1f30b8";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/cfa2013d0f68c062055180dd4328cc8b9d1f30b8";
          sha256 = "1wgzy4fbj565czpn9xasr8lnd9ilh1x3bsalrpx5bskvqr4zspgj";
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
        name = "psr-http-factory-2b4765fddfe3b508ac62f829e852b1501d3f6e8a";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/2b4765fddfe3b508ac62f829e852b1501d3f6e8a";
          sha256 = "1ll0pzm0vd5kn45hhwrlkw2z9nqysqkykynn1bk1a73c5cjrghx3";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-402d35bcb92c70c026d1a6a9883f06b2ead23d71";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/402d35bcb92c70c026d1a6a9883f06b2ead23d71";
          sha256 = "13cnlzrh344n00sgkrp5cgbkr8dznd99c3jfnpl0wg1fdv1x4qfm";
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
        name = "psy-psysh-b6b6cce7d3ee8fbf31843edce5e8f5a72eff4a73";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/b6b6cce7d3ee8fbf31843edce5e8f5a72eff4a73";
          sha256 = "0k3fz94cafw7r8wrs5ybb15wmxiv65yqkyhj2l3m185659iym2p3";
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
        name = "ramsey-uuid-91039bc1faa45ba123c4328958e620d382ec7088";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/91039bc1faa45ba123c4328958e620d382ec7088";
          sha256 = "0n6rj0b042fq319gfnp2c4aawawfz8vb2allw30jjfaf8497hh9j";
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
        name = "sabberworm-php-css-parser-4a3d572b0f8b28bb6fd016ae8bbfc445facef152";
        src = fetchurl {
          url = "https://api.github.com/repos/MyIntervals/PHP-CSS-Parser/zipball/4a3d572b0f8b28bb6fd016ae8bbfc445facef152";
          sha256 = "1gs3q8j70ccwa2s3icf936xxik8h3qi5plkpvw4ygzkb9vkcicdv";
        };
      };
    };
    "socialiteproviders/discord" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-discord-c71c379acfdca5ba4aa65a3db5ae5222852a919c";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Discord/zipball/c71c379acfdca5ba4aa65a3db5ae5222852a919c";
          sha256 = "0xly514yax8rlz91pp86s24apcam1cvjnphanjhdshd42hmpwr7w";
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
        name = "socialiteproviders-manager-dea5190981c31b89e52259da9ab1ca4e2b258b21";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/dea5190981c31b89e52259da9ab1ca4e2b258b21";
          sha256 = "11lvz1lckglh5nz0nvv0ifw9a2yfcgzlf30h09ci0d6cklkqf3la";
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-453d62c9d7e3b3b76e94c913fb46e68a33347b16";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/453d62c9d7e3b3b76e94c913fb46e68a33347b16";
          sha256 = "0wcqwpj2x3llnisixz8id8ww0vr1cab7mh19mvf33dymxzydv11h";
        };
      };
    };
    "socialiteproviders/okta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-okta-5e47cd7b4c19da94ecafbd91fa430e4151c09806";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Okta/zipball/5e47cd7b4c19da94ecafbd91fa430e4151c09806";
          sha256 = "0padnyfg93avx33gq2acsss3kpclxsg43b9zywas1rd98d3md1di";
        };
      };
    };
    "socialiteproviders/twitch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-twitch-c8791b9d208195b5f02bea432de89d0e612b955d";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Twitch/zipball/c8791b9d208195b5f02bea432de89d0e612b955d";
          sha256 = "1abdn0ykx7rirmm64wi2zbw8fj9jr7a7p88p2mnfxd87l2qcc4rc";
        };
      };
    };
    "ssddanbrown/htmldiff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-htmldiff-92da405f8138066834b71ac7bedebbda6327761b";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/92da405f8138066834b71ac7bedebbda6327761b";
          sha256 = "1l1s8fdpd7k39l7mslk7pqgg6bwk2c3644ifj58y6515sik6m142";
        };
      };
    };
    "ssddanbrown/symfony-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-symfony-mailer-0497d6eb2734fe22b9550f88ae6526611c9df7ae";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/symfony-mailer/zipball/0497d6eb2734fe22b9550f88ae6526611c9df7ae";
          sha256 = "0zs2hhcyv7f5lmz4xn9gp5dixcixgm3gfj4l8chzmqg6x640l59r";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-be5854cee0e8c7b110f00d695d11debdfa1a2a91";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/be5854cee0e8c7b110f00d695d11debdfa1a2a91";
          sha256 = "018il5dccpnk2988sgxp26440wrx25j064gns7plnidmx7byxjpw";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-4b61b02fe15db48e3687ce1c45ea385d1780fe08";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/4b61b02fe15db48e3687ce1c45ea385d1780fe08";
          sha256 = "066gmgxy8228kxfqgirmilil172q61i6fc0vnxxpmcyz6b7xxfai";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-0e0d29ce1f20deffb4ab1b016a7257c4f1e789a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/0e0d29ce1f20deffb4ab1b016a7257c4f1e789a1";
          sha256 = "1qhyyfyd7q75nyqivjzrljmqa5qhh09gjs2vz7s3xadq0j525c2b";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-ef836152bf13472dc5fb5b08b0c0c4cfeddc0fcc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/ef836152bf13472dc5fb5b08b0c0c4cfeddc0fcc";
          sha256 = "0r29dqwxs2xmv404rfcidf83rycfm9fqv7hsqaz3jwms00y770gg";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-8d7507f02b06e06815e56bb39aa0128e3806208b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/8d7507f02b06e06815e56bb39aa0128e3806208b";
          sha256 = "162p2x4vxwvljdrqq481sccspzyky2g53pmmnqg4hvg76g5yajj8";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-8f93aec25d41b72493c6ddff14e916177c9efc50";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/8f93aec25d41b72493c6ddff14e916177c9efc50";
          sha256 = "1ybpwhcf82fpa7lj5n2i8jhba2qmq4850svd4nv3v852vwr98ani";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-3ef977a43883215d560a2cecb82ec8e62131471c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/3ef977a43883215d560a2cecb82ec8e62131471c";
          sha256 = "1ibv2sk2bfg6hymxhs6p6g62h7ycw1w2lg1w1q78pql1nxvrp7ks";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-27de8cc95e11db7a50b027e71caaab9024545947";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/27de8cc95e11db7a50b027e71caaab9024545947";
          sha256 = "11bf0fhb7pf5jp5kpd7nm8sil9mnnvhihj4l23gx514m81anzfi0";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-6c519aa3f32adcfd1d1f18d923f6b227d9acf3c1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/6c519aa3f32adcfd1d1f18d923f6b227d9acf3c1";
          sha256 = "0y2qsnymkagnds6qwgfv2lbf9i3jf0f4frs1psa35mkb64c58hkg";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-618597ab8b78ac86d1c75a9d0b35540cda074f33";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/618597ab8b78ac86d1c75a9d0b35540cda074f33";
          sha256 = "1rklzg8j8s6ls770l8rqz7mb10nrifr228zmqpxdqkpfrs8j0w3z";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-ef4d7e442ca910c4764bce785146269b30cb5fc4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/ef4d7e442ca910c4764bce785146269b30cb5fc4";
          sha256 = "16wr6dp9yr4wks11d1qjyzpc343ri2nr7q7fmrnp3jhmp949rppy";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-32a9da87d7b3245e09ac426c83d334ae9f06f80f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/32a9da87d7b3245e09ac426c83d334ae9f06f80f";
          sha256 = "03wk7yxavld4jnvavy7m2d3xxn5h4938wypgwjkblgx8n7s93jiq";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-a287ed7475f85bf6f61890146edbc932c0fff919";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/a287ed7475f85bf6f61890146edbc932c0fff919";
          sha256 = "14x9hv01fn5dmpkm7480lgzhz4lqdi3w1hlkh3sjpb6ic87k0wc1";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-bc45c394692b948b4d383a08d7753968bed9a83d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/bc45c394692b948b4d383a08d7753968bed9a83d";
          sha256 = "1zq1kklvjl4zj2v6yjzg7rv6ibvhxfymgi2xb0m5cw9r6i63rinw";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-9773676c8a1bb1f8d4340a62efe641cf76eda7ec";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/9773676c8a1bb1f8d4340a62efe641cf76eda7ec";
          sha256 = "1jpa4wwjfdkkhdpisviy1p4fhik00cldj5msipwl0izkia1d2qgf";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-861391a8da9a04cbad2d232ddd9e4893220d6e25";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/861391a8da9a04cbad2d232ddd9e4893220d6e25";
          sha256 = "0b4nw7x6c7jjn9bvkpqjnpszx647lncyswpk2iz57c1xl5dqywvh";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-87b68208d5c1188808dd7839ee1e6c8ec3b02f1b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/87b68208d5c1188808dd7839ee1e6c8ec3b02f1b";
          sha256 = "1pn6dzj8b3h8851w3y6mj5qrwklwky5w71v4m455553qlga5cfr7";
        };
      };
    };
    "symfony/polyfill-php83" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php83-86fcae159633351e5fd145d1c47de6c528f8caff";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php83/zipball/86fcae159633351e5fd145d1c47de6c528f8caff";
          sha256 = "0n81fmn058rn7hr70qdwpsnam57pp27avs3h8xcfnq8d3hci5gr4";
        };
      };
    };
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-3abdd21b0ceaa3000ee950097bc3cf9efc137853";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/3abdd21b0ceaa3000ee950097bc3cf9efc137853";
          sha256 = "15g5ng1bcca4nqxjrcjabc1v679zl6xwm1wwfngvww1hvrbgd98d";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-8d92dd79149f29e89ee0f480254db595f6a6a2c5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/8d92dd79149f29e89ee0f480254db595f6a6a2c5";
          sha256 = "1fvyj71vdnbm56xp167svigax6q562j92i309wqikprdyakdqmyy";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-8a40d0f9b01f0fbb80885d3ce0ad6714fb603a58";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/8a40d0f9b01f0fbb80885d3ce0ad6714fb603a58";
          sha256 = "1ayhdyvc503xjjaaz6vclsxbm568l73zybcbxiz6g1625cg4g8gb";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-bd1d9e59a81d8fa4acdcea3f617c581f7475a80f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/bd1d9e59a81d8fa4acdcea3f617c581f7475a80f";
          sha256 = "1q7382ingrvqdh7hm8lrwrimcvlv5qcmp6xrparfh1kmrsf45prv";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-a147c0f826c4a1f3afb763ab8e009e37c877a44d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/a147c0f826c4a1f3afb763ab8e009e37c877a44d";
          sha256 = "1fkpq4lw9rp3wccdjj8qhpl02asp1izvji53sd0gzq4z3djq0y7p";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-a002933b13989fc4bd0b58e04bf7eec5210e438a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/a002933b13989fc4bd0b58e04bf7eec5210e438a";
          sha256 = "0a6rw66b6yysafkyhgzpqq147cm38id3v1kksnzgna528d5cac87";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-b9d2189887bb6b2e0367a9fc7136c5239ab9b05a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/b9d2189887bb6b2e0367a9fc7136c5239ab9b05a";
          sha256 = "0y9dp08gw7rk50i5lpci6n2hziajvps97g9j3sz148p0afdr5q3c";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-35904eca37a84bb764c560cbfcac9f0ac2bcdbdf";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/35904eca37a84bb764c560cbfcac9f0ac2bcdbdf";
          sha256 = "1xwvr4lp9cxr7s065xidqw9k3abdj6npd54flp7smgb4npl67s13";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-ad23ca4312395f0a8a8633c831ef4c4ee542ed25";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/ad23ca4312395f0a8a8633c831ef4c4ee542ed25";
          sha256 = "077ppd7v37qh6rfrv76apa1hm4apaqj5iskbfwlm32cndv0bnxk1";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-83ee6f38df0a63106a9e4536e3060458b74ccedb";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/83ee6f38df0a63106a9e4536e3060458b74ccedb";
          sha256 = "1ahj49c7qz6m3y65jd18cz2c8cg6zqhkmnsrqrw1bf3s8ly9a9bp";
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
  devPackages = { };
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
