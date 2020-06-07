{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "appstract/laravel-blade-directives" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "appstract-laravel-blade-directives-398d36a1c1f2740c81358b99473fd1564a81c406";
        src = fetchurl {
          url = https://api.github.com/repos/appstract/laravel-blade-directives/zipball/398d36a1c1f2740c81358b99473fd1564a81c406;
          sha256 = "0dhlkzm2yqqfyaj5amqfp3l98ba64dk7d9y7bss9ghiacp0ksbvi";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-e02575af8021ee57b818107c1fd8759110374044";
        src = fetchurl {
          url = https://api.github.com/repos/aws/aws-sdk-php/zipball/e02575af8021ee57b818107c1fd8759110374044;
          sha256 = "0gmrh2f49yv9113zlnk4swg9bjfqxh4k2hg9qhi7z8q78faxv4zj";
        };
      };
    };
    "cakephp/chronos" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cakephp-chronos-395110125ff577f080fa064dca5c5608a4e77ee1";
        src = fetchurl {
          url = https://api.github.com/repos/cakephp/chronos/zipball/395110125ff577f080fa064dca5c5608a4e77ee1;
          sha256 = "1mblmni7lf1yppcqljpi5qh91qq0qq3y5lkbik1smmrxq9x68qf6";
        };
      };
    };
    "dnoegel/php-xdg-base-dir" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dnoegel-php-xdg-base-dir-265b8593498b997dc2d31e75b89f053b5cc9621a";
        src = fetchurl {
          url = https://api.github.com/repos/dnoegel/php-xdg-base-dir/zipball/265b8593498b997dc2d31e75b89f053b5cc9621a;
          sha256 = "1xkzxi7j589ayvx1669qaybamravfawz6hc6im32v8vkkbng5kva";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-d768d58baee9a4862ca783840eca1b9add7a7f57";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/cache/zipball/d768d58baee9a4862ca783840eca1b9add7a7f57;
          sha256 = "1kljhw4gqp12iz88h6ymsrlfir2fis7icn6dffyizfc1csyb4s2i";
        };
      };
    };
    "doctrine/dbal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-dbal-5140a64c08b4b607b9bedaae0cedd26f04a0e621";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/5140a64c08b4b607b9bedaae0cedd26f04a0e621;
          sha256 = "1mffxinvs2v5kca18xn5nx1cqwclpndf9hdz5da4ldl916c91pjg";
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-a520bc093a0170feeb6b14e9d83f3a14452e64b3";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/event-manager/zipball/a520bc093a0170feeb6b14e9d83f3a14452e64b3;
          sha256 = "165cxvw4idqj01l63nya2whpdb3fz6ld54rx198b71bzwfrydl88";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-inflector-5527a48b7313d15261292c149e55e26eae771b0a";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/inflector/zipball/5527a48b7313d15261292c149e55e26eae771b0a;
          sha256 = "0ng6vlwjr8h6hqwa32ynykz1mhlfsff5hirjidlk086ab6njppa5";
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-lexer-83893c552fd2045dd78aef794c31e694c37c0b8c";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/lexer/zipball/83893c552fd2045dd78aef794c31e694c37c0b8c;
          sha256 = "0cyh3vwcl163cx1vrcwmhlh5jg9h47xwiqgzc6rwscxw0ppd1v74";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-92a2c3768d50e21a1f26a53cb795ce72806266c5";
        src = fetchurl {
          url = https://api.github.com/repos/dragonmantank/cron-expression/zipball/92a2c3768d50e21a1f26a53cb795ce72806266c5;
          sha256 = "08362fcipgbddw024spvbyrvdmip4nhgb9n2cq1ajgxnyv0jcphl";
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-0578b32b30b22de3e8664f797cf846fc9246f786";
        src = fetchurl {
          url = https://api.github.com/repos/egulias/EmailValidator/zipball/0578b32b30b22de3e8664f797cf846fc9246f786;
          sha256 = "0270g3pjiazvmddjb2zw70hb7kalvc5r6y7p1wgrvv8fag3v9377";
        };
      };
    };
    "erusev/parsedown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "erusev-parsedown-92e9c27ba0e74b8b028b111d1b6f956a15c01fc1";
        src = fetchurl {
          url = https://api.github.com/repos/erusev/parsedown/zipball/92e9c27ba0e74b8b028b111d1b6f956a15c01fc1;
          sha256 = "1v7n9niys176acs8cn9lh6qlwaw62hmsvm76384k6jg24c1pyp0k";
        };
      };
    };
    "fideloper/proxy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fideloper-proxy-cf8a0ca4b85659b9557e206c90110a6a4dba980a";
        src = fetchurl {
          url = https://api.github.com/repos/fideloper/TrustedProxy/zipball/cf8a0ca4b85659b9557e206c90110a6a4dba980a;
          sha256 = "0yiilhg9iz5fzsxp87s5wh42am13hzf0a6zpmx8blqg864n1g9cj";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-407b0cb880ace85c9b63c5f9551db498cb2d50ba";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/guzzle/zipball/407b0cb880ace85c9b63c5f9551db498cb2d50ba;
          sha256 = "19m6lgb0blhap3qiqm00slgfc1sc6lzqpbdk47fqg4xgcbn0ymmb";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-a59da6cf61d80060647ff4d3eb2c03a2bc694646";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/promises/zipball/a59da6cf61d80060647ff4d3eb2c03a2bc694646;
          sha256 = "1kpl91fzalcgkcs16lpakvzcnbkry3id4ynx6xhq477p4fipdciz";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-f5b8a8512e2b58b0071a7280e39f14f72e05d87c";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/f5b8a8512e2b58b0071a7280e39f14f72e05d87c;
          sha256 = "1l901gxwqwk034idjw8nvcq58a0f036wnpaxayv21chh6v4gjmr1";
        };
      };
    };
    "hashids/hashids" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "hashids-hashids-b6c61142bfe36d43740a5419d11c351dddac0458";
        src = fetchurl {
          url = https://api.github.com/repos/vinkla/hashids/zipball/b6c61142bfe36d43740a5419d11c351dddac0458;
          sha256 = "1nm0nsazyv6hgslhwbhfg8cd8ks3bv3rszzv9drlr8b9ahxkzb2j";
        };
      };
    };
    "igaster/laravel-theme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "igaster-laravel-theme-c0b93dfcfac3602d6d224ad79f76795f6918f4c1";
        src = fetchurl {
          url = https://api.github.com/repos/igaster/laravel-theme/zipball/c0b93dfcfac3602d6d224ad79f76795f6918f4c1;
          sha256 = "030a756pygf1vpnjnzl0yj3mywmkqx6vk58w63320grwxw78q466";
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
    "laracasts/utilities" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laracasts-utilities-298fb3c6f29901a4550c4f98b57c05f368341d04";
        src = fetchurl {
          url = https://api.github.com/repos/laracasts/PHP-Vars-To-Js-Transformer/zipball/298fb3c6f29901a4550c4f98b57c05f368341d04;
          sha256 = "0ig27kw5gbx6raq3x9lws47xdc7j8dgs8kqwc28a3z2k2b7hrhkv";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-ad6c1fe1e455c0f73a431928282704879ccbd856";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/framework/zipball/ad6c1fe1e455c0f73a431928282704879ccbd856;
          sha256 = "197smddclrhla0avn0fvpc1f86xky8apgpr1jbadllwmfjlghll3";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-cafbf598a90acde68985660e79b2b03c5609a405";
        src = fetchurl {
          url = https://api.github.com/repos/laravel/tinker/zipball/cafbf598a90acde68985660e79b2b03c5609a405;
          sha256 = "06aay28znsvinzjrxxqxhypgvdnhaj6dzf4l4si3zsiwpdwlhfhg";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-a63cc83d8a931b271be45148fa39ba7156782ffd";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/a63cc83d8a931b271be45148fa39ba7156782ffd;
          sha256 = "1w311hjs19zz7xwh5vzzwpk7iwaa1p9p6zl7c72vs7kyglsfn700";
        };
      };
    };
    "league/fractal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-fractal-a0b350824f22fc2fdde2500ce9d6851a3f275b0e";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/fractal/zipball/a0b350824f22fc2fdde2500ce9d6851a3f275b0e;
          sha256 = "16bw2q3byv60vk0ma91bz9iv4w843d5n9ydz24yh9b9yxfnfdfqh";
        };
      };
    };
    "lord/laroute" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lord-laroute-7242310f02ebc3f3d6a94b00db95ad0978b1802b";
        src = fetchurl {
          url = https://api.github.com/repos/aaronlord/laroute/zipball/7242310f02ebc3f3d6a94b00db95ad0978b1802b;
          sha256 = "18f86vv0na6xq9lpjfyzm6hwg6dsl1y2asr8rsm83immv8qgx0iz";
        };
      };
    };
    "matriphe/iso-639" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "matriphe-iso-639-0245d844daeefdd22a54b47103ffdb0e03c323e1";
        src = fetchurl {
          url = https://api.github.com/repos/matriphe/php-iso-639/zipball/0245d844daeefdd22a54b47103ffdb0e03c323e1;
          sha256 = "1g0b13al0rkcirydx228c6dnmn72n5q6h6ffrf5rk10k5if53nf5";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-bfc9ebb28f97e7a24c45bdc3f0ff482e47bb0266";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/bfc9ebb28f97e7a24c45bdc3f0ff482e47bb0266;
          sha256 = "0h3nnxjf2bdh7nmpqnpij99lqv6bw13r2bx83d8vn5zvblwg5png";
        };
      };
    };
    "mtdowling/jmespath.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mtdowling-jmespath.php-adcc9531682cf87dfda21e1fd5d0e7a41d292fac";
        src = fetchurl {
          url = https://api.github.com/repos/jmespath/jmespath.php/zipball/adcc9531682cf87dfda21e1fd5d0e7a41d292fac;
          sha256 = "11y5awyh0vyhv5k0qdirqhl5dbl2hyp5nh3v2q4bmbfxigcxi198";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-63da8cdf89d7a5efe43aabc794365f6e7b7b8983";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/63da8cdf89d7a5efe43aabc794365f6e7b7b8983;
          sha256 = "18gfrnqng1cr0ns5d01b7f3f2j0i3si422ljyyp98psg88dx8kbz";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-d0230c5c77a7e3cfa69446febf340978540958c0";
        src = fetchurl {
          url = https://api.github.com/repos/nikic/PHP-Parser/zipball/d0230c5c77a7e3cfa69446febf340978540958c0;
          sha256 = "08bhgbkvjz6fsasqbvlac8452z3rl9xsjmf0ipzw1kc81kp38w6g";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-d3209e46ad6c69a969b705df0738fd0dbe26ef9e";
        src = fetchurl {
          url = https://api.github.com/repos/opis/closure/zipball/d3209e46ad6c69a969b705df0738fd0dbe26ef9e;
          sha256 = "1x25cg1p71zzzy1772mrkbrkns5dmp0lmvsrg4nlw6mz1w8yx8gn";
        };
      };
    };
    "paragonie/constant_time_encoding" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-constant_time_encoding-eccf915f45f911bfb189d1d1638d940ec6ee6e33";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/constant_time_encoding/zipball/eccf915f45f911bfb189d1d1638d940ec6ee6e33;
          sha256 = "17rjm6fbzadpwq593xsq6nzhj3sfsxaccj6zxssn7j7da15zn728";
        };
      };
    };
    "paragonie/random_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-random_compat-29af24f25bab834fcbb38ad2a69fa93b867e070d";
        src = fetchurl {
          url = https://api.github.com/repos/paragonie/random_compat/zipball/29af24f25bab834fcbb38ad2a69fa93b867e070d;
          sha256 = "04a8zlxz5kw1m7ix18bhc34a0dfbxfkmqmw9f2v0aci2y3yclxqm";
        };
      };
    };
    "pragmarx/google2fa" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pragmarx-google2fa-17c969c82f427dd916afe4be50bafc6299aef1b4";
        src = fetchurl {
          url = https://api.github.com/repos/antonioribeiro/google2fa/zipball/17c969c82f427dd916afe4be50bafc6299aef1b4;
          sha256 = "1z6rjqqigw6v2rns2mgjy9y0addqhc05cl19j80z8nw03dschqib";
        };
      };
    };
    "predis/predis" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "predis-predis-f0210e38881631afeafb56ab43405a92cafd9fd1";
        src = fetchurl {
          url = https://api.github.com/repos/nrk/predis/zipball/f0210e38881631afeafb56ab43405a92cafd9fd1;
          sha256 = "0361alhpbzmi81d0maqd2wd61izf6jfqqdwqr05i02k047lfc6yp";
        };
      };
    };
    "prologue/alerts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "prologue-alerts-d3bf5d7ea480cbbf372bb7f80e23e193ce4862c7";
        src = fetchurl {
          url = https://api.github.com/repos/prologuephp/alerts/zipball/d3bf5d7ea480cbbf372bb7f80e23e193ce4862c7;
          sha256 = "1gydhxr5qy070mprl7w6xv0495wr89996n3h7kg7fns4ylc725hf";
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
        name = "psr-log-6c001f1daafa3a3ac1d8ff69ee4db8e799a654dd";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/log/zipball/6c001f1daafa3a3ac1d8ff69ee4db8e799a654dd;
          sha256 = "1i351p3gd1pgjcjxv7mwwkiw79f1xiqr38irq22156h05zlcx80d";
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
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psy-psysh-9aaf29575bb8293206bb0420c1e1c87ff2ffa94e";
        src = fetchurl {
          url = https://api.github.com/repos/bobthecow/psysh/zipball/9aaf29575bb8293206bb0420c1e1c87ff2ffa94e;
          sha256 = "1frmq783vhj8mk8rchid5rs8iz4i91hsmhzwyc58cvij2yd8a6ny";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-d09ea80159c1929d75b3f9c60504d613aeb4a1e3";
        src = fetchurl {
          url = https://api.github.com/repos/ramsey/uuid/zipball/d09ea80159c1929d75b3f9c60504d613aeb4a1e3;
          sha256 = "1hgnf32xy2cxfwihncmsndnxgkf2hhs6zjqnhyxdhwjyhv4apb67";
        };
      };
    };
    "s1lentium/iptools" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "s1lentium-iptools-f6f8ab6132ca7443bd7cced1681f5066d725fd5f";
        src = fetchurl {
          url = https://api.github.com/repos/S1lentium/IPTools/zipball/f6f8ab6132ca7443bd7cced1681f5066d725fd5f;
          sha256 = "1nmmkyna4yq4nl6i42br3p1zdxdgykayqf086vkdifrfihpw0wad";
        };
      };
    };
    "sofa/eloquence-base" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sofa-eloquence-base-e941b7ff79ca9c77ef540b5f14a7f82a3acea5ba";
        src = fetchurl {
          url = https://api.github.com/repos/jarektkaczyk/eloquence-base/zipball/e941b7ff79ca9c77ef540b5f14a7f82a3acea5ba;
          sha256 = "1hiz5w92pfx604pgnpm2bzixkscqwk20zc4yl068lcq3m17slbzl";
        };
      };
    };
    "sofa/eloquence-validable" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sofa-eloquence-validable-9d9ef65bf4a4952efb54b06ac0b04fc8893d5f95";
        src = fetchurl {
          url = https://api.github.com/repos/jarektkaczyk/eloquence-validable/zipball/9d9ef65bf4a4952efb54b06ac0b04fc8893d5f95;
          sha256 = "1nqf439f92smqwbny2q8h4cz5qbz4mxp6ax9h6nvs6mn5201fnwx";
        };
      };
    };
    "sofa/hookable" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sofa-hookable-c6f03e5e742d539755f8c7993ee96e907593a668";
        src = fetchurl {
          url = https://api.github.com/repos/jarektkaczyk/hookable/zipball/c6f03e5e742d539755f8c7993ee96e907593a668;
          sha256 = "0jvmgs5vkwx1qwv7vmyxzcc2ls8hfd5r6dapyxzw4j0bil96n8j7";
        };
      };
    };
    "spatie/fractalistic" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-fractalistic-5b5710b748beb2c1d5c272f4d3598d44b5b59fc9";
        src = fetchurl {
          url = https://api.github.com/repos/spatie/fractalistic/zipball/5b5710b748beb2c1d5c272f4d3598d44b5b59fc9;
          sha256 = "16ihh7vhkaglbmj5814vp4z9xn0zadsykjwwrxad10r097jsds4a";
        };
      };
    };
    "spatie/laravel-fractal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-fractal-2931881cac3155ceb798f2fd1e55bd152576682b";
        src = fetchurl {
          url = https://api.github.com/repos/spatie/laravel-fractal/zipball/2931881cac3155ceb798f2fd1e55bd152576682b;
          sha256 = "0s1fjlzxd6nlc3lqij10wngdkc9sd07pw3aacr4z7p020v2han4x";
        };
      };
    };
    "staudenmeir/belongs-to-through" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "staudenmeir-belongs-to-through-2ba1ff76353058d2b4d395e725617d97fd103ab0";
        src = fetchurl {
          url = https://api.github.com/repos/staudenmeir/belongs-to-through/zipball/2ba1ff76353058d2b4d395e725617d97fd103ab0;
          sha256 = "1fsvi5390b6q5gafm2mpfrpdy91bmfl5isr31m60ps2f6b3qfb9j";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8ddcb66ac10c392d3beb54829eef8ac1438595f4";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8ddcb66ac10c392d3beb54829eef8ac1438595f4;
          sha256 = "14mjwrrp8wnrw7si394z5kb0bxhz7gnqwa4lfgbipsrmf2clk4j3";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-432122af37d8cd52fba1b294b11976e0d20df595";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/432122af37d8cd52fba1b294b11976e0d20df595;
          sha256 = "0hn0qh33idhmf8qdjhd96skrzcfcxd4rdzixwnfg3x4h1vq1762a";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-d67de79a70a27d93c92c47f37ece958bf8de4d8a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/d67de79a70a27d93c92c47f37ece958bf8de4d8a;
          sha256 = "02azyvgkcw8j8r9plc2hknw4ypvbbnm9600gpkdcq92js5jhz1ns";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-19090917b848a799cbae4800abf740fe4eb71c1d";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/19090917b848a799cbae4800abf740fe4eb71c1d;
          sha256 = "19d7qg4p06p3vd2rsgz5516cgk41wdlgz6iz6752y9jjhlrwi65q";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-552541dad078c85d9414b09c041ede488b456cd5";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/552541dad078c85d9414b09c041ede488b456cd5;
          sha256 = "0y581dhirmfjl5bg3kcnd4rhqd487jjjwd1w3h2kbrlm61bwlh0k";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-1f17195b44543017a9c9b2d437c670627e96ad06";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/1f17195b44543017a9c9b2d437c670627e96ad06;
          sha256 = "1z29mmhhmnm7hn65wq63zhvffqc6rbmhgg4jgd355057rhs924rf";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-82d494c1492b0dd24bbc5c2d963fb02eb44491af";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/82d494c1492b0dd24bbc5c2d963fb02eb44491af;
          sha256 = "1m8i1vcfazpi7nb8m3qd1mchchxkdczlngfw7g7d3ccnhs3caqz3";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-958be64ab13b65172ad646ef5ae20364c2305fae";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-kernel/zipball/958be64ab13b65172ad646ef5ae20364c2305fae;
          sha256 = "1d675611lmg4nrhi98ws0n03hzf28ddy83268ywknibx6qx9pwix";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-e3d826245268269cd66f8326bd8bc066687b4a19";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/e3d826245268269cd66f8326bd8bc066687b4a19;
          sha256 = "16md0qmy5jvvl7lc6n6r5hxjdr5i30vl6n9rpkm4b11rh2nqh7mh";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-c79c051f5b3a46be09205c73b80b346e4153e494";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/c79c051f5b3a46be09205c73b80b346e4153e494;
          sha256 = "18v2777cky55ah6xi4dh383mp4iddwzmnvx81qd86y1kgfykwhpi";
        };
      };
    };
    "symfony/polyfill-php56" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php56-ff208829fe1aa48ab9af356992bb7199fed551af";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php56/zipball/ff208829fe1aa48ab9af356992bb7199fed551af;
          sha256 = "0vmpiwakc7hpbr6jwpk7cqcy41ybgwl6jkn3q8c4ryxynknn5hfk";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-9050816e2ca34a8e916c3a0ae8b9c2fccf68b631";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php72/zipball/9050816e2ca34a8e916c3a0ae8b9c2fccf68b631;
          sha256 = "1smd08fw64mf89s9ma099ayfjlz26wrix9hfr6kh5w4d0rzrhmlw";
        };
      };
    };
    "symfony/polyfill-util" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-util-3b58903eae668d348a7126f999b0da0f2f93611c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-util/zipball/3b58903eae668d348a7126f999b0da0f2f93611c;
          sha256 = "00bb5mgljk6d54nyvd4gmc7mbzfr4b4q7h3rxmv8rzq613wcjp3i";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-3e83acef94d979b1de946599ef86b3a352abcdc9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/3e83acef94d979b1de946599ef86b3a352abcdc9;
          sha256 = "107g2z1mx7d5is0lyiv9nqpk4kyg4q4fihj5lr29dqisvpxcrp3b";
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-routing-d4a3c14cfbe6b9c05a1d6e948654022d4d1ad3fd";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/routing/zipball/d4a3c14cfbe6b9c05a1d6e948654022d4d1ad3fd;
          sha256 = "05yvdsbiy7yvgjhvqdfshiry0dnwd82gf3rqp7q46725w9yhg7l1";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-aa04dc1c75b7d3da7bd7003104cd0cfc5dff635c";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/aa04dc1c75b7d3da7bd7003104cd0cfc5dff635c;
          sha256 = "1ds10hd9az1m52jjih6bcpbas1hrhhdghlkmr5qfp41ghd4dfyvp";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-60319b45653580b0cdacca499344577d87732f16";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/var-dumper/zipball/60319b45653580b0cdacca499344577d87732f16;
          sha256 = "1gszisq7mlix4ry4z3nrmjzj80awmbhpaf1v4kmqa97nhy77yyc8";
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-0ed4a2ea4e0902dac0489e6436ebcd5bbcae9757";
        src = fetchurl {
          url = https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/0ed4a2ea4e0902dac0489e6436ebcd5bbcae9757;
          sha256 = "183pchgj3sccybj12dvd0a13vw92gjrs0gwwxcv4xl5r8nb7w1si";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-8abb4f9aa89ddea9d52112c65bbe8d0125e2fa8e";
        src = fetchurl {
          url = https://api.github.com/repos/vlucas/phpdotenv/zipball/8abb4f9aa89ddea9d52112c65bbe8d0125e2fa8e;
          sha256 = "09d7v9r6ylii60440isdc3x8lf966f2994sbvi6brpn9dl7synqp";
        };
      };
    };
    "webmozart/assert" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "webmozart-assert-0df1908962e7a3071564e857d86874dad1ef204a";
        src = fetchurl {
          url = https://api.github.com/repos/webmozart/assert/zipball/0df1908962e7a3071564e857d86874dad1ef204a;
          sha256 = "05rl9l3in5lm7g574g1w3yadf3dxf6xvj64cw2whv8zbjv2pb7w2";
        };
      };
    };
  };
  devPackages = {
    "barryvdh/laravel-debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-debugbar-9d5caf43c5f3a3aea2178942f281054805872e7c";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/laravel-debugbar/zipball/9d5caf43c5f3a3aea2178942f281054805872e7c;
          sha256 = "1v4r7iljzza5534lazkc4by6i7knpnhaxzdbm341hky39f7rgxd9";
        };
      };
    };
    "barryvdh/laravel-ide-helper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-ide-helper-981ff45b43e0cf808af0a5a5f40f6369e0e29499";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/laravel-ide-helper/zipball/981ff45b43e0cf808af0a5a5f40f6369e0e29499;
          sha256 = "155jck1qvm9jffr2npxj2gvg2inl1chxmfcif3f3iykcr3sq09wj";
        };
      };
    };
    "barryvdh/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-reflection-docblock-64165bd4ba9a550d11ea57569463b7c722dc6b0a";
        src = fetchurl {
          url = https://api.github.com/repos/barryvdh/ReflectionDocBlock/zipball/64165bd4ba9a550d11ea57569463b7c722dc6b0a;
          sha256 = "07s25ck4996pagbzni9w2w08570z2lircl8wlak4dkdfvns6xq3p";
        };
      };
    };
    "codedungeon/php-cli-colors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "codedungeon-php-cli-colors-5649ef76ec0c9ed626e95bf40fdfaf4b8efcf79b";
        src = fetchurl {
          url = https://api.github.com/repos/mikeerickson/php-cli-colors/zipball/5649ef76ec0c9ed626e95bf40fdfaf4b8efcf79b;
          sha256 = "0j15m1wx8fvrnm5ijxkvj39v512qbyzsfgr0i17lylx9im0cap3q";
        };
      };
    };
    "codedungeon/phpunit-result-printer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "codedungeon-phpunit-result-printer-aac73dbc502e70d42059d74a5aced6911982797b";
        src = fetchurl {
          url = https://api.github.com/repos/mikeerickson/phpunit-pretty-result-printer/zipball/aac73dbc502e70d42059d74a5aced6911982797b;
          sha256 = "0vmj76jl0zywz16ah8kzqdjizvqm833sn7bigcg7ib9lvqzdq2mw";
        };
      };
    };
    "composer/ca-bundle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-ca-bundle-8afa52cd417f4ec417b4bfe86b68106538a87660";
        src = fetchurl {
          url = https://api.github.com/repos/composer/ca-bundle/zipball/8afa52cd417f4ec417b4bfe86b68106538a87660;
          sha256 = "18b0gq29frjf4yhl4sl3i3zbz6zr3qjgsjb8cjdhz65vpb50581p";
        };
      };
    };
    "composer/composer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-composer-e965b9aaa8854c3067f1ed2ae45f436572d73eb7";
        src = fetchurl {
          url = https://api.github.com/repos/composer/composer/zipball/e965b9aaa8854c3067f1ed2ae45f436572d73eb7;
          sha256 = "1yf8viv5mc633r5v77c8j0cw8k88wv0nnvjh54fsjzyfwyf29gz3";
        };
      };
    };
    "composer/semver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-semver-c7cb9a2095a074d131b65a8a0cd294479d785573";
        src = fetchurl {
          url = https://api.github.com/repos/composer/semver/zipball/c7cb9a2095a074d131b65a8a0cd294479d785573;
          sha256 = "0rk0xrimzip9zzf5mivdb16yg6wkzv06fipx7aq4iaphcgjqj32j";
        };
      };
    };
    "composer/spdx-licenses" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-spdx-licenses-7a9556b22bd9d4df7cad89876b00af58ef20d3a2";
        src = fetchurl {
          url = https://api.github.com/repos/composer/spdx-licenses/zipball/7a9556b22bd9d4df7cad89876b00af58ef20d3a2;
          sha256 = "1iil1yq763yzqvkv6nyx6m19d875z0x3y0n11fsh3rckkgb93v04";
        };
      };
    };
    "composer/xdebug-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "composer-xdebug-handler-b8e9745fb9b06ea6664d8872c4505fb16df4611c";
        src = fetchurl {
          url = https://api.github.com/repos/composer/xdebug-handler/zipball/b8e9745fb9b06ea6664d8872c4505fb16df4611c;
          sha256 = "0pl8c0xg9x8aipn0kqk3yw024r0q1d9p5yvdkjskzviiad9k6z95";
        };
      };
    };
    "doctrine/annotations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-annotations-c7f2050c68a9ab0bdb0f98567ec08d80ea7d24d5";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/annotations/zipball/c7f2050c68a9ab0bdb0f98567ec08d80ea7d24d5;
          sha256 = "0b80xpqd3j99xgm0c41kbgy0k6knrfnd29223c93295sb12112g7";
        };
      };
    };
    "doctrine/instantiator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-instantiator-185b8868aa9bf7159f5f953ed5afb2d7fcdc3bda";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/instantiator/zipball/185b8868aa9bf7159f5f953ed5afb2d7fcdc3bda;
          sha256 = "1mah9a6mb30qad1zryzjain2dxw29d8h4bjkbcs3srpm3p891msy";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-bc0fd11bc455cc20ee4b5edabc63ebbf859324c7";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/bc0fd11bc455cc20ee4b5edabc63ebbf859324c7;
          sha256 = "0bc9czyqxfpp9bdyxk2av18aii1x4n6g92jik87zm47y3yxmlmfv";
        };
      };
    };
    "friendsofphp/php-cs-fixer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "friendsofphp-php-cs-fixer-20064511ab796593a3990669eff5f5b535001f7c";
        src = fetchurl {
          url = https://api.github.com/repos/FriendsOfPHP/PHP-CS-Fixer/zipball/20064511ab796593a3990669eff5f5b535001f7c;
          sha256 = "016jyjjhn0g2963cf92vsl0f2py6g286wgyx1r2787g9sw379ck6";
        };
      };
    };
    "fzaninotto/faker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fzaninotto-faker-f72816b43e74063c8b10357394b6bba8cb1c10de";
        src = fetchurl {
          url = https://api.github.com/repos/fzaninotto/Faker/zipball/f72816b43e74063c8b10357394b6bba8cb1c10de;
          sha256 = "18dlb13c7ablzad7ixjsydig1z2zmgd8jvjk3az8y2k7496yqxb6";
        };
      };
    };
    "hamcrest/hamcrest-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "hamcrest-hamcrest-php-776503d3a8e85d4f9a1148614f95b7a608b046ad";
        src = fetchurl {
          url = https://api.github.com/repos/hamcrest/hamcrest-php/zipball/776503d3a8e85d4f9a1148614f95b7a608b046ad;
          sha256 = "12f2xsamhcksxcma4yzmm4clmhms1lz2aw4391zmb7y6agpwvjma";
        };
      };
    };
    "hassankhan/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "hassankhan-config-06ac500348af033f1a2e44dc357ca86282626d4a";
        src = fetchurl {
          url = https://api.github.com/repos/hassankhan/config/zipball/06ac500348af033f1a2e44dc357ca86282626d4a;
          sha256 = "1f1fa69d719v1nxa08qzvranz0sqqrbhlwjhsz8iy56342v821i5";
        };
      };
    };
    "justinrainbow/json-schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "justinrainbow-json-schema-8560d4314577199ba51bf2032f02cd1315587c23";
        src = fetchurl {
          url = https://api.github.com/repos/justinrainbow/json-schema/zipball/8560d4314577199ba51bf2032f02cd1315587c23;
          sha256 = "1bp1f41sskfa83w4nqwa5lmls5drz60l1632l8w2icqbp7rlk0li";
        };
      };
    };
    "maximebf/debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maximebf-debugbar-30e7d60937ee5f1320975ca9bc7bcdd44d500f07";
        src = fetchurl {
          url = https://api.github.com/repos/maximebf/php-debugbar/zipball/30e7d60937ee5f1320975ca9bc7bcdd44d500f07;
          sha256 = "1k6ikxp05h8lvq9xs3jgl14qb7ff0sbs0zj8af1r2rnp9wkg802m";
        };
      };
    };
    "mockery/mockery" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mockery-mockery-100633629bf76d57430b86b7098cd6beb996a35a";
        src = fetchurl {
          url = https://api.github.com/repos/mockery/mockery/zipball/100633629bf76d57430b86b7098cd6beb996a35a;
          sha256 = "15pb8wspks5lm8ff66fnsj8wagyqi9gw94w6n3pl1kvhd70jkiyr";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-3e01bdad3e18354c3dce54466b7fbe33a9f9f7f8";
        src = fetchurl {
          url = https://api.github.com/repos/myclabs/DeepCopy/zipball/3e01bdad3e18354c3dce54466b7fbe33a9f9f7f8;
          sha256 = "08hiywin4rfnh3a7pfz71w4743rgkj4p8mipcbwh7p5avannw7la";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-b5feb0c0d92978ec7169232ce5d70d6da6b29f63";
        src = fetchurl {
          url = https://api.github.com/repos/nunomaduro/collision/zipball/b5feb0c0d92978ec7169232ce5d70d6da6b29f63;
          sha256 = "0vfy1m3hiaccn9ki7vlrkwwj2zyp3xbzmynllzr3i9n68apzqldx";
        };
      };
    };
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-7761fcacf03b4d4f16e7ccb606d4879ca431fcf4";
        src = fetchurl {
          url = https://api.github.com/repos/phar-io/manifest/zipball/7761fcacf03b4d4f16e7ccb606d4879ca431fcf4;
          sha256 = "1n59a0gnk43ryl54bc37hlsi1spvi8280bq64zddxrpagyjyp15a";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-45a2ec53a73c70ce41d55cedef9063630abaf1b6";
        src = fetchurl {
          url = https://api.github.com/repos/phar-io/version/zipball/45a2ec53a73c70ce41d55cedef9063630abaf1b6;
          sha256 = "0syr7v2b3lsdavfa22z55sdkg5awc3jlzpgn0qk0d3vf6x96hvzp";
        };
      };
    };
    "php-cs-fixer/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-cs-fixer-diff-78bb099e9c16361126c86ce82ec4405ebab8e756";
        src = fetchurl {
          url = https://api.github.com/repos/PHP-CS-Fixer/diff/zipball/78bb099e9c16361126c86ce82ec4405ebab8e756;
          sha256 = "082w79q2bipw5iibpw6whihnz2zafljh5bgpfs4qdxmz25n8g00l";
        };
      };
    };
    "php-mock/php-mock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-mock-php-mock-22d297231118e6fd5b9db087fbe1ef866c2b95d2";
        src = fetchurl {
          url = https://api.github.com/repos/php-mock/php-mock/zipball/22d297231118e6fd5b9db087fbe1ef866c2b95d2;
          sha256 = "082fxh988ygxpr3dk5rra3qy80paivjvpd1yv5cax7xbyvxjrify";
        };
      };
    };
    "php-mock/php-mock-integration" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-mock-php-mock-integration-5a0d7d7755f823bc2a230cfa45058b40f9013bc4";
        src = fetchurl {
          url = https://api.github.com/repos/php-mock/php-mock-integration/zipball/5a0d7d7755f823bc2a230cfa45058b40f9013bc4;
          sha256 = "006q0fw6mv82s6fyj8vhvmj7d5ammn08q05pg3sj1lvvwjmp6f69";
        };
      };
    };
    "php-mock/php-mock-phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-mock-php-mock-phpunit-57b92e621f14c2c07a4567cd29ed4e87de0d2912";
        src = fetchurl {
          url = https://api.github.com/repos/php-mock/php-mock-phpunit/zipball/57b92e621f14c2c07a4567cd29ed4e87de0d2912;
          sha256 = "1h1pgzhiqazv4qpyanjami2hw5cfdg1yplkl95fva65yk2952vvk";
        };
      };
    };
    "phpdocumentor/reflection-common" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-common-21bdeb5f65d7ebf9f43b1b25d404f87deab5bfb6";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionCommon/zipball/21bdeb5f65d7ebf9f43b1b25d404f87deab5bfb6;
          sha256 = "1yaf1zg9lnkfnq2ndpviv0hg5bza9vjvv5l4wgcn25lx1p8a94w2";
        };
      };
    };
    "phpdocumentor/reflection-docblock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-reflection-docblock-94fd0001232e47129dd3504189fa1c7225010d08";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/94fd0001232e47129dd3504189fa1c7225010d08;
          sha256 = "03zvxqb5n9ddvysj8mjdwf59h7sagj5x5z15nhs7mqpcky1w388x";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-9c977708995954784726e25d0cd1dddf4e65b0f7";
        src = fetchurl {
          url = https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/9c977708995954784726e25d0cd1dddf4e65b0f7;
          sha256 = "0h888r2iy2290yp9i3fij8wd5b7960yi7yn1rwh26x1xxd83n2mb";
        };
      };
    };
    "phpspec/prophecy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpspec-prophecy-4ba436b55987b4bf311cb7c6ba82aa528aac0a06";
        src = fetchurl {
          url = https://api.github.com/repos/phpspec/prophecy/zipball/4ba436b55987b4bf311cb7c6ba82aa528aac0a06;
          sha256 = "0sz9fg8r4yvpgrhsh6qaic3p89pafdj8bdf4izbcccq6mdhclxn6";
        };
      };
    };
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-807e6013b00af69b6c5d9ceb4282d0393dbb9d8d";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/807e6013b00af69b6c5d9ceb4282d0393dbb9d8d;
          sha256 = "04l5piavahvxp5j3f6s1cx85b3lnjidnlw3nixk24nwqx4bdfk10";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-050bedf145a257b1ff02746c31894800e5122946";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/050bedf145a257b1ff02746c31894800e5122946;
          sha256 = "0b5y1dmksnzqps694h1bhw6r6w1cqrf3vhw2k00adjdawjzaa00j";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-31f8b717e51d9a2afca6c9f046f5d69fc27c8686";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/31f8b717e51d9a2afca6c9f046f5d69fc27c8686;
          sha256 = "1y03m38qqvsbvyakd72v4dram81dw3swyn5jpss153i5nmqr4p76";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-8b8454ea6958c3dee38453d3bd571e023108c91f";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-timer/zipball/8b8454ea6958c3dee38453d3bd571e023108c91f;
          sha256 = "0bdmv1ixlf2dd9b0cgk8sj1yy886hcnd0iiakkmr0vq0p8xh5vk6";
        };
      };
    };
    "phpunit/php-token-stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-token-stream-c99e3be9d3e85f60646f152f9002d46ed7770d18";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/php-token-stream/zipball/c99e3be9d3e85f60646f152f9002d46ed7770d18;
          sha256 = "0q6gbyfjn7rlhw263maxw2smqlr9aivcgaa1npbp6zybck2s9zdd";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-b1be2c8530c4c29c3519a052c9fb6cee55053bbd";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/phpunit/zipball/b1be2c8530c4c29c3519a052c9fb6cee55053bbd;
          sha256 = "15z0048plskpp8brc6klvsyfjgwrd3575c1630ybqg027sl60hk5";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-4419fcdb5eabb9caa61a27c7a1db532a6b55dd18";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/4419fcdb5eabb9caa61a27c7a1db532a6b55dd18;
          sha256 = "0n0bygv2vx1l7af8szbcbn5bpr4axrgvkzd0m348m8ckmk8akvs8";
        };
      };
    };
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-5de4fc177adf9bce8df98d8d141a7559d7ccf6da";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/comparator/zipball/5de4fc177adf9bce8df98d8d141a7559d7ccf6da;
          sha256 = "1kf0w51kj4whak8cdmplhj3vsvpj71bl0k3dyz197vvh83ghvl2i";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-366541b989927187c4ca70490a35615d3fef2dce";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/diff/zipball/366541b989927187c4ca70490a35615d3fef2dce;
          sha256 = "1a6nbci2a7rsqrra1jwj53nch6lrx13yj0hl6l1bahxnn2yav0cp";
        };
      };
    };
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-febd209a219cea7b56ad799b30ebbea34b71eb8f";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/environment/zipball/febd209a219cea7b56ad799b30ebbea34b71eb8f;
          sha256 = "140hkamig1z846l1ralcq7d1yzgfinspzlfg1l8dgkgwy7197d2c";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-234199f4528de6d12aaa58b612e98f7d36adb937";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/exporter/zipball/234199f4528de6d12aaa58b612e98f7d36adb937;
          sha256 = "061rkix1dws8wbjggf6c8s3kjjv3ws1yacg70zp7cc5wk3z1ar8y";
        };
      };
    };
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-e8ba02eed7bbbb9e59e43dedd3dddeff4a56b0c4";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/global-state/zipball/e8ba02eed7bbbb9e59e43dedd3dddeff4a56b0c4;
          sha256 = "1489kfvz0gg6jprakr43mjkminlhpsimcdrrxkmsm6mmhahbgjnf";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-7cfd9e65d11ffb5af41198476395774d4c8a84c5";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/7cfd9e65d11ffb5af41198476395774d4c8a84c5;
          sha256 = "00z5wzh19z1drnh52d27gflqm7dyisp96c29zyxrgsdccv1wss3m";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-773f97c67f28de00d397be301821b06708fca0be";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/773f97c67f28de00d397be301821b06708fca0be;
          sha256 = "1rq5wwf7smdbbz3mj46hmjc643bbsm2b6cnnggmawyls479qmxlk";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-5b0cd723502bac3b006cbf3dbf7a1e3fcefe4fa8";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/5b0cd723502bac3b006cbf3dbf7a1e3fcefe4fa8;
          sha256 = "0p4j54bxriciw67g7l8zy1wa472di0b8f8mxs4fdvm37asz2s6vd";
        };
      };
    };
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-4d7a795d35b889bf80a0cc04e08d77cedfa917a9";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/4d7a795d35b889bf80a0cc04e08d77cedfa917a9;
          sha256 = "0prnq9hvg1bi3nkms21wl0fr0f28p0mhp5w802sqb05v9k0qnb41";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-99732be0ddb3361e16ad77b68ba41efc8e979019";
        src = fetchurl {
          url = https://api.github.com/repos/sebastianbergmann/version/zipball/99732be0ddb3361e16ad77b68ba41efc8e979019;
          sha256 = "0wrw5hskz2hg5aph9r1fhnngfrcvhws1pgs0lfrwindy066z6fj7";
        };
      };
    };
    "seld/jsonlint" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-jsonlint-d15f59a67ff805a44c50ea0516d2341740f81a38";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/jsonlint/zipball/d15f59a67ff805a44c50ea0516d2341740f81a38;
          sha256 = "1yd37g3c9gjk6d0qpd12xrlgd9mfvndv69h41n6fasvr1ags4ya1";
        };
      };
    };
    "seld/phar-utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "seld-phar-utils-7009b5139491975ef6486545a39f3e6dad5ac30a";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/phar-utils/zipball/7009b5139491975ef6486545a39f3e6dad5ac30a;
          sha256 = "02hwq5j88sqnj19ya9k0bxh1nslpkgf5n50vsmyjgnsi9xlkf75j";
        };
      };
    };
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-fd7bd6535beb1f0a0a9e3ee960666d0598546981";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/filesystem/zipball/fd7bd6535beb1f0a0a9e3ee960666d0598546981;
          sha256 = "042wfgl0n4nb7jsdq0yjf7ar4rsk8c318zb62pv0zadbrryh8zb3";
        };
      };
    };
    "symfony/options-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-options-resolver-40f0e40d37c1c8a762334618dea597d64bbb75ff";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/options-resolver/zipball/40f0e40d37c1c8a762334618dea597d64bbb75ff;
          sha256 = "0k904sxnwj52knirrccjwkwpvg86xq88gpmn9gwqhn24d0zxwh2q";
        };
      };
    };
    "symfony/polyfill-php70" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php70-6b88000cdd431cd2e940caa2cb569201f3f84224";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php70/zipball/6b88000cdd431cd2e940caa2cb569201f3f84224;
          sha256 = "08h77r1i2q4pwdd0yk3pfhqqgk0z7gwmkzmvykx9bfv1z7a0h8ik";
        };
      };
    };
    "symfony/stopwatch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-stopwatch-5bfc064125b73ff81229e19381ce1c34d3416f4b";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/stopwatch/zipball/5bfc064125b73ff81229e19381ce1c34d3416f4b;
          sha256 = "061fvpk4gl4y7xsjdcy46q08ym56psnn8zc5vfmfwqqgw9frbw3f";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-367e689b2fdc19965be435337b50bc8adf2746c9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/yaml/zipball/367e689b2fdc19965be435337b50bc8adf2746c9;
          sha256 = "1bji72v10q6k65wdmrrkwqpwamin63gyqxa2mz0lc8f41q9bpi2v";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-cb2f008f3f05af2893a87208fe6a6c4985483f8b";
        src = fetchurl {
          url = https://api.github.com/repos/theseer/tokenizer/zipball/cb2f008f3f05af2893a87208fe6a6c4985483f8b;
          sha256 = "0jpr12k9rjvx223vxy5m3shdvlimyk2r4s332bcq6bn2nfw5wnnb";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "pterodactyl-panel";
  src = fetchTarball {
    url = "https://github.com/pterodactyl/panel/releases/download/v0.7.17/panel.tar.gz";
    sha256 = "0zlddr9cahaxmww6zwqgfpcn57nd02az36x0430hjkggdmv8d3lr";
  };
  executable = false;
  symlinkDependencies = false;
}