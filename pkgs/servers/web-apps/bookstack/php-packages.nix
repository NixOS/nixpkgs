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
        name = "aws-aws-sdk-php-0f8b3f63ba7b296afedcb3e6a43ce140831b9400";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/0f8b3f63ba7b296afedcb3e6a43ce140831b9400";
          sha256 = "1fccvd3mp1q180980y2ri0iy55mrzcv3yc1kiwiz4dm2lswzi2n8";
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
        name = "doctrine-dbal-61446f07fcb522414d6cfd8b1c3e5f9e18c579ba";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/61446f07fcb522414d6cfd8b1c3e5f9e18c579ba";
          sha256 = "0sxl6xf9svrz4pda9x3zpygfqr6m0x96yixjim6mqi8mx4xxayv9";
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
        name = "dompdf-dompdf-fbc7c5ee5d94f7a910b78b43feb7931b7f971b59";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/fbc7c5ee5d94f7a910b78b43feb7931b7f971b59";
          sha256 = "0pm5nkk44z5walc494g907w6s0n8njq62bbr2sr5akcdic4wwshs";
        };
      };
    };
    "dompdf/php-font-lib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-php-font-lib-991d6a954f6bbd7e41022198f00586b230731441";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-font-lib/zipball/991d6a954f6bbd7e41022198f00586b230731441";
          sha256 = "03k37d1dswzgmsjzzmhyavvbs46jara7v976cxmbs89by48kngmj";
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
        name = "firebase-php-jwt-30c19ed0f3264cb660ea496895cfb6ef7ee3653b";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/30c19ed0f3264cb660ea496895cfb6ef7ee3653b";
          sha256 = "1hyf7g7i1bwv5yd53dg3g6c5f4r8cniynys4y4dwqavl5v92lgkn";
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
        name = "intervention-gif-42c131a31b93c440ad49061b599fa218f06f93be";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/gif/zipball/42c131a31b93c440ad49061b599fa218f06f93be";
          sha256 = "00144rc5wig0d594m2xvpwr2nd28z2xr4s7rcgcqg0iyf6d4xnwy";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-b496d1f6b9f812f96166623358dfcafb8c3b1683";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/b496d1f6b9f812f96166623358dfcafb8c3b1683";
          sha256 = "0mkcwbkp6g36irngcdaf13zs2ddhkjjy19szd45xvnrgi815szak";
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
        name = "laravel-framework-f132b23b13909cc22c615c01b0c5640541c3da0c";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/f132b23b13909cc22c615c01b0c5640541c3da0c";
          sha256 = "1jcj7cy0hhnx1h69c5sbj193sd43azgjcg89vmzn271z20nbq2bp";
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
        name = "laravel-serializable-closure-4f48ade902b94323ca3be7646db16209ec76be3d";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/4f48ade902b94323ca3be7646db16209ec76be3d";
          sha256 = "0bky5s0lhi52d50jvns0844v9fcjlrf95df4mxrz17rkffix3h5w";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-40a2dc98c53d9dc6d55eadb0d490d3d72b73f1bf";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/40a2dc98c53d9dc6d55eadb0d490d3d72b73f1bf";
          sha256 = "0bdc7z06yn7n17bhagp3b0a0q5639yy9766vzbd0sxjllnyviq4l";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-ba4d51eb56de7711b3a37d63aa0643e99a339ae5";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/ba4d51eb56de7711b3a37d63aa0643e99a339ae5";
          sha256 = "1zwfb4qcy254fbfzv0y6vijmr5309qi419mppmzd3x68bhwbqqhx";
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
        name = "monolog-monolog-32e515fdc02cdafbe4593e30a9350d486b125b67";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/32e515fdc02cdafbe4593e30a9350d486b125b67";
          sha256 = "0bj9mzh8a08y672fbwmmgxp8ma1n2cjcs37bjv2wy9pcnr28562p";
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
        name = "nikic-php-parser-8eea230464783aa9671db8eea6f8c6ac5285794b";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/8eea230464783aa9671db8eea6f8c6ac5285794b";
          sha256 = "1afglrsixmhjb4s5zpvw1y1mayjii6fbb22cfb6c96i84d3sjlc6";
        };
      };
    };
    "nunomaduro/termwind" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-termwind-5369ef84d8142c1d87e4ec278711d4ece3cbf301";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/termwind/zipball/5369ef84d8142c1d87e4ec278711d4ece3cbf301";
          sha256 = "18n79xd3pp3mim5dkhjlgp6xbsyfrvps6cfwkb2hykf5gbk0n0lh";
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
        name = "phpseclib-phpseclib-db92f1b1987b12b13f248fe76c3a52cadb67bb98";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/db92f1b1987b12b13f248fe76c3a52cadb67bb98";
          sha256 = "0121b5ysn2wj9x5pibil2d0fqvy0b1wpywr7r7y5n2n5bnmq1p6i";
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
        name = "socialiteproviders-manager-ab0691b82cec77efd90154c78f1854903455c82f";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/ab0691b82cec77efd90154c78f1854903455c82f";
          sha256 = "016w17wjw35dbkpy3y032dp1ns43khybsxqfqgvdm5ipwrh2z6hx";
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
        name = "symfony-console-f1fc6f47283e27336e7cebb9e8946c8de7bff9bd";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/f1fc6f47283e27336e7cebb9e8946c8de7bff9bd";
          sha256 = "0c2j2w9fnah56rgpfjnn21n23gp46253qp6j8q5xdz1z70dy9ihg";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-cb23e97813c5837a041b73a6d63a9ddff0778f5e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/cb23e97813c5837a041b73a6d63a9ddff0778f5e";
          sha256 = "1xfvaydli47df151mvrdg34xx0jpvywiyyml5wrznb1hvds5z2gi";
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
        name = "symfony-error-handler-9e024324511eeb00983ee76b9aedc3e6ecd993d9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/9e024324511eeb00983ee76b9aedc3e6ecd993d9";
          sha256 = "18psyck3drgxqshs6r6kixcna3irp9sqf59b1ybd34f2fszp3nn6";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-0ffc48080ab3e9132ea74ef4e09d8dcf26bf897e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/0ffc48080ab3e9132ea74ef4e09d8dcf26bf897e";
          sha256 = "1gbdzsdhmncxpsdhy2l28lb1yjny1k6d7gz04c58bqpy9lwyc6pv";
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
        name = "symfony-finder-daea9eca0b08d0ed1dc9ab702a46128fd1be4958";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/daea9eca0b08d0ed1dc9ab702a46128fd1be4958";
          sha256 = "0sr3vk37p427i8sk4rbyhb8rjqbl51k77q55kasszk75bnmx3dpa";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-431771b7a6f662f1575b3cfc8fd7617aa9864d57";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/431771b7a6f662f1575b3cfc8fd7617aa9864d57";
          sha256 = "03v6aahc3s5wyz295g4iikixfy6jqys4j1k37ik6w1kax4igzy7q";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-8838b5b21d807923b893ccbfc2cbeda0f1bc00f0";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/8838b5b21d807923b893ccbfc2cbeda0f1bc00f0";
          sha256 = "1clb6wl1qnf8ilfcd6zkmdc5dq8r0lf0fhw6z57yxm09yp4gva9g";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-1de1cf14d99b12c7ebbb850491ec6ae3ed468855";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/1de1cf14d99b12c7ebbb850491ec6ae3ed468855";
          sha256 = "1khg1pznfybzwn2ci7dlyy72c34l7gh2xd2imi5dg78xr92f421w";
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
        name = "symfony-process-3cb242f059c14ae08591c5c4087d1fe443564392";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/3cb242f059c14ae08591c5c4087d1fe443564392";
          sha256 = "1dkif5bql8ngvr00x76c2v9x2d6kgddmniyv36m119c83r7ydk3f";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-91e02e606b4b705c2f4fb42f7e7708b7923a3220";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/91e02e606b4b705c2f4fb42f7e7708b7923a3220";
          sha256 = "0bgnl82j3g1qr7idr1xfh0wgc2civvy3hm1dqbk3ryd81mlkxrz7";
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
        name = "symfony-string-73a5e66ea2e1677c98d4449177c5a9cf9d8b4c6f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/73a5e66ea2e1677c98d4449177c5a9cf9d8b4c6f";
          sha256 = "1hnsdk4j9pj1h3nbyndbjl4yx1vczcpxsipf9b5llq70hx9bf12a";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-bee9bfabfa8b4045a66bf82520e492cddbaffa66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/bee9bfabfa8b4045a66bf82520e492cddbaffa66";
          sha256 = "0a2pxp58sy2f3198f3l60kxj74laswvwhldsbfpkbp1kjz47r31k";
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
        name = "symfony-uid-18eb207f0436a993fffbdd811b5b8fa35fa5e007";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/18eb207f0436a993fffbdd811b5b8fa35fa5e007";
          sha256 = "0ah9mjjlizxsb7jk1aky9ws2d7v6y9xlb9vwcqmdmidiwmnkzq51";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-38254d5a5ac2e61f2b52f9caf54e7aa3c9d36b80";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/38254d5a5ac2e61f2b52f9caf54e7aa3c9d36b80";
          sha256 = "0y55js8kqbafns1hkd03vgv7mzlyi540bb5kggi95b7v2mpy6c7j";
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
