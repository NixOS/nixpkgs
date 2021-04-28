{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-3e6143f5c12986d727307d5d19d6aec21575d903";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/3e6143f5c12986d727307d5d19d6aec21575d903;
          sha256 = "16hbw8gqscbc3bcvnfdsll6x1653lq2s4dga3d5jbpczil3ws9yb";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-30310e0a675462bf2aa9d448c8dcbf57fbcc517d";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/30310e0a675462bf2aa9d448c8dcbf57fbcc517d;
          sha256 = "1fnan9b2g4xhqqvlfsn3alb4nx5jjlrapgiad2kca13b3gizv7zr";
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
        name = "doctrine-dbal-47433196b6390d14409a33885ee42b6208160643";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/47433196b6390d14409a33885ee42b6208160643;
          sha256 = "0bcg9494hr31902zcmq5kk7ji78yxk074d5bd9chxn9q0xz4g2h8";
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
        name = "dompdf-dompdf-db91d81866c69a42dad1d2926f61515a1e3f42c5";
        src = fetchurl {
          url = https://api.github.com/repos/dompdf/dompdf/zipball/db91d81866c69a42dad1d2926f61515a1e3f42c5;
          sha256 = "10nsmaiqfk6wgv0l9wjsh7h8nigdfabygkhjk7wdbxdfvlvniddd";
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
        name = "facade-flare-client-php-ef0f5bce23b30b32d98fd9bb49c6fa37b40eb546";
        src = fetchurl {
          url = https://api.github.com/repos/facade/flare-client-php/zipball/ef0f5bce23b30b32d98fd9bb49c6fa37b40eb546;
          sha256 = "1car7k8zzkgib9wpi9lzw1dj9qgjak8s9dmiimxaigvb7q4bc5vk";
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
        name = "facade-ignition-contracts-aeab1ce8b68b188a43e81758e750151ad7da796b";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition-contracts/zipball/aeab1ce8b68b188a43e81758e750151ad7da796b;
          sha256 = "0b5hv56758fh2y6fqbygwn94qgqwjan8d2s1i10m242x80h9jjiw";
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
        name = "filp-whoops-df7933820090489623ce0be5e85c7e693638e536";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/df7933820090489623ce0be5e85c7e693638e536;
          sha256 = "0azpv2r8hc9s5pbk9wh2qk52qzycsbvpijr8w68l311igpcj4f78";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-0aa74dfb41ae110835923ef10a9d803a22d50e79";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/guzzle/zipball/0aa74dfb41ae110835923ef10a9d803a22d50e79;
          sha256 = "0gba1711dpi147fzi2ab2pg0k1g6zfanm5w5hf4c7w0b3h4ya5gj";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-60d379c243457e073cff02bc323a2a86cb355631";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/promises/zipball/60d379c243457e073cff02bc323a2a86cb355631;
          sha256 = "0lvcr64bx9sb90qggxk7g7fsplz403gm3i8lnlcaifyjrlmdj5wb";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-53330f47520498c0ae1f61f7e2c90f55690c06a3";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/53330f47520498c0ae1f61f7e2c90f55690c06a3;
          sha256 = "0948mbbqn1xcz39diajhvlr9a7586vx3091kzx96m0z4ki3lhv7g";
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
        name = "laravel-framework-d0e4731e92ca88f4a78fe9e0c2c426a3e8c063c8";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/d0e4731e92ca88f4a78fe9e0c2c426a3e8c063c8;
          sha256 = "15zjpq6lbxs019vd0mm2nbfi91yyw40wsf5fl0jbw3s1ffvaq898";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-8d25d574b4f2005411c0b9cb527ef5e745c1b07d";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/socialite/zipball/8d25d574b4f2005411c0b9cb527ef5e745c1b07d;
          sha256 = "0ash56za1flniq9nnk3siyb8l0m2cjwn2n25315qfhmdgbxxjz68";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-11df9b36fd4f1d2b727a73bf14931d81373b9a54";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/commonmark/zipball/11df9b36fd4f1d2b727a73bf14931d81373b9a54;
          sha256 = "15chm1sa65b58b47am00ik03s2agnx49i8yww3mhqlijvbrjvxc3";
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
        name = "nesbot-carbon-528783b188bdb853eb21239b1722831e0f000a8d";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/528783b188bdb853eb21239b1722831e0f000a8d;
          sha256 = "18pvfwjvclfj0mrgqvycgrbyx5jfcp1hks4yljc6mp66yxr787x4";
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
        name = "onelogin-php-saml-a7328b11887660ad248ea10952dd67a5aa73ba3b";
        src = fetchurl {
          url = https://api.github.com/repos/onelogin/php-saml/zipball/a7328b11887660ad248ea10952dd67a5aa73ba3b;
          sha256 = "0ycj3n22k5i3h8p7gn0xff6a7smjypazl2k5qvyzg86fjr7s3vfv";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-943b5d70cc5ae7483f6aff6ff43d7e34592ca0f5";
        src = fetchurl {
          url = https://api.github.com/repos/opis/closure/zipball/943b5d70cc5ae7483f6aff6ff43d7e34592ca0f5;
          sha256 = "0y47ldgzzv22c5dnsdzqmbrsicq6acjyba0119d3dc6wa3n7zqi6";
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
        name = "predis-predis-9930e933c67446962997b05201c69c2319bf26de";
        src = fetchurl {
          url = https://api.github.com/repos/predis/predis/zipball/9930e933c67446962997b05201c69c2319bf26de;
          sha256 = "0qnpiyv96gs8yzy3b1ba918yw1pv8bgzw7skcf3k40ffpxsmkxv6";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-b7ce3b176482dbbc1245ebf52b181af44c2cf55f";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/container/zipball/b7ce3b176482dbbc1245ebf52b181af44c2cf55f;
          sha256 = "0rkz64vgwb0gfi09klvgay4qnw993l1dc03vyip7d7m2zxi6cy4j";
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
        name = "socialiteproviders-slack-8efb25c71d98bedf4010a829d1e41ff9fe449bcc";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Slack/zipball/8efb25c71d98bedf4010a829d1e41ff9fe449bcc;
          sha256 = "0ax3n4s1djidkhgvrcgv1qipv3k0fhfd0cvs273h6wh66bjniq66";
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
        name = "swiftmailer-swiftmailer-698a6a9f54d7eb321274de3ad19863802c879fb7";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/698a6a9f54d7eb321274de3ad19863802c879fb7;
          sha256 = "1zmyr6szxvbc77rs4q1cp7f3vzw1wfx9rbbj7x9s65gh37z9fd1w";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-24026c44fc37099fa145707fecd43672831b837a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/24026c44fc37099fa145707fecd43672831b837a;
          sha256 = "19c5yczwxk0965pdg7ka8sa8wsr569r6l725rj4y9sabfd6mg6jf";
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
        name = "symfony-debug-af4987aa4a5630e9615be9d9c3ed1b0f24ca449c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/af4987aa4a5630e9615be9d9c3ed1b0f24ca449c;
          sha256 = "15y1bgdrzq3859ql37ymx4fsvd28kyck69ncm6zyg84q3fhd8i19";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-5fa56b4074d1ae755beb55617ddafe6f5d78f665";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/deprecation-contracts/zipball/5fa56b4074d1ae755beb55617ddafe6f5d78f665;
          sha256 = "0ny59x0aaipqaj956wx7ak5f6d5rn90766swp5m18019v9cppg10";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-d603654eaeb713503bba3e308b9e748e5a6d3f2e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/d603654eaeb713503bba3e308b9e748e5a6d3f2e;
          sha256 = "15xdk9bbyfdm8yf19jfb3zr1yaj0lprf9pmxgj630vbpbqkgsd8f";
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
        name = "symfony-finder-25d79cfccfc12e84e7a63a248c3f0720fdd92db6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/25d79cfccfc12e84e7a63a248c3f0720fdd92db6;
          sha256 = "04fwddn12sj6vzr5xr4xd25m86cn4l15079490h3q3igprzvrqk8";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-41db680a15018f9c1d4b23516059633ce280ca33";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-client-contracts/zipball/41db680a15018f9c1d4b23516059633ce280ca33;
          sha256 = "1iia9rpbri1whp2dw4qfhh90gmkdvxhgjwxi54q7wlnlhijgga81";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-8888741b633f6c3d1e572b7735ad2cae3e03f9c5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/8888741b633f6c3d1e572b7735ad2cae3e03f9c5;
          sha256 = "0qs389nxxqc6nwx5x6b9kz8ykdlhdx7k8k6nd2apppxpqalvk6sw";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-07ea794a327d7c8c5d76e3058fde9fec6a711cb4";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/07ea794a327d7c8c5d76e3058fde9fec6a711cb4;
          sha256 = "0mnay6nn299ljjgaqqbk8kcl431wrzvzsqybvl648pf513mp9vy9";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-7dee6a43493f39b51ff6c5bb2bd576fe40a76c86";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/7dee6a43493f39b51ff6c5bb2bd576fe40a76c86;
          sha256 = "0931zsmnpx75b9b34a03l0sfp22mailaa2y5az3cgx9v0bkc0vka";
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
        name = "symfony-routing-87529f6e305c7acb162840d1ea57922038072425";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/87529f6e305c7acb162840d1ea57922038072425;
          sha256 = "0qrgacividsp7c61y03qh8lb4vj30g0mvljnm5k60h4zzdmivlgc";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-d15da7ba4957ffb8f1747218be9e1a121fd298a1";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/d15da7ba4957ffb8f1747218be9e1a121fd298a1;
          sha256 = "168iq1lp2r5qb5h8j0s17da09iaj2h5hrrdc9rw2p73hq8rvm1w2";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-e1d0c67167a553556d9f974b5fa79c2448df317a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/e1d0c67167a553556d9f974b5fa79c2448df317a;
          sha256 = "1b6fj278i1wdf4l7py9n86lmhrqmzvjy7kapjpfkz03adn2ps127";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-e2eaa60b558f26a4b0354e1bbb25636efaaad105";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation-contracts/zipball/e2eaa60b558f26a4b0354e1bbb25636efaaad105;
          sha256 = "1k26yvgk84rz6ja9ml6l6iwbbi68qsqnq2cpky044g9ymvlg8d5g";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-a1eab2f69906dc83c5ddba4632180260d0ab4f7f";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/a1eab2f69906dc83c5ddba4632180260d0ab4f7f;
          sha256 = "1yw12jbx6gf5mvg7jrr1v57ah3b2s4hflz2p1m98nayi4qhdp20m";
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
