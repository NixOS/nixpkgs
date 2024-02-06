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
        name = "aws-aws-sdk-php-2e34d45e970c77775e4c298e08732d64b647c41c";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/2e34d45e970c77775e4c298e08732d64b647c41c";
          sha256 = "1h08lxna8sjq90lrxj60w2cyf9iynvyw4b8r9nl1bxsdmbmgl27s";
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
        name = "doctrine-lexer-39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
          sha256 = "19kak8fh8sf5bpmcn7a90sqikgx30mk2bmjf0jbzcvlbnsjyggah";
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
        name = "laravel-framework-082345d76fc6a55b649572efe10b11b03e279d24";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/082345d76fc6a55b649572efe10b11b03e279d24";
          sha256 = "0gzpj0cgnqncxd4h196k5mvv169xzmy8c6bdwm5pkdy0f2hnb6lq";
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
        name = "laravel-socialite-4f6a8af6f3f7c18da03d19842dd0514315501c10";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/4f6a8af6f3f7c18da03d19842dd0514315501c10";
          sha256 = "0329mzryfg198mgjb9k3ay5699mi4gz3i6dmaaxglar7gp0mlpvh";
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
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-d4ad81e2b67396e33dc9d7e54ec74ccf73151dcc";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/d4ad81e2b67396e33dc9d7e54ec74ccf73151dcc";
          sha256 = "1xfgcslv66jid10yjjzp1chwv579xgaymlzkxiwfk5mh77fdfryi";
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
        name = "league-flysystem-local-5cf046ba5f059460e86a997c504dd781a39a109b";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/5cf046ba5f059460e86a997c504dd781a39a109b";
          sha256 = "0yr12z32plvpz70y8ravb9w80y583wkpsl1d0xhnglcka24aysdr";
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
        name = "league-mime-type-detection-b6a5854368533df0295c5761a0253656a2e52d9e";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/b6a5854368533df0295c5761a0253656a2e52d9e";
          sha256 = "0bsqha9c0pyb5l78iiv1klrpqmhki6nh9x73pgnmh7sphh6ilygj";
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
        name = "monolog-monolog-437cb3628f4cf6042cc10ae97fc2b8472e48ca1f";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/437cb3628f4cf6042cc10ae97fc2b8472e48ca1f";
          sha256 = "02xaa057fj2bjf6g6zx80rb6ikcgn601ns50ml51b8yp48pjdla3";
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
        name = "nesbot-carbon-2b3b3db0a2d0556a177392ff1a3bf5608fa09f78";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/2b3b3db0a2d0556a177392ff1a3bf5608fa09f78";
          sha256 = "1wf1kc2v6n68x04kf5dqf96ihkly4yb77bj09isp3yadsnhqy69d";
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
        name = "nikic-php-parser-1bcbb2179f97633e98bbbc87044ee2611c7d7999";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/1bcbb2179f97633e98bbbc87044ee2611c7d7999";
          sha256 = "1all9j7b5cr87jjs2lam2s11kvygi9jkkc7fks43f9jf1sp2ybji";
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
        name = "phenx-php-svg-lib-8a8a1ebcf6aea861ef30197999f096f7bd4b4456";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/8a8a1ebcf6aea861ef30197999f096f7bd4b4456";
          sha256 = "14iq5594y19dl5sr1f0zqvpg6fkv4hifb9y5i97phhplyprfdh7g";
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
        name = "phpseclib-phpseclib-56c79f16a6ae17e42089c06a2144467acc35348a";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/56c79f16a6ae17e42089c06a2144467acc35348a";
          sha256 = "0xmv35m6fsw7rfaxs82ky0wgj3gsnp7qw0sjgkig2cw10anfs0gq";
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
        name = "socialiteproviders-manager-df5e45b53d918ec3d689f014d98a6c838b98ed96";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/df5e45b53d918ec3d689f014d98a6c838b98ed96";
          sha256 = "0hzgj5p3cdi4mxrnq3c20yyjr4c1hnqnz8d2440s308a4wahz33z";
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
        name = "symfony-console-c3ebc83d031b71c39da318ca8b7a07ecc67507ed";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/c3ebc83d031b71c39da318ca8b7a07ecc67507ed";
          sha256 = "1vvdw2fg08x9788m50isspi06n0lhw6c6nif3di1snxfq0sgb1np";
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
        name = "symfony-error-handler-c7df52182f43a68522756ac31a532dd5b1e6db67";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c7df52182f43a68522756ac31a532dd5b1e6db67";
          sha256 = "1dqr0n3w6zmk96q7x8pz1przkiyb2kyg5mw3d1nmnyry8dryv7c8";
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
        name = "symfony-finder-5cc9cac6586fc0c28cd173780ca696e419fefa11";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/5cc9cac6586fc0c28cd173780ca696e419fefa11";
          sha256 = "1f0sbxczwcrzxb03cc2rshfzdrkjfg7nwkbvvi449qscaq1qx2dc";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-e16b2676a4b3b1fa12378a20b29c364feda2a8d6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/e16b2676a4b3b1fa12378a20b29c364feda2a8d6";
          sha256 = "0d2fgzcxi7sq7j8l1lg2kpfsr6p1xk1lxdjyqr63vihm34i8p42g";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-6dc70833fd0ef5e861e17c7854c12d7d86679349";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/6dc70833fd0ef5e861e17c7854c12d7d86679349";
          sha256 = "1j1z911g4nsx7wjg14q1g7y98qj1k4crxnwxi97i4cjnyqihcj2r";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-d7052547a0070cbeadd474e172b527a00d657301";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/d7052547a0070cbeadd474e172b527a00d657301";
          sha256 = "005jfcpcdn8p2qqv1kyh14jijx36n3rrh9v9a9immfdr0gyv22ca";
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
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-7581cd600fa9fd681b797d00b02f068e2f13263b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/7581cd600fa9fd681b797d00b02f068e2f13263b";
          sha256 = "0ngi5nhnbj4yycnf6yw628vmr7h6dhxxh7jawyp6gq7bzs94g2dy";
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
        name = "symfony-routing-e56ca9b41c1ec447193474cd86ad7c0b547755ac";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/e56ca9b41c1ec447193474cd86ad7c0b547755ac";
          sha256 = "0qsx525fhqnx6g5rn8lavzpqccrg2ixrp88p1g4yjr8x7i2im5nd";
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
        name = "symfony-string-d9e72497367c23e08bf94176d2be45b00a9d232a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/d9e72497367c23e08bf94176d2be45b00a9d232a";
          sha256 = "0k4vvcjfdp2dni8gzq4rn8d6n0ivd38sfna70lgsh8vlc8rrlhpf";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-9c24b3fdbbe9fb2ef3a6afd8bbaadfd72dad681f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/9c24b3fdbbe9fb2ef3a6afd8bbaadfd72dad681f";
          sha256 = "12c13k5ljch06g8xp28kkpv0ml67hy086rk25mzd94hjpawrs4x2";
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
        name = "symfony-var-dumper-eb980457fa6899840fe1687e8627a03a7d8a3d52";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/eb980457fa6899840fe1687e8627a03a7d8a3d52";
          sha256 = "183igs4i74kljxyq7azpg59wb281mlvy1xgqnb4pkz4dw50jgc2k";
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

