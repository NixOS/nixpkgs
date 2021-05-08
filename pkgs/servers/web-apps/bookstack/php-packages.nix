{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-0aa83b522d5ffa794c02e7411af87a0e241a3082";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/0aa83b522d5ffa794c02e7411af87a0e241a3082;
          sha256 = "03qahdj01bz76aar21limham7xnv5r0d61gfk1fph8ljf2gbg33i";
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
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-13e3381b25847283a91948d04640543941309727";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/cache/zipball/13e3381b25847283a91948d04640543941309727;
          sha256 = "088fxbpjssp8x95qr3ip2iynxrimimrby03xlsvp2254vcyx94c5";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-c800380457948e65bbd30ba92cc17cda108bf8c9";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/c800380457948e65bbd30ba92cc17cda108bf8c9;
          sha256 = "1x6bij89yaj0d52ffx683rlpxrgxl0vx9q6a121mkz1zplnif647";
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
        name = "facade-flare-client-php-6bf380035890cb0a09b9628c491ae3866b858522";
        src = fetchurl {
          url = https://api.github.com/repos/facade/flare-client-php/zipball/6bf380035890cb0a09b9628c491ae3866b858522;
          sha256 = "1y0rjlpd71jkl0zzl3q4flv5s9gbk87947xgfi8w62sg5g7jjgl2";
        };
      };
    };
    "facade/ignition" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-b6aea4a99303d9d32afd486a285162a89af8a8a3";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition/zipball/b6aea4a99303d9d32afd486a285162a89af8a8a3;
          sha256 = "1dx6gf4qz6jf8hds3lyxs09zlr6ndl3d36212w2hr4b15ihmyszw";
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
        name = "filp-whoops-d501fd2658d55491a2295ff600ae5978eaad7403";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/d501fd2658d55491a2295ff600ae5978eaad7403;
          sha256 = "1mpgkl7yzw9j4pxkw404fvykapr42347lyz7jgrl1ks61pk6s9v5";
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
        name = "guzzlehttp-psr7-35ea11d335fd638b5882ff1725228b3d35496ab1";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/35ea11d335fd638b5882ff1725228b3d35496ab1;
          sha256 = "1nsd7sla2jpx9kzg0lzk4kvc66d30bnkf2yfzdp7gghb67wvajfa";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-abbf18d5ab8367f96b3205ca3c89fb2fa598c69e";
        src = fetchurl {
          url = https://api.github.com/repos/Intervention/image/zipball/abbf18d5ab8367f96b3205ca3c89fb2fa598c69e;
          sha256 = "1msfpr9bip69bmhg23ka2f43phgb6dq5z604j5psjh3xd86r6c5d";
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
        name = "laravel-framework-d94c07d72c14f07e7d2027458e7f0a76f9ceb0d9";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/d94c07d72c14f07e7d2027458e7f0a76f9ceb0d9;
          sha256 = "02cml6rg3qxnr8gynnd8iqwdyzflqwnyivxw034dzbm60xpg6w93";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-1960802068f81e44b2ae9793932181cf1cb91b5c";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/socialite/zipball/1960802068f81e44b2ae9793932181cf1cb91b5c;
          sha256 = "1v68icdk7x1qbnhzsvpzv4nj0hwdw70s75g2bzbvmli6ah0kvvck";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-08fa59b8e4e34ea8a773d55139ae9ac0e0aecbaf";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/commonmark/zipball/08fa59b8e4e34ea8a773d55139ae9ac0e0aecbaf;
          sha256 = "10bs8r0qiq9bybypnascvk7a7181699cnwl27yq4m108cj1i223h";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-9be3b16c877d477357c015cec057548cf9b2a14a";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/9be3b16c877d477357c015cec057548cf9b2a14a;
          sha256 = "0mhlr6l75j58xwbadq30x58s67434195zlpdax6ix4nkr7fc907j";
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
        name = "league-oauth1-client-1e7e6be2dc543bf466236fb171e5b20e1b06aee6";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth1-client/zipball/1e7e6be2dc543bf466236fb171e5b20e1b06aee6;
          sha256 = "1vmzvghl4c4k9vxza50k0w28hxm88vcrcdspqp7f3vmfg5c1zav2";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-1cb1cde8e8dd0f70cc0fe51354a59acad9302084";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/1cb1cde8e8dd0f70cc0fe51354a59acad9302084;
          sha256 = "1gymdiymwrjw25fjqapq3jlmf6wnp1h26ms74sckd70d53c4m52k";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-42dae2cbd13154083ca6d70099692fef8ca84bfb";
        src = fetchurl {
          url = https://api.github.com/repos/jmespath/jmespath.php/zipball/42dae2cbd13154083ca6d70099692fef8ca84bfb;
          sha256 = "157pdx45dmkxwxyq8vdjfci24fw7kl3yc2gj1cifp9kaia7mwlkk";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-2fd2c4a77d58a4e95234c8a61c5df1f157a91bf4";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/2fd2c4a77d58a4e95234c8a61c5df1f157a91bf4;
          sha256 = "0riizvfqxvvbkhhfadcqr8717s0q12p00qmffv26664h5kckl58r";
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
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-84b4dfb120c6f9b4ff7b3685f9b8f1aa365a0c95";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/random_compat/zipball/84b4dfb120c6f9b4ff7b3685f9b8f1aa365a0c95;
          sha256 = "03nsccdvcb79l64b7lsmx0n8ldf5z3v8niqr7bpp6wg401qp9p09";
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
        name = "phpoption-phpoption-994ecccd8f3283ecf5ac33254543eb0ac946d525";
        src = fetchurl {
          url = https://api.github.com/repos/schmittjoh/php-option/zipball/994ecccd8f3283ecf5ac33254543eb0ac946d525;
          sha256 = "1snrnfvqhnr5z9llf8kbqk9l97gfyp8gghmhi1ng8qx5xzv1anr7";
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
        name = "psr-log-0f73288fd15629204f9d42b7055f72dacbe811fc";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/0f73288fd15629204f9d42b7055f72dacbe811fc;
          sha256 = "1npi9ggl4qll4sdxz1xgp8779ia73gwlpjxbb1f1cpl1wn4s42r4";
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
        name = "ramsey-uuid-7e1633a6964b48589b142d60542f9ed31bd37a92";
        src = fetchurl {
          url = https://api.github.com/repos/ramsey/uuid/zipball/7e1633a6964b48589b142d60542f9ed31bd37a92;
          sha256 = "0s6z2c8jvwjmxzy2kqmxqpz0val9i5r757mdwf2yc7qrwm6bwd15";
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
        name = "scrivo-highlight.php-44a3d4136edb5ad8551590bf90f437db80b2d466";
        src = fetchurl {
          url = https://api.github.com/repos/scrivo/highlight.php/zipball/44a3d4136edb5ad8551590bf90f437db80b2d466;
          sha256 = "0p0bj3yqiaa917lgx4ycwic2qqlg3cxka2adhziqzhlq9jqhzi8r";
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
        name = "socialiteproviders-microsoft-azure-7808764f777a01df88be9ca6b14d683e50aaf88a";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/7808764f777a01df88be9ca6b14d683e50aaf88a;
          sha256 = "1lxsvb5pzqrm467a8737v98sgmsxs6mvxc683p19b2y30g4fyrlj";
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
        name = "symfony-console-1ba4560dbbb9fcf5ae28b61f71f49c678086cf23";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/1ba4560dbbb9fcf5ae28b61f71f49c678086cf23;
          sha256 = "1zsmv0p0xxdp44301yd3n1w9j79g631bvvfp04zniqk4h5q6kvg9";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-f907d3e53ecb2a5fad8609eb2f30525287a734c8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/f907d3e53ecb2a5fad8609eb2f30525287a734c8;
          sha256 = "19yqy81psz2wh8gy2j3phywsgrw9sbcw83l8lbnxbk5khg8hw3nm";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-157bbec4fd773bae53c5483c50951a5530a2cc16";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/157bbec4fd773bae53c5483c50951a5530a2cc16;
          sha256 = "0v7l7081fw2wr96xv472nhi1d0xzw6lnl8hnjgi9g3gnksfagwq8";
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
        name = "symfony-error-handler-48e81a375525872e788c2418430f54150d935810";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/48e81a375525872e788c2418430f54150d935810;
          sha256 = "17hpwx8arv3h4cw4fwzkm7a39lsa92vwxsinyqmx723v1nr5z1d2";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-c352647244bd376bf7d31efbd5401f13f50dad0c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/c352647244bd376bf7d31efbd5401f13f50dad0c;
          sha256 = "1cxgn0y83i4qqx757kq96jadwwbc68h11snhvy175xvy8nvsmxkd";
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
        name = "symfony-finder-2543795ab1570df588b9bbd31e1a2bd7037b94f6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/2543795ab1570df588b9bbd31e1a2bd7037b94f6;
          sha256 = "0scclnfc9aphjsric1xaj51vbqqz56kiz6l8l6ldqv6cvyg8zlyi";
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
        name = "symfony-http-foundation-02d968647fe61b2f419a8dc70c468a9d30a48d3a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/02d968647fe61b2f419a8dc70c468a9d30a48d3a;
          sha256 = "1bq4why2v8p7wy8801bdml43xh7kb5fli16cv74bvqpwlp4cdv9f";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-0248214120d00c5f44f1cd5d9ad65f0b38459333";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/0248214120d00c5f44f1cd5d9ad65f0b38459333;
          sha256 = "032ljl732x0bs3my26wjfmxrxplz8vlxs0xzlqsxrh18lnyv6z3h";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-1b2092244374cbe48ae733673f2ca0818b37197b";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/1b2092244374cbe48ae733673f2ca0818b37197b;
          sha256 = "0d2vhmd25d7yvh9xzl2vazx2bfsb8qyvd2kgvl9cry1va4vrpkj3";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-c6c942b1ac76c82448322025e084cadc56048b4e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/c6c942b1ac76c82448322025e084cadc56048b4e;
          sha256 = "0jpk859wx74vm03q5s9z25f4ak2138p2x5q3b587wvy8rq2m4pbd";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-06fb361659649bcfd6a208a0f1fcaf4e827ad342";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/06fb361659649bcfd6a208a0f1fcaf4e827ad342;
          sha256 = "0glb56w5q4v2j629rkndp2c7v4mcs6xdl14nwaaxy85lr5w4ixnq";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-2d63434d922daf7da8dd863e7907e67ee3031483";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/2d63434d922daf7da8dd863e7907e67ee3031483;
          sha256 = "0sk592qrdb6dvk6v8msjva8p672qmhmnzkw1lw53gks0xrc20xjy";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-43a0283138253ed1d48d352ab6d0bdb3f809f248";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/43a0283138253ed1d48d352ab6d0bdb3f809f248;
          sha256 = "04irkl6aks8zyfy17ni164060liihfyraqm1fmpjbs5hq0b14sc9";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-5232de97ee3b75b0360528dae24e73db49566ab1";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/5232de97ee3b75b0360528dae24e73db49566ab1;
          sha256 = "1mm670fxj2x72a9mbkyzs3yifpp6glravq2ss438bags1xf6psz8";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-cc6e6f9b39fe8075b3dabfbaf5b5f645ae1340c9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php72/zipball/cc6e6f9b39fe8075b3dabfbaf5b5f645ae1340c9;
          sha256 = "12dmz2n1b9pqqd758ja0c8h8h5dxdai5ik74iwvaxc5xn86a026b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-a678b42e92f86eca04b7fa4c0f6f19d097fb69e2";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/a678b42e92f86eca04b7fa4c0f6f19d097fb69e2;
          sha256 = "10rq2x2q9hsdzskrz0aml5qcji27ypxam324044fi24nl60fyzg0";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-dc3063ba22c2a1fd2f45ed856374d79114998f91";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/dc3063ba22c2a1fd2f45ed856374d79114998f91;
          sha256 = "1mhfjibk7mqyzlqpz6jjpxpd93fnfw0nik140x3mq1d2blg5cbvd";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-7e950b6366d4da90292c2e7fa820b3c1842b965a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/7e950b6366d4da90292c2e7fa820b3c1842b965a;
          sha256 = "07ykgz5bjd45izf5n6jm2n27wcaa7aih2wlsiln1ffj9vqd6l1s4";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-69919991c845b34626664ddc9b3aef9d09d2a5df";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/69919991c845b34626664ddc9b3aef9d09d2a5df;
          sha256 = "0ghynrw6d9dpskhgyf3ljlz4pfmi68r3bzhr45lygadx21yacddw";
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
        name = "symfony-translation-eb8f5428cc3b40d6dffe303b195b084f1c5fbd14";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/eb8f5428cc3b40d6dffe303b195b084f1c5fbd14;
          sha256 = "0x80ijdhpfv9is847pp09jlr0g0hwg9sil95jknil7dgx5pjsa5z";
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
        name = "symfony-var-dumper-0da0e174f728996f5d5072d6a9f0a42259dbc806";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/0da0e174f728996f5d5072d6a9f0a42259dbc806;
          sha256 = "1qmv99bvq10siy8bbszqmn488cjcm70vip4xs8vxwm6x6x5cw1ia";
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
