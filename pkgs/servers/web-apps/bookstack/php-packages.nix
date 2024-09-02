{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

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
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-9843d2be423670fb434f4c978b3c0f4dd92c87a6";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/9843d2be423670fb434f4c978b3c0f4dd92c87a6";
          sha256 = "1b7j7rnba50ibsnjzxz3bcnpcii51qrin5p0ivi0bzm57xhvns9s";
        };
      };
    };
    "barryvdh/laravel-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-snappy-940eec2d99b89cbc9bea2f493cf068382962a485";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-snappy/zipball/940eec2d99b89cbc9bea2f493cf068382962a485";
          sha256 = "0i168sq1sah83xw3xfrilnpja789q79zvhjfgfcszd10g7y444gc";
        };
      };
    };
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-0ad82ce168c82ba30d1c01ec86116ab52f589478";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/0ad82ce168c82ba30d1c01ec86116ab52f589478";
          sha256 = "04kqy1hqvp4634njjjmhrc2g828d69sk6q3c55bpqnnmsqf154yb";
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
        name = "doctrine-lexer-861c870e8b75f7c8f69c146c7f89cc1c0f1b49b6";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/861c870e8b75f7c8f69c146c7f89cc1c0f1b49b6";
          sha256 = "0q25i1d6nqkrj4yc35my6b51kn2nksddhddm13vkc7ilkkn20pg7";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-093f2d9739cec57428e39ddadedfd4f3ae862c0f";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/093f2d9739cec57428e39ddadedfd4f3ae862c0f";
          sha256 = "0852xp3qfg40byhv7z4bma9bpiyrc3yral3p9xhk8g62jjddvayn";
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
        name = "egulias-email-validator-e5997fa97e8790cdae03a9cbd5e78e45e3c7bda7";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/e5997fa97e8790cdae03a9cbd5e78e45e3c7bda7";
          sha256 = "16s7k5ck8bzk83xfy46fikjyj4jywalriqba8jvd5ngd177s2mw5";
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
        name = "knplabs-knp-snappy-3db13fe45d12a7bccb2b83f622e5a90f7e40b111";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/3db13fe45d12a7bccb2b83f622e5a90f7e40b111";
          sha256 = "1l4nln4cg01ywv9lzi5srnm7jq4q1v0210j9sshq34vx8slll9di";
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
        name = "league-flysystem-b25a361508c407563b34fac6f64a8a17a8819675";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/b25a361508c407563b34fac6f64a8a17a8819675";
          sha256 = "07fd3nqvs9wnl7wwlii3aaalpdldgf6agk2l1ihl3w253qyg8ynn";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-809474e37b7fb1d1f8bcc0f8a98bc1cae99aa513";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/809474e37b7fb1d1f8bcc0f8a98bc1cae99aa513";
          sha256 = "0iv1n4y6w4pa2051wxvnkcap08jb86qgfx1hb6w8z5rngg67nz4d";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-b884d2bf9b53bb4804a56d2df4902bb51e253f00";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/b884d2bf9b53bb4804a56d2df4902bb51e253f00";
          sha256 = "1ggpc08rdaqk2wxkvklfi6l7nqzd6ch2dgf9icr1shfiv09l0mp6";
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
        name = "masterminds-html5-f47dcf3c70c584de14f21143c55d9939631bc6cf";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/f47dcf3c70c584de14f21143c55d9939631bc6cf";
          sha256 = "1n2xiyxqmxk9g34wn1lg2yyivwg2ry8iqk8m7g2432gm97rmyb20";
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
        name = "nesbot-carbon-0c6fd108360c562f6e4fd1dedb8233b423e91c83";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/0c6fd108360c562f6e4fd1dedb8233b423e91c83";
          sha256 = "1qwdzf2jgppj2r8jpxxd1q08aycyvj17azy2ixlw4cnmwhcqzgnh";
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
        name = "onelogin-php-saml-b22a57ebd13e838b90df5d3346090bc37056409d";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/b22a57ebd13e838b90df5d3346090bc37056409d";
          sha256 = "1bi65bi04a26zmaz7ms0qyg6i86k4cd9g8qs7dp1pphpvflgz461";
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
        name = "phenx-php-svg-lib-732faa9fb4309221e2bd9b2fda5de44f947133aa";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/732faa9fb4309221e2bd9b2fda5de44f947133aa";
          sha256 = "0hjf562cm8mvb36c2s63bh5104j6m5c27lwd4pgj3lwmq6mpzns6";
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
        name = "ramsey-collection-ad7475d1c9e70b190ecffc58f2d989416af339b4";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/ad7475d1c9e70b190ecffc58f2d989416af339b4";
          sha256 = "1a1wqdwdrbzkf2hias2kw9crr31265pn027vm69pr7alyq2qrzfw";
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
        name = "socialiteproviders-manager-a67f194f0f4c4c7616c549afc697b78df9658d44";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/a67f194f0f4c4c7616c549afc697b78df9658d44";
          sha256 = "0r5c6q7dm02hnk574br5mrm1z8amrxjxcbf4n94l02vq9din2c0m";
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
    "ssddanbrown/symfony-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-symfony-mailer-2219dcdc5f58e4f382ce8f1e6942d16982aa3012";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/symfony-mailer/zipball/2219dcdc5f58e4f382ce8f1e6942d16982aa3012";
          sha256 = "14j99gr09mvgjf6jjxbw50zay8n9mg6c0w429hz3vrfaijc2ih8c";
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
        name = "symfony-css-selector-f1d00bddb83a4cb2138564b2150001cb6ce272b1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/f1d00bddb83a4cb2138564b2150001cb6ce272b1";
          sha256 = "0nl94wjr5sm4yrx9y0vwk4dzh1hm17f1n3d71hmj7biyzds0474i";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
          sha256 = "1wlaj9ngbyjmgr92gjyf7lsmjfswyh8vpbzq5rdzaxjb6bcsj3dp";
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
        name = "symfony-event-dispatcher-2eaf8e63bc5b8cefabd4a800157f0d0c094f677a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/2eaf8e63bc5b8cefabd4a800157f0d0c094f677a";
          sha256 = "0wwphxh21n502wgldh3kqqhvl1zxh2yncbadwwh05d8sp5mz0ysn";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-7bc61cc2db649b4637d331240c5346dcc7708051";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/7bc61cc2db649b4637d331240c5346dcc7708051";
          sha256 = "1crx2j4g5jn904fwk7919ar9zpyfd5bvgm80lmyg15kinsjm3w4i";
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
    "symfony/polyfill-php81" = {
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
        name = "symfony-process-2114fd60f26a296cc403a7939ab91478475a33d4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/2114fd60f26a296cc403a7939ab91478475a33d4";
          sha256 = "1rpcl0qayf0jysfn95c4s73r7fl48sng4m5flxy099z6m6bblwq1";
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
        name = "symfony-service-contracts-d78d39c1599bd1188b8e26bb341da52c3c6d8a66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/d78d39c1599bd1188b8e26bb341da52c3c6d8a66";
          sha256 = "1cgbn2yx2fyrc3c1d85vdriiwwifr1sdg868f3rhq9bh78f03z99";
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
        name = "symfony-translation-contracts-acbfbb274e730e5a0236f619b6168d9dedb3e282";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/acbfbb274e730e5a0236f619b6168d9dedb3e282";
          sha256 = "1r496j63a6q3ch0ax76qa1apmc4iqf41zc8rf6yn8vkir3nzkqr0";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-6499e28b0ac9f2aa3151e11845bdb5cd21e6bb9d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/6499e28b0ac9f2aa3151e11845bdb5cd21e6bb9d";
          sha256 = "12r2jgmwwchmq4apgmb2h1hy6i4cznjpc94976h2qzy3q3yp7zyq";
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

