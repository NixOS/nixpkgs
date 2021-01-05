{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-742663a85ec84647f74dea454d2dc45bba180f9d";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/742663a85ec84647f74dea454d2dc45bba180f9d;
          sha256 = "1i5g97bhj00xcv08g6jm96bl8i3a83faq3f7kz46swyw5z47s7h6";
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
        name = "egulias-email-validator-ca90a3291eee1538cd48ff25163240695bd95448";
        src = fetchurl {
          url = https://api.github.com/repos/egulias/EmailValidator/zipball/ca90a3291eee1538cd48ff25163240695bd95448;
          sha256 = "078pb791w6vim6ws1jsny90rpm9cjni5d0rg329710cynn8wg972";
        };
      };
    };
    "facade/flare-client-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-flare-client-php-fd688d3c06658f2b3b5f7bb19f051ee4ddf02492";
        src = fetchurl {
          url = https://api.github.com/repos/facade/flare-client-php/zipball/fd688d3c06658f2b3b5f7bb19f051ee4ddf02492;
          sha256 = "1bqjr3kar3q71ix9vvm7agxz5xw39bdy62iaxcal4f6rwvgil5jm";
        };
      };
    };
    "facade/ignition" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-1da1705e7f6b24ed45af05461463228da424e14f";
        src = fetchurl {
          url = https://api.github.com/repos/facade/ignition/zipball/1da1705e7f6b24ed45af05461463228da424e14f;
          sha256 = "004qrwc5v6w9sj99xjki5610hcjrw4pjs3av8zghwx1dvcf0b3aq";
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
        name = "filp-whoops-307fb34a5ab697461ec4c9db865b20ff2fd40771";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/307fb34a5ab697461ec4c9db865b20ff2fd40771;
          sha256 = "0fgj0gcnagm8g3dml9628gq8bd2jkcq11bx5ndxpkzngq60b1d82";
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
    "jakub-onderka/php-console-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jakub-onderka-php-console-color-d5deaecff52a0d61ccb613bb3804088da0307191";
        src = fetchurl {
          url = https://api.github.com/repos/JakubOnderka/PHP-Console-Color/zipball/d5deaecff52a0d61ccb613bb3804088da0307191;
          sha256 = "0ih1sa301sda03vqsbg28mz44azii1l0adsjp94p6lhgaawyj4rn";
        };
      };
    };
    "jakub-onderka/php-console-highlighter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jakub-onderka-php-console-highlighter-9f7a229a69d52506914b4bc61bfdb199d90c5547";
        src = fetchurl {
          url = https://api.github.com/repos/JakubOnderka/PHP-Console-Highlighter/zipball/9f7a229a69d52506914b4bc61bfdb199d90c5547;
          sha256 = "1wgk540dkk514vb6azn84mygxy92myi1y27l9la6q24h0hb96514";
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
        name = "laravel-framework-bdc79701b567c5f8ed44d212dd4a261b8300b9c3";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/bdc79701b567c5f8ed44d212dd4a261b8300b9c3;
          sha256 = "08yhwymmc0s76931pib6kr5wkja4hip3nsrxhyys4vc6vn7j4jx5";
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-socialite-19fc65ac28e0b4684a8735b14c1dc6f6ef5d62c7";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/socialite/zipball/19fc65ac28e0b4684a8735b14c1dc6f6ef5d62c7;
          sha256 = "05ii5ijbilfbxqnk4k24xj71qgp839b09xav9fy39vfx7kir80pa";
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
        name = "league-mime-type-detection-353f66d7555d8a90781f6f5e7091932f9a4250aa";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/mime-type-detection/zipball/353f66d7555d8a90781f6f5e7091932f9a4250aa;
          sha256 = "01wis6in4davwh0k2qmcpc93x72cp9f73js3c6cfrrs7fklim5i0";
        };
      };
    };
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-159c3d2bf27568f9af87d6c3f4bb616a251eb12b";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth1-client/zipball/159c3d2bf27568f9af87d6c3f4bb616a251eb12b;
          sha256 = "1i0qw0q00ks0kxf5mp3hay06qhw8hjqnwl3cm805r70fl673w4mv";
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
        name = "nesbot-carbon-d0463779663437392fe42ff339ebc0213bd55498";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/d0463779663437392fe42ff339ebc0213bd55498;
          sha256 = "1v57k7r2kilip5xw40vg8b3h39nffqnk8ky7bsxxwp6g7fkjk65j";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-88b58b5bd9bdcc54756480fb3ce87234696544ee";
        src = fetchurl {
          url = https://api.github.com/repos/nunomaduro/collision/zipball/88b58b5bd9bdcc54756480fb3ce87234696544ee;
          sha256 = "0fnjpjynjlnx0z7aprj0wzngfj8mkm5angczq8qcjnijfyrqqi6k";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-593aca859b67d607923fe50d8ad7315373f5b6dd";
        src = fetchurl {
          url = https://api.github.com/repos/onelogin/php-saml/zipball/593aca859b67d607923fe50d8ad7315373f5b6dd;
          sha256 = "1ccfp9mshjvy4vjmsl32ncc312ian9gs1f54n8cpp2sra3wwpc5n";
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
        name = "scrivo-highlight.php-fa75a865928a4a5d49e5e77faca6bd2f2410baaf";
        src = fetchurl {
          url = https://api.github.com/repos/scrivo/highlight.php/zipball/fa75a865928a4a5d49e5e77faca6bd2f2410baaf;
          sha256 = "064vdidzgavq2gfyi9vm719j6r9fpkhj0rhrp5j1vk6bm9x344m0";
        };
      };
    };
    "socialiteproviders/discord" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-discord-34c62db509c9680e120982f9239db5ce905eb027";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Discord/zipball/34c62db509c9680e120982f9239db5ce905eb027;
          sha256 = "0y0nsj29i1xca5lv6mgp1ssqjgz54i8lysq1aq5d8bv44ff98qbq";
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
        name = "socialiteproviders-okta-60f88b8e8c88508889c61346af83290131b72fe7";
        src = fetchurl {
          url = https://api.github.com/repos/SocialiteProviders/Okta/zipball/60f88b8e8c88508889c61346af83290131b72fe7;
          sha256 = "1icv3qpq99clrg4l78d5308pq55xd7fp8xg9lqfm9bkz5c898q88";
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
        name = "ssddanbrown-htmldiff-d1978c7d1c685800997f982a0ae9cff1e45df70c";
        src = fetchurl {
          url = https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/d1978c7d1c685800997f982a0ae9cff1e45df70c;
          sha256 = "04fkyhzhh8sydkwjcx0swdi4dih2hpj1indjgrqxchkakkv530iw";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-56f0ab23f54c4ccbb0d5dcc67ff8552e0c98d59e";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/56f0ab23f54c4ccbb0d5dcc67ff8552e0c98d59e;
          sha256 = "03k23hwsgq3hyralxmc0l9kbjp0h100pb85mar86bk981rrw484i";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-12e071278e396cc3e1c149857337e9e192deca0b";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/12e071278e396cc3e1c149857337e9e192deca0b;
          sha256 = "0v49k8mqjs2gywxcx2rk2x211vms9w8pcmk5gwgf74847xzbvc97";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-74bd82e75da256ad20851af6ded07823332216c7";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/74bd82e75da256ad20851af6ded07823332216c7;
          sha256 = "038v1z14v6m8jjh0cchzlvfs6z6p4njqiprgsq0y352i11cjaakn";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-5dfc7825f3bfe9bb74b23d8b8ce0e0894e32b544";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/5dfc7825f3bfe9bb74b23d8b8ce0e0894e32b544;
          sha256 = "17awfzd2v6w5xca1vf0x8hlz1crzz3pp2g1g42nwy6axygygymdl";
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
        name = "symfony-error-handler-ef2f7ddd3b9177bbf8ff2ecd8d0e970ed48da0c3";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/error-handler/zipball/ef2f7ddd3b9177bbf8ff2ecd8d0e970ed48da0c3;
          sha256 = "19mgkk27lh1vvs19kqfallxzp714dxf7yyyyh6dbkz2j98scq18c";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-5d4c874b0eb1c32d40328a09dbc37307a5a910b0";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/5d4c874b0eb1c32d40328a09dbc37307a5a910b0;
          sha256 = "1ghfxc3gmshmjfn0w6m5yvl29093b15rx96h14p3sd4vkbs8aj42";
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
        name = "symfony-finder-ebd0965f2dc2d4e0f11487c16fbb041e50b5c09b";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/ebd0965f2dc2d4e0f11487c16fbb041e50b5c09b;
          sha256 = "090s0zq2z97xw9nx5rfj57yy1mv0s31h1f1sqjk1af6mbgz7wvsy";
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
        name = "symfony-http-foundation-5ebda66b51612516bf338d5f87da2f37ff74cf34";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/5ebda66b51612516bf338d5f87da2f37ff74cf34;
          sha256 = "0g5d6vhj1h1qw8bc31cdasdj6b1n5g18l8j8spdm06h93shq15ck";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-eaff9a43e74513508867ecfa66ef94fbb96ab128";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/eaff9a43e74513508867ecfa66ef94fbb96ab128;
          sha256 = "1wav9r85rbr112nw2z10jzigynllxpkiw93wcbsfk4qwlnn4clnb";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-de97005aef7426ba008c46ba840fc301df577ada";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/de97005aef7426ba008c46ba840fc301df577ada;
          sha256 = "15v6y503z42p8cp9613gx2yzmk5wkawmby21pnwyv3fafnv7dd2s";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-f4ba089a5b6366e453971d3aad5fe8e897b37f41";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/f4ba089a5b6366e453971d3aad5fe8e897b37f41;
          sha256 = "0gx3vypz6hipnma7ymqlarr66yxddjmqwkgspiriy8mqcz2y61mn";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-c536646fdb4f29104dd26effc2fdcb9a5b085024";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/c536646fdb4f29104dd26effc2fdcb9a5b085024;
          sha256 = "1an5ls0ihqim5dfxnzcngzbknxb0jdr4x950xr8g6rx0bwq8qxqk";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-3b75acd829741c768bc8b1f84eb33265e7cc5117";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/3b75acd829741c768bc8b1f84eb33265e7cc5117;
          sha256 = "0fmb41s2s3ycba9xdhkgrrcjzn1b6kf64p2fllvfbf3mc6rashs0";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-727d1096295d807c309fb01a851577302394c897";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/727d1096295d807c309fb01a851577302394c897;
          sha256 = "1w4v31l8bnvzjdfafzamwr4fsdf25w7pxmihxkb7z2y9pj9mrsag";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-39d483bdf39be819deabf04ec872eb0b2410b531";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/39d483bdf39be819deabf04ec872eb0b2410b531;
          sha256 = "1rzll717f58biifmxsb56akm7fsjfj70wahycdsfpxdds75m267w";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-cede45fcdfabdd6043b3592e83678e42ec69e930";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php72/zipball/cede45fcdfabdd6043b3592e83678e42ec69e930;
          sha256 = "0r1041r0rg8qqra47imill4sjfwjf0mv9vvrqji4xj5ss60kpwf2";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-8ff431c517be11c78c48a39a66d37431e26a6bed";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/8ff431c517be11c78c48a39a66d37431e26a6bed;
          sha256 = "00rrgiy04y0qfqyvgdr501i66k3sghl6z21vncg05szijp6s6sb3";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-e70aa8b064c5b72d3df2abd5ab1e90464ad009de";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/e70aa8b064c5b72d3df2abd5ab1e90464ad009de;
          sha256 = "1q3gkx34fl7683dcc6w9214k5cpn3bbg7p7yhfxad1x1a1fl62ig";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-075316ff72233ce3d04a9743414292e834f2cb4a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/075316ff72233ce3d04a9743414292e834f2cb4a;
          sha256 = "0k5pjs26fbi95vng76qckd142bfwc5yjxcf8x3ck3y22av05b0zd";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-80b042c20b035818daec844723e23b9825134ba0";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/80b042c20b035818daec844723e23b9825134ba0;
          sha256 = "0riia3jgxybxd4hzllg55f9z898xxlp2xdigbxgsfdv2iq359vkf";
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
        name = "symfony-translation-c1001b7d75b3136648f94b245588209d881c6939";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/c1001b7d75b3136648f94b245588209d881c6939;
          sha256 = "18ik4y3rgm94biq70v6yy4qxk3k4bq9j402jpv0pbx215vwakb39";
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
        name = "symfony-var-dumper-4f31364bbc8177f2a6dbc125ac3851634ebe2a03";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/4f31364bbc8177f2a6dbc125ac3851634ebe2a03;
          sha256 = "0iilxqkykn0h03mc2n0r988rppzvslqrz3dq3pqcfbhyf1pkpv58";
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
        name = "vlucas-phpdotenv-2065beda6cbe75e2603686907b2e45f6f3a5ad82";
        src = fetchurl {
          url = https://api.github.com/repos/vlucas/phpdotenv/zipball/2065beda6cbe75e2603686907b2e45f6f3a5ad82;
          sha256 = "02viglbsv3bfd0az4blrkv33y7d0gfsdkiw8hipkfni5r4rwcyl8";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "bookstack-0.31.1";
  src = ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "MIT";
  };
}
