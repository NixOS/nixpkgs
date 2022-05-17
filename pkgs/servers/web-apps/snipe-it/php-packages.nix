{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "adldap2/adldap2" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "adldap2-adldap2-b2203d800c5932f975abc213c659428697e27cd9";
        src = fetchurl {
          url = "https://api.github.com/repos/Adldap2/Adldap2/zipball/b2203d800c5932f975abc213c659428697e27cd9";
          sha256 = "028lkx1hrkp4dqi8f3rcbhyjlk61lajz2fqw8xmlzyhip9l6ivq3";
        };
      };
    };
    "alek13/slack" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "alek13-slack-9db79a622803bf7baf0efafb50e37b900882f7fb";
        src = fetchurl {
          url = "https://api.github.com/repos/php-slack/slack/zipball/9db79a622803bf7baf0efafb50e37b900882f7fb";
          sha256 = "0h70p0va4r20lw65asa68zv73w9047hyal0xa082p0wjihim5k1s";
        };
      };
    };
    "asm89/stack-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "asm89-stack-cors-73e5b88775c64ccc0b84fb60836b30dc9d92ac4a";
        src = fetchurl {
          url = "https://api.github.com/repos/asm89/stack-cors/zipball/73e5b88775c64ccc0b84fb60836b30dc9d92ac4a";
          sha256 = "1idpisw39ba2dic9jl2s2yrkdgbyny9dfxf0qdr5i0wfvvlmbdih";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-6c919bc226f7ff3fbcbce948f31e618066d02ad0";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/6c919bc226f7ff3fbcbce948f31e618066d02ad0";
          sha256 = "1wicn300x19v77dq11pwb6v91h8z11fqjrqrr8b9ncahyf5lg0aq";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-5a91b62b9d37cee635bbf8d553f4546057250bee";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/5a91b62b9d37cee635bbf8d553f4546057250bee";
          sha256 = "0rb88fg083790bbciffniff7xqkgzm091szm131afhkl8rr7pnkq";
        };
      };
    };
    "barryvdh/laravel-debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-debugbar-70b89754913fd89fef16d0170a91dbc2a5cd633a";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-debugbar/zipball/70b89754913fd89fef16d0170a91dbc2a5cd633a";
          sha256 = "1sqm1afhmf0fgyvvwa760f0d5ifnd84fv83v40n28lp534xsibz5";
        };
      };
    };
    "defuse/php-encryption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "defuse-php-encryption-77880488b9954b7884c25555c2a0ea9e7053f9d2";
        src = fetchurl {
          url = "https://api.github.com/repos/defuse/php-encryption/zipball/77880488b9954b7884c25555c2a0ea9e7053f9d2";
          sha256 = "1lcvpg56nw72cxyh6sga7fx94qw9l0l1y78z7y7ny3hgdniwhihx";
        };
      };
    };
    "doctrine/annotations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-annotations-e6e7b7d5b45a2f2abc5460cc6396480b2b1d321f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/annotations/zipball/e6e7b7d5b45a2f2abc5460cc6396480b2b1d321f";
          sha256 = "090vizq3xy9p151cjx5fa2izgvypc756wrnclswiiiac4h6mzpyf";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-3bb5588cec00a0268829cc4a518490df6741af9d";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/3bb5588cec00a0268829cc4a518490df6741af9d";
          sha256 = "0r9fhv0y79ma7a5llmj1skycflnwbxyyrblkavjj6svld46li94q";
        };
      };
    };
    "doctrine/collections" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-collections-55f8b799269a1a472457bd1a41b4f379d4cfba4a";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/collections/zipball/55f8b799269a1a472457bd1a41b4f379d4cfba4a";
          sha256 = "1kalndrc2g8g82524yg0rcn4xzrl5a9hi0x6g6ixqa6afzgzmvbs";
        };
      };
    };
    "doctrine/common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-common-f3812c026e557892c34ef37f6ab808a6b567da7f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/common/zipball/f3812c026e557892c34ef37f6ab808a6b567da7f";
          sha256 = "16jf1wzs6ccpw2ny7rkzpf0asdwr1cfzcyw8g5x88i4j9jazn8xa";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-8dd39d2ead4409ce652fd4f02621060f009ea5e4";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/8dd39d2ead4409ce652fd4f02621060f009ea5e4";
          sha256 = "107k0qr3m34cjxy00yhdjmd8liqa8wg729zj4z2jifz26niiy8qs";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-9504165960a1f83cc1480e2be1dd0a0478561314";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/9504165960a1f83cc1480e2be1dd0a0478561314";
          sha256 = "04kpbzk5iw86imspkg7dgs54xx877k9b5q0dfg2h119mlfkvxil6";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-41370af6a30faa9dc0368c4a6814d596e81aba7f";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/41370af6a30faa9dc0368c4a6814d596e81aba7f";
          sha256 = "0pn2aiwl4fvv6fcwar9alng2yrqy8bzc58n4bkp6y2jnpw5gp4m8";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-4bd5c1cdfcd00e9e2d8c484f79150f67e5d355d9";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/4bd5c1cdfcd00e9e2d8c484f79150f67e5d355d9";
          sha256 = "0390gkbk3vdjd98h7wjpdv0579swbavrdb6yrlslfdr068g4bmbf";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-d56bf6102915de5702778fe20f2de3b2fe570b5b";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/instantiator/zipball/d56bf6102915de5702778fe20f2de3b2fe570b5b";
          sha256 = "04rihgfjv8alvvb92bnb5qpz8fvqvjwfrawcjw34pfnfx4jflcwh";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-c268e882d4dbdd85e36e4ad69e02dc284f89d229";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/c268e882d4dbdd85e36e4ad69e02dc284f89d229";
          sha256 = "12g069nljl3alyk15884nd1jc4mxk87isqsmfj7x6j2vxvk9qchs";
        };
      };
    };
    "doctrine/persistence" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-persistence-7a6eac9fb6f61bba91328f15aa7547f4806ca288";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/persistence/zipball/7a6eac9fb6f61bba91328f15aa7547f4806ca288";
          sha256 = "0mszkf7lxdhbr5b3ibpn7ipyrf6a6kfj283fvh83akyv1mplsl0h";
        };
      };
    };
    "doctrine/reflection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-reflection-fa587178be682efe90d005e3a322590d6ebb59a5";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/reflection/zipball/fa587178be682efe90d005e3a322590d6ebb59a5";
          sha256 = "1jn3bbzv0pn16aw0kkg0l765wi49zpf5vpirqwmw3viqj9bgj1b5";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-65b2d8ee1f10915efb3b55597da3404f096acba2";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/65b2d8ee1f10915efb3b55597da3404f096acba2";
          sha256 = "07yqbhf6n4d818gvla60mgg23gichwiafd5ypd70w4b4dlbcxcpl";
        };
      };
    };
    "eduardokum/laravel-mail-auto-embed" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "eduardokum-laravel-mail-auto-embed-83349a6a35560edb1c95e31205e2a848d73196ef";
        src = fetchurl {
          url = "https://api.github.com/repos/eduardokum/laravel-mail-auto-embed/zipball/83349a6a35560edb1c95e31205e2a848d73196ef";
          sha256 = "0v1zbyln5ly1fhyr8m6wdm140zy14l71mqjpkij2pacskbbmvij2";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-0dbf5d78455d4d6a41d186da50adc1122ec066f4";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/0dbf5d78455d4d6a41d186da50adc1122ec066f4";
          sha256 = "00kwb8rhk1fq3a1i152xniipk3y907q1v5r3szqbkq5rz82dwbck";
        };
      };
    };
    "enshrined/svg-sanitize" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "enshrined-svg-sanitize-e50b83a2f1f296ca61394fe88fbfe3e896a84cf4";
        src = fetchurl {
          url = "https://api.github.com/repos/darylldoyle/svg-sanitizer/zipball/e50b83a2f1f296ca61394fe88fbfe3e896a84cf4";
          sha256 = "1pv8lkpyl0fp0ychfqlds31lpy73pzz9z2rjngxhpvzfka39gchg";
        };
      };
    };
    "erusev/parsedown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "erusev-parsedown-cb17b6477dfff935958ba01325f2e8a2bfa6dab3";
        src = fetchurl {
          url = "https://api.github.com/repos/erusev/parsedown/zipball/cb17b6477dfff935958ba01325f2e8a2bfa6dab3";
          sha256 = "1iil9v8g03m5vpxxg3a5qb2sxd1cs5c4p5i0k00cqjnjsxfrazxd";
        };
      };
    };
    "fideloper/proxy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fideloper-proxy-c073b2bd04d1c90e04dc1b787662b558dd65ade0";
        src = fetchurl {
          url = "https://api.github.com/repos/fideloper/TrustedProxy/zipball/c073b2bd04d1c90e04dc1b787662b558dd65ade0";
          sha256 = "05jzgjj4fy5p1smqj41b5qxj42zn0mnczvsaacni4fmq174mz4gy";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-2edbc73a4687d9085c8f20f398eebade844e8424";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/2edbc73a4687d9085c8f20f398eebade844e8424";
          sha256 = "1x79vnjdbjk9z2mix75ri56kyc5iwvjv3dyivncg6n3wd80nyfgg";
        };
      };
    };
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-83b609028194aa042ea33b5af2d41a7427de80e6";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/83b609028194aa042ea33b5af2d41a7427de80e6";
          sha256 = "16a0nw983x36al7zdcrf6h2m4jmnnvmr4p9znr5yzpchi5zx42ig";
        };
      };
    };
    "fruitcake/laravel-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-laravel-cors-783a74f5e3431d7b9805be8afb60fd0a8f743534";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/laravel-cors/zipball/783a74f5e3431d7b9805be8afb60fd0a8f743534";
          sha256 = "13mqhjks048fb5042l0rfrr52rz7knp9gjn8qviw9cx76kllw2c9";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-9d4290de1cfd701f38099ef7e183b64b4b7b0c5e";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/9d4290de1cfd701f38099ef7e183b64b4b7b0c5e";
          sha256 = "1dlrdpil0173cmx73ghy8iis2j0lk00dzv3n166d0riky21n8djb";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-8e7d04f1f6450fef59366c399cfad4b9383aa30d";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/8e7d04f1f6450fef59366c399cfad4b9383aa30d";
          sha256 = "158wd8nmvvl386c24lkr4jkwdhqpdj0dxdbjwh8iv6a2rgccjr2q";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-337e3ad8e5716c15f9657bd214d16cc5e69df268";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/337e3ad8e5716c15f9657bd214d16cc5e69df268";
          sha256 = "0qpldw2aw55dm275hgavw9h53l5697ahiz7cn2d0fz97l8j7fg9p";
        };
      };
    };
    "intervention/image" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "intervention-image-abbf18d5ab8367f96b3205ca3c89fb2fa598c69e";
        src = fetchurl {
          url = "https://api.github.com/repos/Intervention/image/zipball/abbf18d5ab8367f96b3205ca3c89fb2fa598c69e";
          sha256 = "1msfpr9bip69bmhg23ka2f43phgb6dq5z604j5psjh3xd86r6c5d";
        };
      };
    };
    "javiereguiluz/easyslugger" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "javiereguiluz-easyslugger-11524a3fd70e3f0c98043755a0ffa228f2529211";
        src = fetchurl {
          url = "https://api.github.com/repos/javiereguiluz/EasySlugger/zipball/11524a3fd70e3f0c98043755a0ffa228f2529211";
          sha256 = "12x5cgp3qmz5d9wvgpd6c0whygm9z3y392fdi4kqjlzi3n5yknnp";
        };
      };
    };
    "laminas/laminas-diactoros" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-diactoros-36ef09b73e884135d2059cc498c938e90821bb57";
        src = fetchurl {
          url = "https://api.github.com/repos/laminas/laminas-diactoros/zipball/36ef09b73e884135d2059cc498c938e90821bb57";
          sha256 = "0qzf3890j1976q6f684fydz49gd48kg3hwipzhsw0dgbcgmr8qs6";
        };
      };
    };
    "laminas/laminas-zendframework-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-zendframework-bridge-6ede70583e101030bcace4dcddd648f760ddf642";
        src = fetchurl {
          url = "https://api.github.com/repos/laminas/laminas-zendframework-bridge/zipball/6ede70583e101030bcace4dcddd648f760ddf642";
          sha256 = "10cksxv2fzv3d14n8kmij3wvfibddzp1qz65dqgybs1w2fd1n358";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-505ebcdeaa9ca56d6d7dbf38ed4f53998c973ed0";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/505ebcdeaa9ca56d6d7dbf38ed4f53998c973ed0";
          sha256 = "0hwjxlzj3hg8zmwslcjkp9jcrbqpxsvyj9fjhqk3j919dwlwwx0z";
        };
      };
    };
    "laravel/helpers" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-helpers-febb10d8daaf86123825de2cb87f789a3371f0ac";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/helpers/zipball/febb10d8daaf86123825de2cb87f789a3371f0ac";
          sha256 = "1axbawm5hamfqvs5a6n4bbjc2fs5q3zwpsf7xrvqirxc4rgrdbgw";
        };
      };
    };
    "laravel/passport" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-passport-011bd500e8ae3d459b692467880a49ff1ecd60c0";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/passport/zipball/011bd500e8ae3d459b692467880a49ff1ecd60c0";
          sha256 = "0aix2nf06xl32iqyhjjfjp7sq9z57v8w8i9qh408cmr78qg28kwv";
        };
      };
    };
    "laravel/slack-notification-channel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-slack-notification-channel-f428e76b8d0a0a2ff413ab225eeb829b9a8ffc20";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/slack-notification-channel/zipball/f428e76b8d0a0a2ff413ab225eeb829b9a8ffc20";
          sha256 = "1bmn7018j6pi7jfjbzkwpx3qa1b33d8vvm48xjsyci44vkp7swbk";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-04ad32c1a3328081097a181875733fa51f402083";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/04ad32c1a3328081097a181875733fa51f402083";
          sha256 = "1h4847a5rq2qdyszvjx6bqw5c0xi2m3pn9x7cqnq7jz7fkzpi5f9";
        };
      };
    };
    "laravelcollective/html" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravelcollective-html-ae15b9c4bf918ec3a78f092b8555551dd693fde3";
        src = fetchurl {
          url = "https://api.github.com/repos/LaravelCollective/html/zipball/ae15b9c4bf918ec3a78f092b8555551dd693fde3";
          sha256 = "0prkxn874gp2x1hv4nsv30rfrqn5l7ld8qy3ivd3p7n391k7iak6";
        };
      };
    };
    "lcobucci/jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lcobucci-jwt-3ef8657a78278dfeae7707d51747251db4176240";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/jwt/zipball/3ef8657a78278dfeae7707d51747251db4176240";
          sha256 = "03d8ah4xjhq4pikifgbyxlip8pdqwdiypi2aqbx32i98sj2fa4fr";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
          sha256 = "14hp7vmqag9jh89rcq1mi3hyw01rkmypdbw2p3zsnjq2p8wwh4r5";
        };
      };
    };
    "league/csv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-csv-f28da6e483bf979bac10e2add384c90ae9983e4e";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/csv/zipball/f28da6e483bf979bac10e2add384c90ae9983e4e";
          sha256 = "13wpdjf0646z1mawi9bh540gvykwx7ry6kd8cyvpnpi1gjxyqzma";
        };
      };
    };
    "league/event" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-event-d2cc124cf9a3fab2bb4ff963307f60361ce4d119";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/event/zipball/d2cc124cf9a3fab2bb4ff963307f60361ce4d119";
          sha256 = "1fc8aj0mpbrnh3b93gn8pypix28nf2gfvi403kfl7ibh5iz6ds5l";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-f3ad69181b8afed2c9edf7be5a2918144ff4ea32";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/f3ad69181b8afed2c9edf7be5a2918144ff4ea32";
          sha256 = "0s4sx4j7c16qkk7m6k2r4ajfjidlv15z18ybxhfmmz4jb4wsmv94";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-4e25cc0582a36a786c31115e419c6e40498f6972";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/4e25cc0582a36a786c31115e419c6e40498f6972";
          sha256 = "1q2vkgyaz7h6z3q0z3v3l5rsvhv4xc45prgzr214cgm656i2h1ab";
        };
      };
    };
    "league/flysystem-cached-adapter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-cached-adapter-d1925efb2207ac4be3ad0c40b8277175f99ffaff";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-cached-adapter/zipball/d1925efb2207ac4be3ad0c40b8277175f99ffaff";
          sha256 = "1gvp89cl27ypcy4h0qjm04dc5k77jfm95m4paasglzfsi6g40i71";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-3b9dff8aaf7323590c1d2e443db701eb1f9aa0d3";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/3b9dff8aaf7323590c1d2e443db701eb1f9aa0d3";
          sha256 = "0pmq486v2nf6672y2z53cyb3mfrxcc8n7z2ilpzz9zkkf2yb990j";
        };
      };
    };
    "league/oauth2-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-server-f5698a3893eda9a17bcd48636990281e7ca77b2a";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-server/zipball/f5698a3893eda9a17bcd48636990281e7ca77b2a";
          sha256 = "1fi46pi8aiw8jdhdjwq38kxrva9hbk85h5gr5h1ixlxm699vnrsz";
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "masterminds-html5-9227822783c75406cfe400984b2f095cdf03d417";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/9227822783c75406cfe400984b2f095cdf03d417";
          sha256 = "1szy5njj102vql3i9l9qgnx8z40lhn7lgaqkscma9hn478963rbz";
        };
      };
    };
    "maximebf/debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maximebf-debugbar-6d51ee9e94cff14412783785e79a4e7ef97b9d62";
        src = fetchurl {
          url = "https://api.github.com/repos/maximebf/php-debugbar/zipball/6d51ee9e94cff14412783785e79a4e7ef97b9d62";
          sha256 = "13lh63wnsp2a6564h3if3925x4maf2plkhzyd1byv995g7bhi68i";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-d7fd7450628561ba697b7097d86db72662f54aef";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/d7fd7450628561ba697b7097d86db72662f54aef";
          sha256 = "1zi8pprp0jfjvnw4xh5rcbcr8wmqcgrsccl257p25x2n50sggm8l";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-9b87907a81b87bc76d19a7fb2d61e61486ee9edb";
        src = fetchurl {
          url = "https://api.github.com/repos/jmespath/jmespath.php/zipball/9b87907a81b87bc76d19a7fb2d61e61486ee9edb";
          sha256 = "1ig3gi6f8gisagcn876598ps48s86s6m0c82diyksylarg3yn0yd";
        };
      };
    };
    "neitanod/forceutf8" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "neitanod-forceutf8-c1fbe70bfb5ad41b8ec5785056b0e308b40d4831";
        src = fetchurl {
          url = "https://api.github.com/repos/neitanod/forceutf8/zipball/c1fbe70bfb5ad41b8ec5785056b0e308b40d4831";
          sha256 = "1fvh2iapy7q22n65p6xkcbxcmp68x917gkv2cb0gs59671fwxsjf";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-93d9db91c0235c486875d22f1e08b50bdf3e6eee";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/93d9db91c0235c486875d22f1e08b50bdf3e6eee";
          sha256 = "1xk4bg9imbsm8481mc49111cimanrxswqqkj3bqs4ja8bam6a51z";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-4432ba399e47c66624bc73c8c0f811e5c109576f";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/4432ba399e47c66624bc73c8c0f811e5c109576f";
          sha256 = "0372c09xdgdr9dhd9m7sblxyqxk9xdk2r9s0i13ja3ascsz3zvpd";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-f7c45764dfe4ba5f2618d265a6f1f9c72732e01d";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/collision/zipball/f7c45764dfe4ba5f2618d265a6f1f9c72732e01d";
          sha256 = "1cazbjxl5rqw4cl783nrymhcvjhvwwwjswr5w0si1wfhmpvr349q";
        };
      };
    };
    "nyholm/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nyholm-psr7-1461e07a0f2a975a52082ca3b769ca912b816226";
        src = fetchurl {
          url = "https://api.github.com/repos/Nyholm/psr7/zipball/1461e07a0f2a975a52082ca3b769ca912b816226";
          sha256 = "1i6v8r9c2gxsjafyy03g339hkc0wcbsdlg47gy6rswg7qc1r91g1";
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-a7328b11887660ad248ea10952dd67a5aa73ba3b";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/a7328b11887660ad248ea10952dd67a5aa73ba3b";
          sha256 = "0ycj3n22k5i3h8p7gn0xff6a7smjypazl2k5qvyzg86fjr7s3vfv";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-3d81e4309d2a927abbe66df935f4bb60082805ad";
        src = fetchurl {
          url = "https://api.github.com/repos/opis/closure/zipball/3d81e4309d2a927abbe66df935f4bb60082805ad";
          sha256 = "0hqs6rdkkcggswrgjlispkby2yg4hwn63bl2ma62lnmpfbpwn0sd";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/constant_time_encoding/zipball/f34c2b11eb9d2c9318e13540a1dbc2a3afbd939c";
          sha256 = "1r1xj3j7s5mskw5gh3ars4dfhvcn7d252gdqgpif80026kj5fvrp";
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
    "patchwork/utf8" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "patchwork-utf8-e1fa4d4a57896d074c9a8d01742b688d5db4e9d5";
        src = fetchurl {
          url = "https://api.github.com/repos/tchwork/utf8/zipball/e1fa4d4a57896d074c9a8d01742b688d5db4e9d5";
          sha256 = "0rarkg8v23y58bc4n6j39wdi6is0p1rgqxnixqlgavcm35xjgnw0";
        };
      };
    };
    "php-http/message-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-http-message-factory-a478cb11f66a6ac48d8954216cfed9aa06a501a1";
        src = fetchurl {
          url = "https://api.github.com/repos/php-http/message-factory/zipball/a478cb11f66a6ac48d8954216cfed9aa06a501a1";
          sha256 = "13drpc83bq332hz0b97whibkm7jpk56msq4yppw9nmrchzwgy7cs";
        };
      };
    };
    "php-parallel-lint/php-console-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-color-b6af326b2088f1ad3b264696c9fd590ec395b49e";
        src = fetchurl {
          url = "https://api.github.com/repos/php-parallel-lint/PHP-Console-Color/zipball/b6af326b2088f1ad3b264696c9fd590ec395b49e";
          sha256 = "030449mkpxs35y8dk336ls3bfdq3zjnxswnk5khlg45z5147cr3k";
        };
      };
    };
    "php-parallel-lint/php-console-highlighter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-parallel-lint-php-console-highlighter-21bf002f077b177f056d8cb455c5ed573adfdbb8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-parallel-lint/PHP-Console-Highlighter/zipball/21bf002f077b177f056d8cb455c5ed573adfdbb8";
          sha256 = "013phmp5n6hp6mvlpbqbrih0zd8h7xc152dpzxxf49b0jczxh8y4";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-1d01c49d4ed62f25aa84a747ad35d5a16924662b";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/1d01c49d4ed62f25aa84a747ad35d5a16924662b";
          sha256 = "1wx720a17i24471jf8z499dnkijzb4b8xra11kvw9g9hhzfadz1r";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-069a785b2141f5bcf49f3e353548dc1cce6df556";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/069a785b2141f5bcf49f3e353548dc1cce6df556";
          sha256 = "0qid63bsfjmc3ka54f1ijl4a5zqwf7jmackjyjmbw3gxdnbi69il";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-6a467b8989322d92aa1c8bf2bebcc6e5c2ba55c0";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/6a467b8989322d92aa1c8bf2bebcc6e5c2ba55c0";
          sha256 = "01g6mihq5wd1396njjb7ibcdfgk26ix1kmbjb6dlshzav0k3983h";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoption-phpoption-eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/eab7a0df01fe2344d172bff4cd6dbd3f8b84ad15";
          sha256 = "1lk50y8jj2mzbwc2mxfm2xdasxf4axya72nv8wfc1vyz9y5ys3li";
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpseclib-phpseclib-c812fbb4d6b4d7f30235ab7298a12f09ba13b37c";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/c812fbb4d6b4d7f30235ab7298a12f09ba13b37c";
          sha256 = "0yak18zyyjhqd2l5mlgiinw9rf4rrvbyxp2fnivjvm93jymhhl49";
        };
      };
    };
    "phpspec/prophecy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpspec-prophecy-be1996ed8adc35c3fd795488a653f4b518be70ea";
        src = fetchurl {
          url = "https://api.github.com/repos/phpspec/prophecy/zipball/be1996ed8adc35c3fd795488a653f4b518be70ea";
          sha256 = "167snpasy7499pbxpyx2bj607qa1vrg07xfpa30dlpbwi7f34dji";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-26c4c5cf30a2844ba121760fd7301f8ad240100b";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa/zipball/26c4c5cf30a2844ba121760fd7301f8ad240100b";
          sha256 = "1jmc7s3hbczvb0h4kfmya67l969nfww3lmc4slvzsz0zd769434h";
        };
      };
    };
    "pragmarx/google2fa-laravel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-laravel-f9014fd7ea36a1f7fffa233109cf59b209469647";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa-laravel/zipball/f9014fd7ea36a1f7fffa233109cf59b209469647";
          sha256 = "1y1b24fyfsf8mrhla3j699x1x6pd23rw5k3pjsag0vqgvd4v3a8n";
        };
      };
    };
    "pragmarx/google2fa-qrcode" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-qrcode-fd5ff0531a48b193a659309cc5fb882c14dbd03f";
        src = fetchurl {
          url = "https://api.github.com/repos/antonioribeiro/google2fa-qrcode/zipball/fd5ff0531a48b193a659309cc5fb882c14dbd03f";
          sha256 = "1csa15v68bznrz3262xjcdgcgw0lg8fwb6fhrbms2mnylhq4s35g";
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-cache-d11b50ad223250cf17b86e38383413f5a6764bf8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/d11b50ad223250cf17b86e38383413f5a6764bf8";
          sha256 = "06i2k3dx3b4lgn9a4v1dlgv8l9wcl4kl7vzhh63lbji0q96hv8qz";
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-container-8622567409010282b7aeebe4bb841fe98b58dcaf";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/8622567409010282b7aeebe4bb841fe98b58dcaf";
          sha256 = "0qfvyfp3mli776kb9zda5cpc8cazj3prk0bg0gm254kwxyfkfrwn";
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363";
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-log-d49695b909c3b7628b6289db5479a1c204601f11";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/d49695b909c3b7628b6289db5479a1c204601f11";
          sha256 = "0sb0mq30dvmzdgsnqvw3xh4fb4bqjncx72kf8n622f94dd48amln";
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-e4573f47750dd6c92dca5aee543fa77513cbd8d3";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/e4573f47750dd6c92dca5aee543fa77513cbd8d3";
          sha256 = "1pzw57gild4h66nfkvlcbz43ralypcjr9dgvwj6rs2gl72rfiwnk";
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
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-ffa80ab953edd85d5b6c004f96181a538aad35a3";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/ffa80ab953edd85d5b6c004f96181a538aad35a3";
          sha256 = "043g1nwpbvqrvq6ri2517254d72538h5jfzv9miafnws4ajwfpzg";
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
    "rollbar/rollbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "rollbar-rollbar-ff3db5739dd635740caed02ddad43e671b5a37e5";
        src = fetchurl {
          url = "https://api.github.com/repos/rollbar/rollbar-php/zipball/ff3db5739dd635740caed02ddad43e671b5a37e5";
          sha256 = "1mkbw0mcaj50ks0x6ql2qq7dr2i5nfr46x6chdf8hvnm1vjnphmd";
        };
      };
    };
    "rollbar/rollbar-laravel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "rollbar-rollbar-laravel-11df7e19313a4cf60769d26ce35e29b09d5405cd";
        src = fetchurl {
          url = "https://api.github.com/repos/rollbar/rollbar-php-laravel/zipball/11df7e19313a4cf60769d26ce35e29b09d5405cd";
          sha256 = "0df52a29c9xs0ifvfkcskix1nx9bz6xykrv2ah9m4pg1ikjkg2cx";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-1071dfcef776a57013124ff35e1fc41ccd294758";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/comparator/zipball/1071dfcef776a57013124ff35e1fc41ccd294758";
          sha256 = "0i2lnvf56n4s88001dzxzy9bjzih1qbf7kzc7457qhlvwdnaydn3";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-14f72dd46eaf2f2293cbe79c93cc0bc43161a211";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/14f72dd46eaf2f2293cbe79c93cc0bc43161a211";
          sha256 = "0planffhifwhxgml9r3ma89c83jvbrqilj517a5ps9x8vc6kk312";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-0c32ea2e40dbf59de29f3b49bf375176ce7dd8db";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/exporter/zipball/0c32ea2e40dbf59de29f3b49bf375176ce7dd8db";
          sha256 = "179m35wkps4vy5yxdpbgim8v2cxf9v2wifswj3ww7qhg7h53b1gk";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-367dcba38d6e1977be014dc4b22f47a484dac7fb";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/367dcba38d6e1977be014dc4b22f47a484dac7fb";
          sha256 = "1zpq0qk2mgwnbyhjnj05dz2n2v8hvj2g4jy68fd5klxxkdr92ps7";
        };
      };
    };
    "spatie/db-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-db-dumper-05e5955fb882008a8947c5a45146d86cfafa10d1";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/db-dumper/zipball/05e5955fb882008a8947c5a45146d86cfafa10d1";
          sha256 = "0g0scxq259qn1maxa61qh3cl5a88778qgx27dgbxr9p8kszivlsg";
        };
      };
    };
    "spatie/laravel-backup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-backup-3ede36961b79b6ea4a6b5f708f2cc60fee74ad6c";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-backup/zipball/3ede36961b79b6ea4a6b5f708f2cc60fee74ad6c";
          sha256 = "1i6j0qc8g80d9jxb4xhybgym8sykdackfqwqdahhmgs4mc4fg6ps";
        };
      };
    };
    "spatie/temporary-directory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-temporary-directory-f517729b3793bca58f847c5fd383ec16f03ffec6";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/temporary-directory/zipball/f517729b3793bca58f847c5fd383ec16f03ffec6";
          sha256 = "1pn6l9c86yigpzn83ajpq2wiy8ds0rlxmiq0iwby14cijc98ma3m";
        };
      };
    };
    "squizlabs/php_codesniffer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "squizlabs-php_codesniffer-ffced0d2c8fa8e6cdc4d695a743271fab6c38625";
        src = fetchurl {
          url = "https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/ffced0d2c8fa8e6cdc4d695a743271fab6c38625";
          sha256 = "1cndvz85ii2cl47lbfkmxr4xw03n7y70l6jc8sdh6bhz4axvk03z";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8a5d5072dca8f48460fce2f4131fcc495eec654c";
        src = fetchurl {
          url = "https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8a5d5072dca8f48460fce2f4131fcc495eec654c";
          sha256 = "1p9m4fw9y9md9a7msbmnc0hpdrky8dwrllnyg1qf1cdyp9d70x1d";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-bdcc66f3140421038f495e5b50e3ca6ffa14c773";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/bdcc66f3140421038f495e5b50e3ca6ffa14c773";
          sha256 = "16w04xyq1igg3q4542s3v8vry5k2wsz8ip1vz7j036ghlv154j76";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-c1e29de6dc893b130b45d20d8051efbb040560a9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/c1e29de6dc893b130b45d20d8051efbb040560a9";
          sha256 = "0af571s9i7inwsjbqpf5dkpghs2k5ds8ba8x7wdvad6hpgphify8";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-5de6c6e7f52b364840e53851c126be4d71e60470";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/debug/zipball/5de6c6e7f52b364840e53851c126be4d71e60470";
          sha256 = "1kmf8kk5ra6nr17z007vacw3dvpcglng584l0y98wrn5kmmfgh4x";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-6f981ee24cf69ee7ce9736146d1c57c2780598a8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/6f981ee24cf69ee7ce9736146d1c57c2780598a8";
          sha256 = "05jws1g4kcs297bwf5d72z47m2263i2jqpivi3yv8kf50kdjjzba";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-2d0c9c229d995bef5e87fe4e83b717541832b448";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/2d0c9c229d995bef5e87fe4e83b717541832b448";
          sha256 = "1zl6p02pzmzi64fh6c77zgcnwqd41nxvhi4syhdm90l24d0b1di0";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-3ccfcfb96ecce1217d7b0875a0736976bc6e63dc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/3ccfcfb96ecce1217d7b0875a0736976bc6e63dc";
          sha256 = "0rx6h15nzhia0g797xbgd692lraxlbv9fblg9528xr6if94bgcng";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-01e9a4efac0ee33a05dfdf93b346f62e7d0e998c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/01e9a4efac0ee33a05dfdf93b346f62e7d0e998c";
          sha256 = "08hi7dgz6bnq8ys1hblgqfqkgix6kzqb1a4751bkxfz2sjh6sza8";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-b17d76d7ed179f017aad646e858c90a2771af15d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/b17d76d7ed179f017aad646e858c90a2771af15d";
          sha256 = "0lmss9kblyj3pvc7wmkj1vlkjx8rr8ad6rrd9c0pf5r9iqbgy1zq";
        };
      };
    };
    "symfony/http-client-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-client-contracts-ec82e57b5b714dbb69300d348bd840b345e24166";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-client-contracts/zipball/ec82e57b5b714dbb69300d348bd840b345e24166";
          sha256 = "0q2ad5vjyrh753a71ymlqbb6rnmvq2z65c5mf4iwic2j16cmzr7p";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-60e8e42a4579551e5ec887d04380e2ab9e4cc314";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/60e8e42a4579551e5ec887d04380e2ab9e4cc314";
          sha256 = "1vkb67il9cv954lkkzgmsivcx9iypv4hmp1kkkgprmqsrzl5plwl";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-330a859a7ec9d7e7d82f2569b1c0700a26ffb1e3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/330a859a7ec9d7e7d82f2569b1c0700a26ffb1e3";
          sha256 = "0cgngsln3k2mfp8hrmbmc71alpwfhqv7ilq8mgj1h1blh8ms5igg";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-92d27a34dea2e199fa9b687e3fff3a7d169b7b1c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/92d27a34dea2e199fa9b687e3fff3a7d169b7b1c";
          sha256 = "02ibqpbm9az4hwfk6k8ypaqwwbx92kw14lp28wsxywb0lp7hzbcd";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-30885182c981ab175d4d034db0f6f469898070ab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/30885182c981ab175d4d034db0f6f469898070ab";
          sha256 = "0dfh24f8g048vbj88vx0lvw48nq5dsamy5kva72ab1h7vw9hvpwb";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-f1aed619e28cb077fc83fac8c4c0383578356e40";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/f1aed619e28cb077fc83fac8c4c0383578356e40";
          sha256 = "0fjx1a0kvkj0677nc6h49phqlk0hsgkzbs401lmhj6b6cdc7hvzp";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-749045c69efb97c70d25d7463abba812e91f3a44";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/749045c69efb97c70d25d7463abba812e91f3a44";
          sha256 = "0ni1zlnp5xpxyzbax7v3mn20x35i69nsmch2sx322cs6dwb0ggbn";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-8590a5f561694770bdcd3f9b5c69dde6945028e8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/8590a5f561694770bdcd3f9b5c69dde6945028e8";
          sha256 = "1c60xin00q0d2gbyaiglxppn5hqwki616v5chzwyhlhf6aplwsh3";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-0abb51d2f102e00a4eefcf46ba7fec406d245825";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/0abb51d2f102e00a4eefcf46ba7fec406d245825";
          sha256 = "1z17f7465fn778ak68mzz5kg2ql1n6ghgqh3827n9mcipwbp4k58";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9a142215a36a3888e30d0a9eeea9766764e96976";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/9a142215a36a3888e30d0a9eeea9766764e96976";
          sha256 = "06ipbcvrxjzgvraf2z9fwgy0bzvzjvs5z1j67grg1gb15x3d428b";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-cc5db0e22b3cb4111010e48785a97f670b350ca5";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/cc5db0e22b3cb4111010e48785a97f670b350ca5";
          sha256 = "04z6fah8rn5b01w78j0vqa0jys4mvji66z4ql6wk1r1bf6j0048y";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-4407588e0d3f1f52efb65fbe92babe41f37fe50c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/4407588e0d3f1f52efb65fbe92babe41f37fe50c";
          sha256 = "187whknxl9rs0ddkjph6zmla5kh3k7w6hnvgfc44zig17jxsjdff";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-54e9d763759268e07eb13b921d8631fc2816206f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/54e9d763759268e07eb13b921d8631fc2816206f";
          sha256 = "01zkgmf4ypscdrpb0wk0fb593sm09xfdk8ah645xx38rsbf3hiy1";
        };
      };
    };
    "symfony/psr-http-message-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-psr-http-message-bridge-22b37c8a3f6b5d94e9cdbd88e1270d96e2f97b34";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/psr-http-message-bridge/zipball/22b37c8a3f6b5d94e9cdbd88e1270d96e2f97b34";
          sha256 = "18zvhrcry8173wklv3zpf8k06xx15smrw1dnj0zmq97injnam6fl";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-324f7f73b89cd30012575119430ccfb1dfbc24be";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/324f7f73b89cd30012575119430ccfb1dfbc24be";
          sha256 = "0lks9bscddqgwbljgrf4mvd948frvv2ckar4v8m3pdc8s9pajrw2";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/1ab11b933cd6bc5464b08e81e2c5b07dec58b0fc";
          sha256 = "0c1vq6jv2jc37i9m1ndpbv7g75blgvf1s44vk65nb1jdk3hrbrd1";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-dfe132c5c6d89f90ce7f961742cc532e9ca16dd4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/dfe132c5c6d89f90ce7f961742cc532e9ca16dd4";
          sha256 = "1w7m0x6i2r77h8w7sqhnaf4g52x6bb53mm4wbx70aljfahigk0l1";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-d28150f0f44ce854e942b671fc2620a98aae1b1e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/d28150f0f44ce854e942b671fc2620a98aae1b1e";
          sha256 = "0gwqxhrzb9dzsqvqr9lc3whzl8wwlfhwskr0wdwqri4pq5mspb2w";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-35237c5e5dcb6593a46a860ba5b29c1d4683d80e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/35237c5e5dcb6593a46a860ba5b29c1d4683d80e";
          sha256 = "0vqb4m5iqy0g9l4wh53f6w5fsf4lh1i3k7f7lisg5wvxlwfy4yjw";
        };
      };
    };
    "tecnickcom/tc-lib-barcode" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tecnickcom-tc-lib-barcode-a8a7183e2be6379e522dc825a3b7a3af5394a9e7";
        src = fetchurl {
          url = "https://api.github.com/repos/tecnickcom/tc-lib-barcode/zipball/a8a7183e2be6379e522dc825a3b7a3af5394a9e7";
          sha256 = "19b06fj7cin93xis03h62nm64rxmryyzi5rxpc4fi5z5i1q97702";
        };
      };
    };
    "tecnickcom/tc-lib-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tecnickcom-tc-lib-color-83cdb57fd900901c6aa2af8cfd67202518fb69b2";
        src = fetchurl {
          url = "https://api.github.com/repos/tecnickcom/tc-lib-color/zipball/83cdb57fd900901c6aa2af8cfd67202518fb69b2";
          sha256 = "1qs2j2288awzmrzkpbyswp1v8q83fk3fjmz1kzgdz38xxmff5sfp";
        };
      };
    };
    "tightenco/collect" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tightenco-collect-3a42ca9b730a88e942fe05180d4f15e045464e40";
        src = fetchurl {
          url = "https://api.github.com/repos/tighten/collect/zipball/3a42ca9b730a88e942fe05180d4f15e045464e40";
          sha256 = "0gs28b97v8ll6rr7yc2lwawkjzpigzadivr43idfs3hrc2jw37vv";
        };
      };
    };
    "tightenco/ziggy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tightenco-ziggy-82ea6ec6cb6ab3545b0245310b2a424316fe48d8";
        src = fetchurl {
          url = "https://api.github.com/repos/tighten/ziggy/zipball/82ea6ec6cb6ab3545b0245310b2a424316fe48d8";
          sha256 = "1mfiwvpd5jhs9lsg0bl3qm1spa25062cfilkn80f9la08gbry5fh";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-da444caae6aca7a19c0c140f68c6182e337d5b1c";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/da444caae6aca7a19c0c140f68c6182e337d5b1c";
          sha256 = "13lzhf1kswg626b8zd23z4pa7sg679si368wcg6pklqvijnn0any";
        };
      };
    };
    "unicodeveloper/laravel-password" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "unicodeveloper-laravel-password-806e345ae992e0adf38c4cfa32063d7d7c9d189a";
        src = fetchurl {
          url = "https://api.github.com/repos/unicodeveloper/laravel-password/zipball/806e345ae992e0adf38c4cfa32063d7d7c9d189a";
          sha256 = "1qd63zahc0mw7ypfghm2q1zfq1w3vr58zxh5gdgcx0srlg2v69gc";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-5b547cdb25825f10251370f57ba5d9d924e6f68e";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/5b547cdb25825f10251370f57ba5d9d924e6f68e";
          sha256 = "05a2d5dky62xq42qldhzxak6hf8734kjnpw3y9xhlvrg8ir4d8pv";
        };
      };
    };
    "watson/validating" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "watson-validating-b8731af37eade6b25aac1fcec5e90fdfdb9de5f5";
        src = fetchurl {
          url = "https://api.github.com/repos/dwightwatson/validating/zipball/b8731af37eade6b25aac1fcec5e90fdfdb9de5f5";
          sha256 = "1mhialmg9f8q1ka3nawgs6b0pzinb60c6n7vkml3226wpwcj9kq0";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-6964c76c7804814a842473e0c8fd15bab0f18e25";
        src = fetchurl {
          url = "https://api.github.com/repos/webmozarts/assert/zipball/6964c76c7804814a842473e0c8fd15bab0f18e25";
          sha256 = "17xqhb2wkwr7cgbl4xdjf7g1vkal17y79rpp6xjpf1xgl5vypc64";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "snipe-it";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-or-later";
  };
}

