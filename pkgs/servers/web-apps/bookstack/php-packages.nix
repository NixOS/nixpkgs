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
        name = "aws-aws-crt-php-d71d9906c7bb63a28295447ba12e74723bd3730e";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/d71d9906c7bb63a28295447ba12e74723bd3730e";
          sha256 = "1giqdlzja742di06qychsi8w12hy4dmaajzgl7jhcpwqqyi4xh42";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-2ad93ef447289da27892707efa683c1ae7ced85f";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/2ad93ef447289da27892707efa683c1ae7ced85f";
          sha256 = "0mc72zzqd3yrksdm1qj9xic5nxncds6r7wjx0bkyd4dagpqi113g";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-f9cc1f52b5a463062251d666761178dbdb6b544f";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/f9cc1f52b5a463062251d666761178dbdb6b544f";
          sha256 = "1gjx5c8y5kx57i1525pls1ay0rrxd3bh8504arrxjh7fcag0lvdf";
        };
      };
    };
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-866551da34e9a618e64a819ee1e01c20d8a588ba";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/866551da34e9a618e64a819ee1e01c20d8a588ba";
          sha256 = "1iam7m0yz09bk0qh59sqnibrfpr0sq9gw4zp41cpqfwq5i080hhd";
        };
      };
    };
    "carbonphp/carbon-doctrine-types" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "carbonphp-carbon-doctrine-types-18ba5ddfec8976260ead6e866180bd5d2f71aa1d";
        src = fetchurl {
          url = "https://api.github.com/repos/CarbonPHP/carbon-doctrine-types/zipball/18ba5ddfec8976260ead6e866180bd5d2f71aa1d";
          sha256 = "04vcxjgynvjaz3k1lws1a8cydxiw8blb4iz2xkawq8579rxdiq7v";
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
        name = "dompdf-dompdf-a51bd7a063a65499446919286fb18b518177155a";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/a51bd7a063a65499446919286fb18b518177155a";
          sha256 = "1b45fla6finix51vzmrml19ncwfl07bi3rq43krl73jcrx8h83nn";
        };
      };
    };
    "dompdf/php-font-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-php-font-lib-6137b7d4232b7f16c882c75e4ca3991dbcf6fe2d";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-font-lib/zipball/6137b7d4232b7f16c882c75e4ca3991dbcf6fe2d";
          sha256 = "0ss6xw6kvlpkv7vz1v17a71hp1mrja41qlm1qiwm2k0p3zgvwabk";
        };
      };
    };
    "dompdf/php-svg-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-php-svg-lib-eb045e518185298eb6ff8d80d0d0c6b17aecd9af";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/eb045e518185298eb6ff8d80d0d0c6b17aecd9af";
          sha256 = "1n9ykcs226fnzhk45afyjpn50pqmz5w3gw5zx5iyv0lsdpdhdilc";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-8c784d071debd117328803d86b2097615b457500";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/8c784d071debd117328803d86b2097615b457500";
          sha256 = "1zamydhfqww233055i7199jqpn6cjxm00r5mfa6mix3fnbbff7n1";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-b115554301161fa21467629f1e1391c1936de517";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/b115554301161fa21467629f1e1391c1936de517";
          sha256 = "0qnd4pc6hk47vr8vilafw4cpzxjgfjyipaml6vp6mdr8zmjnk1d1";
        };
      };
    };
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-8f718f4dfc9c5d5f0c994cdfd103921b43592712";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/8f718f4dfc9c5d5f0c994cdfd103921b43592712";
          sha256 = "0ylh24xfn32sjmwxpgm52s2byzdz9azqhf7ig66w2n44sg0wwrfg";
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
        name = "guzzlehttp-promises-f9c436286ab2892c7db7be8c8da4ef61ccf7b455";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/f9c436286ab2892c7db7be8c8da4ef61ccf7b455";
          sha256 = "0xp8slhb6kw9n7i5y6cpbgkc0nkk4gb1lw452kz4fszhk3r1wmgh";
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
        name = "guzzlehttp-uri-template-30e286560c137526eccd4ce21b2de477ab0676d2";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/uri-template/zipball/30e286560c137526eccd4ce21b2de477ab0676d2";
          sha256 = "0270l6ab9i7m991xm4l9ygclws4z1gcf2d3j83ydywlkxppixwj5";
        };
      };
    };
    "intervention/gif" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-gif-6addac2c68b4bc0e37d0d3ccedda57eb84729c49";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/gif/zipball/6addac2c68b4bc0e37d0d3ccedda57eb84729c49";
          sha256 = "126z8dpxqwq3ipkyzfa79yshyxip0m2vgj3pcmnk4snyyic5d7f1";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-ebbb711871fb261c064cf4c422f5f3c124fe1842";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/ebbb711871fb261c064cf4c422f5f3c124fe1842";
          sha256 = "13vd4g2vbi6nfff6w9ah70bf8sn2scsdqasa89xkyq1ihcfyr4jl";
        };
      };
    };
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "knplabs-knp-snappy-3dd138e9e47de91cd2e056c5e6e1a0dd72547ee7";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/3dd138e9e47de91cd2e056c5e6e1a0dd72547ee7";
          sha256 = "0r2a5j5jr10q046vgvcx7nlpb3znwm6z94w1kr4nvrinwvpdyc6h";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-f85216c82cbd38b66d67ebd20ea762cb3751a4b4";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/f85216c82cbd38b66d67ebd20ea762cb3751a4b4";
          sha256 = "1kh7hwpkmk3widpzd1ycrs85hrhvmsmk8ar18w7mc40x4a61301m";
        };
      };
    };
    "laravel/prompts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-prompts-57b8f7efe40333cdb925700891c7d7465325d3b1";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/prompts/zipball/57b8f7efe40333cdb925700891c7d7465325d3b1";
          sha256 = "0nab0qqwkqznyfh856kwgakiwgvp9kjdx3k6s0yq076fa3mjix7q";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-f379c13663245f7aa4512a7869f62eb14095f23f";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/f379c13663245f7aa4512a7869f62eb14095f23f";
          sha256 = "0k1krsgjnd815z0i7wi4j66c1j2809ah075a9zh6s31c0g34wz2b";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-7809dc71250e074cd42970f0f803f2cddc04c5de";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/7809dc71250e074cd42970f0f803f2cddc04c5de";
          sha256 = "0bb8865a6vn2xli391dc559m7r6ld4d7gnnnrrwv438rxrj9ck6f";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-22177cc71807d38f2810c6204d8f7183d88a57d3";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/22177cc71807d38f2810c6204d8f7183d88a57d3";
          sha256 = "0k3ar3dy5l1wv9djhy6rz97p22ncciz7gmr0vb87zanisihra12l";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-d990688c91cedfb69753ffc2512727ec646df2ad";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/d990688c91cedfb69753ffc2512727ec646df2ad";
          sha256 = "139lmk7kr0kapsx3hj3wypmfkrnlwf8k1c9x34k5aqi8hwk1xzyf";
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
        name = "league-flysystem-edc1bb7c86fab0776c3287dbd19b5fa278347319";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/edc1bb7c86fab0776c3287dbd19b5fa278347319";
          sha256 = "04pimnf6r8ji528miz1cvzd7wqg3i79nlgrlnk1g9sl58c3aac99";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-c6ff6d4606e48249b63f269eba7fabdb584e76a9";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/c6ff6d4606e48249b63f269eba7fabdb584e76a9";
          sha256 = "1xafv6yal257zjs78v08axhx0vh8mwp2c755qcc663aqqxf0f191";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-e0e8d52ce4b2ed154148453d321e97c8e931bd27";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/e0e8d52ce4b2ed154148453d321e97c8e931bd27";
          sha256 = "1znrjl38qagn78rjnsrlqmwghff6dfdqk9wy5r0bhrf6yjfs7j3z";
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
        name = "league-mime-type-detection-2d6702ff215bf922936ccc1ad31007edc76451b9";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/2d6702ff215bf922936ccc1ad31007edc76451b9";
          sha256 = "0i1gkmflcb17f2bi39xgfgxkjw0wb3qzlag7zjdwqfrg991xda0v";
        };
      };
    };
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-f9c94b088837eb1aae1ad7c4f23eb65cc6993055";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth1-client/zipball/f9c94b088837eb1aae1ad7c4f23eb65cc6993055";
          sha256 = "02pn0sgfr9f3czx1vkn2r47zmpb4g5kq4kycnqdakkmdbh4wr4ym";
        };
      };
    };
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-9df2924ca644736c835fc60466a3a60390d334f9";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/9df2924ca644736c835fc60466a3a60390d334f9";
          sha256 = "1v94vm5p7qss13k5c7p7g8m8l159q2w7mys99qkzlmnh0zf7a6rd";
        };
      };
    };
    "league/uri" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-81fb5145d2644324614cc532b28efd0215bda430";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri/zipball/81fb5145d2644324614cc532b28efd0215bda430";
          sha256 = "0aszqkywpvclrqw2pdm3chjjidv8k73arcqjdhv078n0yzrlq5ar";
        };
      };
    };
    "league/uri-interfaces" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-interfaces-08cfc6c4f3d811584fb09c37e2849e6a7f9b0742";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri-interfaces/zipball/08cfc6c4f3d811584fb09c37e2849e6a7f9b0742";
          sha256 = "18fhgrfl3vfnl64pqj4ak2gqg3hzn1vfpsfdaxzppjdyqrvpmr2g";
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
        name = "monolog-monolog-aef6ee73a77a66e404dd6540934a9ef1b3c855b4";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/aef6ee73a77a66e404dd6540934a9ef1b3c855b4";
          sha256 = "1p926il809sfz64g07x7nfa7a9z5llpvyaxc2gah5shmfg8dza3d";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-a2a865e05d5f420b50cc2f85bb78d565db12a6bc";
        src = fetchurl {
          url = "https://api.github.com/repos/jmespath/jmespath.php/zipball/a2a865e05d5f420b50cc2f85bb78d565db12a6bc";
          sha256 = "0jrv7w57fb22lrmvr1llw82g2zghm55bar8mp7jnmx486fn6vlx1";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-ff2f20cf83bd4d503720632ce8a426dc747bf7fd";
        src = fetchurl {
          url = "https://api.github.com/repos/CarbonPHP/carbon/zipball/ff2f20cf83bd4d503720632ce8a426dc747bf7fd";
          sha256 = "16ihfi8r13lcl6xczc78zxrqkg4h72q9bf0nnfwcvjayivqbqxkq";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-da801d52f0354f70a638673c4a0f04e16529431d";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/da801d52f0354f70a638673c4a0f04e16529431d";
          sha256 = "0l9yc070yd90v4bzqrcnl4lc7vsk35d96fs1r8qsy4v8gnwmmfxy";
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
        name = "nikic-php-parser-447a020a1f875a434d62f2a401f53b82a396e494";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/447a020a1f875a434d62f2a401f53b82a396e494";
          sha256 = "036m3siss8wsmqdwnvkhpfl7ayj44sw5nz5jhsdj1zzl96w4f7xa";
        };
      };
    };
    "nunomaduro/termwind" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-termwind-52915afe6a1044e8b9cee1bcff836fb63acf9cda";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/termwind/zipball/52915afe6a1044e8b9cee1bcff836fb63acf9cda";
          sha256 = "0bb0c47kckpv2wla8wpp9wqf2zf3ifi0amcrs3kmcfxpcp5ckbkr";
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
        name = "paragonie-constant_time_encoding-df1e7fde177501eee2037dd159cf04f5f301a512";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/df1e7fde177501eee2037dd159cf04f5f301a512";
          sha256 = "1kmhg6nfl71p4incb64md9q0s9lnpbl65z8442kqlgyhhfzi00v2";
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
        name = "phpseclib-phpseclib-709ec107af3cb2f385b9617be72af8cf62441d02";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/709ec107af3cb2f385b9617be72af8cf62441d02";
          sha256 = "0r1cm74vvq25q6nlm3j3p26053r5phki5x8b9dczjgr8dxhf9ja1";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-6f8d87ebd5afbf7790bde1ffc7579c7c705e0fad";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa/zipball/6f8d87ebd5afbf7790bde1ffc7579c7c705e0fad";
          sha256 = "0dknaaz6rlnyvisqbydx9mvy3fgp8pjavk4ms8qyq6dil4z1z13l";
        };
      };
    };
    "predis/predis" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "predis-predis-bac46bfdb78cd6e9c7926c697012aae740cb9ec9";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/bac46bfdb78cd6e9c7926c697012aae740cb9ec9";
          sha256 = "1gq4drppphcxdmcgxnx4l63qnlksns0xs9amnz9dr728vs89y9k6";
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
        name = "psr-log-f16e1d5863e37f8d8c2a01719f5b34baa2b714d3";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/f16e1d5863e37f8d8c2a01719f5b34baa2b714d3";
          sha256 = "14h8r5qwjvlj7mjwk6ksbhffbv4k9v5cailin9039z1kz4nwz38y";
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
        name = "psy-psysh-85057ceedee50c49d4f6ecaff73ee96adb3b3625";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/85057ceedee50c49d4f6ecaff73ee96adb3b3625";
          sha256 = "0lsikym2r6jw113f8m8sr5y4687flly8303n3wan52np3aq997xa";
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
        name = "ramsey-collection-3c5990b8a5e0b79cd1cf11c2dc1229e58e93f109";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/3c5990b8a5e0b79cd1cf11c2dc1229e58e93f109";
          sha256 = "0bi856m2qqfzwkvdch0l7pma4fdr7xcx5cdgc5lyww8010wzpb4p";
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
        name = "robrichards-xmlseclibs-2bdfd742624d739dfadbd415f00181b4a77aaf07";
        src = fetchurl {
          url = "https://api.github.com/repos/robrichards/xmlseclibs/zipball/2bdfd742624d739dfadbd415f00181b4a77aaf07";
          sha256 = "0i7kah5qym1nqzvhlyzr4x519cnm2wshgc4x95zis6nci2abc4nb";
        };
      };
    };
    "sabberworm/php-css-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sabberworm-php-css-parser-f414ff953002a9b18e3a116f5e462c56f21237cf";
        src = fetchurl {
          url = "https://api.github.com/repos/MyIntervals/PHP-CSS-Parser/zipball/f414ff953002a9b18e3a116f5e462c56f21237cf";
          sha256 = "0g1swfbvqafhzw6kdfc3dgn3n0bv1mcjy0q4xnb9j31j03j6nhni";
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
        name = "socialiteproviders-manager-8180ec14bef230ec2351cff993d5d2d7ca470ef4";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/8180ec14bef230ec2351cff993d5d2d7ca470ef4";
          sha256 = "1f78m0rw30xsxgqnmjxcms1q726y94fzpy6c201qqf3mmiklsf97";
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
        name = "ssddanbrown-htmldiff";
        src = fetchurl {
          url = "https://codeberg.org/api/v1/repos/danb/HtmlDiff/archive/main.zip";
          sha256 = "00d7qpaba9hp7j457flxzk4v61kkdhpj1yr848x8ds1vfbpqwwpn";
        };
      };
    };
    "ssddanbrown/symfony-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-symfony-mailer-e9de8dccd76a63fc23475016e6574da6f5f12a2d";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/symfony-mailer/zipball/e9de8dccd76a63fc23475016e6574da6f5f12a2d";
          sha256 = "0y0pw5lsqz1i8z191gkcl3k22a59gyapf9315d92ymqxsdd6dnrb";
        };
      };
    };
    "symfony/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-clock-b81435fbd6648ea425d1ee96a2d8e68f4ceacd24";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/clock/zipball/b81435fbd6648ea425d1ee96a2d8e68f4ceacd24";
          sha256 = "137ywgyj5n24aprq7z2wkhmzcrqm96awszypikr5m3kgbvjiafg4";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-fefcc18c0f5d0efe3ab3152f15857298868dc2c3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/fefcc18c0f5d0efe3ab3152f15857298868dc2c3";
          sha256 = "017hwcrl6gyf5gpqhz3xzdq0farcfwcb4hswpbh9s6bkgdq2rqka";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-601a5ce9aaad7bf10797e3663faefce9e26c24e2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/601a5ce9aaad7bf10797e3663faefce9e26c24e2";
          sha256 = "1wynlxnm2d65kbv68j0gq2158ybjq1bcka93szhflg16y8dixknw";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-74c71c939a79f7d5bf3c1ce9f5ea37ba0114c6f6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/74c71c939a79f7d5bf3c1ce9f5ea37ba0114c6f6";
          sha256 = "0jr67zcxmgq26xi9lrw3pg33fvchf27qg3liicm3r1k36hg4ymwf";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-aabf79938aa795350c07ce6464dd1985607d95d5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/aabf79938aa795350c07ce6464dd1985607d95d5";
          sha256 = "19mfy9w66hbjfg4wnxdzv22d58wm1ggxyqv12viijx17xr4j4cbq";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-910c5db85a5356d0fea57680defec4e99eb9c8c1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/910c5db85a5356d0fea57680defec4e99eb9c8c1";
          sha256 = "1dwigkvzawr9i0wkfgfk4am00nb9fcblrks3s1vpqp67v4yi32xr";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-7642f5e970b672283b7823222ae8ef8bbc160b9f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/7642f5e970b672283b7823222ae8ef8bbc160b9f";
          sha256 = "0d6d95w7dix7l8wyz66ki9781z3k8hsz1c7aglszlc1fn2v9kb93";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-87a71856f2f56e4100373e92529eed3171695cfb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/87a71856f2f56e4100373e92529eed3171695cfb";
          sha256 = "1skvr0z0l3qmwq9a3950fvpcrhnl7cvhpnpbz4brxlyq3czdkr2w";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-ee1b504b8926198be89d05e5b6fc4c3810c090f0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/ee1b504b8926198be89d05e5b6fc4c3810c090f0";
          sha256 = "0jw9jmf6zdpn0l92l2nczrq7x3dqnrh0l0qj99icd7gbfnmfajn4";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-9f1103734c5789798fefb90e91de4586039003ed";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/9f1103734c5789798fefb90e91de4586039003ed";
          sha256 = "13aszf8j7zbzdssj2z0nq0nk2jja2lr7mzz9bin92q2vm6fkfr34";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-87ca22046b78c3feaff04b337f33b38510fd686b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/87ca22046b78c3feaff04b337f33b38510fd686b";
          sha256 = "1yps4chr6fa9l01mssllijgla7ha1f9aiw8nhwfbk43fa8471cy0";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-a3cc8b044a6ea513310cbd48ef7333b384945638";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/a3cc8b044a6ea513310cbd48ef7333b384945638";
          sha256 = "1gwalz2r31bfqldkqhw8cbxybmc1pkg74kvg07binkhk531gjqdn";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/b9123926e3b7bc2f98c02ad54f6a4b02b91a8abe";
          sha256 = "06kbz2rqp0kyxpry055pciv02ihl7vgygigqhdqqy6q7aphg9i9a";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-c36586dcf89a12315939e00ec9b4474adcb1d773";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/c36586dcf89a12315939e00ec9b4474adcb1d773";
          sha256 = "1abzqpkq647mh6z5xbf81v50q9s6llaag9sk8y0mf3n0lm47nx4w";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-3833d7255cc303546435cb650316bff708a1c75c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/3833d7255cc303546435cb650316bff708a1c75c";
          sha256 = "0qrq26nw97xfcl0p8x4ria46lk47k73vjjyqiklpw8w5cbibsfxj";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-85181ba99b2345b0ef10ce42ecac37612d9fd341";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/85181ba99b2345b0ef10ce42ecac37612d9fd341";
          sha256 = "07ir4drsx4ddmbps6igm6wyrzx2ksz3d61rs2m7p27qz7kx17ff1";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-60328e362d4c2c802a54fcbf04f9d3fb892b4cf8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/60328e362d4c2c802a54fcbf04f9d3fb892b4cf8";
          sha256 = "008nx5xplqx3iks3fpzd4qgy3zzrvx1bmsdc13ndf562a6hf9lrg";
        };
      };
    };
    "symfony/polyfill-php83" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php83-2fb86d65e2d424369ad2905e83b236a8805ba491";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php83/zipball/2fb86d65e2d424369ad2905e83b236a8805ba491";
          sha256 = "1agcx7ydr1ljimacxbgpspcx7kssclwm0bj4zcdq6fhdwrkzxa15";
        };
      };
    };
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-21533be36c24be3f4b1669c4725c7d1d2bab4ae2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/21533be36c24be3f4b1669c4725c7d1d2bab4ae2";
          sha256 = "0v8x07llqn7hac6qzm92ly6839ib63v05630rzr71f5ds69j1m09";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-d8f411ff3c7ddc4ae9166fb388d1190a2df5b5cf";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/d8f411ff3c7ddc4ae9166fb388d1190a2df5b5cf";
          sha256 = "0mvrxdkwxfyn2s8nid0n9fmbxkryp28s7nki7i846ladfyg7hvjp";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-ee9a67edc6baa33e5fae662f94f91fd262930996";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/ee9a67edc6baa33e5fae662f94f91fd262930996";
          sha256 = "023xx4wg5dyyglgnqc5ahijkk1iiglj6qn4d3p5mw1gpyng5d00w";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-e53260aabf78fb3d63f8d79d69ece59f80d5eda0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/e53260aabf78fb3d63f8d79d69ece59f80d5eda0";
          sha256 = "0qvk3ajc1jgw97ibr3jmxh7wxmxrvra5471ashhbd56gaiim7iq4";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-446e0d146f991dde3e73f45f2c97a9faad773c82";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/446e0d146f991dde3e73f45f2c97a9faad773c82";
          sha256 = "0ad2xspi7yp2631nhzfqvb8lnq71vmhwxm6lhms8zj3p9z7vgvsg";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-283856e6981286cc0d800b53bd5703e8e363f05a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/283856e6981286cc0d800b53bd5703e8e363f05a";
          sha256 = "0iy4dr1pcvmad1kkk42y6p5smiphkqgxhsr5zf3cmdw9np9mrya5";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-4667ff3bd513750603a09c8dedbea942487fb07c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/4667ff3bd513750603a09c8dedbea942487fb07c";
          sha256 = "1hkjg2anfkc56c4k31r2q857pm2w0r57zsn5hfrg7zv47slhb55n";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-2d294d0c48df244c71c105a169d0190bfb080426";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/2d294d0c48df244c71c105a169d0190bfb080426";
          sha256 = "16qzg9mzpp7cs56a01i0gskyhjp4f609hjscv6vsnr8xfkjpq4mq";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-82b478c69745d8878eb60f9a049a4d584996f73a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/82b478c69745d8878eb60f9a049a4d584996f73a";
          sha256 = "0zn72hiq2q3smyx4b192kzfvd3nb0ibsksf5hxc9wvnb9a2kjyjn";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-0d72ac1c00084279c1816675284073c5a337c20d";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/0d72ac1c00084279c1816675284073c5a337c20d";
          sha256 = "0m1yxpxxk5zdvj6rrqrzmivh6f6c9cpsm00a75ac1divg8bihmzx";
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
        name = "voku-portable-ascii-b1d923f88091c6bf09699efcd7c8a1b1bfd7351d";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/b1d923f88091c6bf09699efcd7c8a1b1bfd7351d";
          sha256 = "1x5wls3q4m7sa0jly8f7s29sd4kb2p59imdr6i5ajzyn5b947aac";
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
