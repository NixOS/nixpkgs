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
        name = "aws-aws-crt-php-a63485b65b6b3367039306496d49737cf1995408";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/a63485b65b6b3367039306496d49737cf1995408";
          sha256 = "0sga71rp99dxjx524wxrn9lrjca4fd5iniphzwd9ss97w9nihq9i";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-702b9955160d2dacdf2cdf4d4476fcf95eae1aaf";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/702b9955160d2dacdf2cdf4d4476fcf95eae1aaf";
          sha256 = "0yhld9v2qbdrw3bz8dwjhv60mbjyr632rqnj593h3bsxf4w3l7vj";
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
        name = "dasprid-enum-8dfd07c6d2cf31c8da90c53b83c026c7696dda90";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/8dfd07c6d2cf31c8da90c53b83c026c7696dda90";
          sha256 = "1ainxbpfbh9fir2vihc4q614yq6rc3lvz6836nddl50wx2zpcby2";
        };
      };
    };
    "dflydev/dot-access-data" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-dot-access-data-a23a2bf4f31d3518f3ecb38660c95715dfead60f";
        src = fetchurl {
          url = "https://api.github.com/repos/dflydev/dflydev-dot-access-data/zipball/a23a2bf4f31d3518f3ecb38660c95715dfead60f";
          sha256 = "0j0rywsfpna100ygdk5f2ngijc8cp785szz84274mq8gdzhan06l";
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
        name = "doctrine-dbal-d8f68ea6cc00912e5313237130b8c8decf4d28c6";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/d8f68ea6cc00912e5313237130b8c8decf4d28c6";
          sha256 = "0ay8x80cyfnr83c3bpjkabh0hlzz7hibd8jpfr24gsrf592sz82m";
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
        name = "graham-campbell-result-type-3ba905c11371512af9d9bdd27d99b782216b6945";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/3ba905c11371512af9d9bdd27d99b782216b6945";
          sha256 = "16bsycdsgcf4jz2sd277958rn9k9mzxjnby20xpmyhb7s8c2rac7";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-d281ed313b989f213357e3be1a179f02196ac99b";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/d281ed313b989f213357e3be1a179f02196ac99b";
          sha256 = "048hm3r04ldk2w9pqja6jmkc590h1kln3136128bn7zzdg1vmqi4";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-6ea8dd08867a2a42619d65c3deb2c0fcbf81c8f8";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/6ea8dd08867a2a42619d65c3deb2c0fcbf81c8f8";
          sha256 = "03l91ksymgygdwa30ry0752564nrwkbgmrmlhmmhq89v06i70lln";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-a70f5c95fb43bc83f07c9c948baa0dc1829bf201";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/a70f5c95fb43bc83f07c9c948baa0dc1829bf201";
          sha256 = "1xp4c6v1qszbhzdgcgbd03dvxsk0s0vysr3q4rvhm134qlkbrdf2";
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
        name = "intervention-image-1786ad5e1789050939d73cd195de4b8eaeeb34ed";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/1786ad5e1789050939d73cd195de4b8eaeeb34ed";
          sha256 = "1hx23frhjsisss19xzhjmrv7ymf0siqp1g50xvx27kisp7ifyv1k";
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
        name = "laravel-framework-be2be342d4c74db6a8d2bd18469cd6d488ab9c98";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/be2be342d4c74db6a8d2bd18469cd6d488ab9c98";
          sha256 = "0r62pimjsqcgip725qh4zmb7icssf84larffjv2l0g4f31683h6x";
        };
      };
    };
    "laravel/prompts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-prompts-7b4029a84c37cb2725fc7f011586e2997040bc95";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/prompts/zipball/7b4029a84c37cb2725fc7f011586e2997040bc95";
          sha256 = "0fzww2cdpm5l6smas1kw47wh9j0w72z00bb8ahxyzlz0gl4k7jz8";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-61b87392d986dc49ad5ef64e75b1ff5fee24ef81";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/61b87392d986dc49ad5ef64e75b1ff5fee24ef81";
          sha256 = "02mpbd5qv27p5637yyyx8jpx6x3sgjdj1j5immlgc73j7a0vj7xl";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-cc02625f0bd1f95dc3688eb041cce0f1e709d029";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/cc02625f0bd1f95dc3688eb041cce0f1e709d029";
          sha256 = "1fcrk4h4gwb06x842225yk1mbja0bbrzjd7dxkhqzvccfkd3q1km";
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
        name = "league-commonmark-b650144166dfa7703e62a22e493b853b58d874b0";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/b650144166dfa7703e62a22e493b853b58d874b0";
          sha256 = "0ggjlpjdjvk9dxdav2264j7ycazsg6s5wlzmv8ihv375wi20dg5g";
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
        name = "monolog-monolog-f4393b648b78a5408747de94fca38beb5f7e9ef8";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/f4393b648b78a5408747de94fca38beb5f7e9ef8";
          sha256 = "0jz5b9rss98xa4bw0y4bp3by9vpbw97scwndkjimq7kwr9n6kpjy";
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
        name = "nette-utils-736c567e257dbe0fcf6ce81b4d6dbe05c6899f96";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/736c567e257dbe0fcf6ce81b4d6dbe05c6899f96";
          sha256 = "1v81fswairscrnakbrfh8mlh5i873krlgvhv6ngsb9pi281x6r2b";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-683130c2ff8c2739f4822ff7ac5c873ec529abd1";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/683130c2ff8c2739f4822ff7ac5c873ec529abd1";
          sha256 = "1wwjddqsbq94grckdnplcg8c3423y2jw2mx97n2k7f8wlq4q1fhv";
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
        name = "phpoption-phpoption-e3fac8b24f56113f7cb96af14958c0dd16330f54";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/e3fac8b24f56113f7cb96af14958c0dd16330f54";
          sha256 = "0rbw9mljc00rx2drrqpmwfs47s77iprxvpbff2vqw082x4y989rq";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-621c73f7dcb310b61de34d1da4c4204e8ace6ceb";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/621c73f7dcb310b61de34d1da4c4204e8ace6ceb";
          sha256 = "1p3asiv3cak3m6lla66bgxiwz00nwn1dd6lwnqgdpqyqh6gbln1n";
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
        name = "psr-log-79dff0b268932c640297f5208d6298f71855c03e";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/79dff0b268932c640297f5208d6298f71855c03e";
          sha256 = "18vvdj61v85glmr26i1jl1x93cq2c1aq1ajpa6z4l749c62670f2";
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
        name = "psy-psysh-2fd717afa05341b4f8152547f142cd2f130f6818";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/2fd717afa05341b4f8152547f142cd2f130f6818";
          sha256 = "009mhfsh6vsrygdmr5b64w8mppw6j2n8ajbx856dpcwjji8fx8q7";
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
        name = "sabberworm-php-css-parser-d2fb94a9641be84d79c7548c6d39bbebba6e9a70";
        src = fetchurl {
          url = "https://api.github.com/repos/MyIntervals/PHP-CSS-Parser/zipball/d2fb94a9641be84d79c7548c6d39bbebba6e9a70";
          sha256 = "0dvn86wx9h4vlw7wz7v1jq8ba654s060dg3186z2cr2q9f636dy2";
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
        name = "symfony-console-504974cbe43d05f83b201d6498c206f16fc0cdbc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/504974cbe43d05f83b201d6498c206f16fc0cdbc";
          sha256 = "004hx7047y2cknj54kfifj28rchvx7k1635y28gmaq5k5caahfd8";
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
        name = "symfony-error-handler-231f1b2ee80f72daa1972f7340297d67439224f0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/231f1b2ee80f72daa1972f7340297d67439224f0";
          sha256 = "0bdphr8xv4d9ln3yiaajzxfvybc6kvcpsybf69kg6f2v88p14pj7";
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
        name = "symfony-finder-af29198d87112bebdd397bd7735fbd115997824c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/af29198d87112bebdd397bd7735fbd115997824c";
          sha256 = "0wgc1rr6fg9prsmjbkcaf530h1gf1v8wnab84sfzpcrwaa4abdmv";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-117f1f20a7ade7bcea28b861fb79160a21a1e37b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/117f1f20a7ade7bcea28b861fb79160a21a1e37b";
          sha256 = "1rgzpb9v9502d5f0zlq7h0s15i1lg63clsx1j5cw51w2y079frgn";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-147e0daf618d7575b5007055340d09aece5cf068";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/147e0daf618d7575b5007055340d09aece5cf068";
          sha256 = "1bpv2zwsgz1ki9vzhcz5jj9c712zz6crncw2gw88n10gn2sir1cj";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-7d048964877324debdcb4e0549becfa064a20d43";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/7d048964877324debdcb4e0549becfa064a20d43";
          sha256 = "0i9falma5rwi59cjylibgzj70gqj0vrkpkf9g8mxzy62ij5l61rq";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-0424dff1c58f028c451efff2045f5d92410bd540";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/0424dff1c58f028c451efff2045f5d92410bd540";
          sha256 = "1lcz3k1i3yndy1qkdh89n05m60hh3g1zi438l0qf92j5hy2pr32n";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-64647a7c30b2283f5d49b874d84a18fc22054b7a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/64647a7c30b2283f5d49b874d84a18fc22054b7a";
          sha256 = "1flqdijnx2kz2i9jdaz23ambii3nx60j211hcjzdf5mzmbic4izr";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-a6e83bdeb3c84391d1dfe16f42e40727ce524a5c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/a6e83bdeb3c84391d1dfe16f42e40727ce524a5c";
          sha256 = "1y81p5kkrclbgq1v3qgf32mpgn6q1hjkw0n6328n2n81wj32japg";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-a95281b0be0d9ab48050ebd988b967875cdb9fdb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/a95281b0be0d9ab48050ebd988b967875cdb9fdb";
          sha256 = "1bsynsi3gqcdi5asgip7srnwciwz7dflzqx1n0c9x3zmd128fs42";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-fd22ab50000ef01661e2a31d850ebaa297f8e03c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/fd22ab50000ef01661e2a31d850ebaa297f8e03c";
          sha256 = "145vqkfca4h0smyjnhcsvn85ij75bbp9a5s3m672nn48671a8sxk";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-10112722600777e02d2745716b70c5db4ca70442";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/10112722600777e02d2745716b70c5db4ca70442";
          sha256 = "1l9qpprnqrjjhkwggcz0c6ll8wrfzwlqcwq13xa0j9w0q5bwafp2";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-77fa7995ac1b21ab60769b7323d600a991a90433";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/77fa7995ac1b21ab60769b7323d600a991a90433";
          sha256 = "03y0jzb5z1d2jdxcw1mhcbb9psp1iabmvaflwib68vzncvh6fscl";
        };
      };
    };
    "symfony/polyfill-php83" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php83-dbdcdf1a4dcc2743591f1079d0c35ab1e2dcbbc9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php83/zipball/dbdcdf1a4dcc2743591f1079d0c35ab1e2dcbbc9";
          sha256 = "1sxmb6f75iclbpqwlsgi3af1xfcrxm7vcyyh0khn14nvd654ivrl";
        };
      };
    };
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-2ba1f33797470debcda07fe9dce20a0003df18e9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/2ba1f33797470debcda07fe9dce20a0003df18e9";
          sha256 = "1hsfsap6qmlkzfi56z44wgds5igw9xj7rax2znr8y3ci4x9sbxd0";
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
        name = "symfony-routing-aad19fe10753ba842f0d653a8db819c4b3affa87";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/aad19fe10753ba842f0d653a8db819c4b3affa87";
          sha256 = "1cm2x1bffnm0parfkw3xixz8igj52pc4vv6hydkj0l2i3qrv4y0g";
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
        name = "symfony-string-ccf9b30251719567bfd46494138327522b9a9446";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/ccf9b30251719567bfd46494138327522b9a9446";
          sha256 = "1yfdvksfhpq74vb45d3p8rnkbr43djbcy15gyi0vsbgccr64gc1v";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-94041203f8ac200ae9e7c6a18fa6137814ccecc9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/94041203f8ac200ae9e7c6a18fa6137814ccecc9";
          sha256 = "01kzjwvkq434d36c5ag9qfzi4fdb3klcbx1gsrwx6zc3wvxs50x1";
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
        name = "symfony-var-dumper-a71cc3374f5fb9759da1961d28c452373b343dd4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/a71cc3374f5fb9759da1961d28c452373b343dd4";
          sha256 = "19nwa0qydp0g0s5fvcm7h90973c1j1q5llrg80v43qgv3wgawp36";
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
        name = "vlucas-phpdotenv-a59a13791077fe3d44f90e7133eb68e7d22eaff2";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/a59a13791077fe3d44f90e7133eb68e7d22eaff2";
          sha256 = "1w7nyghdx0vw0v3rqzx0x3lafhrkgfk2fi3xiy5vf4lkbv3rdl4h";
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
