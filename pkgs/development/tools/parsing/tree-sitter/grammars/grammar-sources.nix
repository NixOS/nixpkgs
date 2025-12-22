{ lib }:

{

  ada = {
    version = "0.9.0";
    url = "github:briot/tree-sitter-ada/0a4c27dc1308a9d2742de22e5fcfc0c137b3d3f3";
    hash = "sha256-K5JJjDQwHuHZ6oQaLwJHYJxmFpR+4ENEeiZO2Q0gsk4=";
  };

  adl = {
    version = "0-unstable-2024-04-03";
    url = "github:adl-lang/tree-sitter-adl/2787d04beadfbe154d3f2da6e98dc45a1b134bbf";
    hash = "sha256-gYEtTjjy8qClYg4+ZnKwNUWMxKTc3sUXQdsVCwB7H6w=";
    meta = {
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  agda = {
    version = "1.3.3";
    url = "github:tree-sitter/tree-sitter-agda";
    hash = "sha256-kE35Y4quEnBdub1Wd7sdws7yhR6UFhyhk6Gw2CkI0Ng=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  alloy = {
    version = "0-unstable-2024-11-29";
    url = "github:mattsre/tree-sitter-alloy/58d462b1cdb077682b130caa324f3822aeb00b8e";
    hash = "sha256-yDYGtM/vlZqeOy2O+scGHc6Dae0H/cXyC6Gu0inwJNA=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  amber = {
    version = "0-unstable-2025-11-26";
    url = "github:amber-lang/tree-sitter-amber/107c6d4a420fb0c5962b62ebd9347b7eb0015957";
    hash = "sha256-vEEjHg/qRFfgA8AEWP7hp28/rxBCjPTvxLSMnvlXyi8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  astro = {
    version = "0-unstable-2025-04-23";
    url = "github:virchau13/tree-sitter-astro/213f6e6973d9b456c6e50e86f19f66877e7ef0ee";
    hash = "sha256-TpXs3jbYn39EHxTdtSfR7wLA1L8v9uyK/ATPp5v4WqE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  awk = {
    version = "0-unstable-2024-11-02";
    url = "github:Beaglefoot/tree-sitter-awk/34bbdc7cce8e803096f47b625979e34c1be38127";
    hash = "sha256-MDfAtG6ZC0KttJ5bdW71Jgts+SAJitRnwu8xQ26N9K0=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  bash = {
    version = "0.25.1";
    url = "github:tree-sitter/tree-sitter-bash";
    hash = "sha256-ONQ1Ljk3aRWjElSWD2crCFZraZoRj3b3/VELz1789GE=";
  };

  bass = {
    version = "0-unstable-2024-05-03";
    url = "github:vito/tree-sitter-bass/28dc7059722be090d04cd751aed915b2fee2f89a";
    hash = "sha256-NKu60BbTKLsYQRtfEoqGQUKERJFnmZNVJE6HBz/BRIM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  beancount = {
    version = "2.4.1";
    url = "github:polarmutex/tree-sitter-beancount";
    hash = "sha256-i/Dgen2qF1Qmpi0nm2hDGNUe0tSw03llY4tPTiygWGQ=";
  };

  bibtex = {
    version = "0-unstable-2025-04-19";
    url = "github:latex-lsp/tree-sitter-bibtex/8d04ed27b3bc7929f14b7df9236797dab9f3fa66";
    hash = "sha256-UOXGWm8k9YP0GUwvNEuIxeiXqJo4Jf9uBt+/oYaYUl4=";
  };

  bicep = {
    version = "0-unstable-2024-12-22";
    url = "github:tree-sitter-grammars/tree-sitter-bicep/bff59884307c0ab009bd5e81afd9324b46a6c0f9";
    hash = "sha256-+qvhJgYqs8aj/Kmojr7lmjbXmskwVvbYBn4ia9wOv3k=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  bitbake = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-bitbake";
    hash = "sha256-PSI1XVDGwDk5GjHjvCJfmBDfYM2Gmm1KR4h5KxBR1d0=";
  };

  blade = {
    version = "0-unstable-2025-08-25";
    url = "github:EmranMR/tree-sitter-blade/cc764dadcbbceb3f259396fef66f970c72e94f96";
    hash = "sha256-3/gY68F+xOF5Fv6rK9cEIJCVDzg/3ap1/gzkEacGuy4=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  blueprint = {
    version = "0-unstable-2025-06-17";
    url = "github:smrtrfszm/tree-sitter-blueprint/de66f283c6c9b7c270d766c2e4cf95535650ec48";
    hash = "sha256-zmMJZAxyKO42gIK3cWP/LuoPIo2+xr6fEDeHXknqa7M=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  bqn = {
    version = "0.3.2";
    url = "github:shnarazk/tree-sitter-bqn";
    hash = "sha256-/FsA5GeFhWYFl1L9pF+sQfDSyihTnweEdz2k8mtLqnY=";
  };

  c = {
    version = "0.24.1";
    url = "github:tree-sitter/tree-sitter-c";
    hash = "sha256-gmzbdwvrKSo6C1fqTJFGxy8x0+T+vUTswm7F5sojzKc=";
  };

  c-sharp = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-c-sharp";
    hash = "sha256-weH0nyLpvVK/OpgvOjTuJdH2Hm4a1wVshHmhUdFq3XA=";
  };

  caddyfile = {
    version = "0-unstable-2025-12-16";
    url = "github:caddyserver/tree-sitter-caddyfile/2b816940b5bf4f86c650aded24500cb5b682f1a1";
    hash = "sha256-C/dTDm4X+VxtNZaqb2AHgcDZyGeBN9VMwZjSzJVEHGo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  cairo = {
    version = "0-unstable-2025-09-14";
    url = "github:starkware-libs/tree-sitter-cairo/8dcd77dbe7f68b2cc661031dff224dfc17bdbaf4";
    hash = "sha256-RzxmMV0Uo4N25QuhMaTJHCA0sLE/51cfhd25LYFlFog=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  capnp = {
    version = "0-unstable-2024-04-20";
    url = "github:amaanq/tree-sitter-capnp/7b0883c03e5edd34ef7bcf703194204299d7099f";
    hash = "sha256-WKrZuOMxmdGlvUI9y8JgwCNMdJ8MULucMhkmW8JCiXM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  cel = {
    version = "0-unstable-2024-02-13";
    url = "github:bufbuild/tree-sitter-cel/df0585025e6f50cdb07347f5009ae3f47c652890";
    hash = "sha256-Fyq56kzu1bL44QhrF3ZnKWgsoPRh3tjTRi2CynNQGfw=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  circom = {
    version = "0-unstable-2024-09-09";
    url = "github:Decurity/tree-sitter-circom/02150524228b1e6afef96949f2d6b7cc0aaf999e";
    hash = "sha256-wosqwiDkK1rytGWMJApz1M42Sme9OaWXC0rmj7vM4g8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  clarity = {
    version = "0-unstable-2025-11-17";
    url = "github:xlittlerag/tree-sitter-clarity/cbb3ffe8688aca558286fd45ed46857a1f3207bb";
    hash = "sha256-iylkAIBEpMPzRYHXyFQKMIEZJbqij/8tLdq9z/UPgN8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  clojure = {
    version = "0.0.13-unstable-2025-08-26";
    url = "github:sogaiu/tree-sitter-clojure/e43eff80d17cf34852dcd92ca5e6986d23a7040f";
    hash = "sha256-jokekIuuQLx5UtuPs4XAI+euispeFCwSQByVKVelrC4=";
  };

  cmake = {
    version = "0.7.2";
    url = "github:uyha/tree-sitter-cmake";
    hash = "sha256-mR+gA7eWigC2zO1gMHzOgRagsfK1y/NBsn3mAOqR35A=";
  };

  comment = {
    version = "0.3.0";
    url = "github:stsewd/tree-sitter-comment";
    hash = "sha256-O9BBcsMfIfDDzvm2eWuOhgLclUNdgZ/GsQd0kuFFFPQ=";
  };

  commonlisp = {
    version = "0.4.1";
    url = "github:tree-sitter-grammars/tree-sitter-commonlisp";
    hash = "sha256-wHVdRiorBgxQ+gG+m/duv9nt5COxz6XK0AcKQ5FX43U=";
  };

  cpon = {
    version = "0-unstable-2023-06-06";
    url = "github:fvacek/tree-sitter-cpon/d42786f6295db7046372c042b208b8094940e9cd";
    hash = "sha256-5Va7cnbumCQDNAhrYe2dCBhFmgZUQ6dCy4VjB4+JaTs=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  cpp = {
    version = "0.23.4";
    url = "github:tree-sitter/tree-sitter-cpp";
    hash = "sha256-tP5Tu747V8QMCEBYwOEmMQUm8OjojpJdlRmjcJTbe2k=";
  };

  crystal = {
    version = "0-unstable-2025-10-12";
    url = "github:crystal-lang-tools/tree-sitter-crystal/50ca9e6fcfb16a2cbcad59203cfd8ad650e25c49";
    hash = "sha256-xmQrplDxoJ8GhcTyCOuEGn4wwMM3/9M6tyM1dgRGARU=";
  };

  css = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-css";
    hash = "sha256-jFsnEyS+FThk7L48FzAdSp5fNPSLvM8hTL/VC5FMlOE=";
  };

  csv = {
    version = "0-unstable-2025-03-13";
    url = "github:weartist/rainbow-csv-tree-sitter/fbf125bcedb15080980e8afaf69c4374412e5844";
    hash = "sha256-caWf6cIx0CcDP2u84ncfdTSlWvhVawnYAIW4m5bzRQY=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  cuda = {
    version = "0.21.1";
    url = "github:tree-sitter-grammars/tree-sitter-cuda";
    hash = "sha256-sX9AOe8dJJsRbzGq20qakWBnLiwYQ90mQspAuYxQzoQ=";
  };

  cue = {
    version = "0.1.0";
    url = "github:eonpatapon/tree-sitter-cue";
    hash = "sha256-ujSBOwOnjsKuFhHtt4zvj90VcQsak8mEcWYJ0e5/mKc=";
  };

  cylc = {
    version = "0-unstable-2025-09-08";
    url = "github:elliotfontaine/tree-sitter-cylc/6d1d81137112299324b526477ce1db989ab58fb8";
    hash = "sha256-jgQCTM36S8UwSyT4LAfcX4DUIl2OYVMeQdDg3zRrw00=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  d = {
    version = "0-unstable-2025-06-29";
    url = "github:gdamore/tree-sitter-d/fb028c8f14f4188286c2eef143f105def6fbf24f";
    hash = "sha256-Xi8out5j4L5pAArA9zmLA7aGhma++G+AaVLgFW+TEAo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  dart = {
    version = "0-unstable-2025-10-04";
    url = "github:usernobody14/tree-sitter-dart/d4d8f3e337d8be23be27ffc35a0aef972343cd54";
    hash = "sha256-1ftYqCor1A0PsQ0AJLVqtxVRZxaXqE/NZ5yy7SizZCY=";
  };

  dbml = {
    version = "0-unstable-2023-11-02";
    url = "github:dynamotn/tree-sitter-dbml/2e2fa5640268c33c3d3f27f7e676f631a9c68fd9";
    hash = "sha256-IxxUW6YYxP1hkwA9NEojEEE3c8pwvAI6juX8aF7NfMw=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  debian = {
    version = "0-unstable-2025-04-01";
    url = "gitlab:MggMuggins/tree-sitter-debian/9b3f4b78c45aab8a2f25a5f9e7bbc00995bc3dde";
    hash = "sha256-VjWoF5oI+K101xKvF+MDsy1+eCkkUytn39PHKqOCkjo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  devicetree = {
    version = "0.11.1";
    url = "github:joelspadin/tree-sitter-devicetree";
    hash = "sha256-2uJEItLwoBoiB49r2XuO216Dhu9AnAa0p7Plmm4JNY8=";
  };

  dhall = {
    version = "0-unstable-2025-04-13";
    url = "github:jbellerb/tree-sitter-dhall/62013259b26ac210d5de1abf64cf1b047ef88000";
    hash = "sha256-4xbz7DDUlLGgLW5V6Yyvo7dkE9MOk3mCQEBTYyRbNuM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  diff = {
    version = "0-unstable-2025-10-29";
    url = "github:the-mikedavis/tree-sitter-diff/2520c3f934b3179bb540d23e0ef45f75304b5fed";
    hash = "sha256-8rYLNGgoZSvvfqO2++nAgFKmvbkKJ3m+9B8bTXp6Us4=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  djot = {
    version = "0-unstable-2025-09-15";
    url = "github:treeman/tree-sitter-djot/74fac1f53c6d52aeac104b6874e5506be6d0cfe6";
    hash = "sha256-HfEZHNhxEbH07gDzLPdl6n2Pf//o8tbJvwE+tesJDC8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  dockerfile = {
    version = "0.2.0";
    url = "github:camdencheek/tree-sitter-dockerfile";
    hash = "sha256-4J1bA0y3YSriFTkYt81VftVtlQk790qmMlG/S3FNPCY=";
  };

  dot = {
    version = "0-unstable-2025-10-21";
    url = "github:rydesun/tree-sitter-dot/80327abbba6f47530edeb0df9f11bd5d5c93c14d";
    hash = "sha256-sepmaKnpbj/bgMBa06ksQFOMPtcCqGaINiJqFBJN/0Y=";
  };

  dtd = {
    version = "0-unstable-2023-04-07";
    url = "github:KMikeeU/tree-sitter-dtd/6116becb02a6b8e9588ef73d300a9ba4622e156f";
    hash = "sha256-mq617pfH/Na9JB8SDEudxbKJfaoezgjC3xVOIOZ8Qb8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  dunstrc = {
    version = "0-unstable-2025-05-04";
    url = "github:rotmh/tree-sitter-dunstrc/9cb9d5cc51cf5e2a47bb2a0e2f2e519ff11c1431";
    hash = "sha256-yfjOly1NvdNIFc3zzFb8XSCA+IW9uIzjtQRhf4/NQzY=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  earthfile = {
    version = "0.6.0-unstable-2025-10-27";
    url = "github:glehmann/tree-sitter-earthfile/5baef88717ad0156fd29a8b12d0d8245bb1096a8";
    hash = "sha256-eeXzc+thSPey7r59QkJd5jgchZRhSwT5isSljYLBQ8k=";
  };

  edoc = {
    version = "0-unstable-2022-11-23";
    url = "github:the-mikedavis/tree-sitter-edoc/74774af7b45dd9cefbf9510328fc6ff2374afc50";
    hash = "sha256-ALGr1vI/R2gAgjHfwORYMP/+CeIejnSGqC9Db+GD5uM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  eex = {
    version = "0.1.0";
    url = "github:connorlay/tree-sitter-eex";
    hash = "sha256-UPq62MkfGFh9m/UskoB9uBDIYOcotITCJXDyrbg/wKY=";
  };

  elisp = rec {
    version = "1.6.1";
    url = "github:wilfred/tree-sitter-elisp?ref=${version}";
    hash = "sha256-ixZKsQtRk5ykR6miQ5JicI3xn/Bp9t4WGAIoNTC/gbY=";
  };

  elixir = {
    version = "0.3.4";
    url = "github:elixir-lang/tree-sitter-elixir";
    hash = "sha256-9M/DpqpGivDtgGt3ojU/kHR51sla59+KtZ/95hT6IIo=";
  };

  elm = {
    version = "5.9.0";
    url = "github:elm-tooling/tree-sitter-elm";
    hash = "sha256-vaeGViXob7AYyJj93AUJWBD8Zdfs4zXdKikvBZ3GptU=";
  };

  elvish = {
    version = "0-unstable-2023-07-17";
    url = "github:ckafi/tree-sitter-elvish/5e7210d945425b77f82cbaebc5af4dd3e1ad40f5";
    hash = "sha256-POuQA2Ihi+qDYQ5Pv7hBAzHpPu/FcnuYscW4ItDOCZg=";
    meta = {
      license = lib.licenses.bsd0;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  embedded-template = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-embedded-template";
    hash = "sha256-nBQain0Lc21jOgQFfvkyq615ZmT8qdMxtqIoUcOcO3A=";
  };

  erlang = rec {
    version = "0.1.0";
    url = "github:WhatsApp/tree-sitter-erlang?ref=${version}";
    hash = "sha256-FH8DNE03k95ZsRwaiXHkaU9/cdWrWALCEdChN5ZPdog=";
  };

  esdl = {
    version = "0-unstable-2024-03-28";
    url = "github:greym0uth/tree-sitter-esdl/7e6692b2e2b4f73b03f1371e8d8b83f23bc1c6c8";
    hash = "sha256-8vBpWfRl0yd0Tcsgq+wzcrajGbNJMc7qSq+YH/8A0cU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  factor = {
    version = "0-unstable-2025-01-12";
    url = "github:erochest/tree-sitter-factor/554d8b705df61864eb41a0ecf3741e94eb9f0c54";
    hash = "sha256-Z60ySUrBAiNm5s3iH/6jkjsKX5mPAW8bgid+5m2MzJM=";
  };

  fennel = {
    version = "1.1.0-unstable-2025-09-07";
    url = "github:travonted/tree-sitter-fennel/36eb796a84b4f57bdf159d0a99267260d4960c89";
    hash = "sha256-aFcTPgWkd/o1qu8d/hulmVDyFlTHJgb35iea4Jc1510=";
  };

  fga = {
    version = "0-unstable-2025-12-17";
    url = "github:matoous/tree-sitter-fga/e763d12cfd8569494215f304bc2b0074c84709e9";
    hash = "sha256-d1gvEoJosBcEiq4fxb+1LFcdSkuOWGXyG1cC44Lo19o=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  fidl = {
    version = "0-unstable-2024-02-27";
    url = "github:google/tree-sitter-fidl/0a8910f293268e27ff554357c229ba172b0eaed2";
    hash = "sha256-QFAkxQo2w/+OR7nZn9ldBk2yHOd23kzciAcQvIZ5hrY=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  fish = rec {
    version = "3.6.0";
    url = "github:ram02z/tree-sitter-fish?ref=${version}";
    hash = "sha256-ZQj6XR7pHGoCOBS6GOHiRW9LWNoNPlwVcZe5F2mtGNE=";
  };

  forth = {
    version = "0-unstable-2025-12-01";
    url = "github:alexanderbrevig/tree-sitter-forth/360ef13f8c609ec6d2e80782af69958b84e36cd0";
    hash = "sha256-d7X1Ubd9tKMQgNHlH+sQxmcsgLWB4mxR5CIdyKkLnM8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  fortran = {
    version = "0.5.1";
    url = "github:stadelmanma/tree-sitter-fortran";
    hash = "sha256-6l+cfLVbs8geKIYhnfuZDac8uzmNHOZf2rFANdl4tDs=";
  };

  fsharp = {
    version = "0-unstable-2025-07-05";
    url = "github:ionide/tree-sitter-fsharp/5141851c278a99958469eb1736c7afc4ec738e47";
    hash = "sha256-cJpbO9PjGtJu4RCDsmQ0qjys765/z397y/wbfGxTY9Y=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gas = {
    version = "0-unstable-2023-09-15";
    url = "github:sirius94/tree-sitter-gas/60f443646b20edee3b7bf18f3a4fb91dc214259a";
    hash = "sha256-HyLNnmK4jud2Ndkc+5MY9MlASh/ehPA/eQATsCVGcUw=";
    meta = {
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gdscript = {
    version = "6.0.0";
    url = "github:prestonknopp/tree-sitter-gdscript";
    hash = "sha256-S+AF6slDnw3O00C8hcL013A8MU7fKU5mCwhyV50rqmI=";
  };

  gemini = rec {
    version = "0.1.0";
    url = "github:blessanabraham/tree-sitter-gemini?ref=${version}";
    hash = "sha256-grWpLh5ozSUct5sSI8M8qnWy72b7ruRuhOpoyswvJuU=";
  };

  gherkin = {
    version = "0-unstable-2024-07-04";
    url = "github:SamyAB/tree-sitter-gherkin/43873ee8de16476635b48d52c46f5b6407cb5c09";
    hash = "sha256-6Ywu4HPfgpKsuZ6wo2b1CA3Z+lD+/3XEyJi2l2Q66+Y=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ghostty = {
    version = "0-unstable-2025-11-27";
    url = "github:bezhermoso/tree-sitter-ghostty/c2f7af6d7250f63f01401a6d84b3e353e71ff3c3";
    hash = "sha256-d9cJWhEHiAMxyNhUt7VR5IU5z/5oXn3m9aMsknexaNM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  git-config = {
    version = "0-unstable-2025-05-11";
    url = "github:the-mikedavis/tree-sitter-git-config/0fbc9f99d5a28865f9de8427fb0672d66f9d83a5";
    hash = "sha256-u1NrtCap+CvhSW4q7xrwiUPGuCspjk9sHKkXQcEXc2E=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  git-rebase = {
    version = "0-unstable-2024-07-22";
    url = "github:the-mikedavis/tree-sitter-git-rebase/bff4b66b44b020d918d67e2828eada1974a966aa";
    hash = "sha256-k4C7dJUkvQxIxcaoVmG2cBs/CeYzVqrip2+2mRvHtZc=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gitattributes = {
    version = "0-unstable-2022-05-06";
    url = "github:mtoohey31/tree-sitter-gitattributes/deb04fdbff485310ee5bac74ddc6ab624a602b7b";
    hash = "sha256-4auPT/qeURtVMs+mi/zS4B08v0cMVkHOjSidV5FELO0=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gitcommit = {
    version = "0-unstable-2025-03-13";
    url = "github:gbprod/tree-sitter-gitcommit/a716678c0f00645fed1e6f1d0eb221481dbd6f6d";
    hash = "sha256-KYfcs99p03b0RiPYnZeKJf677fmVf658FLZcFk2v2Ws=";
    meta = {
      license = lib.licenses.wtfpl;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gitignore = {
    version = "0-unstable-2022-05-04";
    url = "github:shunsambongi/tree-sitter-gitignore/f4685bf11ac466dd278449bcfe5fd014e94aa504";
    hash = "sha256-MjoY1tlVZgN6JqoTjhhg0zSdHzc8yplMr8824sfIKp8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gleam = {
    version = "1.1.0";
    url = "github:gleam-lang/tree-sitter-gleam";
    hash = "sha256-GIikbo8N2bmUa8wddpAgTHeejCInoEY8HxGDbuYq/zQ=";
  };

  glimmer = {
    version = "1.4.0";
    url = "github:ember-tooling/tree-sitter-glimmer?ref=v1.4.0-tree-sitter-glimmer";
    hash = "sha256-4kEOvObNnZtt2aaf0Df+R/Wvyk/JlFnsvbasDIJxt4w=";
  };

  glsl = {
    version = "0.2.0";
    url = "github:tree-sitter-grammars/tree-sitter-glsl";
    hash = "sha256-S0Yr/RQE4uLpazphTKLUoHgPEOUbOBDGCkkRXemsHjQ=";
  };

  gn = {
    version = "0-unstable-2023-12-10";
    url = "github:willcassella/tree-sitter-gn/fbaa7b3d52b958e3ac06e15416e1785138bde063";
    hash = "sha256-3OLlUL21YcdOZcnroPMwvMVJgu8bsGHldTnZh8y6q9M=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  go = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-go";
    hash = "sha256-y7bTET8ypPczPnMVlCaiZuswcA7vFrDOc2jlbfVk5Sk=";
  };

  go-template = {
    version = "0-unstable-2025-12-12";
    url = "github:ngalaiko/tree-sitter-go-template/c59999dc449c29549f5735eaac31b938a13b6c14";
    hash = "sha256-YKqpNkCRLX+89Ottw4KVXxrEsIPRUsWs0UwIgucHwdo=";
  };

  godot-resource = {
    language = "godot_resource";
    version = "0.7.0";
    url = "github:prestonknopp/tree-sitter-godot-resource";
    hash = "sha256-+tUMLqtak9ToY+UUnIiqngDs6diG8crW8Ac0mbk7FMo=";
  };

  gomod = {
    version = "1.1.0";
    url = "github:camdencheek/tree-sitter-go-mod";
    hash = "sha256-C3pPBgm68mmaPmstyIpIvvDHsx29yZ0ZX/QoUqwjb+0=";
  };

  gotmpl = {
    version = "0-unstable-2022-07-19";
    url = "github:dannylongeuay/tree-sitter-go-template/395a33e08e69f4155156f0b90138a6c86764c979";
    hash = "sha256-YlPX74tEgCxGm2GYqYvQ0ouzTZ4x5/R+hkP+lBuOLGw=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  gowork = {
    version = "0-unstable-2022-10-04";
    url = "github:omertuc/tree-sitter-go-work/949a8a470559543857a62102c84700d291fc984c";
    hash = "sha256-Tode7W05xaOKKD5QOp3rayFgLEOiMJUeGpVsIrizxto=";
  };

  gpr = {
    version = "0-unstable-2024-08-13";
    url = "github:brownts/tree-sitter-gpr/cea857d3c18d1385d1f5b66cd09ea1e44173945c";
    hash = "sha256-tqff8Aaj9uebJeNYuNdaDBllsj/mwRStWhhY3zB8xlU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  graphql = {
    version = "0-unstable-2021-05-10";
    url = "github:bkegley/tree-sitter-graphql/5e66e961eee421786bdda8495ed1db045e06b5fe";
    hash = "sha256-NvE9Rpdp4sALqKSRWJpqxwl6obmqnIIdvrL1nK5peXc=";
  };

  gren = {
    version = "0-unstable-2025-05-03";
    url = "github:MaeBrooks/tree-sitter-gren/c36aac51a915fdfcaf178128ba1e9c2205b25930";
    hash = "sha256-XtLP2ncpwAiubHug6k4sJCYRZo5f+Nu02tho/4tVD/k=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  groovy = {
    version = "0-unstable-2025-01-22";
    url = "github:murtaza64/tree-sitter-groovy/86911590a8e46d71301c66468e5620d9faa5b6af";
    hash = "sha256-652wluH2C3pYmhthaj4eWDVLtEvvVIuu70bJNnt5em0=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  hare = {
    version = "0-unstable-2024-07-30";
    url = "sourcehut:~ecs/tree-sitter-hare/fb6ea01461441ec7c312e64e326649f5e9011a64";
    hash = "sha256-KQ9U3XWzqS0ozTHpaLpAIvK8T8ilbV1ex6CLFzHXPzA=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  haskell = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-haskell";
    hash = "sha256-bggXKbV4vTWapQAbERPUszxpQtpC1RTujNhwgbjY7T4=";
  };

  haskell-persistent = {
    version = "0-unstable-2023-09-19";
    url = "github:MercuryTechnologies/tree-sitter-haskell-persistent/577259b4068b2c281c9ebf94c109bd50a74d5857";
    hash = "sha256-ASdkBQ57GfpLF8NXgDzJMB/Marz9p1q03TZkwMgF/eQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  hcl = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-hcl";
    hash = "sha256-saVKSYUJY7OuIuNm9EpQnhFO/vQGKxCXuv3EKYOJzfs=";
  };

  heex = {
    version = "0.8.0";
    url = "github:phoenixframework/tree-sitter-heex";
    hash = "sha256-rifYGyIpB14VfcEZrmRwYSz+ZcajQcB4mCjXnXuVFDQ=";
  };

  hjson = {
    version = "0-unstable-2021-08-02";
    url = "github:winston0410/tree-sitter-hjson/02fa3b79b3ff9a296066da6277adfc3f26cbc9e0";
    hash = "sha256-NsTf3DR3gHVMYZDmTNvThB5bJcDwTcJ1+3eJhvsiDn8=";
  };

  hocon = {
    version = "0-unstable-2022-11-07";
    url = "github:antosha417/tree-sitter-hocon/c390f10519ae69fdb03b3e5764f5592fb6924bcc";
    hash = "sha256-9Zo3YYoo9mJ4Buyj7ofSrlZURrwstBo0vgzeTq1jMGw=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  hoon = {
    version = "0-unstable-2024-12-17";
    url = "github:urbit-pilled/tree-sitter-hoon/1545137aadcc63660c47db9ad98d02fa602655d0";
    hash = "sha256-RkSPoscrinmuSTWHzXkRNaiqECDXpKAbQ4z7a6Tpvek=";
    meta = {
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  hosts = {
    version = "0-unstable-2022-12-01";
    url = "github:ath3/tree-sitter-hosts/301b9379ce7dfc8bdbe2c2699a6887dcb73953f9";
    hash = "sha256-f8ldDZD0I/D8IC566bZ4YgQE/b0maTE3BfzuzPfy92k=";
    meta = {
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  html = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-html";
    hash = "sha256-Pd5Me1twLGOrRB3pSMVX9M8VKenTK0896aoLznjNkGo=";
  };

  htmldjango = {
    version = "0-unstable-2025-04-16";
    url = "github:interdependence/tree-sitter-htmldjango/3a643167ad9afac5d61e092f08ff5b054576fadf";
    hash = "sha256-sQV7olTaQ68wixzvKV44myVvDUXXjBZh9N3jvDFUSvE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  http = {
    version = "3.0.0";
    url = "github:rest-nvim/tree-sitter-http?ref=v3.0";
    hash = "sha256-pg7QmnfhuCmyuq6HupCJl4H/rcxDeUn563LoL+Wd2Uw=";
  };

  hurl = {
    version = "0-unstable-2025-09-13";
    url = "github:pfeiferj/tree-sitter-hurl/597efbd7ce9a814bb058f48eabd055b1d1e12145";
    hash = "sha256-sQjjx3DGfi0l8/XNOIoyFYAcDpaQOkD4Ics3g6vkgjM=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  hyprlang = {
    version = "3.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-hyprlang";
    hash = "sha256-pNAN5TF01Bnqfcsoa0IllchCCBph9/SowzIoMyQcN5w=";
  };

  iex = {
    version = "0-unstable-2022-01-08";
    url = "github:elixir-lang/tree-sitter-iex/39f20bb51f502e32058684e893c0c0b00bb2332c";
    hash = "sha256-YRVxMz9VqZ00bG0tQ/IDxf/8UkK3/OYZTIMxsQfknII=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ini = {
    version = "0-unstable-2025-12-08";
    url = "github:justinmk/tree-sitter-ini/e4018b5176132b4f3c5d6e61cea383f42288d0f5";
    hash = "sha256-8WCyIaApsLPOybe+cntF4ISyQKN41L2IRAATd9KmzL0=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ink = {
    version = "0-unstable-2025-02-05";
    url = "github:rhizoome/tree-sitter-ink/3bafa20b888b97a505164fa9ee3812c331b2b809";
    hash = "sha256-i+e+eaiAzTx2n9A0mlQ1SStGTbcS4LQJfmK8uNpzNiI=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  inko = {
    version = "0-unstable-2025-12-06";
    url = "github:inko-lang/tree-sitter-inko/20e2842680dd0d47dd2ee976bc320e4399f65fe1";
    hash = "sha256-qgB2s/ghmOGjJ+MH7p3ZQKa+RMxx58642Z9lYC1wlq4=";
    meta = {
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  janet-simple = {
    version = "0.0.7-unstable-2025-05-19";
    url = "github:sogaiu/tree-sitter-janet-simple/7e28cbf1ca061887ea43591a2898001f4245fddf";
    hash = "sha256-qWsUPZfQkuEUiuCSsqs92MIMEvdD+q2bwKir3oE5thc=";
  };

  java = {
    version = "0.23.5";
    url = "github:tree-sitter/tree-sitter-java";
    hash = "sha256-OvEO1BLZLjP3jt4gar18kiXderksFKO0WFXDQqGLRIY=";
  };

  javascript = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-javascript";
    hash = "sha256-2Jj/SUG+k8lHlGSuPZvHjJojvQFgDiZHZzH8xLu7suE=";
  };

  jinja2 = {
    version = "0-unstable-2023-02-09";
    url = "github:varpeti/tree-sitter-jinja2/a533cd3c33aea6acb0f9bf9a56f35dcfe6a8eb53";
    hash = "sha256-ksHel/kkWk4cyCx/+k8IfqjnID8i744WsZi9+AVSNpw=";
    meta = {
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  jjdescription = {
    version = "0-unstable-2025-02-20";
    url = "github:kareigu/tree-sitter-jjdescription/1613b8c85b6ead48464d73668f39910dcbb41911";
    hash = "sha256-HPghz3mOukXrY0KQllOR7Kkl2U3+ukPBrXWKnJCwsqI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  jq = {
    version = "0-unstable-2025-05-10";
    url = "github:flurie/tree-sitter-jq/c204e36d2c3c6fce1f57950b12cabcc24e5cc4d9";
    hash = "sha256-WEsiDsZEFTGC3s0awYE8rN/fsRML7CePKOXUbL+Fujc=";
    meta = {
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  jsdoc = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-jsdoc";
    hash = "sha256-xjLC56NiOwwb5BJ2DLiG3rknMR3rrcYrPuHI24NVL+M=";
  };

  json = {
    version = "0.24.8";
    url = "github:tree-sitter/tree-sitter-json";
    hash = "sha256-DNZC2cTy1C8OaMOpEHM6NoRtOIbLaBf0CLXXWCKODlw=";
  };

  json5 = {
    version = "0.1.0";
    url = "github:joakker/tree-sitter-json5";
    hash = "sha256-QfzqRUe9Ji/QXBHHOJHuftIJKOONtmS1ml391QDKfTI=";
  };

  jsonnet = {
    version = "0-unstable-2024-08-15";
    url = "github:sourcegraph/tree-sitter-jsonnet/ddd075f1939aed8147b7aa67f042eda3fce22790";
    hash = "sha256-ODGRkirfUG8DqV6ZcGRjKeCyEtsU0r+ICK0kCG6Xza0=";
  };

  julia = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-julia";
    hash = "sha256-jwtMgHYSa9/kcsqyEUBrxC+U955zFZHVQ4N4iogiIHY=";
  };

  just = {
    version = "0-unstable-2025-01-05";
    url = "github:IndianBoy42/tree-sitter-just/bb0c898a80644de438e6efe5d88d30bf092935cd";
    hash = "sha256-FwEuH/2R745jsuFaVGNeUTv65xW+MPjbcakRNcAWfZU=";
  };

  kdl = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-kdl";
    hash = "sha256-+oJqfbBDbrNS7E+x/QCX9m6FVf0NLw4qWH9n54joJYA=";
  };

  koka = {
    version = "0-unstable-2025-07-26";
    url = "github:mtoohey31/tree-sitter-koka/6dce132911ac375ac1a3591c868c47a2a84b30aa";
    hash = "sha256-QXKfXg1qs3HNvjk1J8Kzm6uwR0frXXEONlJQPCqioNA=";
  };

  kotlin = rec {
    version = "0.3.8";
    url = "github:fwcd/tree-sitter-kotlin?ref=${version}";
    hash = "sha256-kze1kF8naH2qQou58MKMhzmMXk0ouzcP6i3F61kOYi8=";
  };

  koto = {
    version = "0-unstable-2025-11-17";
    url = "github:koto-lang/tree-sitter-koto/f8b3f62c0eed185dca1559789e78759d4bee60e5";
    hash = "sha256-vv5HMDXMcSi91loIppsx/5Hu6jJ7/cedtTyahOBP780=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  latex = {
    version = "0.6.0";
    url = "github:latex-lsp/tree-sitter-latex";
    hash = "sha256-nb1pOSHawLIw7/gaepuq2EN0a/F7/un4Xt5VCnDzvWs=";
    generate = true;
  };

  ld = {
    version = "0-unstable-2024-04-12";
    url = "github:mtoohey31/tree-sitter-ld/0e9695ae0ede47b8744a8e2ad44d4d40c5d4e4c9";
    hash = "sha256-U+yqSO+vo1RAZrCqCojhY4HwjcjirZU/HgWDCdw3YGw=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ldif = {
    version = "0-unstable-2023-05-27";
    url = "github:kepet19/tree-sitter-ldif/0a917207f65ba3e3acfa9cda16142ee39c4c1aaa";
    hash = "sha256-xivgajrM0sqbEcX+ZN0h5C+s7KJVJanrvxRQ/j1VNIQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  lean = {
    version = "0-unstable-2024-12-25";
    url = "github:Julian/tree-sitter-lean/efe6b87145608d12f5996bd7f0cf6095a0e82261";
    hash = "sha256-MF+LRzhDw3V/l/h11ZTyWCUCm3b+g0oyOdaCZMVlJc4=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ledger = {
    version = "0-unstable-2025-05-04";
    url = "github:cbarrete/tree-sitter-ledger/96c92d4908a836bf8f661166721c98439f8afb80";
    hash = "sha256-L2xUTItnQ/bcieasItrozjAEJLm/fsUUyMex2juCnjw=";
  };

  llvm = {
    version = "0-unstable-2024-10-07";
    url = "github:benwilliamgraham/tree-sitter-llvm/c14cb839003348692158b845db9edda201374548";
    hash = "sha256-L3XwPhvwIR/mUbugMbaHS9dXyhO7bApv/gdlxQ+2Bbo=";
  };

  llvm-mir = {
    version = "0-unstable-2024-10-03";
    url = "github:Flakebi/tree-sitter-llvm-mir/d166ff8c5950f80b0a476956e7a0ad2f27c12505";
    hash = "sha256-ivslvFNr3550Grko9xbHPtA63XNc+twFfZQFhBmPaME=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  log = {
    version = "0-unstable-2023-11-26";
    url = "github:Tudyx/tree-sitter-log/62cfe307e942af3417171243b599cc7deac5eab9";
    hash = "sha256-lvN2it+pNyYvGIqtRI+zUZwPrj/3SLMZX9zordYg3IU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  lpf = {
    version = "0-unstable-2023-10-13";
    url = "gitlab:TheZoq2/tree-sitter-lpf/db7372e60c722ca7f12ab359e57e6bf7611ab126";
    hash = "sha256-Y+W4Ceb0+gUJbBC9ziy672not6zc8JVIGTWYsPmWk7c=";
    meta = {
      license = lib.licenses.isc;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  lua = {
    version = "0.0.19-unstable-2025-05-16";
    url = "github:MunifTanjim/tree-sitter-lua/4fbec840c34149b7d5fe10097c93a320ee4af053";
    hash = "sha256-fO8XqlauYiPR0KaFzlAzvkrYXgEsiSzlB3xYzUpcbrs=";
  };

  luau = {
    version = "0-unstable-2025-12-08";
    url = "github:polychromatist/tree-sitter-luau/71b03e66b2c8dd04e0133c9b998a54a58f239ca4";
    hash = "sha256-aXoq9NvJDzQLSuyanFL8dQepxTyK/k5y0APAJn1DZKI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  mail = {
    version = "0-unstable-2025-04-09";
    url = "github:ficcdaf/tree-sitter-mail/c84126474aee00ce67c32229710a4e1e09827a08";
    hash = "sha256-qqy7jsqsWVUlRuk+Cv+n3sEiH/SlO5/4Q+mrcftFKP4=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  make = {
    version = "0-unstable-2021-12-16";
    url = "github:alemuller/tree-sitter-make/a4b9187417d6be349ee5fd4b6e77b4172c6827dd";
    hash = "sha256-qQqapnKKH5X8rkxbZG5PjnyxvnpyZHpFVi/CLkIn/x0=";
  };

  markdoc = {
    version = "0-unstable-2024-10-06";
    url = "github:markdoc-extra/tree-sitter-markdoc/e4211fe541a13350275e4684de79adfebe9a91f8";
    hash = "sha256-WFFrpvulhT9Z0L+zAgZQGIzcg3YxkcJpLfNeqpf3afI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  markdown = {
    version = "0.3.2";
    url = "github:tree-sitter-grammars/tree-sitter-markdown";
    hash = "sha256-OlVuHz9/5lxsGVT+1WhKx+7XtQiezMW1odiHGinzro8=";
    location = "tree-sitter-markdown";
  };

  markdown-inline = {
    language = "markdown_inline";
    version = "0.3.2";
    url = "github:tree-sitter-grammars/tree-sitter-markdown";
    hash = "sha256-OlVuHz9/5lxsGVT+1WhKx+7XtQiezMW1odiHGinzro8=";
    location = "tree-sitter-markdown-inline";
  };

  matlab = {
    version = "0-unstable-2025-11-22";
    url = "github:acristoffers/tree-sitter-matlab/1bccabdbd420a9c3c3f96f36d7f9e65b3d9c88ef";
    hash = "sha256-V7GOXiR//JgxjTOxRi+PpfRGvunX4r3C0Bu1CrN+/K4=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  mermaid = {
    version = "0-unstable-2024-04-22";
    url = "github:monaqa/tree-sitter-mermaid/90ae195b31933ceb9d079abfa8a3ad0a36fee4cc";
    hash = "sha256-Tt1bPqpL59FQzuI8CPljBmQoAfJPUkVC9Xe1GcfXzfE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  meson = {
    version = "0-unstable-2022-11-02";
    url = "github:staysail/tree-sitter-meson/1a497eecfb1b840ab12caf28f0ef45d4a5e26d28";
    hash = "sha256-VWI4q85uOzT/n/tWYAMgGWdK1q3BAAuwC4WjErE82xk=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  mojo = {
    version = "0-unstable-2024-12-07";
    url = "github:lsh/tree-sitter-mojo/564d5a8489e20e5f723020ae40308888699055c0";
    hash = "sha256-UY4gTG9HI/agpD+2syb7lUqfZpw6I6UnKzs9zE9JFwA=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  move = {
    version = "0-unstable-2025-06-17";
    url = "github:tzakian/tree-sitter-move/640ee15e4a7b0d09a4bc95dcc71336c28d97999b";
    hash = "sha256-rLIyJZEjMRo8am+ivKCwAESvv6jFtTPYJuuebN3T5Es=";
    meta = {
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  nasm = {
    version = "0-unstable-2024-11-23";
    url = "github:naclsn/tree-sitter-nasm/d1b3638d017f2a8585e26dcfc66fe1df94185e30";
    hash = "sha256-38yRvaSkHZ7iRmHlXdCssJtd/RQRfBB437HzBwWv2mg=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  netlinx = {
    version = "1.0.4";
    url = "github:norgate-av/tree-sitter-netlinx";
    hash = "sha256-WCzt5cglAQ9/1VRP/TJ0EjeLXrF9erIGMButRV7iAic=";
  };

  nginx = {
    version = "0-unstable-2024-10-15";
    url = "gitlab:joncoole/tree-sitter-nginx/f6d13cf6281b25f2ce342a49a41a10a0381e00f0";
    hash = "sha256-ofFBxW4p7rZFZm9w5cyA0semYLJWFu9emv8bfTfAFok=";
    meta = {
      license = lib.licenses.gpl3;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  nickel = {
    version = "0.3.0";
    url = "github:nickel-lang/tree-sitter-nickel?ref=0.3";
    hash = "sha256-jL054OJj+1eXksNYOTTTFzZjwPqTFp06syC3TInN8rc=";
  };

  nim = {
    version = "0-unstable-2025-07-29";
    url = "github:alaviss/tree-sitter-nim/4ad352773688deb84a95eeaa9872acda5b466439";
    hash = "sha256-dinMmbD36o1QkcLk2mgycgHZ9sW5Mg6lfnxssynaj58=";
    meta = {
      license = lib.licenses.mpl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  nix = {
    version = "0.3.0-unstable-2025-12-03";
    url = "github:nix-community/tree-sitter-nix/eabf96807ea4ab6d6c7f09b671a88cd483542840";
    hash = "sha256-cSiBd0XkSR8l1CF2vkThWUtMxqATwuxCNO5oy2kyOZY=";
  };

  norg = {
    version = "0.2.6";
    url = "github:nvim-neorg/tree-sitter-norg";
    hash = "sha256-z3h5qMuNKnpQgV62xZ02F5vWEq4VEnm5lxwEnIFu+Rw=";
  };

  norg-meta = {
    version = "0.1.0";
    url = "github:nvim-neorg/tree-sitter-norg-meta";
    hash = "sha256-8qSdwHlfnjFuQF4zNdLtU2/tzDRhDZbo9K54Xxgn5+8=";
  };

  nu = {
    version = "0-unstable-2025-12-13";
    url = "github:nushell/tree-sitter-nu/4c149627cc592560f77ead1c384e27ec85926407";
    hash = "sha256-h02kb3VxSK/fxQENtj2yaRmAQ5I8rt5s5R8VrWOQWeo=";
  };

  ocaml = {
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-ocaml";
    hash = "sha256-e08lrKCyQRpb8pnLV6KK4ye53YBjxQ52nnDIzH+7ONc=";
  };

  ocaml-interface = {
    language = "ocaml_interface";
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-ocaml";
    hash = "sha256-e08lrKCyQRpb8pnLV6KK4ye53YBjxQ52nnDIzH+7ONc=";
  };

  odin = {
    version = "0-unstable-2025-01-12";
    url = "github:tree-sitter-grammars/tree-sitter-odin/d2ca8efb4487e156a60d5bd6db2598b872629403";
    hash = "sha256-aPeaGERAP1Fav2QAjZy1zXciCuUTQYrsqXaSQsYG0oU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ohm = {
    version = "0-unstable-2025-12-12";
    url = "github:novusnota/tree-sitter-ohm/a1de3e748a185a335b446613aaeff1eb10e83cdf";
    hash = "sha256-phH6FHdP9ycVXSzsON0/IyEuqkR65/8cNxJcTOBr3JE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  opencl = {
    version = "0-unstable-2023-03-30";
    url = "github:lefp/tree-sitter-opencl/8e1d24a57066b3cd1bb9685bbc1ca9de5c1b78fb";
    hash = "sha256-tymKOBQbbXAI4bUDSOnZaMoyhFuDwSInvqgGq0eTDl8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  openscad = {
    version = "0-unstable-2025-11-25";
    url = "github:openscad/tree-sitter-openscad/09ed1478aa98a11df06367e91f2d310e334e39fb";
    hash = "sha256-tRBUGfcEdEnym1mrpPs7YdWvbBgeLQoZLgb47XtoGd8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  org = {
    version = "0-unstable-2023-06-19";
    url = "github:milisims/tree-sitter-org/64cfbc213f5a83da17632c95382a5a0a2f3357c1";
    hash = "sha256-/03eZBbv23W5s/GbDgPgaJV5TyK+/lrWUVeINRS5wtA=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  org-nvim = {
    version = "0-unstable-2023-06-19";
    url = "github:emiasims/tree-sitter-org/64cfbc213f5a83da17632c95382a5a0a2f3357c1";
    hash = "sha256-/03eZBbv23W5s/GbDgPgaJV5TyK+/lrWUVeINRS5wtA=";
  };

  pascal = {
    version = "0-unstable-2025-05-17";
    url = "github:Isopod/tree-sitter-pascal/5054931bcd022860dd5936864f981e359fb63aef";
    hash = "sha256-+5HzlNL54/Wdr7b1vRwZzIU3Z8vqFP9FzmEO1qwxJrk=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  passwd = {
    version = "0-unstable-2022-12-01";
    url = "github:ath3/tree-sitter-passwd/20239395eacdc2e0923a7e5683ad3605aee7b716";
    hash = "sha256-3UfuyJeblQBKjqZvLYyO3GoCvYJp+DvBwQGkR3pFQQ4=";
    meta = {
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  pem = {
    version = "0-unstable-2023-02-05";
    url = "github:mtoohey31/tree-sitter-pem/62842ea106ff66876f9af4cccdf87913d1ed912e";
    hash = "sha256-yxxm3Iu3FQxdWM0d2VeptZj/ePTa58NFhLgYBzaeSeU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  perl = {
    version = "1.1.1";
    url = "github:ganezdragon/tree-sitter-perl";
    hash = "sha256-1RnL1dFbTWalqIYg8oGNzwvZxOFPPKwj86Rc3ErfYMU=";
  };

  pest = {
    version = "0-unstable-2025-10-06";
    url = "github:pest-parser/tree-sitter-pest/c19629a0c50e6ca2485c3b154b1dde841a08d169";
    hash = "sha256-S5qg/LLPlMmNtRTTi7vW8y/c+zcId7ADmMqIt0gqJBo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  pgn = {
    version = "1.4.2";
    url = "github:rolandwalker/tree-sitter-pgn";
    hash = "sha256-pGUSsmm+YUvfvt5c4tPs6tmEcFh3DZoDtVf+EpFhOo0=";
  };

  php = {
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-php";
    hash = "sha256-jI7yzcoHS/tNxUqJI4aD1rdEZV3jMn1GZD0J+81Dyf0=";
  };

  php-only = {
    version = "0-unstable-2025-11-24";
    url = "github:tree-sitter/tree-sitter-php/7d07b41ce2d442ca9a90ed85d0075eccc17ae315";
    hash = "sha256-XEKlsqC7HJ3mShmcwmfpezNP9DHE8f73f7/ru4MuxEo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  pioasm = {
    version = "0-unstable-2024-10-12";
    url = "github:leo60228/tree-sitter-pioasm/afece58efdb30440bddd151ef1347fa8d6f744a9";
    hash = "sha256-rUuolF/jPJGiqunD6SLUJ0x/MTIJ+mJ1QSBCasUw5T8=";
  };

  pkl = {
    version = "0-unstable-2025-12-12";
    url = "github:apple/tree-sitter-pkl/ac58931956c000d3aeefbb55a81fc3c5bd6aecf0";
    hash = "sha256-R0p9ceNjd9xnikxaCjDFwN4HkfRr+4ezVSlXqLP/YuQ=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  po = {
    version = "0-unstable-2024-04-20";
    url = "github:erasin/tree-sitter-po/bd860a0f57f697162bf28e576674be9c1500db5e";
    hash = "sha256-/St0VxDTAF872ZlBph1TukRoO0PBIOMT0D11DZ6nSLQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  pod = {
    version = "0-unstable-2024-08-23";
    url = "github:tree-sitter-perl/tree-sitter-pod/release";
    hash = "sha256-yV2kVAxWxdyIJ3g2oivDc01SAQF0lc7UMT2sfv9lKzI=";

    meta = {
      license = lib.licenses.artistic2;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ponylang = {
    version = "0-unstable-2023-03-13";
    url = "github:mfelsche/tree-sitter-ponylang/cc8a0ff12f4f9e56f8a0d997c55155b702938dfe";
    hash = "sha256-/Qyr6TPmYPVQuWUmkb/77k94DK7nzlAA3hjSjeF6MeI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  powershell = {
    version = "0-unstable-2025-12-08";
    url = "github:airbus-cert/tree-sitter-powershell/7212f47716ced384ac012b2cc428fd9f52f7c5d4";
    hash = "sha256-xzDM1CdBY95XgLsEjqKWrwuIf/s6/2Q0XbxJRvOuL2o=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  prisma = {
    version = "1.6.0";
    url = "github:victorhqc/tree-sitter-prisma";
    hash = "sha256-VE9HUG0z6oPVlA8no011vwYI2HxufJEuXXnCGbCgI4Q=";
  };

  prolog = {
    version = "0-unstable-2025-03-23";
    url = "codeberg:foxy/tree-sitter-prolog/d8d415f6a1cf80ca138524bcc395810b176d40fa";
    hash = "sha256-SEqqmkfV/wsr1ObcBN5My29RY9TWfxnQlsnEEIZyR18=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  properties = {
    version = "0-unstable-2025-07-14";
    url = "github:tree-sitter-grammars/tree-sitter-properties/6310671b24d4e04b803577b1c675d765cbd5773b";
    hash = "sha256-LRutvpXXVK7z+xrnLQVvLY+VRg8IB/VK572PNgvsQfc=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  proto = {
    version = "0-unstable-2021-06-12";
    url = "github:mitchellh/tree-sitter-proto/42d82fa18f8afe59b5fc0b16c207ee4f84cb185f";
    hash = "sha256-cX+0YARIa9i8UymPPviyoj+Wh37AFYl9fsoNZMQXPgA=";
  };

  prql = {
    version = "0-unstable-2023-07-28";
    url = "github:PRQL/tree-sitter-prql/09e158cd3650581c0af4c49c2e5b10c4834c8646";
    hash = "sha256-bdT7LZ2x7BdUqLJRq4ENJTaIFnciac7l2dCxOSB09CI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  pug = {
    version = "0-unstable-2024-11-17";
    url = "github:zealot128/tree-sitter-pug/13e9195370172c86a8b88184cc358b23b677cc46";
    hash = "sha256-Yk1oBv9Flz+QX5tyFZwx0y67I5qgbnLhwYuAvLi9eV8=";
  };

  purescript = {
    version = "0-unstable-2025-06-17";
    url = "github:postsolar/tree-sitter-purescript/f541f95ffd6852fbbe88636317c613285bc105af";
    hash = "sha256-tONS2Eai/eVDecn6ow4nN9F7++UjY6OAKezeCco8hYU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  python = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-python";
    hash = "sha256-F5XH21PjPpbwYylgKdwD3MZ5o0amDt4xf/e5UikPcxY=";
  };

  ql = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ql";
    hash = "sha256-mJ/bj09mT1WTaiKoXiRXDM7dkenf5hv2ArXieeTVe6I=";
  };

  ql-dbscheme = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ql-dbscheme";
    hash = "sha256-lXHm+I3zzCUOR/HjnhQM3Ga+yZr2F2WN28SmpT9Q6nE=";
  };

  qmljs = rec {
    version = "0.3.0";
    url = "github:yuja/tree-sitter-qmljs?ref=${version}";
    hash = "sha256-tV4lipey+OAQwygRFp9lQAzgCNiZzSu7p3Mr6CCBH1g=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        jaredmontoya
      ];
    };
  };

  query = {
    version = "0.8.0";
    url = "github:tree-sitter-grammars/tree-sitter-query";
    hash = "sha256-0y8TbbZKMstjIVFEtq+9Fz44ueRup0ngNcJPJEQB/NQ=";
  };

  quint = {
    version = "0-unstable-2025-04-09";
    url = "github:gruhn/tree-sitter-quint/release";
    hash = "sha256-Eo9jvIhiRlMvNYSqQVS9/sIIkmIWpDJfenqObTWgy40=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  r = {
    version = "1.2.0";
    url = "github:r-lib/tree-sitter-r";
    hash = "sha256-SkCLFIUvJWTtg4m5NMfHbBKald470Kni2mhj2Oxc5ZU=";
  };

  razor = {
    version = "0-unstable-2016-07-08";
    url = "github:tree-sitter/tree-sitter-razor/60edbd8e798e416f5226a746396efa6a8614fa9b";
    hash = "sha256-UVzs4z1Aa/Wvpwck4wrApijTEOrc53h867M32m2yutE=";
    # Source repo is marked as archived (no update for 9 hears) and does not
    # compile with current tree-sitter toolchain.
    meta.broken = true;
  };

  regex = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-regex";
    hash = "sha256-bR0K6SR19QuQwDUic+CJ69VQTSGqry5a5IOpPTVJFlo=";
  };

  rego = {
    version = "0-unstable-2024-06-12";
    url = "github:FallenAngel97/tree-sitter-rego/20b5a5958c837bc9f74b231022a68a594a313f6d";
    hash = "sha256-XwlVsOlxYzB0x+T05iuIp7nFAoQkMByKiHXZ0t5QsjI=";
  };

  rescript = {
    version = "0-unstable-2025-03-03";
    url = "github:rescript-lang/tree-sitter-rescript/d2df8a285fff95de56a91d2f8152aeceb66f40ef";
    hash = "sha256-yNZrihl4BNvLu0Zqr4lSqvdZCeXU3KnCY7ZYC1U42R0=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  river = {
    version = "0-unstable-2023-11-22";
    url = "github:grafana/tree-sitter-river/eafcdc5147f985fea120feb670f1df7babb2f79e";
    hash = "sha256-fhuIO++hLr5DqqwgFXgg8QGmcheTpYaYLMo7117rjyk=";
  };

  robot = {
    version = "0-unstable-2025-05-01";
    url = "github:Hubro/tree-sitter-robot/e34def7cb0d8a66a59ec5057fe17bb4e6b17b56a";
    hash = "sha256-fTV45TQp2Z+ivh2YWphlJjyuBh0iMCpaNDyKoHrNAh0=";
    meta = {
      license = lib.licenses.isc;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  ron = {
    version = "0-unstable-2024-05-05";
    url = "github:tree-sitter-grammars/tree-sitter-ron/78938553b93075e638035f624973083451b29055";
    hash = "sha256-Sp0g6AWKHNjyUmL5k3RIU+5KtfICfg3o/DH77XRRyI0=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  rst = {
    version = "0.2.0";
    url = "github:stsewd/tree-sitter-rst";
    hash = "sha256-EYUn60fU2hMizL+4PITtzJFJKdBktoPjMsYJ1R70LdM=";
  };

  ruby = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ruby";
    hash = "sha256-iu3MVJl0Qr/Ba+aOttmEzMiVY6EouGi5wGOx5ofROzA=";
  };

  rust = {
    version = "0.24.0";
    url = "github:tree-sitter/tree-sitter-rust";
    hash = "sha256-y3sJURlSTM7LRRN5WGIAeslsdRZU522Tfcu6dnXH/XQ=";
  };

  rust-format-args = {
    version = "0-unstable-2025-07-14";
    url = "github:nik-rev/tree-sitter-rust-format-args/3cf8431a4951656bcf24ae06689fbd094fce0187";
    hash = "sha256-lt4vs14DZXCxlpG7awmrZ5Ml5Sr0kKEn5Y26xrlM/ww=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  scala = {
    version = "0.24.0";
    url = "github:tree-sitter/tree-sitter-scala";
    hash = "sha256-ZE+zjpb52hvehJjNchJYK81XZbGAudeTRxlczuoix5g=";
  };

  scheme = {
    version = "0.24.7-1-unstable-2025-12-13";
    url = "github:6cdh/tree-sitter-scheme/b5c701148501fa056302827442b5b4956f1edc03";
    hash = "sha256-SLuK8S03pKVVhxJTkE3ZJvNaNnmXD323YwE7ah2VxyQ=";
  };

  scss = {
    version = "1.0.0";
    url = "github:serenadeai/tree-sitter-scss";
    hash = "sha256-BFtMT6eccBWUyq6b8UXRAbB1R1XD3CrrFf1DM3aUI5c=";
  };

  slang = {
    version = "0-unstable-2025-09-01";
    url = "github:tree-sitter-grammars/tree-sitter-slang/1dbcc4abc7b3cdd663eb03d93031167d6ed19f56";
    hash = "sha256-UsZpXEJwbKn5M9dqbAv5eJgsCdNbsllbFWtNnDPvtoE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  slint = {
    version = "0-unstable-2025-12-09";
    url = "github:slint-ui/tree-sitter-slint/10fb0f188d7950400773c06ba6c31075866e14bf";
    hash = "sha256-60DfIx7aQqe0/ocxbpr00eU3IPs23E8TUILcVGrBYVs=";
  };

  smali = {
    version = "0-unstable-2024-05-05";
    url = "github:amaanq/tree-sitter-smali/fdfa6a1febc43c7467aa7e937b87b607956f2346";
    hash = "sha256-S0U6Xuntz16DrpYwSqMQu8Cu7UuD/JufHUxIHv826yw=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  smithy = {
    version = "0.2.0";
    url = "github:indoorvivants/tree-sitter-smithy";
    hash = "sha256-3cqT6+e0uqAtd92M55qSbza1eph8gklGlEGyO9R170w=";
  };

  sml = {
    version = "0.23.0";
    url = "github:MatthewFluet/tree-sitter-sml";
    hash = "sha256-hqsyHFcSmvyR50TKtOcidwABW+P31qisgSOtWTWM0tE=";
  };

  snakemake = {
    version = "0-unstable-2025-09-18";
    url = "github:osthomas/tree-sitter-snakemake/68010430c3e51c0e84c1ce21c6551df0e2469f51";
    hash = "sha256-jcMNh+pHjYEvTdShp3o6UlgXRM2AuZMp4KE0uXfNMqY=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  solidity = {
    version = "1.2.13";
    url = "github:JoranHonig/tree-sitter-solidity";
    hash = "sha256-b+DHy7BkkMg88kLhirtCzjF3dHlCFkXea65aGC18fW0=";
  };

  sourcepawn = {
    version = "0-unstable-2025-06-13";
    url = "github:nilshelmig/tree-sitter-sourcepawn/5a8fdd446b516c81e218245c12129c6ad4bccfa2";
    hash = "sha256-TfLCG2Ro3QnGStyCNqHwO54HQMR2fEOV6FjBv+0LjJ0=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  spade = {
    version = "0-unstable-2025-12-08";
    url = "gitlab:spade-lang/tree-sitter-spade/6569cd11cc9362e277845ce24111735059b145ee";
    hash = "sha256-h7rlrtV1NHjFPITR1cvYCblkUmbUudem4Ll6Z7qBFqE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  sparql = {
    version = "0-unstable-2024-06-26";
    url = "github:GordianDziwis/tree-sitter-sparql/d853661ca680d8ff7f8d800182d5782b61d0dd58";
    hash = "sha256-0BV0y8IyeIPpuxTixlJL1PsDCuhXbGaImu8JU8WFoPU=";
  };

  spicedb = {
    version = "0-unstable-2024-02-08";
    url = "github:jzelinskie/tree-sitter-spicedb/a4e4645651f86d6684c15dfa9931b7841dc52a66";
    hash = "sha256-dEpPkEohBB3qU1Vma/1VePkGGst4nA2RKgun7NiO2OA=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  sql = {
    version = "0.3.9";
    url = "github:derekstride/tree-sitter-sql";
    hash = "sha256-DC7cZs8ePQmj5t/6GgnmgT5ubuOBaaS3Xch/f76/ZWM=";
    generate = true;
  };

  sshclientconfig = {
    version = "0-unstable-2025-12-19";
    url = "github:metio/tree-sitter-ssh-client-config/9c86b2af6d8f9fd0a82edcc253b45c3e8eb93c52";
    hash = "sha256-YF+iMd0F1po0j8FqBO36P6DCpMgscT6YkVMOKetAS6w=";
    meta = {
      license = lib.licenses.cc0;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  strace = {
    version = "0-unstable-2025-12-21";
    url = "github:sigmaSd/tree-sitter-strace/ac874ddfcc08d689fee1f4533789e06d88388f29";
    hash = "sha256-BGCbpw85+NNQMF+emS2hllbIeTmiFvveFzlK5lKaD5U=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  supercollider = {
    version = "0.3.2";
    url = "github:madskjeldgaard/tree-sitter-supercollider";
    hash = "sha256-drn1S4gNm6fOSUTCa/CrAqCWoUn16y1hpaZBCPpyaNE=";
  };

  surface = {
    version = "0.2.0";
    url = "github:connorlay/tree-sitter-surface";
    hash = "sha256-Hur6lae+9nk8pWL531K52fEsCAv14X5gmYKD9UULW4g=";
  };

  svelte = {
    version = "0.11.0";
    url = "github:Himujjal/tree-sitter-svelte";
    hash = "sha256-novNVlLVHYIfjmC7W+F/1F0RxW6dd27/DwQ3n5UO6c4=";
  };

  sway = {
    version = "0-unstable-2025-09-02";
    url = "github:FuelLabs/tree-sitter-sway/9b7845ce06ecb38b040c3940970b4fd0adc331d1";
    hash = "sha256-+BRw4OFQb7FljdKCj5mruK0L9wsZ+1UDTykVLS9wjoY=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  swift = rec {
    version = "0.7.1";
    url = "github:alex-pinkus/tree-sitter-swift/${version}-with-generated-files";
    hash = "sha256-jVZpnwpcQ3sXE4hXQIHKzQgEE13pqE3fGqdRMjb1AOQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  t32 = {
    version = "0-unstable-2025-12-19";
    url = "github:xasc/tree-sitter-t32/5b5e4336731bda5ea2e6b78b6a2d9e7a89032b75";
    hash = "sha256-dAbjM+wlKtJ3cY3zdRgsdsjJ0ZYDZxTL0mcunqqNbvw=";
    meta = {
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  tablegen = {
    version = "0-unstable-2024-10-04";
    url = "github:Flakebi/tree-sitter-tablegen/3e9c4822ab5cdcccf4f8aa9dcd42117f736d51d9";
    hash = "sha256-8yn/Czv/aNQfa/k8gnr8qeCsuDtU2L2qHGKAMbv8Vgk=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  tact = {
    version = "0-unstable-2025-05-01";
    url = "github:tact-lang/tree-sitter-tact/a6267c2091ed432c248780cec9f8d42c8766d9ad";
    hash = "sha256-2AUN/VYor3K0hkneLYa6+LjE+V8EJogFqBTgdfvOiKM=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  talon = rec {
    version = "5.0.0";
    url = "github:wenkokke/tree-sitter-talon?ref=${version}";
    hash = "sha256-NfPwnySeztMx3qzDbA4HE5WNVd6aImioZkvWi1lXh88=";
  };

  task = {
    version = "0-unstable-2022-08-17";
    url = "github:alexanderbrevig/tree-sitter-task/ed4fb3674dd2d889c36e121f7173099290452af2";
    hash = "sha256-0vqXoDgQcAE1rm3kFlb+l/S4cZuL5sU3WsZMDSna1+s=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  tcl = {
    version = "0-unstable-2025-05-14";
    url = "github:tree-sitter-grammars/tree-sitter-tcl/8f11ac7206a54ed11210491cee1e0657e2962c47";
    hash = "sha256-JrGSHGolf7OhInxotXslw1QXxJscl+bXCxZPYJeBfTY=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  teal = {
    version = "0-unstable-2025-05-14";
    url = "github:euclidianAce/tree-sitter-teal/05d276e737055e6f77a21335b7573c9d3c091e2f";
    hash = "sha256-JDqWr895Ob1Jn3Kf44xbkMJqyna0AiMBU5xJpA6ZP7w=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  templ = {
    version = "1.0.0-unstable-2025-12-03";
    url = "github:vrischmann/tree-sitter-templ/3057cd485f7f23a8ad24107c6adc604f8c5ce3db";
    hash = "sha256-iv5Egh0CcBEsD86IGESI5Bn0NcGji3wruD8UR1JNlk0=";
  };

  tera = {
    version = "0.1.0";
    url = "github:uncenter/tree-sitter-tera";
    hash = "sha256-1Gb947YJnEFrCVKAuz06kwJdKD9PMab/alFJtyYjBso=";
  };

  textproto = {
    version = "0-unstable-2024-10-16";
    url = "github:PorterAtGoogle/tree-sitter-textproto/568471b80fd8793d37ed01865d8c2208a9fefd1b";
    hash = "sha256-VAj8qSxbkFqNp0X8BOZNvGTggSXZvzDjODedY11J0BQ=";
    meta = {
      license = lib.licenses.isc;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  thrift = {
    version = "0-unstable-2024-04-20";
    url = "github:tree-sitter-grammars/tree-sitter-thrift/68fd0d80943a828d9e6f49c58a74be1e9ca142cf";
    hash = "sha256-owZbs8ttjKrqTA8fQ/NmBGyIUUItSUvvW4hRv0NPV8Y=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  tiger = {
    version = "0.3.0-unstable-2025-03-13";
    url = "github:ambroisie/tree-sitter-tiger/4a77b2d7a004587646bddc4e854779044b6db459";
    hash = "sha256-jLdJ3nLShoBxVCcUbnaswYG5d4UU8aaE1xexb2LnmTQ=";
  };

  tlaplus = rec {
    # FIXME: remove language override after release is available that includes
    # https://github.com/tlaplus-community/tree-sitter-tlaplus/pull/138
    version = "1.5.0";
    url = "github:tlaplus-community/tree-sitter-tlaplus?ref=${version}";
    hash = "sha256-k34gkAd0ueXEAww/Hc1mtBfn0Kp1pIBQtjDZ9GQeB4Q=";
  };

  todotxt = {
    version = "0-unstable-2024-01-15";
    url = "github:arnarg/tree-sitter-todotxt/3937c5cd105ec4127448651a21aef45f52d19609";
    hash = "sha256-OeAh51rcFTiexAraRzIZUR/A8h9RPwKY7rmtc3ZzoRQ=";
  };

  toml = {
    version = "0.5.1-unstable-2022-04-21";
    url = "github:tree-sitter/tree-sitter-toml/342d9be207c2dba869b9967124c679b5e6fd0ebe";
    hash = "sha256-V2c7K16g8PikE9eNgrM6iUDiu4kzBvHMFQwfkph+8QI=";
  };

  tsq = {
    version = "0.19.0-unstable-2024-02-24";
    url = "github:tree-sitter/tree-sitter-tsq/49da6de661be6a07cb51018880ebe680324e7b82";
    hash = "sha256-md4xynJx9F/l6N+JZYU8CLXmz50fV13L8xGJVUqk6do=";
  };

  tsx = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-typescript";
    hash = "sha256-CU55+YoFJb6zWbJnbd38B7iEGkhukSVpBN7sli6GkGY=";
  };

  turtle = {
    version = "0-unstable-2024-07-02";
    url = "github:GordianDziwis/tree-sitter-turtle/7f789ea7ef765080f71a298fc96b7c957fa24422";
    hash = "sha256-z6f73euFAG9du5owz7V9WLbWK81Jg0DwxN1metKPbTA=";
  };

  twig = {
    version = "0.7.0";
    url = "github:kaermorchen/tree-sitter-twig";
    hash = "sha256-JvJeSwdqyGNjWwJpcRiJ1hHVlUge3XX0xr/WBJ/LRhk=";
  };

  typescript = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-typescript";
    hash = "sha256-CU55+YoFJb6zWbJnbd38B7iEGkhukSVpBN7sli6GkGY=";
  };

  typespec = {
    version = "0-unstable-2025-06-21";
    url = "github:happenslol/tree-sitter-typespec/814c98283fd92a248ba9d49ebfe61bc672a35875";
    hash = "sha256-3/zNoawx1DsKmG0KFvJD+o80IMBsJd2VV2ng+fSrV1c=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  typst = {
    version = "0.11.0";
    url = "github:uben0/tree-sitter-typst";
    hash = "sha256-n6RTRMJS3h+g+Wawjb7I9NJbz+w/SGi+DQVj1jiyGaU=";
  };

  uiua = {
    version = "0.13.0";
    url = "github:shnarazk/tree-sitter-uiua";
    hash = "sha256-b/uR04wTiLVTgrLr2OuBzZ0LJd35BozFAe2MdBVW0Qk=";
  };

  ungrammar = {
    version = "0-unstable-2023-02-28";
    url = "github:Philipp-M/tree-sitter-ungrammar/debd26fed283d80456ebafa33a06957b0c52e451";
    hash = "sha256-ftvcD8I+hYqH3EGxaRZ0w8FHjBA34OSTTsrUsAOtayU=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  unison = {
    version = "0-unstable-2025-03-06";
    url = "github:kylegoetz/tree-sitter-unison/169e7f748a540ec360c0cb086b448faad012caa4";
    hash = "sha256-0HOLtLh1zRdaGQqchT5zFegWKJHkQe9r7DGKL6sSkPo=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  uxntal = {
    version = "0-unstable-2024-03-23";
    url = "github:Jummit/tree-sitter-uxntal/1a44f8d31053096b79c52f10a39da12479edbf64";
    hash = "sha256-S6B2K2eqHktLknpfTATR5fZYE8+W1BvOYTSNTwslSVg=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  v = rec {
    version = "0.0.6";
    url = "github:vlang/v-analyzer/${version}";
    hash = "sha256-lBrX5n4hYdDq+2m7j9JXyeGGS3yl4oBu8jK7VV+OE7I=";
    location = "tree_sitter_v";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  vala = {
    version = "0-unstable-2024-10-29";
    url = "github:vala-lang/tree-sitter-vala/97e6db3c8c73b15a9541a458d8e797a07f588ef4";
    hash = "sha256-hAekweZGDHVrWVd04RrN+9Jz0D2kode+DpceTlUXii0=";
    meta = {
      license = lib.licenses.lgpl21Only;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  vento = {
    version = "0-unstable-2024-12-30";
    url = "github:ventojs/tree-sitter-vento/3b32474bc29584ea214e4e84b47102408263fe0e";
    hash = "sha256-h8yC+MJIAH7DM69UQ8moJBmcmrSZkxvWrMb+NqtYB2Y=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  verilog = {
    version = "1.0.3";
    url = "github:tree-sitter/tree-sitter-verilog";
    hash = "sha256-SlK33WQhutIeCXAEFpvWbQAwOwMab68WD3LRIqPiaNY=";
  };

  vhdl = {
    version = "0-unstable-2025-12-18";
    url = "github:jpt13653903/tree-sitter-vhdl/7ae08deb5d1641aa57111342218ca1e1b3a5d539";
    hash = "sha256-IJ6Gqq+3YJlL4n4cjtCLUCZKpLVJQa81nQrLsJBCccs=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  vhs = {
    version = "0-unstable-2025-03-26";
    url = "github:charmbracelet/tree-sitter-vhs/0c6fae9d2cfc5b217bfd1fe84a7678f5917116db";
    hash = "sha256-o7Q/3wwiCjxO6hBfj1Wxoz2y6+wxLH+oCLiapox7+Hk=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  vim = {
    version = "0-unstable-2023-05-05";
    url = "github:vigoux/tree-sitter-viml/7c317fbade4b40baa7babcd6c9097c157d148e60";
    hash = "sha256-/TyPUBsKRcF9Ig8psqd4so2IMbHtTu4weJXgfd96Vrs=";
  };

  vue = {
    version = "0.2.1-unstable-2021-04-04";
    url = "github:ikatyang/tree-sitter-vue/91fe2754796cd8fba5f229505a23fa08f3546c06";
    hash = "sha256-NeuNpMsKZUP5mrLCjJEOSLD6tlJpNO4Z/rFUqZLHE1A=";
  };

  wast = {
    version = "0-unstable-2022-05-17";
    url = "github:wasm-lsp/tree-sitter-wasm/2ca28a9f9d709847bf7a3de0942a84e912f59088";
    hash = "sha256-a1l4RsGpRQfUxEjwewyKiV0G7J2DHZW6+y1HnjREYAs=";
    location = "wast";
    meta = {
      license = with lib.licenses; [
        asl20
        llvm-exception
      ];
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  wat = {
    version = "0-unstable-2022-05-17";
    url = "github:wasm-lsp/tree-sitter-wasm/2ca28a9f9d709847bf7a3de0942a84e912f59088";
    hash = "sha256-a1l4RsGpRQfUxEjwewyKiV0G7J2DHZW6+y1HnjREYAs=";
    location = "wat";
    meta = {
      license = with lib.licenses; [
        asl20
        llvm-exception
      ];
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  werk = {
    version = "0-unstable-2025-03-19";
    url = "github:little-bonsai/tree-sitter-werk/92b0f7fe98465c4c435794a58e961306193d1c1e";
    hash = "sha256-VPY1fMYGSF1+87ia+d7b7l8PzNIoKwAbAT+yw5KHjjQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  wesl = {
    version = "0-unstable-2025-09-26";
    url = "github:wgsl-tooling-wg/tree-sitter-wesl/3fa2b96bf5c217dae9bf663e2051fcdad0762c19";
    hash = "sha256-O3n65StgGhxfdwYF/QPBTdkXEGjY2ajHeLpF5JWuTc8=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  wgsl = {
    version = "0-unstable-2023-01-09";
    url = "github:szebniok/tree-sitter-wgsl/40259f3c77ea856841a4e0c4c807705f3e4a2b65";
    hash = "sha256-voLkcJ/062hzipb3Ak/mgQvFbrLUJdnXq1IupzjMJXA=";
  };

  wing = {
    version = "0.83.11";
    url = "github:winglang/tree-sitter-wing";
    hash = "sha256-sL1ZoNuNUvTcOUf2I/6cQkeOPj4Jwqmv5zGXETdMByY=";
  };

  wit = {
    version = "0-unstable-2022-10-31";
    url = "github:hh9527/tree-sitter-wit/c917790ab9aec50c5fd664cbfad8dd45110cfff3";
    hash = "sha256-5+cw9vWPizK7YlEhiNJheYVYOgtheEifd4g1KF5ldyE=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  wren = {
    version = "0-unstable-2024-01-01";
    url = "sourcehut:~jummit/tree-sitter-wren/6748694be32f11e7ec6b5faeb1b48ca6156d4e06";
    hash = "sha256-CU08QY4X/u4W4AEkK+gUmy5P8/XoBHDJmWX1vdGjmsI=";
    meta = {
      license = lib.licenses.lgpl3;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  xit = {
    version = "0-unstable-2024-03-16";
    url = "github:synaptiko/tree-sitter-xit/a4fad351bfa5efdcb379b40c36671413fbe9caac";
    hash = "sha256-wTr7YyGnz/dWfA5oecRqxeR8Unoob6isGnQg4/iu+MI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  xml = {
    version = "0-unstable-2023-01-17";
    url = "github:RenjiSann/tree-sitter-xml/48a7c2b6fb9d515577e115e6788937e837815651";
    hash = "sha256-8c/XtnffylxiqX3Q7VFWlrk/655FG2pwqYrftGpnVxI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  xtc = {
    version = "0-unstable-2024-04-15";
    url = "github:Alexis-Lapierre/tree-sitter-xtc/7bc11b736250c45e25cfb0215db2f8393779957e";
    hash = "sha256-teUDDvH8Km1WHNXyrUtX1yULYOaTgaAwT6aCaR4MTfs=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  yaml = {
    version = "0.7.2";
    url = "github:tree-sitter-grammars/tree-sitter-yaml";
    hash = "sha256-BX6TOfAZLW+0h2TNsgsLC9K2lfirraCWlBN2vCKiXQ4=";
  };

  yang = {
    version = "0-unstable-2022-11-21";
    url = "github:hubro/tree-sitter-yang/2c0e6be8dd4dcb961c345fa35c309ad4f5bd3502";
    hash = "sha256-6EIK1EStHrUHBLZBsZqd1LL05ZAJ6PKUyIzBBsTVjO8=";
  };

  yara = {
    version = "0-unstable-2024-12-12";
    url = "github:egibs/tree-sitter-yara/eb3ede203275c38000177f72ec0f9965312806ef";
    hash = "sha256-twcbL2fKOE0PdiEboSIObzAedljZ3arBm6QQUw/W5HQ=";
    meta = {
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  yuck = {
    version = "0-unstable-2024-05-05";
    url = "github:Philipp-M/tree-sitter-yuck/e877f6ade4b77d5ef8787075141053631ba12318";
    hash = "sha256-l8c1/7q8S78jGyl+VAVVgs8wq58PrrjycyJfWXsCgAI=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        aciceri
      ];
    };
  };

  zig = {
    version = "0-unstable-2024-10-13";
    url = "github:maxxnino/tree-sitter-zig/a80a6e9be81b33b182ce6305ae4ea28e29211bd5";
    hash = "sha256-o3RAbW8kLSfKxuQ/z7WDb5BaDVxZUG5oFutovRkErjk=";
  };

}
