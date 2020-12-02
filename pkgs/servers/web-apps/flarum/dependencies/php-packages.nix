{composerEnv, fetchurl, fetchgit ? null, fetchhg ? null, fetchsvn ? null, noDev ? false}:

let
  packages = {
    "axy/backtrace" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "axy-backtrace-c6c7d0f3497a07ae934f9e8511cbc2286db311c5";
        src = fetchurl {
          url = https://api.github.com/repos/axypro/backtrace/zipball/c6c7d0f3497a07ae934f9e8511cbc2286db311c5;
          sha256 = "0m6apdlimay8jc2migzl53v7c28b9xw15ify7hy3xr15wawf503n";
        };
      };
    };
    "axy/codecs-base64vlq" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "axy-codecs-base64vlq-53a1957f2cb773c6533ac615b3f1ac59e40e13cc";
        src = fetchurl {
          url = https://api.github.com/repos/axypro/codecs-base64vlq/zipball/53a1957f2cb773c6533ac615b3f1ac59e40e13cc;
          sha256 = "1wzgh1cfkz7wz9jzi56mkgr57x9yxcrmw8qhl5bbsmf5fjbypq98";
        };
      };
    };
    "axy/errors" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "axy-errors-2c64374ae2b9ca51304c09b6b6acc275557fc34f";
        src = fetchurl {
          url = https://api.github.com/repos/axypro/errors/zipball/2c64374ae2b9ca51304c09b6b6acc275557fc34f;
          sha256 = "01nhzh53f88p0pzjd96wfgk61y604h9051giwh74qxrw2fmc7a7r";
        };
      };
    };
    "axy/sourcemap" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "axy-sourcemap-95a52df5a08c3a011031dae2e79390134e28467c";
        src = fetchurl {
          url = https://api.github.com/repos/axypro/sourcemap/zipball/95a52df5a08c3a011031dae2e79390134e28467c;
          sha256 = "05v1c6nkmzfffqy33x56alsxcpkjg5n4x83cpk0mpk8hzk6rprpz";
        };
      };
    };
    "components/font-awesome" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "components-font-awesome-1be57c473b964c8130f2dbd9edc4f64db5394114";
        src = fetchurl {
          url = https://api.github.com/repos/components/font-awesome/zipball/1be57c473b964c8130f2dbd9edc4f64db5394114;
          sha256 = "04881xx5xwz7qr0g3d1vw16yyn0qv9rkycb2kn4shkkl7l94vxh2";
        };
      };
    };
    "dflydev/fig-cookies" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "dflydev-fig-cookies-883233c159d00d39e940bd12cfe42c0d23420c1c";
        src = fetchurl {
          url = https://api.github.com/repos/dflydev/dflydev-fig-cookies/zipball/883233c159d00d39e940bd12cfe42c0d23420c1c;
          sha256 = "14ajs56lqk6ljdag46y1fhy6fc87nr735rgysvw6955r99npnxds";
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
        name = "doctrine-dbal-aab745e7b6b2de3b47019da81e7225e14dcfdac8";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/dbal/zipball/aab745e7b6b2de3b47019da81e7225e14dcfdac8;
          sha256 = "04c6r4p1b0iknjk95hpc4fsyxg8s2x1skfmnx2g11z64jvldzs62";
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
        name = "doctrine-inflector-4650c8b30c753a76bf44fb2ed00117d6f367490c";
        src = fetchurl {
          url = https://api.github.com/repos/doctrine/inflector/zipball/4650c8b30c753a76bf44fb2ed00117d6f367490c;
          sha256 = "13jnzwpzz63i6zipmhb22lv35l5gq6wmji0532c94331wcq5bvv9";
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
    "egulias/email-validator" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "egulias-email-validator-840d5603eb84cc81a6a0382adac3293e57c1c64c";
        src = fetchurl {
          url = https://api.github.com/repos/egulias/EmailValidator/zipball/840d5603eb84cc81a6a0382adac3293e57c1c64c;
          sha256 = "02gwz6lw5cx3ja7pvgyqx37qs4ks7ki5lwii1j8a6d7x90s4y2jy";
        };
      };
    };
    "erusev/parsedown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "erusev-parsedown-cb17b6477dfff935958ba01325f2e8a2bfa6dab3";
        src = fetchurl {
          url = https://api.github.com/repos/erusev/parsedown/zipball/cb17b6477dfff935958ba01325f2e8a2bfa6dab3;
          sha256 = "1iil9v8g03m5vpxxg3a5qb2sxd1cs5c4p5i0k00cqjnjsxfrazxd";
        };
      };
    };
    "fig/http-message-util" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fig-http-message-util-3242caa9da7221a304b8f84eb9eaddae0a7cf422";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-message-util/zipball/3242caa9da7221a304b8f84eb9eaddae0a7cf422;
          sha256 = "1cjbbsb8z4g340aqg8wrrc4vd9b7dksclqb7sh0xlmigjihn4shk";
        };
      };
    };
    "filp/whoops" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "filp-whoops-5d5fe9bb3d656b514d455645b3addc5f7ba7714d";
        src = fetchurl {
          url = https://api.github.com/repos/filp/whoops/zipball/5d5fe9bb3d656b514d455645b3addc5f7ba7714d;
          sha256 = "09v5pzdjw92fi1xd4fa3h08mc55pg93za4nzd02n62x7vqp06mm8";
        };
      };
    };
    "flarum/approval" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-approval-a93aa0c490ea4e73ac9999b580734febcd9b97a5";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/approval/zipball/a93aa0c490ea4e73ac9999b580734febcd9b97a5;
          sha256 = "08dmk828haksw1vrnlanl6008hrk5f7x34bch416l43mvkc4dfwq";
        };
      };
    };
    "flarum/auth-facebook" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-auth-facebook-434acf36b882b9deb0f6f1f1c1d03ad33d3e0936";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/auth-facebook/zipball/434acf36b882b9deb0f6f1f1c1d03ad33d3e0936;
          sha256 = "1m6l0mhvllm6170anil7al5yjjgnrvdgb3iippc4gli5gj7cm4v9";
        };
      };
    };
    "flarum/auth-github" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-auth-github-d01b8349c49cf9807bdf9da86ff1d5f1a8d7c853";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/auth-github/zipball/d01b8349c49cf9807bdf9da86ff1d5f1a8d7c853;
          sha256 = "0l91bjlkmpliqm45c9adfibnhk5dc8sx3v3r1k6ipi7v8rfa7d4v";
        };
      };
    };
    "flarum/auth-twitter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-auth-twitter-f96265c36ccb49e0d16734907ffd6acb6108ce75";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/auth-twitter/zipball/f96265c36ccb49e0d16734907ffd6acb6108ce75;
          sha256 = "0mchmwvdvd7pgpn22cvgskamghhb1sispn3r6yawdzbvs6fsb44j";
        };
      };
    };
    "flarum/bbcode" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-bbcode-165c47059e1f44cae56cc5462366c92ca96dcc33";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/bbcode/zipball/165c47059e1f44cae56cc5462366c92ca96dcc33;
          sha256 = "1l0xrjdmjywdazdffn62y9aabxg7sa67b14lhmf0mhkfg6l4lyp9";
        };
      };
    };
    "flarum/core" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-core-fd371c1203439810af8f6814cdff402faebf4126";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/core/zipball/fd371c1203439810af8f6814cdff402faebf4126;
          sha256 = "07rbnfj2n23p92jxxl2c879cqf5yq8pa0a14q6vyisarz2hl38d1";
        };
      };
    };
    "flarum/emoji" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-emoji-0155803b0503727c9962d3994f59e7f3d34dd629";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/emoji/zipball/0155803b0503727c9962d3994f59e7f3d34dd629;
          sha256 = "0pff0m354lrgdnmmgqmplxvw9y5s375r8bhkxykjhn4w5m7az43f";
        };
      };
    };
    "flarum/flags" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-flags-dfa0b09545937b95010f63a122cdc16f9f23696c";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/flags/zipball/dfa0b09545937b95010f63a122cdc16f9f23696c;
          sha256 = "0xvhiqrm3q5d5bqx7s4dqhj0gqjy1ir7idxyisqw9sf49df94y0r";
        };
      };
    };
    "flarum/lang-english" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-lang-english-9056fca21d357d24700aa11b98ff277f23542675";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/lang-english/zipball/9056fca21d357d24700aa11b98ff277f23542675;
          sha256 = "1dhkikjc8yw64bmzx4drjx0yf1gnq46hlp609kx1m8qknvfmlnyc";
        };
      };
    };
    "flarum/likes" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-likes-18681e5d671fdc06a9e6b8c2bef2b1cd8ecafa66";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/likes/zipball/18681e5d671fdc06a9e6b8c2bef2b1cd8ecafa66;
          sha256 = "109mj7gm4jy3dqj20cdah2zfymy9qnk5lp0wmh2817x88z87z6sh";
        };
      };
    };
    "flarum/lock" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-lock-9c44e335b6e9e9d38a72c278ff6e55c904ae0864";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/lock/zipball/9c44e335b6e9e9d38a72c278ff6e55c904ae0864;
          sha256 = "1b0zg7wlfk66zi9wjxijv3fyqbhj9zpa2pnvwjm4sp0i51s57761";
        };
      };
    };
    "flarum/markdown" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-markdown-0fabad5137c535f561fb6464daf61b68dc6120d7";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/markdown/zipball/0fabad5137c535f561fb6464daf61b68dc6120d7;
          sha256 = "0y3fiwsxsgn8vms447an4nc7pmwvs5bzfkn2yg6i18l6nj01zq0y";
        };
      };
    };
    "flarum/mentions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-mentions-63e203b608bd86b6d0fbd9db189227a2d54bf12f";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/mentions/zipball/63e203b608bd86b6d0fbd9db189227a2d54bf12f;
          sha256 = "1scdzgs2b2wh48imq578nwpanb9hqyzkrv0nhvrmi92ga7n8dbdb";
        };
      };
    };
    "flarum/pusher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-pusher-0f4955004c16b9ce230307b6539b0e389d9804cd";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/pusher/zipball/0f4955004c16b9ce230307b6539b0e389d9804cd;
          sha256 = "1a43bq4ij5j2irs12kpkafx1pdydm1h7kai8zg66w9j9jyrrxqf6";
        };
      };
    };
    "flarum/statistics" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-statistics-24f396e81e76d2ad0176d5818bea8110b1564820";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/statistics/zipball/24f396e81e76d2ad0176d5818bea8110b1564820;
          sha256 = "14ybvqx34f11qnyzvbmfnyjv9an9jf8wjv2i2zrqbm02d1ja62mh";
        };
      };
    };
    "flarum/sticky" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-sticky-683c3742833d74243e75a30417a4d61ecdb87551";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/sticky/zipball/683c3742833d74243e75a30417a4d61ecdb87551;
          sha256 = "1z46zjkn89y9jrijliyijn4xycr60kpcqyk7yabm08apflghss0n";
        };
      };
    };
    "flarum/subscriptions" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-subscriptions-bf017e06d7e312e37ef5309b26bc2ec55263731c";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/subscriptions/zipball/bf017e06d7e312e37ef5309b26bc2ec55263731c;
          sha256 = "1mwqwqh453f2c69m23hkz23zd98k2mxqsd957ifry2yl62wv7lk0";
        };
      };
    };
    "flarum/suspend" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-suspend-095f9bada0ef251f48c38a608f523bfea6eba67e";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/suspend/zipball/095f9bada0ef251f48c38a608f523bfea6eba67e;
          sha256 = "1ji0cg7mdiqpcbk8lxc6g8wlq2hcxzfirl6dwxhmhw0hmcqwrh0i";
        };
      };
    };
    "flarum/tags" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "flarum-tags-fa83f496b0004e31ef2f4fc854bfcdf6a4cfa3c3";
        src = fetchurl {
          url = https://api.github.com/repos/flarum/tags/zipball/fa83f496b0004e31ef2f4fc854bfcdf6a4cfa3c3;
          sha256 = "0vb47ysdfi2mlyfd3v4bqcqb6ylhv9zj8y92i3y8zkj9y65mzjcy";
        };
      };
    };
    "fof/upload" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "fof-upload-c21fab65ce6dc6cf696de88da1359f58d59a36ca";
        src = fetchurl {
          url = https://api.github.com/repos/FriendsOfFlarum/upload/zipball/c21fab65ce6dc6cf696de88da1359f58d59a36ca;
          sha256 = "1maha49pq2cdpn4h168qw8yvl98lsj85j33ymq395yfd4zg77ziw";
        };
      };
    };
    "franzl/whoops-middleware" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "franzl-whoops-middleware-625a80d90b22c38d8a9372187e76ae5f844e4412";
        src = fetchurl {
          url = https://api.github.com/repos/franzliedke/whoops-middleware/zipball/625a80d90b22c38d8a9372187e76ae5f844e4412;
          sha256 = "1gmrgh1nvr62xsq3gsxashfrqw69a2qihmk9vnrdzcf198ckwnyi";
        };
      };
    };
    "guzzlehttp/guzzle" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "guzzlehttp-guzzle-9d4290de1cfd701f38099ef7e183b64b4b7b0c5e";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/guzzle/zipball/9d4290de1cfd701f38099ef7e183b64b4b7b0c5e;
          sha256 = "1dlrdpil0173cmx73ghy8iis2j0lk00dzv3n166d0riky21n8djb";
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
        name = "guzzlehttp-psr7-239400de7a173fe9901b9ac7c06497751f00727a";
        src = fetchurl {
          url = https://api.github.com/repos/guzzle/psr7/zipball/239400de7a173fe9901b9ac7c06497751f00727a;
          sha256 = "0mfq93x7ayix6l3v5jkk40a9hnmrxaqr9vk1r26q39d1s6292ma7";
        };
      };
    };
    "illuminate/bus" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-bus-5cad4bff635071ff07c317aad200a8c2169f264f";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/bus/zipball/5cad4bff635071ff07c317aad200a8c2169f264f;
          sha256 = "04w0hizxkfy98rrh1r7saqw4xkab12ld621hxhnrp53q83418y4a";
        };
      };
    };
    "illuminate/cache" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-cache-7998b137cc723dd5e68846ada33f8c0143f5b10f";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/cache/zipball/7998b137cc723dd5e68846ada33f8c0143f5b10f;
          sha256 = "1ka41kw2f4jbm53iap0qkpa7wi8i59h3hrw9nnvray6n1igd8py0";
        };
      };
    };
    "illuminate/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-config-540e11b9ae058c9a94051d9ca6c02e40258c71fd";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/config/zipball/540e11b9ae058c9a94051d9ca6c02e40258c71fd;
          sha256 = "0jl1hmlxcd953wp9ny1izjp6i2xyggj00hihkcarprplq767kcn6";
        };
      };
    };
    "illuminate/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-console-0d97b6ead0cbb09140b1e8317f5a9d9f69ff9ec6";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/console/zipball/0d97b6ead0cbb09140b1e8317f5a9d9f69ff9ec6;
          sha256 = "0w42d1awawdapd21bg3icrxcrx9aw3kc0pcq0qz26i1020nn0021";
        };
      };
    };
    "illuminate/container" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-container-8c3a75e464d59509ae88db152cab61a3f115b9ec";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/container/zipball/8c3a75e464d59509ae88db152cab61a3f115b9ec;
          sha256 = "1z570fxx2lfy84g1p2dz22lx44m0h7fw7vqnlfcvi3fczw579f7i";
        };
      };
    };
    "illuminate/contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-contracts-b63324d349a8ae2156fbc2697c1ccc85879b3803";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/contracts/zipball/b63324d349a8ae2156fbc2697c1ccc85879b3803;
          sha256 = "0g34fmhpjdw5cdx1r3dww4mym4izl3ywxy3rkxblxwb1j7328262";
        };
      };
    };
    "illuminate/database" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-database-c0702cb8c665cab8d080a81de5a44ac672b26d62";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/database/zipball/c0702cb8c665cab8d080a81de5a44ac672b26d62;
          sha256 = "01lga1wghfbmax29hn0zw82zqilf7cgl2xl1sbyg0idi7ss6cq26";
        };
      };
    };
    "illuminate/events" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-events-e48888062a9962f30c431524357b9a815b093609";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/events/zipball/e48888062a9962f30c431524357b9a815b093609;
          sha256 = "19b4p7b001wf6lskrjlnhm7yjp4viidlda9s5kh8rdqybvn2h9l5";
        };
      };
    };
    "illuminate/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-filesystem-ff853e678a93996b1d0a3ddc6fc56c10bae0de30";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/filesystem/zipball/ff853e678a93996b1d0a3ddc6fc56c10bae0de30;
          sha256 = "05pipw206aalma04rrky6ncglg4mnzxx1szd5wxafij2cw1pf92q";
        };
      };
    };
    "illuminate/hashing" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-hashing-c56e2e6cedadeddb677702820bec3c08097b9e44";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/hashing/zipball/c56e2e6cedadeddb677702820bec3c08097b9e44;
          sha256 = "014y6czr4g6pcj6lp36rhlz2dvq4yx9bsbnykwha6gximq1lk6sd";
        };
      };
    };
    "illuminate/mail" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-mail-91ac88078b481f4b8bde7403f8bcb406be70769e";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/mail/zipball/91ac88078b481f4b8bde7403f8bcb406be70769e;
          sha256 = "11m1xc5ll4972658gydjyf6502fd8cpcd075g7qyqr2drvmf5kjh";
        };
      };
    };
    "illuminate/pipeline" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-pipeline-63a6e66bfab88c9a7dd4bbb077634fac3df4aa2a";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/pipeline/zipball/63a6e66bfab88c9a7dd4bbb077634fac3df4aa2a;
          sha256 = "1qv0iwpyi3lv6l0hgik4azicmbrr1n8sayv7s16kfg1r7wg0h6ly";
        };
      };
    };
    "illuminate/queue" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-queue-44babb781fd61c665afc865be981dd7a3b494796";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/queue/zipball/44babb781fd61c665afc865be981dd7a3b494796;
          sha256 = "0lmmrgrlrzm31nsqcxq840y1r8gb9md1g1k5ign9pz3lhjwp602w";
        };
      };
    };
    "illuminate/session" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-session-0d1233ea455b9ad50112212022ca3bcff874fa86";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/session/zipball/0d1233ea455b9ad50112212022ca3bcff874fa86;
          sha256 = "1fg7019kiwlqgzlg4l88455294ligdlq9bjdy0nq5sl5vqjcb1ji";
        };
      };
    };
    "illuminate/support" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-support-3e2810145f37eb89fa11759781ee88ee1c1a5262";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/support/zipball/3e2810145f37eb89fa11759781ee88ee1c1a5262;
          sha256 = "1agi566ybjqq6nm703wmkm1gbdnscr67aljfyqgs72fgrb4pgazd";
        };
      };
    };
    "illuminate/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-translation-4875559c0f32892c4070ca1185127c71fe18b8cb";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/translation/zipball/4875559c0f32892c4070ca1185127c71fe18b8cb;
          sha256 = "1vhmfyn0xml78fcpiz0mkkj88hccvjp6baqrz7dg2rjarjc6b8zp";
        };
      };
    };
    "illuminate/validation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-validation-ee897c6708685294ebaa1db8407f30a1fe62f7f3";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/validation/zipball/ee897c6708685294ebaa1db8407f30a1fe62f7f3;
          sha256 = "17bwkv09cbn6nz6dzv3hhv5rwnhcxgkpc4h15ynnp1qch9w5g9jd";
        };
      };
    };
    "illuminate/view" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "illuminate-view-e19e4e16ad309503d27845383fc533a889581739";
        src = fetchurl {
          url = https://api.github.com/repos/illuminate/view/zipball/e19e4e16ad309503d27845383fc533a889581739;
          sha256 = "0j6wrr4w6hik3r872hmlnwpvfwp07jn1mzv326gjag0ylx8kyrwx";
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
    "kylekatarnls/update-helper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "kylekatarnls-update-helper-429be50660ed8a196e0798e5939760f168ec8ce9";
        src = fetchurl {
          url = https://api.github.com/repos/kylekatarnls/update-helper/zipball/429be50660ed8a196e0798e5939760f168ec8ce9;
          sha256 = "02lzagbgykk5bqqa203vkyh6xxblvsg6d8sfgsrzp0g228my4qpz";
        };
      };
    };
    "laminas/laminas-diactoros" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-diactoros-6991c1af7c8d2c8efee81b22ba97024781824aaa";
        src = fetchurl {
          url = https://api.github.com/repos/laminas/laminas-diactoros/zipball/6991c1af7c8d2c8efee81b22ba97024781824aaa;
          sha256 = "0rby0zv1sf8yh3qr2245r6mnjvzwfiydbskghazcrjld97nhgb6y";
        };
      };
    };
    "laminas/laminas-escaper" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-escaper-25f2a053eadfa92ddacb609dcbbc39362610da70";
        src = fetchurl {
          url = https://api.github.com/repos/laminas/laminas-escaper/zipball/25f2a053eadfa92ddacb609dcbbc39362610da70;
          sha256 = "1ryp3is9rmnnb02mzr68nh5vymw3j3ycbzggc0a82r1m3d5g5ckg";
        };
      };
    };
    "laminas/laminas-httphandlerrunner" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-httphandlerrunner-e1a5dad040e0043135e8095ee27d1fbf6fb640e1";
        src = fetchurl {
          url = https://api.github.com/repos/laminas/laminas-httphandlerrunner/zipball/e1a5dad040e0043135e8095ee27d1fbf6fb640e1;
          sha256 = "0qn0ip0ahsw4y1w442yky4i5fhnddmmznbcpjyaq53jicxzgdpk1";
        };
      };
    };
    "laminas/laminas-stratigility" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-stratigility-3f88aa174324bc9e6dd55715f401f9f25dbd722c";
        src = fetchurl {
          url = https://api.github.com/repos/laminas/laminas-stratigility/zipball/3f88aa174324bc9e6dd55715f401f9f25dbd722c;
          sha256 = "1lvhh2w1wyyjmxll136ia9g1kmvpjqkglrs6hdcvwjwb3abjay91";
        };
      };
    };
    "laminas/laminas-zendframework-bridge" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "laminas-laminas-zendframework-bridge-4939c81f63a8a4968c108c440275c94955753b19";
        src = fetchurl {
          url = https://api.github.com/repos/laminas/laminas-zendframework-bridge/zipball/4939c81f63a8a4968c108c440275c94955753b19;
          sha256 = "0ig89amx88a27bkzynwx8p40b2i20nysginy6pglq2niqjf6wih9";
        };
      };
    };
    "league/flysystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-flysystem-63cd8c14708b9544d3f61d3c15b747fda1c95c6e";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/flysystem/zipball/63cd8c14708b9544d3f61d3c15b747fda1c95c6e;
          sha256 = "11px6xc87x5b7pm5fmfdnrs7qaadbvg9lbhcszgizdqwnny1c8hz";
        };
      };
    };
    "league/mime-type-detection" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-mime-type-detection-fda190b62b962d96a069fcc414d781db66d65b69";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/mime-type-detection/zipball/fda190b62b962d96a069fcc414d781db66d65b69;
          sha256 = "15vxpkks81cxpwjxaw5kv5gwxx897jbmf6c4jdinw46rf6qpw1b0";
        };
      };
    };
    "league/oauth1-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth1-client-fca5f160650cb74d23fc11aa570dd61f86dcf647";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth1-client/zipball/fca5f160650cb74d23fc11aa570dd61f86dcf647;
          sha256 = "19i4dhzlbda70qn1ma580b98zk7fy19w9h0w4xzjz19rx915ja4x";
        };
      };
    };
    "league/oauth2-client" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-client-d9f2a1e000dc14eb3c02e15d15759385ec7ff0fb";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth2-client/zipball/d9f2a1e000dc14eb3c02e15d15759385ec7ff0fb;
          sha256 = "088m3gh4q0x1qa8z22001wp5xw5jxnnfk5scfn33d1d9ran221vq";
        };
      };
    };
    "league/oauth2-facebook" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-facebook-c482a851c93a6cb718270773635d6a0c8384b560";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth2-facebook/zipball/c482a851c93a6cb718270773635d6a0c8384b560;
          sha256 = "1izlavdvjh4qhb6bjv8giy99ik7vcfnx53iyash618qcdjv7aqni";
        };
      };
    };
    "league/oauth2-github" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "league-oauth2-github-e63d64f3ec167c09232d189c6b0c397458a99357";
        src = fetchurl {
          url = https://api.github.com/repos/thephpleague/oauth2-github/zipball/e63d64f3ec167c09232d189c6b0c397458a99357;
          sha256 = "1ashd92r61442jdgl5aba8dikj70y2niydi8by21fxqbwd59ajvx";
        };
      };
    };
    "matthiasmullie/minify" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "matthiasmullie-minify-9ba1b459828adc13430f4dd6c49dae4950dc4117";
        src = fetchurl {
          url = https://api.github.com/repos/matthiasmullie/minify/zipball/9ba1b459828adc13430f4dd6c49dae4950dc4117;
          sha256 = "1jmd09q2kkbkc263zqgqsmnjmycv1xp70xpqhxxbq61crl2ajqs7";
        };
      };
    };
    "matthiasmullie/path-converter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "matthiasmullie-path-converter-e7d13b2c7e2f2268e1424aaed02085518afa02d9";
        src = fetchurl {
          url = https://api.github.com/repos/matthiasmullie/path-converter/zipball/e7d13b2c7e2f2268e1424aaed02085518afa02d9;
          sha256 = "0b42v65bwds4h9y8dgqxafvkxpwjqa7y236sfknd0jbhjdr1hj3r";
        };
      };
    };
    "middlewares/base-path" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "middlewares-base-path-18277023b9a4acdc85479071a10f702582c3a909";
        src = fetchurl {
          url = https://api.github.com/repos/middlewares/base-path/zipball/18277023b9a4acdc85479071a10f702582c3a909;
          sha256 = "17m7k1bdbmpavanh0bajrkjhmwf1vwc8lhf6p29rw6aygl1s58b4";
        };
      };
    };
    "middlewares/base-path-router" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "middlewares-base-path-router-1706ec57dbeb7083c7ea17561041f8dc2de3b37c";
        src = fetchurl {
          url = https://api.github.com/repos/middlewares/base-path-router/zipball/1706ec57dbeb7083c7ea17561041f8dc2de3b37c;
          sha256 = "1aa8lc0pjap74sx8ri3zhm65yq24v61pcki18mgbzy5837g3kq68";
        };
      };
    };
    "middlewares/request-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "middlewares-request-handler-adcc7dd36361661bd62057a21c052643ede6c726";
        src = fetchurl {
          url = https://api.github.com/repos/middlewares/request-handler/zipball/adcc7dd36361661bd62057a21c052643ede6c726;
          sha256 = "0jngyfv08sbc1w3yjljpm9j9mpvgkm6i5vm3mz1gc0gzm6v180p7";
        };
      };
    };
    "middlewares/utils" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "middlewares-utils-7dc49454b4fbf249226023c7b77658b6068abfbc";
        src = fetchurl {
          url = https://api.github.com/repos/middlewares/utils/zipball/7dc49454b4fbf249226023c7b77658b6068abfbc;
          sha256 = "1rvbcm2s9xi8gwr12glrip8kpvjdd5x0vq9vzrvmamac861dv43f";
        };
      };
    };
    "monolog/monolog" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "monolog-monolog-1817faadd1846cd08be9a49e905dc68823bc38c0";
        src = fetchurl {
          url = https://api.github.com/repos/Seldaek/monolog/zipball/1817faadd1846cd08be9a49e905dc68823bc38c0;
          sha256 = "1l277wfllaaf54v61h4by6637h43i6h0va15r7m82fp6rffydgb9";
        };
      };
    };
    "nesbot/carbon" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nesbot-carbon-4be0c005164249208ce1b5ca633cd57bdd42ff33";
        src = fetchurl {
          url = https://api.github.com/repos/briannesbitt/Carbon/zipball/4be0c005164249208ce1b5ca633cd57bdd42ff33;
          sha256 = "15vddmcxpzfaglb0w7y49kahppnl7df0smhwpxgy5v05c5c0093a";
        };
      };
    };
    "nikic/fast-route" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "nikic-fast-route-31fa86924556b80735f98b294a7ffdfb26789f22";
        src = fetchurl {
          url = https://api.github.com/repos/nikic/FastRoute/zipball/31fa86924556b80735f98b294a7ffdfb26789f22;
          sha256 = "0wd29sbh0b9irn2y1qy511w5lc0qcz3r0npas02wmbxbxyv52m5k";
        };
      };
    };
    "opis/closure" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "opis-closure-e8d34df855b0a0549a300cb8cb4db472556e8aa9";
        src = fetchurl {
          url = https://api.github.com/repos/opis/closure/zipball/e8d34df855b0a0549a300cb8cb4db472556e8aa9;
          sha256 = "1g5fpd3gjqs0yxin6nd4z2w10gcq6isngk5x3zng6z1dw8ccqma0";
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
    "psr/http-factory" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-factory-12ac7fcd07e5b077433f5f2bee95b3a771bf61be";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-factory/zipball/12ac7fcd07e5b077433f5f2bee95b3a771bf61be;
          sha256 = "0inbnqpc5bfhbbda9dwazsrw9xscfnc8rdx82q1qm3r446mc1vds";
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
    "psr/http-server-handler" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-server-handler-aff2f80e33b7f026ec96bb42f63242dc50ffcae7";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-server-handler/zipball/aff2f80e33b7f026ec96bb42f63242dc50ffcae7;
          sha256 = "0sfz1j9lxirsld0zm0bqqmxf52krjn982w3fq9n27q7mpjd33y4x";
        };
      };
    };
    "psr/http-server-middleware" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "psr-http-server-middleware-2296f45510945530b9dceb8bcedb5cb84d40c5f5";
        src = fetchurl {
          url = https://api.github.com/repos/php-fig/http-server-middleware/zipball/2296f45510945530b9dceb8bcedb5cb84d40c5f5;
          sha256 = "1r92xj2hybnxcnamxqklk5kivkgy0bi34hhsh00dnwn9wmf3s0gj";
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
    "pusher/pusher-php-server" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "pusher-pusher-php-server-2cf2ba85e7ce3250468a1c42ab7c948a7d43839d";
        src = fetchurl {
          url = https://api.github.com/repos/pusher/pusher-http-php/zipball/2cf2ba85e7ce3250468a1c42ab7c948a7d43839d;
          sha256 = "16bk4yfmbzqd8z61vk6chk67kkva8s5dgn33xhyvqjk1i3w9frik";
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
    "s9e/regexp-builder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "s9e-regexp-builder-605b33841a766abd40ba3d07c15d0f62b5e7f033";
        src = fetchurl {
          url = https://api.github.com/repos/s9e/RegexpBuilder/zipball/605b33841a766abd40ba3d07c15d0f62b5e7f033;
          sha256 = "1xzy85xqknrpsl9sn661rszb311civv3zh4xncf3bg2jwmc086wp";
        };
      };
    };
    "s9e/sweetdom" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "s9e-sweetdom-f3a58c723fbe04d92ebcef5c8c7913bb364f58cd";
        src = fetchurl {
          url = https://api.github.com/repos/s9e/SweetDOM/zipball/f3a58c723fbe04d92ebcef5c8c7913bb364f58cd;
          sha256 = "1rmp5cg3j57a6wc99wgcrh81v7jmrn8crxswg53451cpiiw9fwkd";
        };
      };
    };
    "s9e/text-formatter" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "s9e-text-formatter-9a8e77826604e24deacbd280c2543b68b4ff2a84";
        src = fetchurl {
          url = https://api.github.com/repos/s9e/TextFormatter/zipball/9a8e77826604e24deacbd280c2543b68b4ff2a84;
          sha256 = "1g0349rfwx6yq3h1lz604fiwlaik961wan1ybhshcj52y25p0xj1";
        };
      };
    };
    "softcreatr/php-mime-detector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "softcreatr-php-mime-detector-682651747adf0196fec007c2afaedc6dd44a941f";
        src = fetchurl {
          url = https://api.github.com/repos/SoftCreatR/php-mime-detector/zipball/682651747adf0196fec007c2afaedc6dd44a941f;
          sha256 = "0w06spmf4saw7yrgpqby9q1x87mnhx1fqgfl8y7zrglqnx2s3n9f";
        };
      };
    };
    "swiftmailer/swiftmailer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "swiftmailer-swiftmailer-149cfdf118b169f7840bbe3ef0d4bc795d1780c9";
        src = fetchurl {
          url = https://api.github.com/repos/swiftmailer/swiftmailer/zipball/149cfdf118b169f7840bbe3ef0d4bc795d1780c9;
          sha256 = "0kscflkky6h7p7ambsf19rywnlnqslc503958cyriq5lg91nj9ri";
        };
      };
    };
    "symfony/config" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-config-9e2aa97f0d51f114983666f5aa362426d53e004a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/config/zipball/9e2aa97f0d51f114983666f5aa362426d53e004a;
          sha256 = "0gpva1fdla9idjj7xsn56kmsmccj2mr2w84lmvif35vamvgzmsgn";
        };
      };
    };
    "symfony/console" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-console-55d07021da933dd0d633ffdab6f45d5b230c7e02";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/console/zipball/55d07021da933dd0d633ffdab6f45d5b230c7e02;
          sha256 = "15n095z603majh0brhwm307lzy43p0alp059q1qfgg4g0rb3dnzv";
        };
      };
    };
    "symfony/css-selector" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-css-selector-e544e24472d4c97b2d11ade7caacd446727c6bf9";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/css-selector/zipball/e544e24472d4c97b2d11ade7caacd446727c6bf9;
          sha256 = "1a1022qd93jw6drrsc1p7rhjv694n0qk0zg9mz6mfwihrnyrjf8n";
        };
      };
    };
    "symfony/debug" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-debug-47aa9064d75db36389692dd4d39895a0820f00f2";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/debug/zipball/47aa9064d75db36389692dd4d39895a0820f00f2;
          sha256 = "017r9ngn1g65gg2i2rv8dfk6n7y5s7fd6kic3bwwhn6pf2kyjfbg";
        };
      };
    };
    "symfony/event-dispatcher" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-event-dispatcher-6140fc7047dafc5abbe84ba16a34a86c0b0229b8";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/event-dispatcher/zipball/6140fc7047dafc5abbe84ba16a34a86c0b0229b8;
          sha256 = "1cfhyi73bjjdmyvazxxyd6kl93145m528l739sn3akpm0qixr55q";
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
    "symfony/filesystem" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-filesystem-b27f491309db5757816db672b256ea2e03677d30";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/filesystem/zipball/b27f491309db5757816db672b256ea2e03677d30;
          sha256 = "0gabsvz7pqycph6bhj51a5kspf3pynzhky2wz556fjydlw7aiq6m";
        };
      };
    };
    "symfony/finder" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-finder-2727aa35fddfada1dd37599948528e9b152eb742";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/finder/zipball/2727aa35fddfada1dd37599948528e9b152eb742;
          sha256 = "1fq500kmxghw15lfpzhia9mqdxzq3c8pcrbw9ndbf5g0mi69hdg1";
        };
      };
    };
    "symfony/http-foundation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-http-foundation-3675676b6a47f3e71d3ab10bcf53fb9239eb77e6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/http-foundation/zipball/3675676b6a47f3e71d3ab10bcf53fb9239eb77e6;
          sha256 = "1k9l60dp4cdlg1figihsx7hj0asa45ghjq3d1js0dzn3b1w4g6l0";
        };
      };
    };
    "symfony/mime" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-mime-149fb0ad35aae3c7637b496b38478797fa6a7ea6";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/mime/zipball/149fb0ad35aae3c7637b496b38478797fa6a7ea6;
          sha256 = "1whqc28npd35zby0awig6y6dczzw3l1vy2cdi6bipkybvxncsij5";
        };
      };
    };
    "symfony/polyfill-ctype" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-ctype-1c302646f6efc070cd46856e600e5e0684d6b454";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-ctype/zipball/1c302646f6efc070cd46856e600e5e0684d6b454;
          sha256 = "17piwz6vhdch0kc7wd3h04sgrvpmw7dqfkrcj2dppid5j8v29lnv";
        };
      };
    };
    "symfony/polyfill-iconv" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-iconv-6c2f78eb8f5ab8eaea98f6d414a5915f2e0fce36";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-iconv/zipball/6c2f78eb8f5ab8eaea98f6d414a5915f2e0fce36;
          sha256 = "0lhdmym9mlfgjhsrgmxfvpjrpsq1n2wh5jyrgqkwjv0jib4qhccr";
        };
      };
    };
    "symfony/polyfill-intl-idn" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-idn-5dcab1bc7146cf8c1beaa4502a3d9be344334251";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-idn/zipball/5dcab1bc7146cf8c1beaa4502a3d9be344334251;
          sha256 = "015saw0cl3108lqqax58p9q608193hh89dav4ril54na1yz6r3lz";
        };
      };
    };
    "symfony/polyfill-intl-normalizer" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-intl-normalizer-37078a8dd4a2a1e9ab0231af7c6cb671b2ed5a7e";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-intl-normalizer/zipball/37078a8dd4a2a1e9ab0231af7c6cb671b2ed5a7e;
          sha256 = "0dy6snii84dyific6xn6a3mz9shhp7wj4fyqjizg89jwvc3f7qdj";
        };
      };
    };
    "symfony/polyfill-mbstring" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-mbstring-a6977d63bf9a0ad4c65cd352709e230876f9904a";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-mbstring/zipball/a6977d63bf9a0ad4c65cd352709e230876f9904a;
          sha256 = "1i6fhjag28q3ynp7jfixm8rx1j1p9z88yvmcxzfkzjm1gl8v7w54";
        };
      };
    };
    "symfony/polyfill-php70" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php70-0dd93f2c578bdc9c72697eaa5f1dd25644e618d3";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php70/zipball/0dd93f2c578bdc9c72697eaa5f1dd25644e618d3;
          sha256 = "1mrsfx3pxs1wqz5bz24i1rxlsbv7bx8q5fndk7z53kb59jsg1837";
        };
      };
    };
    "symfony/polyfill-php72" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php72-639447d008615574653fb3bc60d1986d7172eaae";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php72/zipball/639447d008615574653fb3bc60d1986d7172eaae;
          sha256 = "1kqxamfcf5k8i3fh3950syg91rsk4bhjm83w5qjbia6xfm03awxz";
        };
      };
    };
    "symfony/polyfill-php73" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php73-fffa1a52a023e782cdcc221d781fe1ec8f87fcca";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php73/zipball/fffa1a52a023e782cdcc221d781fe1ec8f87fcca;
          sha256 = "07sv5hjmadp879rq2q50d9rbwi2ki6rkap98yn0h7hq82q2yh1f0";
        };
      };
    };
    "symfony/polyfill-php80" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-polyfill-php80-d87d5766cbf48d72388a9f6b85f280c8ad51f981";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/polyfill-php80/zipball/d87d5766cbf48d72388a9f6b85f280c8ad51f981;
          sha256 = "1cxwqycsj776iqlib7np33l94ch3hal6a7dghq1b3xmm1j1450z7";
        };
      };
    };
    "symfony/process" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-process-65e70bab62f3da7089a8d4591fb23fbacacb3479";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/process/zipball/65e70bab62f3da7089a8d4591fb23fbacacb3479;
          sha256 = "1w8p5xmj5z2gzgy4vf1hnsn1yp5x7sdxph72y66vs7mpqwcx3100";
        };
      };
    };
    "symfony/service-contracts" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-service-contracts-58c7475e5457c5492c26cc740cc0ad7464be9442";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/service-contracts/zipball/58c7475e5457c5492c26cc740cc0ad7464be9442;
          sha256 = "14rd5zcq3mk9l95m45y95lkydd72ak9cy5h3byviqpfzif1l3hq8";
        };
      };
    };
    "symfony/translation" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-translation-600b84224bf482441cd4d0026eba78755d2e2b34";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/translation/zipball/600b84224bf482441cd4d0026eba78755d2e2b34;
          sha256 = "1djcnw02nnsw5mpja0nhkpvnmrsh0ibryx5347xfp1x2mc90l7k7";
        };
      };
    };
    "symfony/yaml" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "symfony-yaml-e7fa05917ae931332a42d65b577ece4d497aad81";
        src = fetchurl {
          url = https://api.github.com/repos/symfony/yaml/zipball/e7fa05917ae931332a42d65b577ece4d497aad81;
          sha256 = "0bnr3qk8jidwws8ph72jnld2pknyp4yqdmgf6pxanymv6jh6zfhv";
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
    "tobscure/json-api" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "tobscure-json-api-663d1c1299d4363758e8e440e5849134f218f45c";
        src = fetchurl {
          url = https://api.github.com/repos/tobscure/json-api/zipball/663d1c1299d4363758e8e440e5849134f218f45c;
          sha256 = "13nwva4d1d9mhdpw6psy2z6l6vb00jqiiyvc08bh1h4psnl4ap7x";
        };
      };
    };
    "wikimedia/less.php" = {
      targetDir = "";
      src = composerEnv.buildZipPackage {
        name = "wikimedia-less.php-5e2a4fba9304915c4cbf98cc9cb665a5c365c351";
        src = fetchurl {
          url = https://api.github.com/repos/wikimedia/less.php/zipball/5e2a4fba9304915c4cbf98cc9cb665a5c365c351;
          sha256 = "1w2b74s104jbzp6vr20a4mg3q0y5n77g4ilm4p3v325570giwhs7";
        };
      };
    };
  };
  devPackages = {};
in
composerEnv.buildPackage rec {
  inherit packages devPackages noDev;
  name = "flarum-${version}";
  version = "0.1.0-beta.13";
  src = ./src;
  executable = false;
  symlinkDependencies = false;
  meta = {
    homepage = https://flarum.org/;
    description = "Discussion platform, with fof/upload extension";
    license = "MIT";
  };
}
