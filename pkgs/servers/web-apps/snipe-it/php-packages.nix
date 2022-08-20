{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "alek13/slack" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "alek13-slack-9222449402df4e1e57d7850be87898b2c99803bd";
        src = fetchurl {
          url = "https://api.github.com/repos/php-slack/slack/zipball/9222449402df4e1e57d7850be87898b2c99803bd";
          sha256 = "02kxal8066rlq4002qf36yfq8i3pafrrlbspqbvh3vxhnzzj2f2k";
        };
      };
    };
    "arietimmerman/laravel-scim-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "arietimmerman-laravel-scim-server-d0e3d7c0b5da2ec76283b8a2fa2e672a91596509";
        src = fetchurl {
          url = "https://api.github.com/repos/grokability/laravel-scim-server/zipball/d0e3d7c0b5da2ec76283b8a2fa2e672a91596509";
          sha256 = "0xznsbdph32q1nx5ibl90gfqa7j0bj0ikcvz8hfpxxk967k1ayfj";
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
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-crt-php-3942776a8c99209908ee0b287746263725685732";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/3942776a8c99209908ee0b287746263725685732";
          sha256 = "0g4vjln6s1419ydljn5m64kzid0b7cplbc0nwn3y4cj72408fyiz";
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "aws-aws-sdk-php-8f8742caa42b260950320c98ddc5da4926e2373d";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/8f8742caa42b260950320c98ddc5da4926e2373d";
          sha256 = "0z87ncxqvcs6bjp1b0dw1gib0f1k35sxzag8vzcd4ssh9n1m29gm";
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-d70c840f68657ce49094b8d91f9ee0cc07fbf66c";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/d70c840f68657ce49094b8d91f9ee0cc07fbf66c";
          sha256 = "0k2z8a6qz5xg1p85vwcp58yqbiw8bmnp3hg2pjcaqlimnf65v058";
        };
      };
    };
    "barryvdh/laravel-debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-debugbar-3372ed65e6d2039d663ed19aa699956f9d346271";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-debugbar/zipball/3372ed65e6d2039d663ed19aa699956f9d346271";
          sha256 = "08ll8z25mbq21q8gxdlgdb0pymx7z3xxc1la68m879l5r2ddhi05";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "barryvdh-laravel-dompdf-1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
          sha256 = "0xvaq6mp9s8nxlpfisa50fr8rjb6vmivxdbr985q9vydadh1dsv2";
        };
      };
    };
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brick-math-ca57d18f028f84f777b2168cd1911b0dee2343ae";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/ca57d18f028f84f777b2168cd1911b0dee2343ae";
          sha256 = "1nr1grrb9g5g3ihx94yk0amp8zx8prkkvg2934ygfc3rrv03cq9w";
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dasprid-enum-5abf82f213618696dda8e3bf6f64dd042d8542b2";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/5abf82f213618696dda8e3bf6f64dd042d8542b2";
          sha256 = "0rs7i1xiwhssy88s7bwnp5ri5fi2xy3fl7pw6l5k27xf2f1hv7q6";
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
    "dflydev/dot-access-data" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-dot-access-data-0992cc19268b259a39e86f296da5f0677841f42c";
        src = fetchurl {
          url = "https://api.github.com/repos/dflydev/dflydev-dot-access-data/zipball/0992cc19268b259a39e86f296da5f0677841f42c";
          sha256 = "0qdf1gbfkj7vjqhn7m99s1gpjkj2crqrqh1wzpdzyz27izgjgsyw";
        };
      };
    };
    "doctrine/annotations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-annotations-648b0343343565c4a056bfc8392201385e8d89f0";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/annotations/zipball/648b0343343565c4a056bfc8392201385e8d89f0";
          sha256 = "0mkxq1yaqp6an2gjcgsmg7hq37mrwcj27f94sfkfxq9x6qh02k57";
        };
      };
    };
    "doctrine/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-cache-56cd022adb5514472cb144c087393c1821911d09";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/cache/zipball/56cd022adb5514472cb144c087393c1821911d09";
          sha256 = "1ri5pwrnq8pxjv8ljscvlaqzjj7ii87420af4dq133qm35jn4ffr";
        };
      };
    };
    "doctrine/collections" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-collections-1958a744696c6bb3bb0d28db2611dc11610e78af";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/collections/zipball/1958a744696c6bb3bb0d28db2611dc11610e78af";
          sha256 = "0ygsw2vgrkz1wd9aw6gd8y6kjwxq9bjqcp3dgdx0p8w9mz7bdpm5";
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
        name = "doctrine-dbal-9f79d4650430b582f4598fe0954ef4d52fbc0a8a";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/9f79d4650430b582f4598fe0954ef4d52fbc0a8a";
          sha256 = "0jf1whbf0d5kizrlzdm29ld5lrk4fgmayr239vyl2dmdzzxyvkhf";
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-deprecations-0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
          sha256 = "1sk1f020n0w7p7r4rsi7wnww85vljrim1i5h9wb0qiz2c4l8jj09";
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
        name = "doctrine-instantiator-10dcfce151b967d20fde1b34ae6640712c3891bc";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/instantiator/zipball/10dcfce151b967d20fde1b34ae6640712c3891bc";
          sha256 = "1m6pw3bb8v04wqsysj8ma4db8vpm9jnd7ddh8ihdqyfpz8pawjp7";
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
        name = "doctrine-reflection-1034e5e71f89978b80f9c1570e7226f6c3b9b6fb";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/reflection/zipball/1034e5e71f89978b80f9c1570e7226f6c3b9b6fb";
          sha256 = "08n0m6z8b66b0v8awl1w8s8ncg61sa25273ba42fbjmn24b3h6mp";
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dompdf-dompdf-79573d8b8a141ec8a17312515de8740eed014fa9";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/79573d8b8a141ec8a17312515de8740eed014fa9";
          sha256 = "0glv4fhzk674jgk1v9rkhb4859x5h1aspr63qdn7ajls27c582l5";
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dragonmantank-cron-expression-be85b3f05b46c39bbc0d95f6c071ddff669510fa";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/be85b3f05b46c39bbc0d95f6c071ddff669510fa";
          sha256 = "09k5cj8bay6jkphjl5ngfx7qb17dxnlvpf6918a9ms8am731s2a6";
        };
      };
    };
    "eduardokum/laravel-mail-auto-embed" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "eduardokum-laravel-mail-auto-embed-ea098444590521d574c84a37ed732c92b840d5b4";
        src = fetchurl {
          url = "https://api.github.com/repos/eduardokum/laravel-mail-auto-embed/zipball/ea098444590521d574c84a37ed732c92b840d5b4";
          sha256 = "1amqglrskwx9lfdl06k5j0inz3j41lbr0kmq6hjxx1gia0ddh91f";
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
    "ezyang/htmlpurifier" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ezyang-htmlpurifier-12ab42bd6e742c70c0a52f7b82477fcd44e64b75";
        src = fetchurl {
          url = "https://api.github.com/repos/ezyang/htmlpurifier/zipball/12ab42bd6e742c70c0a52f7b82477fcd44e64b75";
          sha256 = "168kkjcq1w9vdnly5k72qc8jb8amdcmax9wja0xwfh926gb6dpz7";
        };
      };
    };
    "facade/flare-client-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-flare-client-php-b2adf1512755637d0cef4f7d1b54301325ac78ed";
        src = fetchurl {
          url = "https://api.github.com/repos/facade/flare-client-php/zipball/b2adf1512755637d0cef4f7d1b54301325ac78ed";
          sha256 = "10yqn1bi4q6mp89g16d02dc7crxdigjxyvax973fdnmxnvafl0cb";
        };
      };
    };
    "facade/ignition" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-6acd82e986a2ecee89e2e68adfc30a1936d1ab7c";
        src = fetchurl {
          url = "https://api.github.com/repos/facade/ignition/zipball/6acd82e986a2ecee89e2e68adfc30a1936d1ab7c";
          sha256 = "1mxn6kqwbgd3vs36ckwydpx7kvjky6fvnhmbvn0c2zp0hsliq7rw";
        };
      };
    };
    "facade/ignition-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "facade-ignition-contracts-3c921a1cdba35b68a7f0ccffc6dffc1995b18267";
        src = fetchurl {
          url = "https://api.github.com/repos/facade/ignition-contracts/zipball/3c921a1cdba35b68a7f0ccffc6dffc1995b18267";
          sha256 = "1nsjwd1k9q8qmfvh7m50rs42yxzxyq4f56r6dq205gwcmqsjb2j0";
        };
      };
    };
    "fideloper/proxy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fideloper-proxy-a751f2bc86dd8e6cfef12dc0cbdada82f5a18750";
        src = fetchurl {
          url = "https://api.github.com/repos/fideloper/TrustedProxy/zipball/a751f2bc86dd8e6cfef12dc0cbdada82f5a18750";
          sha256 = "11whawpjkiphdfpfwm5c2v3finc3apl9gp8b4lwq76370i41plcf";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-a63e5e8f26ebbebf8ed3c5c691637325512eb0dc";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/a63e5e8f26ebbebf8ed3c5c691637325512eb0dc";
          sha256 = "0hc9zfh3i7br30831grccm4wny9dllpswhaw8hdn988mvg5xrdy0";
        };
      };
    };
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-018dfc4e1da92ad8a1b90adc4893f476a3b41cb8";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/018dfc4e1da92ad8a1b90adc4893f476a3b41cb8";
          sha256 = "1jzri64bl3hiwah9nk3yq8nfjfn4z0xb0znp1dwh65qzjy54f0jh";
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
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "graham-campbell-result-type-0690bde05318336c7221785f2a932467f98b64ca";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/0690bde05318336c7221785f2a932467f98b64ca";
          sha256 = "0a6kj3vxmhr1wh2kggmrl6y41hkg19jc0iq8qw095lf11mr4bd83";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-1dd98b0564cb3f6bd16ce683cb755f94c10fbd82";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/1dd98b0564cb3f6bd16ce683cb755f94c10fbd82";
          sha256 = "0a8491bb72y61r3ghqn32kabsj8rxhj9pddnkkr14x3wbc10zfr4";
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-promises-fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/fe752aedc9fd8fcca3fe7ad05d419d32998a06da";
          sha256 = "09ivi77y49bpc2sy3xhvgq22rfh2fhv921mn8402dv0a8bdprf56";
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-psr7-13388f00956b1503577598873fffb5ae994b5737";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/13388f00956b1503577598873fffb5ae994b5737";
          sha256 = "05vc1q903nxfg11y9mcnlg253lm5d81jjg6wv76hjiwx8m47lbac";
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
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-96aecced5126d48e277e5339193c376fe82b6565";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/96aecced5126d48e277e5339193c376fe82b6565";
          sha256 = "1s4bcjpfsjafqigj28xbwa3bycs2cd1h4jnbpn9c9zj87w4smhzm";
        };
      };
    };
    "laravel/helpers" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-helpers-c28b0ccd799d58564c41a62395ac9511a1e72931";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/helpers/zipball/c28b0ccd799d58564c41a62395ac9511a1e72931";
          sha256 = "0s9ppwkwl5c1gp1bd12fvb2k1n77h0qj5vl4c88i325y5fcfgvnb";
        };
      };
    };
    "laravel/passport" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-passport-b62b418a6d9e9aca231a587be0fc14dc55cd8d77";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/passport/zipball/b62b418a6d9e9aca231a587be0fc14dc55cd8d77";
          sha256 = "139yqi5561cqzn35g336hf6m0gffcn4ixvmks7wz9kv4f0f336vn";
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-serializable-closure-09f0e9fb61829f628205b7c94906c28740ff9540";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/09f0e9fb61829f628205b7c94906c28740ff9540";
          sha256 = "1b0kdx0cs43ci4pyhhv874k5i0k42iiizz1mz0f6wk8lpzhk0r6r";
        };
      };
    };
    "laravel/slack-notification-channel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-slack-notification-channel-060617a31562c88656c95c5971a36989122d4b53";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/slack-notification-channel/zipball/060617a31562c88656c95c5971a36989122d4b53";
          sha256 = "1b2hw28aqb805ac5w7knm9myrgyh40aqw9njyzmvsr2jrphjwgr4";
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-tinker-dff39b661e827dae6e092412f976658df82dbac5";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/dff39b661e827dae6e092412f976658df82dbac5";
          sha256 = "0az4n99pfrhrnr7diwi656f8y9qbynxzdw25md29ji8bw0isbc6d";
        };
      };
    };
    "laravel/ui" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-ui-65ec5c03f7fee2c8ecae785795b829a15be48c2c";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/ui/zipball/65ec5c03f7fee2c8ecae785795b829a15be48c2c";
          sha256 = "0hr8kkbxvxxidnw86r1i92938wajhskv68zjn1627h1i16b10ysm";
        };
      };
    };
    "laravelcollective/html" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravelcollective-html-78c3cb516ac9e6d3d76cad9191f81d217302dea6";
        src = fetchurl {
          url = "https://api.github.com/repos/LaravelCollective/html/zipball/78c3cb516ac9e6d3d76cad9191f81d217302dea6";
          sha256 = "14nm7wzlp8hz0ja1xhs10nhci3bq9ss73jpavbs0qazipfpc38sn";
        };
      };
    };
    "lcobucci/clock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lcobucci-clock-353d83fe2e6ae95745b16b3d911813df6a05bfb3";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/clock/zipball/353d83fe2e6ae95745b16b3d911813df6a05bfb3";
          sha256 = "18jdhd0jl5sqy5qkg2kjlrwyilyd80mck9gcpwa9xm7il9s9lf8m";
        };
      };
    };
    "lcobucci/jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "lcobucci-jwt-fe2d89f2eaa7087af4aa166c6f480ef04e000582";
        src = fetchurl {
          url = "https://api.github.com/repos/lcobucci/jwt/zipball/fe2d89f2eaa7087af4aa166c6f480ef04e000582";
          sha256 = "04rm6gfjlhxfllhmppx2fmxl8knflcxz6ss12y4lisg938xgm187";
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-commonmark-155ec1c95626b16fda0889cf15904d24890a60d5";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/155ec1c95626b16fda0889cf15904d24890a60d5";
          sha256 = "1bl4f0s6adgilly5yivcyg6ya42f173vc734518vjrdmzzh1wk2m";
        };
      };
    };
    "league/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-config-a9d39eeeb6cc49d10a6e6c36f22c4c1f4a767f3e";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/config/zipball/a9d39eeeb6cc49d10a6e6c36f22c4c1f4a767f3e";
          sha256 = "0mwqf6pdapgbxcry328kl9974awjmnv491c6ryirw74lqkapw2bn";
        };
      };
    };
    "league/csv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-csv-9d2e0265c5d90f5dd601bc65ff717e05cec19b47";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/csv/zipball/9d2e0265c5d90f5dd601bc65ff717e05cec19b47";
          sha256 = "0mcngirl2r8aw7hgbwaq3hrkkib4xwvhngijdhrkdzg4hj6ii3ap";
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
        name = "league-flysystem-094defdb4a7001845300334e7c1ee2335925ef99";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/094defdb4a7001845300334e7c1ee2335925ef99";
          sha256 = "0dn71b1pwikbwz1cmmz9k1fc8k1fsmah3gy8sqxbz7czhqn5qiva";
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-aws-s3-v3-af286f291ebab6877bac0c359c6c2cb017eb061d";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/af286f291ebab6877bac0c359c6c2cb017eb061d";
          sha256 = "1dyj1cvf2pbvkdw9i53qg6lycxv0di85qnjzcvy5lphrxambifxy";
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
        name = "league-mime-type-detection-ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
          sha256 = "1a63nvqd6cz3vck3y8vjswn6c3cfwh13p0cn0ci5pqdf0bgjvvfz";
        };
      };
    };
    "league/oauth2-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-server-7aeb7c42b463b1a6fe4d084d3145e2fa22436876";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-server/zipball/7aeb7c42b463b1a6fe4d084d3145e2fa22436876";
          sha256 = "08fla005m5w3cvcivsi8x5jbxgyx814xhh9jmx6kcxrbwcpw2cpf";
        };
      };
    };
    "league/uri" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-2d7c87a0860f3126a39f44a8a9bf2fed402dcfea";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri/zipball/2d7c87a0860f3126a39f44a8a9bf2fed402dcfea";
          sha256 = "1cibnnh81jvkn28050scyldnzbshqhy5464gqmdfw0ar1a6bz545";
        };
      };
    };
    "league/uri-interfaces" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-uri-interfaces-00e7e2943f76d8cb50c7dfdc2f6dee356e15e383";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri-interfaces/zipball/00e7e2943f76d8cb50c7dfdc2f6dee356e15e383";
          sha256 = "01jllf6n9fs4yjcf6sjc4ivqp7k7dkqhbpz354bq9mr14njsjv6x";
        };
      };
    };
    "livewire/livewire" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "livewire-livewire-020ad095cf1239138b097d22b584e2701ec3edfb";
        src = fetchurl {
          url = "https://api.github.com/repos/livewire/livewire/zipball/020ad095cf1239138b097d22b584e2701ec3edfb";
          sha256 = "0kklhhk351fbw38dw810si3gpzppjnm8hn9f6h8arxhcgxc8vnx7";
        };
      };
    };
    "maatwebsite/excel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maatwebsite-excel-8a54972e3d616c74687c3cbff15765555761885c";
        src = fetchurl {
          url = "https://api.github.com/repos/SpartnerNL/Laravel-Excel/zipball/8a54972e3d616c74687c3cbff15765555761885c";
          sha256 = "0h49x9aagq4wi05fymwhknvi16gl0na1xgi2cp9vlhy5ncrmpxy2";
        };
      };
    };
    "maennchen/zipstream-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maennchen-zipstream-php-211e9ba1530ea5260b45d90c9ea252f56ec52729";
        src = fetchurl {
          url = "https://api.github.com/repos/maennchen/ZipStream-PHP/zipball/211e9ba1530ea5260b45d90c9ea252f56ec52729";
          sha256 = "02llnd0f72lmqhn84ggv2kkdk6968bg29wv196386dabf7ilq4wg";
        };
      };
    };
    "markbaker/complex" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "markbaker-complex-ab8bc271e404909db09ff2d5ffa1e538085c0f22";
        src = fetchurl {
          url = "https://api.github.com/repos/MarkBaker/PHPComplex/zipball/ab8bc271e404909db09ff2d5ffa1e538085c0f22";
          sha256 = "1zgy7bz25a6wa4f0m9q3ax38a3dfzv8cz2mfcppf3znb2mxs8w5y";
        };
      };
    };
    "markbaker/matrix" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "markbaker-matrix-c66aefcafb4f6c269510e9ac46b82619a904c576";
        src = fetchurl {
          url = "https://api.github.com/repos/MarkBaker/PHPMatrix/zipball/c66aefcafb4f6c269510e9ac46b82619a904c576";
          sha256 = "0vfa7phvjkgsfplpxd3s2h00c28hy389yig29bmcpxlfk008vicn";
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "masterminds-html5-f640ac1bdddff06ea333a920c95bbad8872429ab";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/f640ac1bdddff06ea333a920c95bbad8872429ab";
          sha256 = "1v9sn44z710wha5jrzy0alx1ayj3d0fcin1xpx6c6fdhlksbqc6z";
        };
      };
    };
    "maximebf/debugbar" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "maximebf-debugbar-0d44b75f3b5d6d41ae83b79c7a4bceae7fbc78b6";
        src = fetchurl {
          url = "https://api.github.com/repos/maximebf/php-debugbar/zipball/0d44b75f3b5d6d41ae83b79c7a4bceae7fbc78b6";
          sha256 = "02g3kz29pgf31q2q7zmm2w999n4bncm6336bh0ixv8v9vl1mssd4";
        };
      };
    };
    "mediconesystems/livewire-datatables" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mediconesystems-livewire-datatables-bf6f24d529208e6bdec58276e92792719c73c827";
        src = fetchurl {
          url = "https://api.github.com/repos/MedicOneSystems/livewire-datatables/zipball/bf6f24d529208e6bdec58276e92792719c73c827";
          sha256 = "0pdr1ax3735f2147w6bz843rrfjnrr57z6355xkdax9a16zvc0lm";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-5579edf28aee1190a798bfa5be8bc16c563bd524";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/5579edf28aee1190a798bfa5be8bc16c563bd524";
          sha256 = "014sys8bv57jbpag7xlc7vplc1qy4h5jppy258hpr0xfbh27cg3w";
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
    "myclabs/php-enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-php-enum-b942d263c641ddb5190929ff840c68f78713e937";
        src = fetchurl {
          url = "https://api.github.com/repos/myclabs/php-enum/zipball/b942d263c641ddb5190929ff840c68f78713e937";
          sha256 = "16123l5459sjbmnz5nx68x8kpq5mc7miz95q4sjvancpb1dgl8d3";
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
        name = "nesbot-carbon-a9000603ea337c8df16cc41f8b6be95a65f4d0f5";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/a9000603ea337c8df16cc41f8b6be95a65f4d0f5";
          sha256 = "0rjlq01108i309q9lyfv0vvb9vmsnqy5ylk9h8wvhd7916vw3jnc";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-9a39cef03a5b34c7de64f551538cbba05c2be5df";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/9a39cef03a5b34c7de64f551538cbba05c2be5df";
          sha256 = "1kr5lai6r1l6w85ck64b1cq9cp0r2kwa10i1xcmlc7q0xlrxwhp2";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-0af4e3de4df9f1543534beab255ccf459e7a2c99";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/0af4e3de4df9f1543534beab255ccf459e7a2c99";
          sha256 = "0pmcgx3h3bl02sdqvhb9ap548ldxnhl3051imqss2yd64fkxf5fj";
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-php-parser-34bea19b6e03d8153165d8f30bba4c3be86184c1";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/34bea19b6e03d8153165d8f30bba4c3be86184c1";
          sha256 = "1yj97j9cdx48566qwjl5q8hkjkrd1xl59aczb1scspxay37l9w72";
        };
      };
    };
    "nunomaduro/collision" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-collision-8b610eef8582ccdc05d8f2ab23305e2d37049461";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/collision/zipball/8b610eef8582ccdc05d8f2ab23305e2d37049461";
          sha256 = "0w559vqpknkl6fbhz5hnkc9g37ydcyrqx82w3kjl88vmjycd1f61";
        };
      };
    };
    "nyholm/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nyholm-psr7-f734364e38a876a23be4d906a2a089e1315be18a";
        src = fetchurl {
          url = "https://api.github.com/repos/Nyholm/psr7/zipball/f734364e38a876a23be4d906a2a089e1315be18a";
          sha256 = "0w8i5l1qg8dkc1zsyz1gpwn2awgkhlm295l1b8smmzabqdc65dcx";
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
        name = "phenx-php-svg-lib-4498b5df7b08e8469f0f8279651ea5de9626ed02";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/4498b5df7b08e8469f0f8279651ea5de9626ed02";
          sha256 = "01w65haq96sfyjl8ahm9nb95wasgl66ymv5lycx1cbagy653xdin";
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
        name = "phpdocumentor-reflection-docblock-622548b623e81ca6d78b721c5e029f4ce664f170";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/ReflectionDocBlock/zipball/622548b623e81ca6d78b721c5e029f4ce664f170";
          sha256 = "1vs0fhpqk8s9bc0sqyfhpbs63q14lfjg1f0c1dw4jz97145j6r1n";
        };
      };
    };
    "phpdocumentor/type-resolver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpdocumentor-type-resolver-77a32518733312af16a44300404e945338981de3";
        src = fetchurl {
          url = "https://api.github.com/repos/phpDocumentor/TypeResolver/zipball/77a32518733312af16a44300404e945338981de3";
          sha256 = "0y6byv5psmrcy6ga7nghzblv61rjbni046h0pgjda8r8qmz26yr4";
        };
      };
    };
    "phpoffice/phpspreadsheet" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpoffice-phpspreadsheet-69991111e05fca3ff7398e1e7fca9ebed33efec6";
        src = fetchurl {
          url = "https://api.github.com/repos/PHPOffice/PhpSpreadsheet/zipball/69991111e05fca3ff7398e1e7fca9ebed33efec6";
          sha256 = "091g479mzh4w057m6v7xpn8i8l8k4abvvyd9l51c2sf7mskjz1n0";
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
        name = "phpseclib-phpseclib-2f0b7af658cbea265cbb4a791d6c29a6613f98ef";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/2f0b7af658cbea265cbb4a791d6c29a6613f98ef";
          sha256 = "08azglzhm6j821p5w3nb61ny7gz4lgj5kdmr1f1h723f8sjjwmfs";
        };
      };
    };
    "phpspec/prophecy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpspec-prophecy-bbcd7380b0ebf3961ee21409db7b38bc31d69a13";
        src = fetchurl {
          url = "https://api.github.com/repos/phpspec/prophecy/zipball/bbcd7380b0ebf3961ee21409db7b38bc31d69a13";
          sha256 = "1xw7x12lws8qdrryhbgjiih48gxwlq99ayhhsy0q2ls9i9p6mw0w";
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
        name = "psr-container-513e0666f7216c7459170d56df27dfcefe1689ea";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/513e0666f7216c7459170d56df27dfcefe1689ea";
          sha256 = "00yvj3b5ls2l1d0sk38g065raw837rw65dx1sicggjnkr85vmfzz";
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
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
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
        name = "psy-psysh-77fc7270031fbc28f9a7bea31385da5c4855cb7a";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/77fc7270031fbc28f9a7bea31385da5c4855cb7a";
          sha256 = "058wlfpslslxh59844ybwk2knplfxd67mc9k4gia3vmakc2n7ysb";
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
        name = "ramsey-collection-cccc74ee5e328031b15640b51056ee8d3bb66c0a";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/cccc74ee5e328031b15640b51056ee8d3bb66c0a";
          sha256 = "1i2ga25aj80cci3di58qm17l588lzgank8wqhdbq0dcb3cg6cgr6";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ramsey-uuid-fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
          sha256 = "1fhjsyidsj95x5dd42z3hi5qhzii0hhhxa7xvc5jj7spqjdbqln4";
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
        name = "rollbar-rollbar-laravel-d7647ffabf234beabfd0239ffaca003d934653b4";
        src = fetchurl {
          url = "https://api.github.com/repos/rollbar/rollbar-php-laravel/zipball/d7647ffabf234beabfd0239ffaca003d934653b4";
          sha256 = "0jm70pqhzdczrwzq4m7vxcwkzj1fcjn4r19qjpawvbsw4ldlcdg7";
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
    "sebastian/comparator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-comparator-55f4261989e546dc112258c7a75935a81a7ce382";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/comparator/zipball/55f4261989e546dc112258c7a75935a81a7ce382";
          sha256 = "1d4bgf4m2x0kn3nw9hbb45asbx22lsp9vxl74rp1yl3sj2vk9sch";
        };
      };
    };
    "sebastian/diff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-diff-3461e3fccc7cfdfc2720be910d3bd73c69be590d";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/diff/zipball/3461e3fccc7cfdfc2720be910d3bd73c69be590d";
          sha256 = "0967nl6cdnr0v0z83w4xy59agn60kfv8gb41aw3fpy1n2wpp62dj";
        };
      };
    };
    "sebastian/exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-exporter-65e8b7db476c5dd267e65eea9cab77584d3cfff9";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/exporter/zipball/65e8b7db476c5dd267e65eea9cab77584d3cfff9";
          sha256 = "071813jw7nlsa3fs1hlrkl5fsjz4sidyq0i26p22m43isvvyad0q";
        };
      };
    };
    "sebastian/recursion-context" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-recursion-context-cd9d8cf3c5804de4341c283ed787f099f5506172";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/recursion-context/zipball/cd9d8cf3c5804de4341c283ed787f099f5506172";
          sha256 = "1k0ki1krwq6329vsbw3515wsyg8a7n2l83lk19pdc12i2lg9nhpy";
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
        name = "spatie-laravel-backup-332fae80b12cacb9e4161824ba195d984b28c8fb";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-backup/zipball/332fae80b12cacb9e4161824ba195d984b28c8fb";
          sha256 = "02gcsv825zhw727bphrykp7lg7nhna7a2pzc20pnchkl9qbb6pnj";
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
        name = "squizlabs-php_codesniffer-1359e176e9307e906dc3d890bcc9603ff6d90619";
        src = fetchurl {
          url = "https://api.github.com/repos/squizlabs/PHP_CodeSniffer/zipball/1359e176e9307e906dc3d890bcc9603ff6d90619";
          sha256 = "0bgb02zirxg0swfil3hacp7ry4cv5rwnbjkrj4l3hqln97cvmn21";
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
        name = "symfony-console-4d671ab4ddac94ee439ea73649c69d9d200b5000";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/4d671ab4ddac94ee439ea73649c69d9d200b5000";
          sha256 = "13p16qi328f7jds94vh2gswpq2zgkh99zr7x0ihvy9ysmdc4vln2";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-0628e6c6d7c92f1a7bae543959bdc17347be2436";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/0628e6c6d7c92f1a7bae543959bdc17347be2436";
          sha256 = "1piyal7jg8sslxn4h4znrl1fsppbv2ik2s99i5na8wyq6wpz9zp4";
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-deprecation-contracts-e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
          sha256 = "09k869asjb7cd3xh8i5ps824k5y6v510sbpzfalndwy3knig9fig";
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-error-handler-c116cda1f51c678782768dce89a45f13c949455d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c116cda1f51c678782768dce89a45f13c949455d";
          sha256 = "16bvys7dkhja7bjf42k7rxd7d96fbsp1aj3n50a6b6fj3q2jkxwm";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-8e6ce1cc0279e3ff3c8ff0f43813bc88d21ca1bc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/8e6ce1cc0279e3ff3c8ff0f43813bc88d21ca1bc";
          sha256 = "10vdzpy7gvmy0w4lpr4h4xj2gr224k5llc7f356x1jzbijxg8ckh";
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-contracts-f98b54df6ad059855739db6fcbc2d36995283fe1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/f98b54df6ad059855739db6fcbc2d36995283fe1";
          sha256 = "114zpsd8vac016a0ppf5ag5lmgllrha7nwln8vvhq9282r79xhsl";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-9b630f3427f3ebe7cd346c277a1408b00249dad9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/9b630f3427f3ebe7cd346c277a1408b00249dad9";
          sha256 = "0b2rdx4080jav1ixqxrl4mabn91amf81xsj533b067vdfq4rcfv4";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-e7793b7906f72a8cc51054fbca9dcff7a8af1c1e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/e7793b7906f72a8cc51054fbca9dcff7a8af1c1e";
          sha256 = "1wd6ja7wfc6gkmbvpvlmg1d2fbnscnqsx5m2c2qzfnr64pm8wnxm";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-255ae3b0a488d78fbb34da23d3e0c059874b5948";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/255ae3b0a488d78fbb34da23d3e0c059874b5948";
          sha256 = "0mjkq7badxnrwh8f7xwrpgxsaikb2zb9pf2576v5g3mj4ipf8m2b";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-02265e1e5111c3cd7480387af25e82378b7ab9cc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/02265e1e5111c3cd7480387af25e82378b7ab9cc";
          sha256 = "0fm8smz4y87igkwl7sgp05xzxknbsjb16qma6v6k543ba8p46fzy";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-6fd1b9a79f6e3cf65f9e679b23af304cd9e010d4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/6fd1b9a79f6e3cf65f9e679b23af304cd9e010d4";
          sha256 = "18235xiqpjx9nzx3pzylm5yzqr6n1j8wnnrzgab1hpbvixfrbqba";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-143f1881e655bebca1312722af8068de235ae5dc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/143f1881e655bebca1312722af8068de235ae5dc";
          sha256 = "19v4r40vx62a181l6zfs7n40w9f7npy7jw5x6dssg40hl4a0i3p2";
        };
      };
    };
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-433d05519ce6990bf3530fba6957499d327395c2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/433d05519ce6990bf3530fba6957499d327395c2";
          sha256 = "11169jh39mhr591b61iara8hvq4pnfzgkynlqg90iv510c74d1cg";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-59a8d271f00dd0e4c2e518104cc7963f655a1aa8";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/59a8d271f00dd0e4c2e518104cc7963f655a1aa8";
          sha256 = "1bcdl48ji0dmswwvw2b66qxdxxawbx8bgicc02la92gacps08n5v";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-219aa369ceff116e673852dce47c3a41794c14bd";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/219aa369ceff116e673852dce47c3a41794c14bd";
          sha256 = "1cwckrazq4p4i9ysjh8wjqw8qfnp0rx48pkwysch6z7vkgcif22w";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-9344f9cb97f3b19424af1a21a3b0e75b0a7d8d7e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/9344f9cb97f3b19424af1a21a3b0e75b0a7d8d7e";
          sha256 = "0y289x91c9lgr8vlixj5blayf9lsgi4nn2gyn3a99brvn2jnh6q8";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-bf44a9fd41feaac72b074de600314a93e2ae78e2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/bf44a9fd41feaac72b074de600314a93e2ae78e2";
          sha256 = "11knb688wcf8yvrprgp4z02z3nb6s5xj3wrv77n2qjkc7nc8q7l7";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-e440d35fa0286f77fb45b79a03fedbeda9307e85";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/e440d35fa0286f77fb45b79a03fedbeda9307e85";
          sha256 = "1c7w7j375a1fxq5m4ldy72jg5x4dpijs8q9ryqxvd6gmj1lvncqy";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-cfa0ae98841b9e461207c13ab093d76b0fa7bace";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/cfa0ae98841b9e461207c13ab093d76b0fa7bace";
          sha256 = "1kbh4j01kxxc39ls9kzkg7dj13cdlzwy599b96harisysn47jw2n";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-13f6d1271c663dc5ae9fb843a8f16521db7687a1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/13f6d1271c663dc5ae9fb843a8f16521db7687a1";
          sha256 = "01dqzkdppaw7kh1vkckkzn54aql4iw6m9vyg99ahhzmqc2krs91x";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-597f3fff8e3e91836bb0bd38f5718b56ddbde2f3";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/597f3fff8e3e91836bb0bd38f5718b56ddbde2f3";
          sha256 = "1vv2xwk3cvr144yxjj6k4afhkv50v2b957lscncs6m3rvi2zs1nk";
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
        name = "symfony-routing-e07817bb6244ea33ef5ad31abc4a9288bef3f2f7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/e07817bb6244ea33ef5ad31abc4a9288bef3f2f7";
          sha256 = "1lk7dbcxvfwmyx65hm0v78ma79f67jnq2xnzg6k0wz52161rk6cl";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
          sha256 = "0lh0vxy0h4wsjmnlf42s950bicsvkzz6brqikfnfb5kmvi0xhcm6";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-4432bc7df82a554b3e413a8570ce2fea90e94097";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/4432bc7df82a554b3e413a8570ce2fea90e94097";
          sha256 = "08abxmddl3nphkqf6a58r8w1d5la2f3m9rkbhdfv2k78h2nn19v7";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-1639abc1177d26bcd4320e535e664cef067ab0ca";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/1639abc1177d26bcd4320e535e664cef067ab0ca";
          sha256 = "0q7f4hfv8n7px5fhh0f8ii6lbfj9xp7fas5ls7yazm4980c06a1x";
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-contracts-136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
          sha256 = "1z1514i3gsxdisyayzh880i8rj954qim7c183cld91kvvqcqi7x0";
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-dumper-af52239a330fafd192c773795520dc2dd62b5657";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/af52239a330fafd192c773795520dc2dd62b5657";
          sha256 = "1dxmwyg3wxq313zfrjwywkfsi38lq6i3prq69f47vbiqajfs55jn";
        };
      };
    };
    "tecnickcom/tc-lib-barcode" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tecnickcom-tc-lib-barcode-4907ef1e384dbb7d3100c897925e7dc071a419a3";
        src = fetchurl {
          url = "https://api.github.com/repos/tecnickcom/tc-lib-barcode/zipball/4907ef1e384dbb7d3100c897925e7dc071a419a3";
          sha256 = "1wwrws42lh60zmx7d49dqwlli09j1q6m1669cdlya907icx6cxbd";
        };
      };
    };
    "tecnickcom/tc-lib-color" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tecnickcom-tc-lib-color-f9e45c59496418227184626ad31e83470153c11f";
        src = fetchurl {
          url = "https://api.github.com/repos/tecnickcom/tc-lib-color/zipball/f9e45c59496418227184626ad31e83470153c11f";
          sha256 = "04g9fkk4ifc8sj27jz3nj6rnqgfyls6b2p1ll59wm9d99rngyq72";
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
    "tmilos/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tmilos-lexer-e7885595614759f1da2ff79b66e3fb26d7f875fa";
        src = fetchurl {
          url = "https://api.github.com/repos/tmilos/lexer/zipball/e7885595614759f1da2ff79b66e3fb26d7f875fa";
          sha256 = "0b1dysgnfph13xcc04kvi0kncsq63q1kw973q5ichwl4h9w5qfdk";
        };
      };
    };
    "tmilos/scim-filter-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tmilos-scim-filter-parser-cfd9ba1f33e1e15adcab2481bffd74cb9fb35704";
        src = fetchurl {
          url = "https://api.github.com/repos/tmilos/scim-filter-parser/zipball/cfd9ba1f33e1e15adcab2481bffd74cb9fb35704";
          sha256 = "08vp7p7jbzarmq1dlsiy7wb5klqp6ln8iidhnhq9xcqa1frrfj87";
        };
      };
    };
    "tmilos/scim-schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tmilos-scim-schema-bb871e667b33080b4cd36d7a9b2ac2cdbf796062";
        src = fetchurl {
          url = "https://api.github.com/repos/tmilos/scim-schema/zipball/bb871e667b33080b4cd36d7a9b2ac2cdbf796062";
          sha256 = "0k78qica59y2cmad17qcww6gm0caqa1shvv73scgyf0fxzqpay8w";
        };
      };
    };
    "tmilos/value" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tmilos-value-9e78ad9c026b14cacec1a27552ee0ada9d7d1c06";
        src = fetchurl {
          url = "https://api.github.com/repos/tmilos/value/zipball/9e78ad9c026b14cacec1a27552ee0ada9d7d1c06";
          sha256 = "1lbmm5l0q8mn2qs9jczqk1lc72m77455b3dv774fdfpy8vm2d7iy";
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
        name = "vlucas-phpdotenv-264dce589e7ce37a7ba99cb901eed8249fbec92f";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/264dce589e7ce37a7ba99cb901eed8249fbec92f";
          sha256 = "0z2q376k3rww8qb9jdywm3fj386pqmcx7rg6msd3zdrjxfbqcqnl";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "voku-portable-ascii-87337c91b9dfacee02452244ee14ab3c43bc485a";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/87337c91b9dfacee02452244ee14ab3c43bc485a";
          sha256 = "1j2xpbv7xiwxwb6gfc3h6imc6xcbyb2jw3h8wgfnpvjl5yfbi4xb";
        };
      };
    };
    "watson/validating" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "watson-validating-fda4daaf804ead4aef641e1fb3f3b40a8448167e";
        src = fetchurl {
          url = "https://api.github.com/repos/dwightwatson/validating/zipball/fda4daaf804ead4aef641e1fb3f3b40a8448167e";
          sha256 = "00i2k7q0n62yy20k6p09j7hwbxxwq1n15gprsp4rl9wbagwwx4m9";
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
  name = "snipe-it";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-or-later";
  };
}

