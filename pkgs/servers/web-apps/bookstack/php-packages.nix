{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "aws/aws-crt-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "aws-aws-crt-php-2f1dc7b7eda080498be96a4a6d683a41583030e9";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/2f1dc7b7eda080498be96a4a6d683a41583030e9";
          sha256 = "12b7kvc8r5rw3g47hfpg5y37ybk6b67xvq6a36id5pxxkbzsqzwx";
=======
        name = "aws-aws-crt-php-3942776a8c99209908ee0b287746263725685732";
        src = fetchurl {
          url = "https://api.github.com/repos/awslabs/aws-crt-php/zipball/3942776a8c99209908ee0b287746263725685732";
          sha256 = "0g4vjln6s1419ydljn5m64kzid0b7cplbc0nwn3y4cj72408fyiz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "aws/aws-sdk-php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "aws-aws-sdk-php-ebd5e47c5be0425bb5cf4f80737850ed74767107";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/ebd5e47c5be0425bb5cf4f80737850ed74767107";
          sha256 = "0fnbhpr5awvq4463l51j4rr0cc15lqqa9ppdjjp4jw2g6azckb8y";
=======
        name = "aws-aws-sdk-php-c600a07da531d6c29af791b9d2e8b6df796aa14b";
        src = fetchurl {
          url = "https://api.github.com/repos/aws/aws-sdk-php/zipball/c600a07da531d6c29af791b9d2e8b6df796aa14b";
          sha256 = "03iisnif804dkgnynn24y6ji1hnq95ryv8vwgwi6398apcz6vypn";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "bacon/bacon-qr-code" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "bacon-bacon-qr-code-8674e51bb65af933a5ffaf1c308a660387c35c22";
        src = fetchurl {
          url = "https://api.github.com/repos/Bacon/BaconQrCode/zipball/8674e51bb65af933a5ffaf1c308a660387c35c22";
          sha256 = "0hb0w6m5rwzghw2im3yqn6ly2kvb3jgrv8jwra1lwd0ik6ckrngl";
        };
      };
    };
    "barryvdh/laravel-dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "barryvdh-laravel-dompdf-9843d2be423670fb434f4c978b3c0f4dd92c87a6";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/9843d2be423670fb434f4c978b3c0f4dd92c87a6";
          sha256 = "1b7j7rnba50ibsnjzxz3bcnpcii51qrin5p0ivi0bzm57xhvns9s";
=======
        name = "barryvdh-laravel-dompdf-1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-dompdf/zipball/1d47648c6cef37f715ecb8bcc5f5a656ad372e27";
          sha256 = "0xvaq6mp9s8nxlpfisa50fr8rjb6vmivxdbr985q9vydadh1dsv2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "barryvdh/laravel-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "barryvdh-laravel-snappy-940eec2d99b89cbc9bea2f493cf068382962a485";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-snappy/zipball/940eec2d99b89cbc9bea2f493cf068382962a485";
          sha256 = "0i168sq1sah83xw3xfrilnpja789q79zvhjfgfcszd10g7y444gc";
=======
        name = "barryvdh-laravel-snappy-2c18a3602981bc6f25b32908cf8aaa05952ab2f7";
        src = fetchurl {
          url = "https://api.github.com/repos/barryvdh/laravel-snappy/zipball/2c18a3602981bc6f25b32908cf8aaa05952ab2f7";
          sha256 = "1h3s9g9n1rk3iji0p9m3g21gakjxnp4ciqwd5cdbj0wnh9k7gi2h";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "brick/math" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "brick-math-0ad82ce168c82ba30d1c01ec86116ab52f589478";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/0ad82ce168c82ba30d1c01ec86116ab52f589478";
          sha256 = "04kqy1hqvp4634njjjmhrc2g828d69sk6q3c55bpqnnmsqf154yb";
=======
        name = "brick-math-ca57d18f028f84f777b2168cd1911b0dee2343ae";
        src = fetchurl {
          url = "https://api.github.com/repos/brick/math/zipball/ca57d18f028f84f777b2168cd1911b0dee2343ae";
          sha256 = "1nr1grrb9g5g3ihx94yk0amp8zx8prkkvg2934ygfc3rrv03cq9w";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "dasprid/enum" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "dasprid-enum-8e6b6ea76eabbf19ea2bf5b67b98e1860474012f";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/8e6b6ea76eabbf19ea2bf5b67b98e1860474012f";
          sha256 = "0cckq42c9iyjfv7xmy6rl4xj3dn80v9k8qzc3ppdjm4wgj43rrkz";
        };
      };
    };
    "dflydev/dot-access-data" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-dot-access-data-f41715465d65213d644d3141a6a93081be5d3549";
        src = fetchurl {
          url = "https://api.github.com/repos/dflydev/dflydev-dot-access-data/zipball/f41715465d65213d644d3141a6a93081be5d3549";
          sha256 = "1vgbjrq8qh06r26y5nlxfin4989r3h7dib1jifb2l3cjdn1r5bmj";
=======
        name = "dasprid-enum-5abf82f213618696dda8e3bf6f64dd042d8542b2";
        src = fetchurl {
          url = "https://api.github.com/repos/DASPRiD/Enum/zipball/5abf82f213618696dda8e3bf6f64dd042d8542b2";
          sha256 = "0rs7i1xiwhssy88s7bwnp5ri5fi2xy3fl7pw6l5k27xf2f1hv7q6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "doctrine-dbal-63646ffd71d1676d2f747f871be31b7e921c7864";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/63646ffd71d1676d2f747f871be31b7e921c7864";
          sha256 = "0qqiq46983m5c4w0i59z2ik1v69slglr8nrj5p2zcpxq9zmczbkj";
=======
        name = "doctrine-dbal-88fa7e5189fd5ec6682477044264dc0ed4e3aa1e";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/dbal/zipball/88fa7e5189fd5ec6682477044264dc0ed4e3aa1e";
          sha256 = "1xz7yyq0r8378zb4jrac13z0762pid0dxxnaj0rx82f7vwbxaqas";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "doctrine/deprecations" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "doctrine-deprecations-612a3ee5ab0d5dd97b7cf3874a6efe24325efac3";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/612a3ee5ab0d5dd97b7cf3874a6efe24325efac3";
          sha256 = "078w4k0xdywyb44caz5grbcbxsi87iy13g7a270rs9g5f0p245fi";
=======
        name = "doctrine-deprecations-0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/deprecations/zipball/0e2a4f1f8cdfc7a92ec3b01c9334898c806b30de";
          sha256 = "1sk1f020n0w7p7r4rsi7wnww85vljrim1i5h9wb0qiz2c4l8jj09";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "doctrine/event-manager" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "doctrine-event-manager-95aa4cb529f1e96576f3fda9f5705ada4056a520";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/event-manager/zipball/95aa4cb529f1e96576f3fda9f5705ada4056a520";
          sha256 = "0xi2s28jmmvrndg1yd0r5s10d9a0q6j2dxdbazvcbws9waf0yrvj";
        };
      };
    };
    "doctrine/inflector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "doctrine-inflector-f9301a5b2fb1216b2b08f02ba04dc45423db6bff";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/f9301a5b2fb1216b2b08f02ba04dc45423db6bff";
          sha256 = "1kdq3sbwrzwprxr36cdw9m1zlwn15c0nz6i7mw0sq9mhnd2sgbrb";
=======
        name = "doctrine-inflector-d9d313a36c872fd6ee06d9a6cbcf713eaa40f024";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/inflector/zipball/d9d313a36c872fd6ee06d9a6cbcf713eaa40f024";
          sha256 = "1z6y0mxqadarw76whppcl0h0cj7p5n6k7mxihggavq46i2wf7nhj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "doctrine/lexer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "doctrine-lexer-39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/39ab8fcf5a51ce4b85ca97c7a7d033eb12831124";
          sha256 = "19kak8fh8sf5bpmcn7a90sqikgx30mk2bmjf0jbzcvlbnsjyggah";
=======
        name = "doctrine-lexer-c268e882d4dbdd85e36e4ad69e02dc284f89d229";
        src = fetchurl {
          url = "https://api.github.com/repos/doctrine/lexer/zipball/c268e882d4dbdd85e36e4ad69e02dc284f89d229";
          sha256 = "12g069nljl3alyk15884nd1jc4mxk87isqsmfj7x6j2vxvk9qchs";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "dompdf/dompdf" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "dompdf-dompdf-e8d2d5e37e8b0b30f0732a011295ab80680d7e85";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/e8d2d5e37e8b0b30f0732a011295ab80680d7e85";
          sha256 = "0a2qk57c3qwg7j8gp1hwyd8y8dwm5pb8lg1npb49sijig8kyjlv3";
=======
        name = "dompdf-dompdf-c5310df0e22c758c85ea5288175fc6cd777bc085";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/dompdf/zipball/c5310df0e22c758c85ea5288175fc6cd777bc085";
          sha256 = "1h9y3v02qdijc6hmi7p8x626jlhkjd2pcck9mkcmm5sz9xzqhdwb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "dragonmantank/cron-expression" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "dragonmantank-cron-expression-adfb1f505deb6384dc8b39804c5065dd3c8c8c0a";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/adfb1f505deb6384dc8b39804c5065dd3c8c8c0a";
          sha256 = "1gw2bnsh8ca5plfpyyyz1idnx7zxssg6fbwl7niszck773zrm5ca";
=======
        name = "dragonmantank-cron-expression-782ca5968ab8b954773518e9e49a6f892a34b2a8";
        src = fetchurl {
          url = "https://api.github.com/repos/dragonmantank/cron-expression/zipball/782ca5968ab8b954773518e9e49a6f892a34b2a8";
          sha256 = "18pxn1v3b2yhwzky22p4wn520h89rcrihl7l6hd0p769vk1b2qg9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "egulias-email-validator-e5997fa97e8790cdae03a9cbd5e78e45e3c7bda7";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/e5997fa97e8790cdae03a9cbd5e78e45e3c7bda7";
          sha256 = "16s7k5ck8bzk83xfy46fikjyj4jywalriqba8jvd5ngd177s2mw5";
        };
      };
    };
    "fruitcake/php-cors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fruitcake-php-cors-58571acbaa5f9f462c9c77e911700ac66f446d4e";
        src = fetchurl {
          url = "https://api.github.com/repos/fruitcake/php-cors/zipball/58571acbaa5f9f462c9c77e911700ac66f446d4e";
          sha256 = "18xm69q4dk9zqfwgp938y2byhlyy9lr5x5qln4k2mg8cq8xr2sm1";
=======
        name = "egulias-email-validator-0dbf5d78455d4d6a41d186da50adc1122ec066f4";
        src = fetchurl {
          url = "https://api.github.com/repos/egulias/EmailValidator/zipball/0dbf5d78455d4d6a41d186da50adc1122ec066f4";
          sha256 = "00kwb8rhk1fq3a1i152xniipk3y907q1v5r3szqbkq5rz82dwbck";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-f7948baaa0330277c729714910336383286305da";
        src = fetchurl {
          url = "https://api.github.com/repos/filp/whoops/zipball/f7948baaa0330277c729714910336383286305da";
          sha256 = "1l70lq27h072ria2pgmf9dp3h5awszirqd1khlcknl4w1hww3swv";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "graham-campbell/result-type" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "graham-campbell-result-type-672eff8cf1d6fe1ef09ca0f89c4b287d6a3eb831";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/672eff8cf1d6fe1ef09ca0f89c4b287d6a3eb831";
          sha256 = "156zbfs19r9g543phlpjwhqin3k2x4dsvr5p0wk7rk4j0wwp8l2v";
=======
        name = "graham-campbell-result-type-a878d45c1914464426dc94da61c9e1d36ae262a8";
        src = fetchurl {
          url = "https://api.github.com/repos/GrahamCampbell/Result-Type/zipball/a878d45c1914464426dc94da61c9e1d36ae262a8";
          sha256 = "1xayas92b467yixpc79l7ydgspy3s76cpfddv7lrvd691y11g1vb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "guzzlehttp-guzzle-fb7566caccf22d74d1ab270de3551f72a58399f5";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/fb7566caccf22d74d1ab270de3551f72a58399f5";
          sha256 = "0cmpq50s5xi9sg1dygllrhwj5dz5bxxj83xkvjspz63751xr51cs";
=======
        name = "guzzlehttp-guzzle-b50a2a1251152e43f6a37f0fa053e730a67d25ba";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/guzzle/zipball/b50a2a1251152e43f6a37f0fa053e730a67d25ba";
          sha256 = "0cy828r0kafx58jh0k1cy17y77qh248d9kfk9ncn9pyq2q5v9p9p";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "guzzlehttp/promises" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "guzzlehttp-promises-111166291a0f8130081195ac4556a5587d7f1b5d";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/111166291a0f8130081195ac4556a5587d7f1b5d";
          sha256 = "17d50in3wq62y8gcgadiimn9s2mc90xvil5g851l9y2k0c4y31s2";
=======
        name = "guzzlehttp-promises-b94b2807d85443f9719887892882d0329d1e2598";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/promises/zipball/b94b2807d85443f9719887892882d0329d1e2598";
          sha256 = "1vvac7y5ax955qjg7dyjmaw3vab9v2lypjygap0040rv3z4x9vz8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "guzzlehttp/psr7" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "guzzlehttp-psr7-8bd7c33a0734ae1c5d074360512beb716bef3f77";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/8bd7c33a0734ae1c5d074360512beb716bef3f77";
          sha256 = "0c2b8n3ip5w91fg277dccak0z7p6jgc0fm7m8lc9s5n567aahmj3";
        };
      };
    };
    "guzzlehttp/uri-template" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-uri-template-b945d74a55a25a949158444f09ec0d3c120d69e2";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/uri-template/zipball/b945d74a55a25a949158444f09ec0d3c120d69e2";
          sha256 = "02vd4r2di8xh9n5awfjy1lyb7vn5gkaynbiiqilm8did0r89qdhf";
=======
        name = "guzzlehttp-psr7-67c26b443f348a51926030c83481b85718457d3d";
        src = fetchurl {
          url = "https://api.github.com/repos/guzzle/psr7/zipball/67c26b443f348a51926030c83481b85718457d3d";
          sha256 = "09avh5xzmzwfpa5xv9zw90ypyfrhpyhszbli395prgh3llnrx9wg";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    "knplabs/knp-snappy" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "knplabs-knp-snappy-b66f79334421c26d9c244427963fa2d92980b5d3";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/b66f79334421c26d9c244427963fa2d92980b5d3";
          sha256 = "164zx6pr06maad8rsf2rq2p576pcx62khzpz808v3dpm4yadlh88";
=======
        name = "knplabs-knp-snappy-5126fb5b335ec929a226314d40cd8dad497c3d67";
        src = fetchurl {
          url = "https://api.github.com/repos/KnpLabs/snappy/zipball/5126fb5b335ec929a226314d40cd8dad497c3d67";
          sha256 = "1j5bdj3sbww43nfgk7pasmyciwqdi92vj6pykw8f2xaq9c3i75p9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "laravel/framework" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "laravel-framework-e3350e87a52346af9cc655a3012d2175d2d05ad7";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/e3350e87a52346af9cc655a3012d2175d2d05ad7";
          sha256 = "1iqqiwvi3q8vhnhrnfismczga0q958i1h44xv3qna80l6iv5vv0m";
=======
        name = "laravel-framework-e1afe088b4ca613fb96dc57e6d8dbcb8cc2c6b49";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/framework/zipball/e1afe088b4ca613fb96dc57e6d8dbcb8cc2c6b49";
          sha256 = "1k7afj4himxmhv02lmq8dc992m2vdkw8hcjyfcnff99cv555z9ph";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "laravel/serializable-closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "laravel-serializable-closure-e5a3057a5591e1cfe8183034b0203921abe2c902";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/e5a3057a5591e1cfe8183034b0203921abe2c902";
          sha256 = "0sjcn7w31x14slfj2mqs32kj62ay86i47i441p5cg3ajw9kjb6iy";
=======
        name = "laravel-serializable-closure-47afb7fae28ed29057fdca37e16a84f90cc62fae";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/serializable-closure/zipball/47afb7fae28ed29057fdca37e16a84f90cc62fae";
          sha256 = "1mfj1jszq1mssxfh68y3s43sq90bpj25a2kpj0djbmcrccgwd46z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "laravel/socialite" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "laravel-socialite-50148edf24b6cd3e428aa9bc06a5d915b24376bb";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/50148edf24b6cd3e428aa9bc06a5d915b24376bb";
          sha256 = "0xdp118b59winbyvh7pa43bcp8rkfd75fckj0mbpx7zf72ralp8a";
=======
        name = "laravel-socialite-dae03ca4ecfe3badafcdfb81965d2279080051f4";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/socialite/zipball/dae03ca4ecfe3badafcdfb81965d2279080051f4";
          sha256 = "1cv67knibrhyfbimgbnig4hrnq2rjyi7kqmsqyqs7il2nizl51vm";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "laravel/tinker" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "laravel-tinker-04a2d3bd0d650c0764f70bf49d1ee39393e4eb10";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/04a2d3bd0d650c0764f70bf49d1ee39393e4eb10";
          sha256 = "06rivrmcf8m8hm4vn9s7wwpfmgl89p73b78dm0qx26rs0lpr36p0";
=======
        name = "laravel-tinker-74d0b287cc4ae65d15c368dd697aae71d62a73ad";
        src = fetchurl {
          url = "https://api.github.com/repos/laravel/tinker/zipball/74d0b287cc4ae65d15c368dd697aae71d62a73ad";
          sha256 = "1rhppd4zzz47abjahid8hdhwrzjrnbwkcy0cqqws5dia4x81k7xb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "league/commonmark" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "league-commonmark-d44a24690f16b8c1808bf13b1bd54ae4c63ea048";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/d44a24690f16b8c1808bf13b1bd54ae4c63ea048";
          sha256 = "1qx99m1qa2g3l6r2fim3rak6qh28zjj8sqjj86nq743dm3yszygw";
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
=======
        name = "league-commonmark-2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/commonmark/zipball/2b8185c13bc9578367a5bf901881d1c1b5bbd09b";
          sha256 = "14hp7vmqag9jh89rcq1mi3hyw01rkmypdbw2p3zsnjq2p8wwh4r5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "league-flysystem-a141d430414fcb8bf797a18716b09f759a385bed";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/a141d430414fcb8bf797a18716b09f759a385bed";
          sha256 = "0w476nkv4izdrh8dn4g58lrqnfwrp8ijhj6fj8d8cpvr81kq0wiv";
=======
        name = "league-flysystem-3239285c825c152bcc315fe0e87d6b55f5972ed1";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem/zipball/3239285c825c152bcc315fe0e87d6b55f5972ed1";
          sha256 = "0p1cirl7j9b3gvbp264d08abfnrki89jr7rx0cbw0bjw1apf4spz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "league/flysystem-aws-s3-v3" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "league-flysystem-aws-s3-v3-d8de61ee10b6a607e7996cff388c5a3a663e8c8a";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/d8de61ee10b6a607e7996cff388c5a3a663e8c8a";
          sha256 = "0hr11wwn2c2f26w0kj5yanx17ln17plk0si8yajkd470z3ssprwj";
        };
      };
    };
    "league/flysystem-local" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-local-543f64c397fefdf9cfeac443ffb6beff602796b3";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-local/zipball/543f64c397fefdf9cfeac443ffb6beff602796b3";
          sha256 = "1f44jgjip7pgnjafwlazmbv9jap3xsw3jfzhgakbsa4bkx3aavr2";
=======
        name = "league-flysystem-aws-s3-v3-af286f291ebab6877bac0c359c6c2cb017eb061d";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/flysystem-aws-s3-v3/zipball/af286f291ebab6877bac0c359c6c2cb017eb061d";
          sha256 = "1dyj1cvf2pbvkdw9i53qg6lycxv0di85qnjzcvy5lphrxambifxy";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "league/html-to-markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "league-html-to-markdown-0b4066eede55c48f38bcee4fb8f0aa85654390fd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/0b4066eede55c48f38bcee4fb8f0aa85654390fd";
          sha256 = "0cd0sv99albdkrj4hmrbb76ji366dsl4jcpsr9gmrrpy3jxi2h7a";
=======
        name = "league-html-to-markdown-e0fc8cf07bdabbcd3765341ecb50c34c271d64e1";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/html-to-markdown/zipball/e0fc8cf07bdabbcd3765341ecb50c34c271d64e1";
          sha256 = "1a7ab0xafjwd5hmkmixc3ijwrrncb2qncy9b52jbnzspv1vjav1h";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "league-mime-type-detection-a6dfb1194a2946fcdc1f38219445234f65b35c96";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/a6dfb1194a2946fcdc1f38219445234f65b35c96";
          sha256 = "14yylg4lyyc522kpzlcby1zhfs01d8xrcc4rqvyink0ry8az12jj";
=======
        name = "league-mime-type-detection-ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/mime-type-detection/zipball/ff6248ea87a9f116e78edd6002e39e5128a0d4dd";
          sha256 = "1a63nvqd6cz3vck3y8vjswn6c3cfwh13p0cn0ci5pqdf0bgjvvfz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "league-oauth2-client-160d6274b03562ebeb55ed18399281d8118b76c8";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/160d6274b03562ebeb55ed18399281d8118b76c8";
          sha256 = "1vyd8c64armlaf9zmpjx2gy0nvv4mhzy5qk9k26k75wa9ffh482s";
=======
        name = "league-oauth2-client-2334c249907190c132364f5dae0287ab8666aa19";
        src = fetchurl {
          url = "https://api.github.com/repos/thephpleague/oauth2-client/zipball/2334c249907190c132364f5dae0287ab8666aa19";
          sha256 = "12a3mpv3x5jy1nnpzx25z80chzhjxk8sgvn5x02pzk5dlw8kbzhz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "masterminds/html5" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "masterminds-html5-f47dcf3c70c584de14f21143c55d9939631bc6cf";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/f47dcf3c70c584de14f21143c55d9939631bc6cf";
          sha256 = "1n2xiyxqmxk9g34wn1lg2yyivwg2ry8iqk8m7g2432gm97rmyb20";
=======
        name = "masterminds-html5-897eb517a343a2281f11bc5556d6548db7d93947";
        src = fetchurl {
          url = "https://api.github.com/repos/Masterminds/html5-php/zipball/897eb517a343a2281f11bc5556d6548db7d93947";
          sha256 = "12fmcgsrmh0f0llnpcvk33mrs4067nw246ci5619rr79ijy3yc0k";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "monolog-monolog-f259e2b15fb95494c83f52d3caad003bbf5ffaa1";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/f259e2b15fb95494c83f52d3caad003bbf5ffaa1";
          sha256 = "0lz7lgr1bcxsh4c63z8k26bxawkx14h689wgdiap8992rf97kbk2";
=======
        name = "monolog-monolog-720488632c590286b88b80e62aa3d3d551ad4a50";
        src = fetchurl {
          url = "https://api.github.com/repos/Seldaek/monolog/zipball/720488632c590286b88b80e62aa3d3d551ad4a50";
          sha256 = "0wg1y0mghhib6cp9gcavbs6ajfs9rgxc2ssipqb5yfwfkkbwrif6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "nesbot-carbon-4308217830e4ca445583a37d1bf4aff4153fa81c";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/4308217830e4ca445583a37d1bf4aff4153fa81c";
          sha256 = "1ycjj9d107nbv390qqm9phmhvc1slxl0pa2dzf8lhmcif58863vb";
        };
      };
    };
    "nette/schema" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-schema-c9ff517a53903b3d4e29ec547fb20feecb05b8ab";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/schema/zipball/c9ff517a53903b3d4e29ec547fb20feecb05b8ab";
          sha256 = "1b7xhxdm2hxm5m0b3d2sv2rhw5986bqkxfl9k7mqdfka78mpvmlx";
        };
      };
    };
    "nette/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nette-utils-9124157137da01b1f5a5a22d6486cb975f26db7e";
        src = fetchurl {
          url = "https://api.github.com/repos/nette/utils/zipball/9124157137da01b1f5a5a22d6486cb975f26db7e";
          sha256 = "0ly27z4m2w9h24kssjc5x4rhksw5hd9nwjzxnzmxrz7kvh7068gd";
=======
        name = "nesbot-carbon-09acf64155c16dc6f580f36569ae89344e9734a3";
        src = fetchurl {
          url = "https://api.github.com/repos/briannesbitt/Carbon/zipball/09acf64155c16dc6f580f36569ae89344e9734a3";
          sha256 = "1m4sb4vnimg3238g0mivnxgfmf3lwkb3v2njmird20jrh48k4c69";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "nikic/php-parser" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "nikic-php-parser-a6303e50c90c355c7eeee2c4a8b27fe8dc8fef1d";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/a6303e50c90c355c7eeee2c4a8b27fe8dc8fef1d";
          sha256 = "0a5a6fzgvcgxn5kc1mxa5grxmm8c1ax91pjr3gxpkji7nyc1zh1y";
        };
      };
    };
    "nunomaduro/termwind" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nunomaduro-termwind-8ab0b32c8caa4a2e09700ea32925441385e4a5dc";
        src = fetchurl {
          url = "https://api.github.com/repos/nunomaduro/termwind/zipball/8ab0b32c8caa4a2e09700ea32925441385e4a5dc";
          sha256 = "1g75vpq7014s5yd6bvj78b88ia31slkikdhjv8iprz987qm5dnl7";
=======
        name = "nikic-php-parser-570e980a201d8ed0236b0a62ddf2c9cbb2034039";
        src = fetchurl {
          url = "https://api.github.com/repos/nikic/PHP-Parser/zipball/570e980a201d8ed0236b0a62ddf2c9cbb2034039";
          sha256 = "1q3hnpjya4rsxfh72ccs2vj3gz8h0sn12290w8wvkz9pvi0qmmmr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "onelogin/php-saml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "onelogin-php-saml-b22a57ebd13e838b90df5d3346090bc37056409d";
        src = fetchurl {
          url = "https://api.github.com/repos/onelogin/php-saml/zipball/b22a57ebd13e838b90df5d3346090bc37056409d";
          sha256 = "1bi65bi04a26zmaz7ms0qyg6i86k4cd9g8qs7dp1pphpvflgz461";
        };
      };
    };
<<<<<<< HEAD
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
        name = "phenx-php-svg-lib-76876c6cf3080bcb6f249d7d59705108166a6685";
        src = fetchurl {
          url = "https://api.github.com/repos/dompdf/php-svg-lib/zipball/76876c6cf3080bcb6f249d7d59705108166a6685";
          sha256 = "0bjynrs81das9f9jwd5jgsxx9gjv2m6c0mkvlgx4w1f4pgbvwsf5";
        };
      };
    };
    "phpoption/phpoption" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "phpoption-phpoption-dd3a383e599f49777d8b628dadbb90cae435b87e";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/dd3a383e599f49777d8b628dadbb90cae435b87e";
          sha256 = "029gpfa66hwg395jvf7swcvrj085wsw5fw6041nrl5kbc36fvwlb";
=======
        name = "phpoption-phpoption-dc5ff11e274a90cc1c743f66c9ad700ce50db9ab";
        src = fetchurl {
          url = "https://api.github.com/repos/schmittjoh/php-option/zipball/dc5ff11e274a90cc1c743f66c9ad700ce50db9ab";
          sha256 = "12i9gc2q75iv6c0x87zj3j499pl8k0wzh3yzvgrhg97nhbdhab5c";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "phpseclib/phpseclib" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "phpseclib-phpseclib-4580645d3fc05c189024eb3b834c6c1e4f0f30a1";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/4580645d3fc05c189024eb3b834c6c1e4f0f30a1";
          sha256 = "0v3c7n9h99pw4f03bfxjsgni7wpq7xr47nw2hf2hq8yjndw19n3p";
=======
        name = "phpseclib-phpseclib-f28693d38ba21bb0d9f0c411ee5dae2b178201da";
        src = fetchurl {
          url = "https://api.github.com/repos/phpseclib/phpseclib/zipball/f28693d38ba21bb0d9f0c411ee5dae2b178201da";
          sha256 = "11hvq1mwk2zn1fgrwvifh5z4md178vzka5nfykj8l28vk7r0vb98";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "predis-predis-5f2b410a74afaff296a87a494e4c5488cf9fab57";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/5f2b410a74afaff296a87a494e4c5488cf9fab57";
          sha256 = "02bf6w5vrzxmd6zzzlgr31g5fbf8k5yyk9gj00a1ql09ndyx51sn";
=======
        name = "predis-predis-a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
        src = fetchurl {
          url = "https://api.github.com/repos/predis/predis/zipball/a2fb02d738bedadcffdbb07efa3a5e7bd57f8d6e";
          sha256 = "109j0chyqmr0rzfn25843yacfnm438z94rpxlx1hvhcigfspjhvf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
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
=======
        name = "psr-cache-d11b50ad223250cf17b86e38383413f5a6764bf8";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/cache/zipball/d11b50ad223250cf17b86e38383413f5a6764bf8";
          sha256 = "06i2k3dx3b4lgn9a4v1dlgv8l9wcl4kl7vzhh63lbji0q96hv8qz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psr-container-c71ecc56dfe541dbd90c5360474fbc405f8d5963";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/c71ecc56dfe541dbd90c5360474fbc405f8d5963";
          sha256 = "1mvan38yb65hwk68hl0p7jymwzr4zfnaxmwjbw7nj3rsknvga49i";
=======
        name = "psr-container-513e0666f7216c7459170d56df27dfcefe1689ea";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/container/zipball/513e0666f7216c7459170d56df27dfcefe1689ea";
          sha256 = "00yvj3b5ls2l1d0sk38g065raw837rw65dx1sicggjnkr85vmfzz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "psr-http-client-0955afe48220520692d2d09f7ab7e0f93ffd6a31";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/0955afe48220520692d2d09f7ab7e0f93ffd6a31";
          sha256 = "09r970lfpwil861gzm47446ck1s6km6ijibkxl13p1ymwdchnv6m";
=======
        name = "psr-http-client-2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-client/zipball/2dfb5f6c5eff0e91e20e913f8c5452ed95b86621";
          sha256 = "0cmkifa3ji1r8kn3y1rwg81rh8g2crvnhbv2am6d688dzsbw967v";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psr-http-factory-e616d01114759c4c489f93b099585439f795fe35";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/e616d01114759c4c489f93b099585439f795fe35";
          sha256 = "1vzimn3h01lfz0jx0lh3cy9whr3kdh103m1fw07qric4pnnz5kx8";
=======
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/http-message" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psr-http-message-402d35bcb92c70c026d1a6a9883f06b2ead23d71";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/402d35bcb92c70c026d1a6a9883f06b2ead23d71";
          sha256 = "13cnlzrh344n00sgkrp5cgbkr8dznd99c3jfnpl0wg1fdv1x4qfm";
=======
        name = "psr-http-message-f6561bf28d520154e4b0ec72be95418abe6d9363";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/http-message/zipball/f6561bf28d520154e4b0ec72be95418abe6d9363";
          sha256 = "195dd67hva9bmr52iadr4kyp2gw2f5l51lplfiay2pv6l9y4cf45";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/log" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psr-log-fe5ea303b0887d5caefd3d431c3e61ad47037001";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/fe5ea303b0887d5caefd3d431c3e61ad47037001";
          sha256 = "0a0rwg38vdkmal3nwsgx58z06qkfl85w2yvhbgwg45anr0b3bhmv";
=======
        name = "psr-log-d49695b909c3b7628b6289db5479a1c204601f11";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/log/zipball/d49695b909c3b7628b6289db5479a1c204601f11";
          sha256 = "0sb0mq30dvmzdgsnqvw3xh4fb4bqjncx72kf8n622f94dd48amln";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psr/simple-cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psr-simple-cache-764e0b3939f5ca87cb904f570ef9be2d78a07865";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/764e0b3939f5ca87cb904f570ef9be2d78a07865";
          sha256 = "0hgcanvd9gqwkaaaq41lh8fsfdraxmp2n611lvqv69jwm1iy76g8";
=======
        name = "psr-simple-cache-408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
        src = fetchurl {
          url = "https://api.github.com/repos/php-fig/simple-cache/zipball/408d5eafb83c57f6365a3ca330ff23aa4a5fa39b";
          sha256 = "1djgzclkamjxi9jy4m9ggfzgq1vqxaga2ip7l3cj88p7rwkzjxgw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "psy/psysh" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "psy-psysh-0fa27040553d1d280a67a4393194df5228afea5b";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/0fa27040553d1d280a67a4393194df5228afea5b";
          sha256 = "1as5sp2vi6873in83qnxq6iiad9qd9zsladw4smid8nlvgkpajfz";
=======
        name = "psy-psysh-e9eadffbed9c9deb5426fd107faae0452bf20a36";
        src = fetchurl {
          url = "https://api.github.com/repos/bobthecow/psysh/zipball/e9eadffbed9c9deb5426fd107faae0452bf20a36";
          sha256 = "0yaj5ixg8zb6hh9swpcc29dcrpffjn4cxp61qz2zqbizvq2d6z0z";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
        name = "ramsey-collection-ad7475d1c9e70b190ecffc58f2d989416af339b4";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/collection/zipball/ad7475d1c9e70b190ecffc58f2d989416af339b4";
          sha256 = "1a1wqdwdrbzkf2hias2kw9crr31265pn027vm69pr7alyq2qrzfw";
        };
      };
    };
    "ramsey/uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "ramsey-uuid-60a4c63ab724854332900504274f6150ff26d286";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/60a4c63ab724854332900504274f6150ff26d286";
          sha256 = "1w1i50pbd18awmvzqjkbszw79dl09912ibn95qm8lxr4nsjvbb27";
=======
        name = "ramsey-uuid-fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
        src = fetchurl {
          url = "https://api.github.com/repos/ramsey/uuid/zipball/fc9bb7fb5388691fd7373cd44dcb4d63bbcf24df";
          sha256 = "1fhjsyidsj95x5dd42z3hi5qhzii0hhhxa7xvc5jj7spqjdbqln4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    "socialiteproviders/discord" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "socialiteproviders-discord-c71c379acfdca5ba4aa65a3db5ae5222852a919c";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Discord/zipball/c71c379acfdca5ba4aa65a3db5ae5222852a919c";
          sha256 = "0xly514yax8rlz91pp86s24apcam1cvjnphanjhdshd42hmpwr7w";
=======
        name = "socialiteproviders-discord-c6eddeb07ace7473e82d02d4db852dfacf5ef574";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Discord/zipball/c6eddeb07ace7473e82d02d4db852dfacf5ef574";
          sha256 = "1w8m7jmlsdk94cqckgd75mwblh3jj6j16w3g4hzysyms25g091xc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
        name = "socialiteproviders-manager-47402cbc5b7ef445317e799bf12fd5a12062206c";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/47402cbc5b7ef445317e799bf12fd5a12062206c";
          sha256 = "0lmsb1ni27dw1zipd3l24dzm43xggh4dd92iws3r161s4pppf7sc";
=======
        name = "socialiteproviders-manager-738276dfbc2b68a9145db7b3df1588d53db528a1";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Manager/zipball/738276dfbc2b68a9145db7b3df1588d53db528a1";
          sha256 = "0d7ayh72cdxkslmgdgj0d6rkqghyhbdhdhkiz9064virm7fa5ii0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "socialiteproviders/microsoft-azure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-microsoft-azure-7522b27cd8518706b50e03b40a396fb0a6891feb";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Microsoft-Azure/zipball/7522b27cd8518706b50e03b40a396fb0a6891feb";
          sha256 = "0nlxyvcn3vc273rq9cp2yhm72mqfj31csnla5bqsaqdshzfk8pna";
        };
      };
    };
    "socialiteproviders/okta" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "socialiteproviders-okta-e5fb62035bfa0ccdbc8facf4cf205428fc502edb";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Okta/zipball/e5fb62035bfa0ccdbc8facf4cf205428fc502edb";
          sha256 = "0lrinkzlf39yr990n5dzn6slpgihrkh970dfz3m8ddcgwa04rw2m";
=======
        name = "socialiteproviders-okta-7c0b7522423943131f680e74123b71ccd3989541";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Okta/zipball/7c0b7522423943131f680e74123b71ccd3989541";
          sha256 = "1hly2f06k6jxjxz36swa3b0g285ni556k3wz089f3lxyrnhwnkdf";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "socialiteproviders/slack" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-slack-2b781c95daf06ec87a8f3deba2ab613d6bea5e8d";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Slack/zipball/2b781c95daf06ec87a8f3deba2ab613d6bea5e8d";
          sha256 = "1xilg7l1wc1vgwyakhfl8dpvgkjqx90g4khvzi411j9xa2wvpprh";
        };
      };
    };
    "socialiteproviders/twitch" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "socialiteproviders-twitch-7accf30ae7a3139b757b4ca8f34989c09a3dbee7";
        src = fetchurl {
          url = "https://api.github.com/repos/SocialiteProviders/Twitch/zipball/7accf30ae7a3139b757b4ca8f34989c09a3dbee7";
          sha256 = "089i4fwxb32zmbxib0544jfs48wzjyp7bsqss2bf2xx89dsrx4ah";
        };
      };
    };
    "ssddanbrown/htmldiff" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-htmldiff-58f81857c02b50b199273edb4cc339876b5a4038";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/HtmlDiff/zipball/58f81857c02b50b199273edb4cc339876b5a4038";
          sha256 = "0ixsi2s1igvciwnal1v2w654n4idbfs8ipyiixch7k5nzxl4g7wm";
        };
      };
    };
<<<<<<< HEAD
    "ssddanbrown/symfony-mailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "ssddanbrown-symfony-mailer-2219dcdc5f58e4f382ce8f1e6942d16982aa3012";
        src = fetchurl {
          url = "https://api.github.com/repos/ssddanbrown/symfony-mailer/zipball/2219dcdc5f58e4f382ce8f1e6942d16982aa3012";
          sha256 = "14j99gr09mvgjf6jjxbw50zay8n9mg6c0w429hz3vrfaijc2ih8c";
=======
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-8a5d5072dca8f48460fce2f4131fcc495eec654c";
        src = fetchurl {
          url = "https://api.github.com/repos/swiftmailer/swiftmailer/zipball/8a5d5072dca8f48460fce2f4131fcc495eec654c";
          sha256 = "1p9m4fw9y9md9a7msbmnc0hpdrky8dwrllnyg1qf1cdyp9d70x1d";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-console-c3ebc83d031b71c39da318ca8b7a07ecc67507ed";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/c3ebc83d031b71c39da318ca8b7a07ecc67507ed";
          sha256 = "1vvdw2fg08x9788m50isspi06n0lhw6c6nif3di1snxfq0sgb1np";
=======
        name = "symfony-console-58422fdcb0e715ed05b385f70d3e8b5ed4bbd45f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/console/zipball/58422fdcb0e715ed05b385f70d3e8b5ed4bbd45f";
          sha256 = "1r8a7hra81wfs10m235qhq9xdgini4gx9hf86l1ijbp7k6aszk7b";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-css-selector-f1d00bddb83a4cb2138564b2150001cb6ce272b1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/f1d00bddb83a4cb2138564b2150001cb6ce272b1";
          sha256 = "0nl94wjr5sm4yrx9y0vwk4dzh1hm17f1n3d71hmj7biyzds0474i";
=======
        name = "symfony-css-selector-052ef49b660f9ad2a3adb311c555c9bc11ba61f4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/css-selector/zipball/052ef49b660f9ad2a3adb311c555c9bc11ba61f4";
          sha256 = "1nracybpl4i2w6vcfhymd0p7bj9cnk5s2frp6dah4anfhmdjk16a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/deprecation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-deprecation-contracts-26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/26954b3d62a6c5fd0ea8a2a00c0353a14978d05c";
          sha256 = "1wlaj9ngbyjmgr92gjyf7lsmjfswyh8vpbzq5rdzaxjb6bcsj3dp";
=======
        name = "symfony-deprecation-contracts-e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/deprecation-contracts/zipball/e8b495ea28c1d97b5e0c121748d6f9b53d075c66";
          sha256 = "09k869asjb7cd3xh8i5ps824k5y6v510sbpzfalndwy3knig9fig";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/error-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-error-handler-c7df52182f43a68522756ac31a532dd5b1e6db67";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/c7df52182f43a68522756ac31a532dd5b1e6db67";
          sha256 = "1dqr0n3w6zmk96q7x8pz1przkiyb2kyg5mw3d1nmnyry8dryv7c8";
=======
        name = "symfony-error-handler-b900446552833ad2f91ca7dd52aa8ffe78f66cb2";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/error-handler/zipball/b900446552833ad2f91ca7dd52aa8ffe78f66cb2";
          sha256 = "0rsp4l6azy715r638xbxp8aydksz8v8r2kaz2590bg7c44v52zf0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-event-dispatcher-2eaf8e63bc5b8cefabd4a800157f0d0c094f677a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/2eaf8e63bc5b8cefabd4a800157f0d0c094f677a";
          sha256 = "0wwphxh21n502wgldh3kqqhvl1zxh2yncbadwwh05d8sp5mz0ysn";
=======
        name = "symfony-event-dispatcher-8e18a9d559eb8ebc2220588f1faa726a2fcd31c9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher/zipball/8e18a9d559eb8ebc2220588f1faa726a2fcd31c9";
          sha256 = "0mp91rpqbjarbh9jzyqa8cv012ilarwa9yx2rhqvms8bhk0aq7qi";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/event-dispatcher-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-event-dispatcher-contracts-7bc61cc2db649b4637d331240c5346dcc7708051";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/7bc61cc2db649b4637d331240c5346dcc7708051";
          sha256 = "1crx2j4g5jn904fwk7919ar9zpyfd5bvgm80lmyg15kinsjm3w4i";
=======
        name = "symfony-event-dispatcher-contracts-f98b54df6ad059855739db6fcbc2d36995283fe1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/event-dispatcher-contracts/zipball/f98b54df6ad059855739db6fcbc2d36995283fe1";
          sha256 = "114zpsd8vac016a0ppf5ag5lmgllrha7nwln8vvhq9282r79xhsl";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-finder-5cc9cac6586fc0c28cd173780ca696e419fefa11";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/5cc9cac6586fc0c28cd173780ca696e419fefa11";
          sha256 = "1f0sbxczwcrzxb03cc2rshfzdrkjfg7nwkbvvi449qscaq1qx2dc";
=======
        name = "symfony-finder-40c08632019838dfb3350f18cf5563b8080055fc";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/finder/zipball/40c08632019838dfb3350f18cf5563b8080055fc";
          sha256 = "0gszqsqjgjf05hrycks1sgvizlfx1y6qnwh8cvcih50nmqn2q950";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-http-foundation-e16b2676a4b3b1fa12378a20b29c364feda2a8d6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/e16b2676a4b3b1fa12378a20b29c364feda2a8d6";
          sha256 = "0d2fgzcxi7sq7j8l1lg2kpfsr6p1xk1lxdjyqr63vihm34i8p42g";
=======
        name = "symfony-http-foundation-b64a0e2df212d5849e4584cabff0cf09c5d6866a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-foundation/zipball/b64a0e2df212d5849e4584cabff0cf09c5d6866a";
          sha256 = "01l1349d2pab5vsihripq8718988yz1kh67bpp3j1xvgzd09b5a1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/http-kernel" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-http-kernel-6dc70833fd0ef5e861e17c7854c12d7d86679349";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/6dc70833fd0ef5e861e17c7854c12d7d86679349";
          sha256 = "1j1z911g4nsx7wjg14q1g7y98qj1k4crxnwxi97i4cjnyqihcj2r";
=======
        name = "symfony-http-kernel-5da6f57a13e5d7d77197443cf55697cdf65f1352";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/http-kernel/zipball/5da6f57a13e5d7d77197443cf55697cdf65f1352";
          sha256 = "1y0mqas5v4rhrmsgizv6pqqhxy49hm6wfs1wahaaxcm3zjip1504";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-mime-d7052547a0070cbeadd474e172b527a00d657301";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/d7052547a0070cbeadd474e172b527a00d657301";
          sha256 = "005jfcpcdn8p2qqv1kyh14jijx36n3rrh9v9a9immfdr0gyv22ca";
=======
        name = "symfony-mime-2a83d82efc91c3f03a23c8b47a896df168aa5c63";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/mime/zipball/2a83d82efc91c3f03a23c8b47a896df168aa5c63";
          sha256 = "1rkg5728y052hq1sag41w46kxnmyfm6jf5bn29canbnx05x32xly";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-5bbc823adecdae860bb64756d639ecfec17b050a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-ctype/zipball/5bbc823adecdae860bb64756d639ecfec17b050a";
          sha256 = "0vyv70z1yi2is727d1mkb961w5r1pb1v3wy1pvdp30h8ffy15wk6";
        };
      };
    };
<<<<<<< HEAD
=======
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-927013f3aac555983a5059aada98e1907d842695";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-iconv/zipball/927013f3aac555983a5059aada98e1907d842695";
          sha256 = "1qmnzd3r2l35rx84r8ai0596dywsj7q5y3dngaf1vsz16k5ig409";
        };
      };
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "symfony/polyfill-intl-grapheme" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-grapheme-511a08c03c1960e08a883f4cffcacd219b758354";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-grapheme/zipball/511a08c03c1960e08a883f4cffcacd219b758354";
          sha256 = "0ifsgsyxf0z0nkynqvr5259dm5dsmbgdpvyi5zfvy8935mi0ki0i";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-639084e360537a19f9ee352433b84ce831f3d2da";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/639084e360537a19f9ee352433b84ce831f3d2da";
          sha256 = "1i2wcsbfbwdyrx8545yrrvbdaf4l2393pjvg9266q74611j6pzxj";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-19bd1e4fcd5b91116f14d8533c57831ed00571b6";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/19bd1e4fcd5b91116f14d8533c57831ed00571b6";
          sha256 = "1d80jph5ykiw6ydv8fwd43s0aglh24qc1yrzds2f3aqanpbk1gr2";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-8ad114f6b39e2c98a8b0e3bd907732c207c2b534";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-mbstring/zipball/8ad114f6b39e2c98a8b0e3bd907732c207c2b534";
          sha256 = "1ym84qp609i50lv4vkd4yz99y19kaxd5kmpdnh66mxx1a4a104mi";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-869329b1e9894268a8a61dabb69153029b7a8c97";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php72/zipball/869329b1e9894268a8a61dabb69153029b7a8c97";
          sha256 = "1h0lbh8d41sa4fymmw03yzws3v3z0lz4lv1kgcld7r53i2m3wfwp";
        };
      };
    };
<<<<<<< HEAD
=======
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-9e8ecb5f92152187c4799efd3c96b78ccab18ff9";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php73/zipball/9e8ecb5f92152187c4799efd3c96b78ccab18ff9";
          sha256 = "1p0jr92x323pl4frjbhmziyk5g1zig1g30i1v1p0wfli2sq8h5mb";
        };
      };
    };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-7a6ff3f1959bb01aefccb463a0f2cd3d3d2fd936";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php80/zipball/7a6ff3f1959bb01aefccb463a0f2cd3d3d2fd936";
          sha256 = "16yydk7rsknlasrpn47n4b4js8svvp4rxzw99dkav52wr3cqmcwd";
        };
      };
    };
    "symfony/polyfill-php81" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php81-707403074c8ea6e2edaf8794b0157a0bfa52157a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-php81/zipball/707403074c8ea6e2edaf8794b0157a0bfa52157a";
          sha256 = "05qrjfnnnz402l11wm0ydblrip7hjll12yqxmh2wd02b0s8dj29f";
        };
      };
    };
<<<<<<< HEAD
    "symfony/polyfill-uuid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-uuid-f3cf1a645c2734236ed1e2e671e273eeb3586166";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/polyfill-uuid/zipball/f3cf1a645c2734236ed1e2e671e273eeb3586166";
          sha256 = "1pjh861iwlf71frm9f9i7acw4bbiq40gkh96a5wd09nfd2c3w7mc";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-2114fd60f26a296cc403a7939ab91478475a33d4";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/2114fd60f26a296cc403a7939ab91478475a33d4";
          sha256 = "1rpcl0qayf0jysfn95c4s73r7fl48sng4m5flxy099z6m6bblwq1";
=======
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-6e75fe6874cbc7e4773d049616ab450eff537bf1";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/process/zipball/6e75fe6874cbc7e4773d049616ab450eff537bf1";
          sha256 = "0jzymj7jh9zm376p3ydq6adid9cxd8fmmk2hdnyjk30chsb37yfw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/routing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-routing-e56ca9b41c1ec447193474cd86ad7c0b547755ac";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/e56ca9b41c1ec447193474cd86ad7c0b547755ac";
          sha256 = "0qsx525fhqnx6g5rn8lavzpqccrg2ixrp88p1g4yjr8x7i2im5nd";
=======
        name = "symfony-routing-4ce2df9a469c19ba45ca6aca04fec1c358a6e791";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/routing/zipball/4ce2df9a469c19ba45ca6aca04fec1c358a6e791";
          sha256 = "1dqnxgkm817msrimhfs9l3d3k4zsjy7zgy2avaq23sm4yvm3nbyw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-service-contracts-d78d39c1599bd1188b8e26bb341da52c3c6d8a66";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/d78d39c1599bd1188b8e26bb341da52c3c6d8a66";
          sha256 = "1cgbn2yx2fyrc3c1d85vdriiwwifr1sdg868f3rhq9bh78f03z99";
=======
        name = "symfony-service-contracts-4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/service-contracts/zipball/4b426aac47d6427cc1a1d0f7e2ac724627f5966c";
          sha256 = "0lh0vxy0h4wsjmnlf42s950bicsvkzz6brqikfnfb5kmvi0xhcm6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/string" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-string-d9e72497367c23e08bf94176d2be45b00a9d232a";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/d9e72497367c23e08bf94176d2be45b00a9d232a";
          sha256 = "0k4vvcjfdp2dni8gzq4rn8d6n0ivd38sfna70lgsh8vlc8rrlhpf";
=======
        name = "symfony-string-55733a8664b8853b003e70251c58bc8cb2d82a6b";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/string/zipball/55733a8664b8853b003e70251c58bc8cb2d82a6b";
          sha256 = "0mbagzl3kmrfdkvrb2nddngnzz0cy18r59gipmfsa60n1d7bww4l";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-translation-9c24b3fdbbe9fb2ef3a6afd8bbaadfd72dad681f";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/9c24b3fdbbe9fb2ef3a6afd8bbaadfd72dad681f";
          sha256 = "12c13k5ljch06g8xp28kkpv0ml67hy086rk25mzd94hjpawrs4x2";
=======
        name = "symfony-translation-f0ed07675863aa6e3939df8b1bc879450b585cab";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation/zipball/f0ed07675863aa6e3939df8b1bc879450b585cab";
          sha256 = "0a6y9glxjaiflprlr3fk8qgjdhqmqzjf912pq1qbn0lmc7f0y8pr";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/translation-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-translation-contracts-acbfbb274e730e5a0236f619b6168d9dedb3e282";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/acbfbb274e730e5a0236f619b6168d9dedb3e282";
          sha256 = "1r496j63a6q3ch0ax76qa1apmc4iqf41zc8rf6yn8vkir3nzkqr0";
        };
      };
    };
    "symfony/uid" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-uid-6499e28b0ac9f2aa3151e11845bdb5cd21e6bb9d";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/uid/zipball/6499e28b0ac9f2aa3151e11845bdb5cd21e6bb9d";
          sha256 = "12r2jgmwwchmq4apgmb2h1hy6i4cznjpc94976h2qzy3q3yp7zyq";
=======
        name = "symfony-translation-contracts-136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/translation-contracts/zipball/136b19dd05cdf0709db6537d058bcab6dd6e2dbe";
          sha256 = "1z1514i3gsxdisyayzh880i8rj954qim7c183cld91kvvqcqi7x0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "symfony/var-dumper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "symfony-var-dumper-eb980457fa6899840fe1687e8627a03a7d8a3d52";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/eb980457fa6899840fe1687e8627a03a7d8a3d52";
          sha256 = "183igs4i74kljxyq7azpg59wb281mlvy1xgqnb4pkz4dw50jgc2k";
=======
        name = "symfony-var-dumper-ad74890513d07060255df2575703daf971de92c7";
        src = fetchurl {
          url = "https://api.github.com/repos/symfony/var-dumper/zipball/ad74890513d07060255df2575703daf971de92c7";
          sha256 = "0i1k6x0rfg17fjbcqgppp0vmhp7y597vik7vs6475v20rmvhdncd";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        };
      };
    };
    "tijsverkoyen/css-to-inline-styles" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tijsverkoyen-css-to-inline-styles-c42125b83a4fa63b187fdf29f9c93cb7733da30c";
        src = fetchurl {
          url = "https://api.github.com/repos/tijsverkoyen/CssToInlineStyles/zipball/c42125b83a4fa63b187fdf29f9c93cb7733da30c";
          sha256 = "0ckk04hwwz0fdkfr20i7xrhdjcnnw1b0liknbb81qyr1y4b7x3dd";
        };
      };
    };
    "vlucas/phpdotenv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "vlucas-phpdotenv-1a7ea2afc49c3ee6d87061f5a233e3a035d0eae7";
        src = fetchurl {
          url = "https://api.github.com/repos/vlucas/phpdotenv/zipball/1a7ea2afc49c3ee6d87061f5a233e3a035d0eae7";
          sha256 = "13h4xyxhdjn1n7xcxbcdhj20rv5fsaigbsbz61x2i224hj76620a";
        };
      };
    };
    "voku/portable-ascii" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
<<<<<<< HEAD
        name = "voku-portable-ascii-b56450eed252f6801410d810c8e1727224ae0743";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/b56450eed252f6801410d810c8e1727224ae0743";
          sha256 = "0gwlv1hr6ycrf8ik1pnvlwaac8cpm8sa1nf4d49s8rp4k2y5anyl";
=======
        name = "voku-portable-ascii-87337c91b9dfacee02452244ee14ab3c43bc485a";
        src = fetchurl {
          url = "https://api.github.com/repos/voku/portable-ascii/zipball/87337c91b9dfacee02452244ee14ab3c43bc485a";
          sha256 = "1j2xpbv7xiwxwb6gfc3h6imc6xcbyb2jw3h8wgfnpvjl5yfbi4xb";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
  name = "bookstack";
  src = composerEnv.filterSrc ./.;
  executable = false;
  symlinkDependencies = false;
  meta = {
    license = "MIT";
  };
}

