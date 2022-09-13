{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "alchemy/binary-driver" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "alchemy-binary-driver-e0615cdff315e6b4b05ada67906df6262a020d22";
        src = fetchurl {
          url = "https://api.github.com/repos/alchemy-fr/BinaryDriver/zipball/e0615cdff315e6b4b05ada67906df6262a020d22";
          sha256 = "1xfxillfyyvfhc3h4q5rsgip7d6x5xj959pchvx1mr18wl9yzpcv";
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
        name = "aws-aws-sdk-php-53b7f43945b19bb0700c75d4c5f130055096e817";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/53b7f43945b19bb0700c75d4c5f130055096e817";
          sha256 = "1k8igmxzy84kgy97i5fxn8k9dkh19sf3v6zk9g216asfas13dvjd";
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
    "beyondcode/laravel-websockets" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "beyondcode-laravel-websockets-f0649b65fb5562d20eff66f61716ef98717e228a";
        src = fetchurl {
          url = "https://api.github.com/repos/beyondcode/laravel-websockets/zipball/f0649b65fb5562d20eff66f61716ef98717e228a";
          sha256 = "193qgg91ds6b5bvxqr9vvmmwsykinblki31492q57rybbgj2acb3";
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
    "buzz/laravel-h-captcha" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "buzz-laravel-h-captcha-502a4a15953cde6e0a17df6fec1459a565504d9b";
        src = fetchurl {
          url = "https://api.github.com/repos/thinhbuzz/laravel-h-captcha/zipball/502a4a15953cde6e0a17df6fec1459a565504d9b";
          sha256 = "1ki38b3cjxgydn3845d9a7zrxdiqmdq5ahsl7r3nwcf0m0xj9yby";
        };
      };
    };
    "cboden/ratchet" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "cboden-ratchet-5012dc954541b40c5599d286fd40653f5716a38f";
        src = fetchurl {
          url = "https://api.github.com/repos/ratchetphp/Ratchet/zipball/5012dc954541b40c5599d286fd40653f5716a38f";
          sha256 = "0bi118mhc74cb4695kdhnh9k3im75zh3fvll12mzz7hfjmsivs17";
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
        name = "doctrine-dbal-c480849ca3ad6706a39c970cdfe6888fa8a058b8";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/c480849ca3ad6706a39c970cdfe6888fa8a058b8";
          sha256 = "15j98h80li6m1aj53p8ddy0lkbkanc5kdy6xrikpdd6zhmsfgq9k";
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
        name = "doctrine-inflector-8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/8b7ff3e4b7de6b2c84da85637b59fd2880ecaa89";
          sha256 = "1l83jbj4k59m1agi041gzx1rxix1wzxw9mvnivmg1hqr158149n7";
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
    "evenement/evenement" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "evenement-evenement-531bfb9d15f8aa57454f5f0285b18bec903b8fb7";
        src = fetchurl {
          url = "https://api.github.com/repos/igorw/evenement/zipball/531bfb9d15f8aa57454f5f0285b18bec903b8fb7";
          sha256 = "02mi1lrga41caa25whr6sj9hmmlfjp10l0d0fq8kc3d4483pm9rr";
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
        name = "fideloper-proxy-c073b2bd04d1c90e04dc1b787662b558dd65ade0";
        src = fetchurl {
          url = "https://api.github.com/repos/fideloper/TrustedProxy/zipball/c073b2bd04d1c90e04dc1b787662b558dd65ade0";
          sha256 = "05jzgjj4fy5p1smqj41b5qxj42zn0mnczvsaacni4fmq174mz4gy";
        };
      };
    };
    "fig/http-message-util" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fig-http-message-util-9d94dc0154230ac39e5bf89398b324a86f63f765";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message-util/zipball/9d94dc0154230ac39e5bf89398b324a86f63f765";
          sha256 = "1cbhchmvh8alqdaf31rmwldyrpi5cgmzgair1gnjv6nxn99m3pqf";
        };
      };
    };
    "firebase/php-jwt" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "firebase-php-jwt-d28e6df83830252650da4623c78aaaf98fb385f3";
        src = fetchurl {
          url = "https://api.github.com/repos/firebase/php-jwt/zipball/d28e6df83830252650da4623c78aaaf98fb385f3";
          sha256 = "0lp9z27mlav8bdcy69d3br93azjnwjimz98w19h6pykp7939aaap";
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
        name = "guzzlehttp-guzzle-a52f0440530b54fa079ce76e8c5d196a42cad981";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/a52f0440530b54fa079ce76e8c5d196a42cad981";
          sha256 = "19y2c0kz5yanagrhxa464r6jq4lc53lypbmznvid0q1vmfgf0wz0";
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
        name = "guzzlehttp-psr7-e98e3e6d4f86621a9b75f623996e6bbdeb4b9318";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/e98e3e6d4f86621a9b75f623996e6bbdeb4b9318";
          sha256 = "1bbp66lwjbj2pg51jix96ddpfabc40samh63815wb913q6vv9m8s";
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
    "jaybizzle/crawler-detect" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jaybizzle-crawler-detect-d572ed4a65a70a2d2871dc5137c9c5b7e69745ab";
        src = fetchurl {
          url = "https://api.github.com/repos/JayBizzle/Crawler-Detect/zipball/d572ed4a65a70a2d2871dc5137c9c5b7e69745ab";
          sha256 = "17jfngkdy4y6rbn6z69a5y8faialpm2aqmjz1k9ng5pwlk1xr2s6";
        };
      };
    };
    "jenssegers/agent" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "jenssegers-agent-daa11c43729510b3700bc34d414664966b03bffe";
        src = fetchurl {
          url = "https://api.github.com/repos/jenssegers/agent/zipball/daa11c43729510b3700bc34d414664966b03bffe";
          sha256 = "0f0wy69w9mdsajfgriwlnpqhqxp83q44p6ggcd6h1bi8ri3h0897";
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-framework-2cf142cd5100b02da248acad3988bdaba5635e16";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/2cf142cd5100b02da248acad3988bdaba5635e16";
          sha256 = "19n6ynj4cbpxx1h4y1np61i7mdahfbzfajly95w4zqss5bm67j73";
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
    "laravel/horizon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-horizon-71291b2dc8172f46a8a503aee97b80d9a4139cdf";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/horizon/zipball/71291b2dc8172f46a8a503aee97b80d9a4139cdf";
          sha256 = "1f2h0yxnag53jr1lz39z9dpk6gwryddj5d5rb5q0hksykw3snw4d";
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
        name = "league-commonmark-0da1dca5781dd3cfddbe328224d9a7a62571addc";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/0da1dca5781dd3cfddbe328224d9a7a62571addc";
          sha256 = "17hpwg0vj4fqs5l63z2cd9jpw9w78dm5jl07vwibr8yrw3hyy9a3";
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
    "league/iso3166" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-iso3166-1a3ec7e6f1e4f16fce68dc239bafae217fbdcfef";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/iso3166/zipball/1a3ec7e6f1e4f16fce68dc239bafae217fbdcfef";
          sha256 = "0dny3mmbsslbvrcbv1710xi1x46m5f9hlsxzzck01sv3s37s8cb5";
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
        name = "league-uri-4147f19b9de3b5af6a258f35d7a0efbbf9963298";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/uri/zipball/4147f19b9de3b5af6a258f35d7a0efbbf9963298";
          sha256 = "0bcidyqg5rh2blka5ilchy1x5015w2bjd7x1a01wzn127j5gcf0y";
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
    "mobiledetect/mobiledetectlib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mobiledetect-mobiledetectlib-0fd6753003fc870f6e229bae869cc1337c99bc45";
        src = fetchurl {
          url = "https://api.github.com/repos/serbanghita/Mobile-Detect/zipball/0fd6753003fc870f6e229bae869cc1337c99bc45";
          sha256 = "1f8v8v9qdkv5v4hksxgg91nyk9p3vari65s52g842zckg2b6j7gc";
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
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-97a34af22bde8d0ac20ab34b29d7bfe360902055";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/97a34af22bde8d0ac20ab34b29d7bfe360902055";
          sha256 = "0dagm5dr9pbyvxhmspdwmpwgnxf65mjk24a32cw8h5wqfn0p99i8";
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
    "neutron/temporary-filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "neutron-temporary-filesystem-55f3d4896eff3bf070e491916e6c564db5e640b5";
        src = fetchurl {
          url = "https://api.github.com/repos/romainneutron/Temporary-Filesystem/zipball/55f3d4896eff3bf070e491916e6c564db5e640b5";
          sha256 = "1ijm5n07cr8vd30dyzsk206yg8jchg01b1j92jzmc6h8cb57zg93";
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
    "paragonie/sodium_compat" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "paragonie-sodium_compat-ac994053faac18d386328c91c7900f930acadf1e";
        src = fetchurl {
          url = "https://api.github.com/repos/paragonie/sodium_compat/zipball/ac994053faac18d386328c91c7900f930acadf1e";
          sha256 = "0xqzk0zyix98ygs9m087kcxsy8pi32v0qclk58x34ah9p4fdymck";
        };
      };
    };
    "pbmedia/laravel-ffmpeg" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pbmedia-laravel-ffmpeg-8fd5667b8898b30531b335ef43c0938d92b60e87";
        src = fetchurl {
          url = "https://api.github.com/repos/protonemedia/laravel-ffmpeg/zipball/8fd5667b8898b30531b335ef43c0938d92b60e87";
          sha256 = "176b6iqqyyq0b7dw5ai116h6qzaa0nqhcsx5hj09s4ni8ddfbl6w";
        };
      };
    };
    "php-ffmpeg/php-ffmpeg" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "php-ffmpeg-php-ffmpeg-22b71931fd1a97207788636b283eee1c0067eff7";
        src = fetchurl {
          url = "https://api.github.com/repos/PHP-FFMpeg/PHP-FFMpeg/zipball/22b71931fd1a97207788636b283eee1c0067eff7";
          sha256 = "0cxff70pdngk2kc1c9cib8r8b4281zw0ac1mq7xhy7jz03dhlakk";
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
    "pixelfed/fractal" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-fractal-faff10c9f3e3300b1571ef41926f933a9cce4782";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/fractal/zipball/faff10c9f3e3300b1571ef41926f933a9cce4782";
          sha256 = "054zbf39ghxk7xydphikxpgkw7hivxmjqzwpcqnpw2vpn3giwfay";
        };
      };
    };
    "pixelfed/laravel-snowflake" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-laravel-snowflake-69255870dcbf949feac889dfc09180a6fef77f6d";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/laravel-snowflake/zipball/69255870dcbf949feac889dfc09180a6fef77f6d";
          sha256 = "1wsgl9066z1zs751msqn5ydc6mz9m22wchy56qk9igjnjmk6g2pj";
        };
      };
    };
    "pixelfed/zttp" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pixelfed-zttp-9a95a42716eb3e71a0a88411805737965bb77c05";
        src = fetchurl {
          url = "https://api.github.com/repos/pixelfed/zttp/zipball/9a95a42716eb3e71a0a88411805737965bb77c05";
          sha256 = "1069qxaz5338sqm1kziwr46czjh55vjvrlzmw8hzsf0pz8ykywln";
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
        name = "predis-predis-a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
          sha256 = "109j0chyqmr0rzfn25843yacfnm438z94rpxlx1hvhcigfspjhvf";
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
        name = "psy-psysh-c23686f9c48ca202710dbb967df8385a952a2daf";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/c23686f9c48ca202710dbb967df8385a952a2daf";
          sha256 = "1qjqb3x1sgqz9m6ckzgsymdgwqkd9kf8zv6wy5xiwhaxvqv4f0i7";
        };
      };
    };
    "pusher/pusher-php-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pusher-pusher-php-server-1024077ff60beebaf5706b4e0208a1e648d20cf4";
        src = fetchurl {
          url = "https://api.github.com/repos/pusher/pusher-http-php/zipball/1024077ff60beebaf5706b4e0208a1e648d20cf4";
          sha256 = "1dd9299hr47nqw8wlkb8cd818a42rd3418jlzi45b0m0bpl9ai30";
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
    "ratchet/rfc6455" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ratchet-rfc6455-7c964514e93456a52a99a20fcfa0de242a43ccdb";
        src = fetchurl {
          url = "https://api.github.com/repos/ratchetphp/RFC6455/zipball/7c964514e93456a52a99a20fcfa0de242a43ccdb";
          sha256 = "1jw7by1y4aky6v1xjr7fl2y4bwag57mnfqqsbn8sxcz99q0yjzlb";
        };
      };
    };
    "react/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-cache-4bf736a2cccec7298bdf745db77585966fc2ca7e";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/cache/zipball/4bf736a2cccec7298bdf745db77585966fc2ca7e";
          sha256 = "07l1gc5lvxspc2gwkwhz0f2al4y452f0n4fdc2g68whxmwm6a6j0";
        };
      };
    };
    "react/dns" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-dns-6d38296756fa644e6cb1bfe95eff0f9a4ed6edcb";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/dns/zipball/6d38296756fa644e6cb1bfe95eff0f9a4ed6edcb";
          sha256 = "08p70q6bm9pn9h10hb7brpkj724npwbwjwx7cr6h8gavldha7hk3";
        };
      };
    };
    "react/event-loop" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-event-loop-187fb56f46d424afb6ec4ad089269c72eec2e137";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/event-loop/zipball/187fb56f46d424afb6ec4ad089269c72eec2e137";
          sha256 = "1nnxfdnigzx7zdc521s0fy4467z809dmw8488ig7r1yypv4ri1yc";
        };
      };
    };
    "react/http" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-http-59961cc4a5b14481728f07c591546be18fa3a5c7";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/http/zipball/59961cc4a5b14481728f07c591546be18fa3a5c7";
          sha256 = "00jx6bfaj7wsgsl9ssqsk9nns8va0wyksmp9y5db2yh35x573bbp";
        };
      };
    };
    "react/promise" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-234f8fd1023c9158e2314fa9d7d0e6a83db42910";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise/zipball/234f8fd1023c9158e2314fa9d7d0e6a83db42910";
          sha256 = "0p3n6jzlny75qcqwvrz0920ry3p902nq4v64cpg9ndd0g79dbdz4";
        };
      };
    };
    "react/promise-stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-stream-ef05517b99e4363beaa7993d4e2d6c50f1b22a09";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise-stream/zipball/ef05517b99e4363beaa7993d4e2d6c50f1b22a09";
          sha256 = "13nv0rs8grlbv8xjasqanf2r8alzavnpax1cw2g2nbk3w72y62y5";
        };
      };
    };
    "react/promise-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-promise-timer-aa7a73c74b8d8c0f622f5982ff7b0351bc29e495";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/promise-timer/zipball/aa7a73c74b8d8c0f622f5982ff7b0351bc29e495";
          sha256 = "1a7l9by70ygpp101arn217zvrpaddzsm2fywxd0nzc964jcq5mgd";
        };
      };
    };
    "react/socket" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-socket-f474156aaab4f09041144fa8b57c7d70aed32a1c";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/socket/zipball/f474156aaab4f09041144fa8b57c7d70aed32a1c";
          sha256 = "027c7qx5b50syvwnlhafy6vhxy5j2vw7v7ab6hxvw9f3y38wffmj";
        };
      };
    };
    "react/stream" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "react-stream-7a423506ee1903e89f1e08ec5f0ed430ff784ae9";
        src = fetchurl {
          url = "https://api.github.com/repos/reactphp/stream/zipball/7a423506ee1903e89f1e08ec5f0ed430ff784ae9";
          sha256 = "1vcn792785hg0991vz3fhdmwl5y47z4g7hvly04y03zmbc0qx0mf";
        };
      };
    };
    "ringcentral/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ringcentral-psr7-360faaec4b563958b673fb52bbe94e37f14bc686";
        src = fetchurl {
          url = "https://api.github.com/repos/ringcentral/psr7/zipball/360faaec4b563958b673fb52bbe94e37f14bc686";
          sha256 = "1j59spmy83gyzc05wl2j92ly51d67bpvgd7nmxma8a8j8vrh063w";
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
    "spatie/image-optimizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-image-optimizer-6db75529cbf8fa84117046a9d513f277aead90a0";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/image-optimizer/zipball/6db75529cbf8fa84117046a9d513f277aead90a0";
          sha256 = "0w0pl1xhgs8bswvvgpc8ipwfgjg7hx80dx7hlzhqj6cccjk49lq5";
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
    "spatie/laravel-image-optimizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "spatie-laravel-image-optimizer-c39e9ea77dee6b6eddfc26800adb1aa06a624294";
        src = fetchurl {
          url = "https://api.github.com/repos/spatie/laravel-image-optimizer/zipball/c39e9ea77dee6b6eddfc26800adb1aa06a624294";
          sha256 = "1z67ycij8mrcp8prl9iib1dmw9s2bin0xr6jqh5sgmybgkjqsd45";
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
    "stevebauman/purify" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "stevebauman-purify-08e8830f0ab9d302f8d76d4f5854910b24bacbb3";
        src = fetchurl {
          url = "https://api.github.com/repos/stevebauman/purify/zipball/08e8830f0ab9d302f8d76d4f5854910b24bacbb3";
          sha256 = "0r59533lb1yb61pchghv07b5bkda700pkxc23y4nbhfzqasz2160";
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
    "symfony/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-a50b7249bea81ddd6d3b799ce40c5521c2f72f0b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache/zipball/a50b7249bea81ddd6d3b799ce40c5521c2f72f0b";
          sha256 = "00nld52fxf91lglk0yqznln6ixkz842w11vhgaxkhdqm8yg2r61n";
        };
      };
    };
    "symfony/cache-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-cache-contracts-64be4a7acb83b6f2bf6de9a02cee6dad41277ebc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/cache-contracts/zipball/64be4a7acb83b6f2bf6de9a02cee6dad41277ebc";
          sha256 = "1qks21c3vfdns0iln9qafvs00qjwh2jg3kp1zflx6bb3bfm6dl5x";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-829d5d1bf60b2efeb0887b7436873becc71a45eb";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/829d5d1bf60b2efeb0887b7436873becc71a45eb";
          sha256 = "1mvlkvs7xq6l1lb6cgwy8j3avfhgx6aiz70ln6i6vaap7yhr3zh5";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-b0a190285cd95cb019237851205b8140ef6e368e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/b0a190285cd95cb019237851205b8140ef6e368e";
          sha256 = "1wpxfb7xcn7sjpcgz45582wxymq9d089a71mz80kmwrlblcvxq99";
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
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-36a017fa4cce1eff1b8e8129ff53513abcef05ba";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/filesystem/zipball/36a017fa4cce1eff1b8e8129ff53513abcef05ba";
          sha256 = "1f10w4f2pi3xnxcvn0ykf86i9d28ccvq6gi9qqlm7qbws7kpcn2i";
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
        name = "symfony-http-foundation-6b0d0e4aca38d57605dcd11e2416994b38774522";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/6b0d0e4aca38d57605dcd11e2416994b38774522";
          sha256 = "0633r4dx8xrbllqxfxl9fhfr32qak5wx8p2zysb3g9yqp0saf4gb";
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-kernel-cf7e61106abfc19b305ca0aedc41724ced89a02a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/cf7e61106abfc19b305ca0aedc41724ced89a02a";
          sha256 = "1z1wh7rqf8s9cwpmf540f5q5fbf1ya0iawlvhl60rlqxh9f74ykc";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-2b3802a24e48d0cfccf885173d2aac91e73df92e";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/2b3802a24e48d0cfccf885173d2aac91e73df92e";
          sha256 = "0qsfkx1md5xkvq5cxkj3qggmk5ykcsdm6i9553p9r14iqpxhnkqg";
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
        name = "symfony-service-contracts-24d9dc654b83e91aa59f9d167b131bc3b5bea24c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/24d9dc654b83e91aa59f9d167b131bc3b5bea24c";
          sha256 = "1flrnq7dw7rg8b901fbi7gv6k25hqbhffpd15w751fmzsrpzaphl";
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-string-985e6a9703ef5ce32ba617c9c7d97873bb7b2a99";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/985e6a9703ef5ce32ba617c9c7d97873bb7b2a99";
          sha256 = "0hjkz8bb95ibp2am8i84b7ijh48llip613l0cc8i5fg5q12b20sn";
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
        name = "symfony-translation-contracts-1211df0afa701e45a04253110e959d4af4ef0f07";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/1211df0afa701e45a04253110e959d4af4ef0f07";
          sha256 = "09d057ycwa7l34ph32agkcbam8jwpxh6fr1ay17xf9haczlgs1ad";
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
    "symfony/var-exporter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-var-exporter-63249ebfca4e75a357679fa7ba2089cfb898aa67";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-exporter/zipball/63249ebfca4e75a357679fa7ba2089cfb898aa67";
          sha256 = "0m5r43yysjdz3l92rlnp3jn2npz0lxxjrncfp8zqrlgv2qczlzf6";
        };
      };
    };
    "tightenco/collect" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tightenco-collect-d7381736dca44ac17d0805a25191b094e5a22446";
        src = fetchurl {
          url = "https://api.github.com/repos/tighten/collect/zipball/d7381736dca44ac17d0805a25191b094e5a22446";
          sha256 = "0qzsr8q6x7ncwdpbp0w652gl260rwynxvrnsjvj86vjkbc4s0y8w";
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
  devPackages = {
    "brianium/paratest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "brianium-paratest-589cdb23728b2a19872945580b95d8aa2c6619da";
        src = fetchurl {
          url = "https://api.github.com/repos/paratestphp/paratest/zipball/589cdb23728b2a19872945580b95d8aa2c6619da";
          sha256 = "1xq9777dnsay9g2gqz7vilpnirw69llaqg0sx9b1ysq6yq68rd9l";
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
        name = "facade-ignition-1d71996f83c9a5a7807331b8986ac890352b7a0c";
        src = fetchurl {
          url = "https://api.github.com/repos/facade/ignition/zipball/1d71996f83c9a5a7807331b8986ac890352b7a0c";
          sha256 = "0zc9x2d597709rp5fzsbx5gqn48qcsw70h1a63cqrw1nl95392gs";
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
    "hamcrest/hamcrest-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "hamcrest-hamcrest-php-8c3d0a3f6af734494ad8f6fbbee0ba92422859f3";
        src = fetchurl {
          url = "https://api.github.com/repos/hamcrest/hamcrest-php/zipball/8c3d0a3f6af734494ad8f6fbbee0ba92422859f3";
          sha256 = "1ixmmpplaf1z36f34d9f1342qjbcizvi5ddkjdli6jgrbla6a6hr";
        };
      };
    };
    "laravel/telescope" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laravel-telescope-d0cf8d6a54a1831dbe189a1f194e8271a4a5435a";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/telescope/zipball/d0cf8d6a54a1831dbe189a1f194e8271a4a5435a";
          sha256 = "0bzw8p4fvpms78jqxn6w1fimb7h84zzsidl9g6jgyvi3ws6ggrmf";
        };
      };
    };
    "mockery/mockery" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "mockery-mockery-c10a5f6e06fc2470ab1822fa13fa2a7380f8fbac";
        src = fetchurl {
          url = "https://api.github.com/repos/mockery/mockery/zipball/c10a5f6e06fc2470ab1822fa13fa2a7380f8fbac";
          sha256 = "1vv1r785wkvf0jaqdpfgka3yaj1sjn28l9kh3nahfq6lfzwqpz1h";
        };
      };
    };
    "myclabs/deep-copy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "myclabs-deep-copy-14daed4296fae74d9e3201d2c4925d1acb7aa614";
        src = fetchurl {
          url = "https://api.github.com/repos/myclabs/DeepCopy/zipball/14daed4296fae74d9e3201d2c4925d1acb7aa614";
          sha256 = "11593chczjw8k5jix2mj9v31lg5jgpxqrkhp27bxd96aajapqd9w";
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
    "phar-io/manifest" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-manifest-97803eca37d319dfa7826cc2437fc020857acb53";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/manifest/zipball/97803eca37d319dfa7826cc2437fc020857acb53";
          sha256 = "107dsj04ckswywc84dvw42kdrqd4y6yvb2qwacigyrn05p075c1w";
        };
      };
    };
    "phar-io/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phar-io-version-4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
        src = fetchurl {
          url = "https://api.github.com/repos/phar-io/version/zipball/4f7fd7836c6f332bb2933569e566a0d6c4cbed74";
          sha256 = "0mdbzh1y0m2vvpf54vw7ckcbcf1yfhivwxgc9j9rbb7yifmlyvsg";
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
    "phpunit/php-code-coverage" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-code-coverage-2e9da11878c4202f97915c1cb4bb1ca318a63f5f";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-code-coverage/zipball/2e9da11878c4202f97915c1cb4bb1ca318a63f5f";
          sha256 = "1dnslzhpj6hzsb6dzxd722sg2kk51mm0l5lwyrkng857ph82dgsj";
        };
      };
    };
    "phpunit/php-file-iterator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-file-iterator-cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-file-iterator/zipball/cf1c2e7c203ac650e352f4cc675a7021e7d1b3cf";
          sha256 = "1407d8f1h35w4sdikq2n6cz726css2xjvlyr1m4l9a53544zxcnr";
        };
      };
    };
    "phpunit/php-invoker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-invoker-5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-invoker/zipball/5a10147d0aaf65b58940a0b72f71c9ac0423cc67";
          sha256 = "1vqnnjnw94mzm30n9n5p2bfgd3wd5jah92q6cj3gz1nf0qigr4fh";
        };
      };
    };
    "phpunit/php-text-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-text-template-5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-text-template/zipball/5da5f67fc95621df9ff4c4e5a84d6a8a2acf7c28";
          sha256 = "0ff87yzywizi6j2ps3w0nalpx16mfyw3imzn6gj9jjsfwc2bb8lq";
        };
      };
    };
    "phpunit/php-timer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-php-timer-5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/php-timer/zipball/5a63ce20ed1b5bf577850e2c4e87f4aa902afbd2";
          sha256 = "0g1g7yy4zk1bidyh165fsbqx5y8f1c8pxikvcahzlfsr9p2qxk6a";
        };
      };
    };
    "phpunit/phpunit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "phpunit-phpunit-0e32b76be457de00e83213528f6bb37e2a38fcb1";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/phpunit/zipball/0e32b76be457de00e83213528f6bb37e2a38fcb1";
          sha256 = "0kixvly1xkwlv2sl68zld1rs3q94mvb7d13d1650y1jszzbd6iq4";
        };
      };
    };
    "sebastian/cli-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-cli-parser-442e7c7e687e42adc03470c7b668bc4b2402c0b2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/cli-parser/zipball/442e7c7e687e42adc03470c7b668bc4b2402c0b2";
          sha256 = "074qzdq19k9x4svhq3nak5h348xska56v1sqnhk1aj0jnrx02h37";
        };
      };
    };
    "sebastian/code-unit" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-1fc9f64c0927627ef78ba436c9b17d967e68e120";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit/zipball/1fc9f64c0927627ef78ba436c9b17d967e68e120";
          sha256 = "04vlx050rrd54mxal7d93pz4119pas17w3gg5h532anfxjw8j7pm";
        };
      };
    };
    "sebastian/code-unit-reverse-lookup" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-code-unit-reverse-lookup-ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/code-unit-reverse-lookup/zipball/ac91f01ccec49fb77bdc6fd1e548bc70f7faa3e5";
          sha256 = "1h1jbzz3zak19qi4mab2yd0ddblpz7p000jfyxfwd2ds0gmrnsja";
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
    "sebastian/complexity" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-complexity-739b35e53379900cc9ac327b2147867b8b6efd88";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/complexity/zipball/739b35e53379900cc9ac327b2147867b8b6efd88";
          sha256 = "1y4yz8n8hszbhinf9ipx3pqyvgm7gz0krgyn19z0097yq3bbq8yf";
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
    "sebastian/environment" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-environment-1b5dff7bb151a4db11d49d90e5408e4e938270f7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/environment/zipball/1b5dff7bb151a4db11d49d90e5408e4e938270f7";
          sha256 = "0qhpamp9hi00zh7warf3mfbfrrpj1rdci90nnzibvii0vdp98691";
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
    "sebastian/global-state" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-global-state-0ca8db5a5fc9c8646244e629625ac486fa286bf2";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/global-state/zipball/0ca8db5a5fc9c8646244e629625ac486fa286bf2";
          sha256 = "1csrfa5b7ivza712lfmbywp9jhwf4ls5lc0vn812xljkj7w24kg1";
        };
      };
    };
    "sebastian/lines-of-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-lines-of-code-c1c2e997aa3146983ed888ad08b15470a2e22ecc";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/lines-of-code/zipball/c1c2e997aa3146983ed888ad08b15470a2e22ecc";
          sha256 = "0fay9s5cm16gbwr7qjihwrzxn7sikiwba0gvda16xng903argbk0";
        };
      };
    };
    "sebastian/object-enumerator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-enumerator-5c9eeac41b290a3712d88851518825ad78f45c71";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-enumerator/zipball/5c9eeac41b290a3712d88851518825ad78f45c71";
          sha256 = "11853z07w8h1a67wsjy3a6ir5x7khgx6iw5bmrkhjkiyvandqcn1";
        };
      };
    };
    "sebastian/object-reflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-object-reflector-b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/object-reflector/zipball/b4f479ebdbf63ac605d183ece17d8d7fe49c15c7";
          sha256 = "0g5m1fswy6wlf300x1vcipjdljmd3vh05hjqhqfc91byrjbk4rsg";
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
    "sebastian/resource-operations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-resource-operations-0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/resource-operations/zipball/0f4443cb3a1d92ce809899753bc0d5d5a8dd19a8";
          sha256 = "0p5s8rp7mrhw20yz5wx1i4k8ywf0h0ximcqan39n9qnma1dlnbyr";
        };
      };
    };
    "sebastian/type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-type-b233b84bc4465aff7b57cf1c4bc75c86d00d6dad";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/type/zipball/b233b84bc4465aff7b57cf1c4bc75c86d00d6dad";
          sha256 = "057a4yk5rhgnq99l024gx8b1gxliyyf7q1x6w37nwzckq3a419yv";
        };
      };
    };
    "sebastian/version" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "sebastian-version-c6c1022351a901512170118436c764e473f6de8c";
        src = fetchurl {
          url = "https://api.github.com/repos/sebastianbergmann/version/zipball/c6c1022351a901512170118436c764e473f6de8c";
          sha256 = "1bs7bwa9m0fin1zdk7vqy5lxzlfa9la90lkl27sn0wr00m745ig1";
        };
      };
    };
    "theseer/tokenizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "theseer-tokenizer-34a41e998c2183e22995f158c581e7b5e755ab9e";
        src = fetchurl {
          url = "https://api.github.com/repos/theseer/tokenizer/zipball/34a41e998c2183e22995f158c581e7b5e755ab9e";
          sha256 = "1za4a017kjb4rw2ydglip4bp5q2y7mfiycj3fvnp145i84jc7n0q";
        };
      };
    };
  };
in
composerEnv.buildPackage {
  inherit packages devPackages noDev;
  name = "pixelfed-pixelfed";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "AGPL-3.0-only";
  };
}
