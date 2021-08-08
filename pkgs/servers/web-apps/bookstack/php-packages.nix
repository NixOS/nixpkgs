{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-35310302912fdc3b4a0e829b84424c41e3fd9727";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/35310302912fdc3b4a0e829b84424c41e3fd9727;
          sha256 = "043ia45zlb3596cnh76yc7wvizr8acn5jrilnnqdv78v07s9c99i";
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
        name = "doctrine-cache-c9622c6820d3ede1e2315a6a377ea1076e421d88";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/cache/zipball/c9622c6820d3ede1e2315a6a377ea1076e421d88;
          sha256 = "0dw03i597mffza3bllsh89fqwa61zwhp0gvs8hh6qzkhwmsw9rk5";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-8dd39d2ead4409ce652fd4f02621060f009ea5e4";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/8dd39d2ead4409ce652fd4f02621060f009ea5e4;
          sha256 = "107k0qr3m34cjxy00yhdjmd8liqa8wg729zj4z2jifz26niiy8qs";
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
        name = "facade-flare-client-php-47b639dc02bcfdfc4ebb83de703856fa01e35f5f";
        src = fetchurl {
          url = https://api.github.com/repos/facade/flare-client-php/zipball/47b639dc02bcfdfc4ebb83de703856fa01e35f5f;
          sha256 = "1chpfxmnlpl98cg127i70ari7nb3w83l91l119hc2fhyjk0zrcy5";
        };
      };
    };
    "facade/ignition" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-dc49305538aeb77e4c89eba57cee4ceff9e42f33";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition/zipball/dc49305538aeb77e4c89eba57cee4ceff9e42f33;
          sha256 = "1nwqgxgp1dsrixf44qh4ywsvd0d35nqg23a8bc9mjvn9wmhdn2q0";
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
        name = "filp-whoops-2edbc73a4687d9085c8f20f398eebade844e8424";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/2edbc73a4687d9085c8f20f398eebade844e8424;
          sha256 = "1x79vnjdbjk9z2mix75ri56kyc5iwvjv3dyivncg6n3wd80nyfgg";
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
        name = "guzzlehttp-psr7-dc960a912984efb74d0a90222870c72c87f10c91";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/dc960a912984efb74d0a90222870c72c87f10c91;
          sha256 = "06nc60wf8k6kcl89kprk04khsrrik5lnis615mx4a0m0pjn8bliz";
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
        name = "laravel-framework-00fa9c04aed10d68481f5757b89da0e6798f53b3";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/00fa9c04aed10d68481f5757b89da0e6798f53b3;
          sha256 = "1ryk6c23sa6lfsx2zpm8mcfng4ys474959kqg959cjaqzq47blq9";
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
        name = "league-commonmark-44ffd8d3c4a9133e4bd0548622b09c55af39db5f";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/commonmark/zipball/44ffd8d3c4a9133e4bd0548622b09c55af39db5f;
          sha256 = "1nlydxyfsh51hrvxg5c7c5lqphynvdclch6w8k9dh1whl8pwjf27";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-f3ad69181b8afed2c9edf7be5a2918144ff4ea32";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/f3ad69181b8afed2c9edf7be5a2918144ff4ea32;
          sha256 = "0s4sx4j7c16qkk7m6k2r4ajfjidlv15z18ybxhfmmz4jb4wsmv94";
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
        name = "nesbot-carbon-f47f17d17602b2243414a44ad53d9f8b9ada5fdb";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/f47f17d17602b2243414a44ad53d9f8b9ada5fdb;
          sha256 = "0b7pr4cqg5l75fncw1lzxcpn4xjnjddyrz287lb4zrjgx1raz3ah";
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
        name = "socialiteproviders-microsoft-azure-64779ec21db0bee3111039a67c0fa0ab550a3462";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/64779ec21db0bee3111039a67c0fa0ab550a3462;
          sha256 = "00jjj7jwmhf2nypwwnmv5rbw6mw0phdlcz8rxybxzy72p2v51m1c";
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
        name = "symfony-console-9aa1eb46c1b12fada74dc0c529e93d1ccef22576";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/9aa1eb46c1b12fada74dc0c529e93d1ccef22576;
          sha256 = "0xsjpsgdm2x2avw92cgx90r5yvpgqfcy0ad8cviwcfdardqfh7z0";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-c1e29de6dc893b130b45d20d8051efbb040560a9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/c1e29de6dc893b130b45d20d8051efbb040560a9;
          sha256 = "0af571s9i7inwsjbqpf5dkpghs2k5ds8ba8x7wdvad6hpgphify8";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-a8d2d5c94438548bff9f998ca874e202bb29d07f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/a8d2d5c94438548bff9f998ca874e202bb29d07f;
          sha256 = "0w0i66c42bvh5ss84jqgjzq81dx673sliaf7z7p60p3fxiy0fdsy";
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
        name = "symfony-error-handler-4001f01153d0eb5496fe11d8c76d1e56b47fdb88";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/4001f01153d0eb5496fe11d8c76d1e56b47fdb88;
          sha256 = "19pf2qk8nal0p59xvgvl04s2v2bcmi87wffml35qiks1pirn6znp";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-047773e7016e4fd45102cedf4bd2558ae0d0c32f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/047773e7016e4fd45102cedf4bd2558ae0d0c32f;
          sha256 = "1cc2lm7fwwqjvx72990k8mzb1xiprpnc1lky13bc61jipdk49jq0";
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
        name = "symfony-finder-ed33314396d968a8936c95f5bd1b88bd3b3e94a3";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/ed33314396d968a8936c95f5bd1b88bd3b3e94a3;
          sha256 = "06m9xr0aik0y5f3j9rr0f23rwdr2b1ib55340myf0lah62as7nxm";
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
        name = "symfony-http-foundation-8759ed5c27c2a8a47cb60f367f4be6727f08d58b";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/8759ed5c27c2a8a47cb60f367f4be6727f08d58b;
          sha256 = "0g47jlsz2p3np3mq4vdhj68jr7a84lwi8hifq132igzgdkbdg6ln";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-e08b2fb8a6eedd81c70522e514bad9b2c1fff881";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/e08b2fb8a6eedd81c70522e514bad9b2c1fff881;
          sha256 = "009w87c31vp5x7hcy77g1b03avm3wp0jznxbqqvdfrid0s42zz77";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-47dd7912152b82d0d4c8d9040dbc93d6232d472a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/47dd7912152b82d0d4c8d9040dbc93d6232d472a;
          sha256 = "1xyk50qrd5hzpwp795adbc56pqxljy3yalsd7p2bfyhd1y5ihwdv";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-46cd95797e9df938fdd2b03693b5fca5e64b01ce";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/46cd95797e9df938fdd2b03693b5fca5e64b01ce;
          sha256 = "0z4iiznxxs4r72xs4irqqb6c0wnwpwf0hklwn2imls67haq330zn";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-63b5bb7db83e5673936d6e3b8b3e022ff6474933";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/63b5bb7db83e5673936d6e3b8b3e022ff6474933;
          sha256 = "1jyjsjprsgb3r6cbc4x1wg1q1zqakqm8a62ah5lppxnjgq1sgjc5";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-65bd267525e82759e7d8c4e8ceea44f398838e65";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/65bd267525e82759e7d8c4e8ceea44f398838e65;
          sha256 = "1cx2cjx0vzni297l7avd3cb1q4c8d2hylkvdqcjlpxjqdimn4jkn";
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
        name = "symfony-polyfill-mbstring-2df51500adbaebdc4c38dea4c89a2e131c45c8a1";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/2df51500adbaebdc4c38dea4c89a2e131c45c8a1;
          sha256 = "1fbi13p4a6nn01ix3gcj966kq6z8qx03li4vbjylsr9ac2mgnmnn";
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
        name = "symfony-polyfill-php73-fba8933c384d6476ab14fb7b8526e5287ca7e010";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/fba8933c384d6476ab14fb7b8526e5287ca7e010;
          sha256 = "0fc1d60iw8iar2zcvkzwdvx0whkbw8p6ll0cry39nbkklzw85n1h";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-eca0bf41ed421bed1b57c4958bab16aa86b757d0";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/eca0bf41ed421bed1b57c4958bab16aa86b757d0;
          sha256 = "1y5kc4vqh920wyjdlgxp23b958g5i9mw10mhbr30vf8j20vf1gra";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-7e812c84c3f2dba173d311de6e510edf701685a8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/7e812c84c3f2dba173d311de6e510edf701685a8;
          sha256 = "1bayw4mnjxqr94y0w0mk1ch5ynvyz71v2hlxlp7w6xw15m9ccpsk";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-3a3c2f197ad0846ac6413225fc78868ba1c61434";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/3a3c2f197ad0846ac6413225fc78868ba1c61434;
          sha256 = "0wbd206gn64q89kiz3fvpcynmpfrjrj081l5lfab0rfj50m80q4h";
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
        name = "symfony-translation-2f7fa60b8d10ca71c30dc46b0870143183a8f131";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/2f7fa60b8d10ca71c30dc46b0870143183a8f131;
          sha256 = "0nhljcj0bmkdx5xsyyxyj32hdl2lirypr5yyy2n9w16bal9fxmc9";
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
        name = "symfony-var-dumper-a586efdf2aa832d05b9249e9115d24f6a2691160";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/a586efdf2aa832d05b9249e9115d24f6a2691160;
          sha256 = "12wnz5hrqcml2l28f1b5949rcvadhc8vigqcg9sqbkzzhxn6gli1";
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
