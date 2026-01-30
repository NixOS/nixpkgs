{ lib }:

{
  bash = {
    version = "0.25.1";
    url = "github:tree-sitter/tree-sitter-bash";
    hash = "sha256-ONQ1Ljk3aRWjElSWD2crCFZraZoRj3b3/VELz1789GE=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  beancount = {
    version = "2.5.0";
    url = "github:polarmutex/tree-sitter-beancount";
    hash = "sha256-eJ1XAPrVCoGQtrRJdcB/V4ULUmYXemUAE3FQijpH8q8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  bibtex = {
    version = "0-unstable-2025-04-19";
    url = "github:latex-lsp/tree-sitter-bibtex/8d04ed27b3bc7929f14b7df9236797dab9f3fa66";
    hash = "sha256-UOXGWm8k9YP0GUwvNEuIxeiXqJo4Jf9uBt+/oYaYUl4=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  bitbake = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-bitbake";
    hash = "sha256-PSI1XVDGwDk5GjHjvCJfmBDfYM2Gmm1KR4h5KxBR1d0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  bqn = {
    version = "0.3.2";
    url = "github:shnarazk/tree-sitter-bqn";
    hash = "sha256-/FsA5GeFhWYFl1L9pF+sQfDSyihTnweEdz2k8mtLqnY=";
    meta = {
      license = lib.licenses.mpl20;
    };
  };

  c-sharp = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-c-sharp";
    hash = "sha256-weH0nyLpvVK/OpgvOjTuJdH2Hm4a1wVshHmhUdFq3XA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  c = {
    version = "0.24.1";
    url = "github:tree-sitter/tree-sitter-c";
    hash = "sha256-gmzbdwvrKSo6C1fqTJFGxy8x0+T+vUTswm7F5sojzKc=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  clojure = {
    version = "0.0.13-unstable-2025-08-26";
    url = "github:sogaiu/tree-sitter-clojure/e43eff80d17cf34852dcd92ca5e6986d23a7040f";
    hash = "sha256-jokekIuuQLx5UtuPs4XAI+euispeFCwSQByVKVelrC4=";
    meta = {
      license = lib.licenses.cc0;
    };
  };

  cmake = {
    version = "0.7.2";
    url = "github:uyha/tree-sitter-cmake";
    hash = "sha256-mR+gA7eWigC2zO1gMHzOgRagsfK1y/NBsn3mAOqR35A=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  comment = {
    version = "0.3.0";
    url = "github:stsewd/tree-sitter-comment";
    hash = "sha256-O9BBcsMfIfDDzvm2eWuOhgLclUNdgZ/GsQd0kuFFFPQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  commonlisp = {
    version = "0.4.1";
    url = "github:tree-sitter-grammars/tree-sitter-commonlisp";
    hash = "sha256-wHVdRiorBgxQ+gG+m/duv9nt5COxz6XK0AcKQ5FX43U=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  cpp = {
    version = "0.23.4";
    url = "github:tree-sitter/tree-sitter-cpp";
    hash = "sha256-tP5Tu747V8QMCEBYwOEmMQUm8OjojpJdlRmjcJTbe2k=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  crystal = {
    version = "0-unstable-2025-10-12";
    url = "github:crystal-lang-tools/tree-sitter-crystal/50ca9e6fcfb16a2cbcad59203cfd8ad650e25c49";
    hash = "sha256-xmQrplDxoJ8GhcTyCOuEGn4wwMM3/9M6tyM1dgRGARU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  css = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-css";
    hash = "sha256-jFsnEyS+FThk7L48FzAdSp5fNPSLvM8hTL/VC5FMlOE=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  cuda = {
    version = "0.21.1";
    url = "github:tree-sitter-grammars/tree-sitter-cuda";
    hash = "sha256-sX9AOe8dJJsRbzGq20qakWBnLiwYQ90mQspAuYxQzoQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  cue = {
    version = "0.1.0";
    url = "github:eonpatapon/tree-sitter-cue";
    hash = "sha256-ujSBOwOnjsKuFhHtt4zvj90VcQsak8mEcWYJ0e5/mKc=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  dart = {
    version = "0-unstable-2025-10-04";
    url = "github:usernobody14/tree-sitter-dart/d4d8f3e337d8be23be27ffc35a0aef972343cd54";
    hash = "sha256-1ftYqCor1A0PsQ0AJLVqtxVRZxaXqE/NZ5yy7SizZCY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  devicetree = {
    version = "0.11.1";
    url = "github:joelspadin/tree-sitter-devicetree";
    hash = "sha256-2uJEItLwoBoiB49r2XuO216Dhu9AnAa0p7Plmm4JNY8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  dockerfile = {
    version = "0.2.0";
    url = "github:camdencheek/tree-sitter-dockerfile";
    hash = "sha256-4J1bA0y3YSriFTkYt81VftVtlQk790qmMlG/S3FNPCY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  dot = {
    version = "0-unstable-2025-10-21";
    url = "github:rydesun/tree-sitter-dot/80327abbba6f47530edeb0df9f11bd5d5c93c14d";
    hash = "sha256-sepmaKnpbj/bgMBa06ksQFOMPtcCqGaINiJqFBJN/0Y=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  earthfile = {
    version = "0.6.0-unstable-2025-10-27";
    url = "github:glehmann/tree-sitter-earthfile/5baef88717ad0156fd29a8b12d0d8245bb1096a8";
    hash = "sha256-eeXzc+thSPey7r59QkJd5jgchZRhSwT5isSljYLBQ8k=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  eex = {
    version = "0.1.0";
    url = "github:connorlay/tree-sitter-eex";
    hash = "sha256-UPq62MkfGFh9m/UskoB9uBDIYOcotITCJXDyrbg/wKY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  elisp = rec {
    version = "1.6.1";
    url = "github:wilfred/tree-sitter-elisp?ref=${version}";
    hash = "sha256-ixZKsQtRk5ykR6miQ5JicI3xn/Bp9t4WGAIoNTC/gbY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  elixir = {
    version = "0.3.4";
    url = "github:elixir-lang/tree-sitter-elixir";
    hash = "sha256-9M/DpqpGivDtgGt3ojU/kHR51sla59+KtZ/95hT6IIo=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  elm = {
    version = "5.9.0";
    url = "github:elm-tooling/tree-sitter-elm";
    hash = "sha256-vaeGViXob7AYyJj93AUJWBD8Zdfs4zXdKikvBZ3GptU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  embedded-template = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-embedded-template";
    hash = "sha256-nBQain0Lc21jOgQFfvkyq615ZmT8qdMxtqIoUcOcO3A=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  erlang = rec {
    version = "0.1.0";
    url = "github:WhatsApp/tree-sitter-erlang?ref=${version}";
    hash = "sha256-FH8DNE03k95ZsRwaiXHkaU9/cdWrWALCEdChN5ZPdog=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  factor = {
    version = "0-unstable-2025-01-12";
    url = "github:erochest/tree-sitter-factor/554d8b705df61864eb41a0ecf3741e94eb9f0c54";
    hash = "sha256-Z60ySUrBAiNm5s3iH/6jkjsKX5mPAW8bgid+5m2MzJM=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  fennel = {
    version = "1.1.0-unstable-2025-09-07";
    url = "github:travonted/tree-sitter-fennel/36eb796a84b4f57bdf159d0a99267260d4960c89";
    hash = "sha256-aFcTPgWkd/o1qu8d/hulmVDyFlTHJgb35iea4Jc1510=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  fish = rec {
    version = "3.6.0";
    url = "github:ram02z/tree-sitter-fish?ref=${version}";
    hash = "sha256-ZQj6XR7pHGoCOBS6GOHiRW9LWNoNPlwVcZe5F2mtGNE=";
    meta = {
      license = lib.licenses.unlicense;
    };
  };

  fortran = {
    version = "0.5.1";
    url = "github:stadelmanma/tree-sitter-fortran";
    hash = "sha256-6l+cfLVbs8geKIYhnfuZDac8uzmNHOZf2rFANdl4tDs=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  gdscript = {
    version = "6.0.0";
    url = "github:prestonknopp/tree-sitter-gdscript";
    hash = "sha256-S+AF6slDnw3O00C8hcL013A8MU7fKU5mCwhyV50rqmI=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  gemini = rec {
    version = "0.1.0";
    url = "github:blessanabraham/tree-sitter-gemini?ref=${version}";
    hash = "sha256-grWpLh5ozSUct5sSI8M8qnWy72b7ruRuhOpoyswvJuU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  gleam = {
    version = "1.1.0";
    url = "github:gleam-lang/tree-sitter-gleam";
    hash = "sha256-GIikbo8N2bmUa8wddpAgTHeejCInoEY8HxGDbuYq/zQ=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  glimmer = {
    version = "1.6.0";
    url = "github:ember-tooling/tree-sitter-glimmer?ref=v1.6.0-tree-sitter-glimmer";
    hash = "sha256-AW+jd1Kl3krTgnPc8NoXfSM91fOan/wIB/mo/feWj74=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  glsl = {
    version = "0.2.0";
    url = "github:tree-sitter-grammars/tree-sitter-glsl";
    hash = "sha256-S0Yr/RQE4uLpazphTKLUoHgPEOUbOBDGCkkRXemsHjQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  go-template = {
    version = "0-unstable-2025-12-12";
    url = "github:ngalaiko/tree-sitter-go-template/c59999dc449c29549f5735eaac31b938a13b6c14";
    hash = "sha256-YKqpNkCRLX+89Ottw4KVXxrEsIPRUsWs0UwIgucHwdo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  go = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-go";
    hash = "sha256-y7bTET8ypPczPnMVlCaiZuswcA7vFrDOc2jlbfVk5Sk=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  godot-resource = {
    language = "godot_resource";
    version = "0.7.0";
    url = "github:prestonknopp/tree-sitter-godot-resource";
    hash = "sha256-+tUMLqtak9ToY+UUnIiqngDs6diG8crW8Ac0mbk7FMo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  gomod = {
    version = "1.1.0";
    url = "github:camdencheek/tree-sitter-go-mod";
    hash = "sha256-C3pPBgm68mmaPmstyIpIvvDHsx29yZ0ZX/QoUqwjb+0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  gowork = {
    version = "0-unstable-2022-10-04";
    url = "github:omertuc/tree-sitter-go-work/949a8a470559543857a62102c84700d291fc984c";
    hash = "sha256-Tode7W05xaOKKD5QOp3rayFgLEOiMJUeGpVsIrizxto=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  graphql = {
    version = "0-unstable-2021-05-10";
    url = "github:bkegley/tree-sitter-graphql/5e66e961eee421786bdda8495ed1db045e06b5fe";
    hash = "sha256-NvE9Rpdp4sALqKSRWJpqxwl6obmqnIIdvrL1nK5peXc=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  haskell = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-haskell";
    hash = "sha256-bggXKbV4vTWapQAbERPUszxpQtpC1RTujNhwgbjY7T4=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  hcl = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-hcl";
    hash = "sha256-saVKSYUJY7OuIuNm9EpQnhFO/vQGKxCXuv3EKYOJzfs=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  heex = {
    version = "0.8.0";
    url = "github:phoenixframework/tree-sitter-heex";
    hash = "sha256-rifYGyIpB14VfcEZrmRwYSz+ZcajQcB4mCjXnXuVFDQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  hjson = {
    version = "0-unstable-2021-08-02";
    url = "github:winston0410/tree-sitter-hjson/02fa3b79b3ff9a296066da6277adfc3f26cbc9e0";
    hash = "sha256-NsTf3DR3gHVMYZDmTNvThB5bJcDwTcJ1+3eJhvsiDn8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  html = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-html";
    hash = "sha256-Pd5Me1twLGOrRB3pSMVX9M8VKenTK0896aoLznjNkGo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  http = {
    version = "3.0.0";
    url = "github:rest-nvim/tree-sitter-http?ref=v3.0";
    hash = "sha256-pg7QmnfhuCmyuq6HupCJl4H/rcxDeUn563LoL+Wd2Uw=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  hyprlang = {
    version = "3.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-hyprlang";
    hash = "sha256-pNAN5TF01Bnqfcsoa0IllchCCBph9/SowzIoMyQcN5w=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  janet-simple = {
    version = "0.0.7-unstable-2025-05-19";
    url = "github:sogaiu/tree-sitter-janet-simple/7e28cbf1ca061887ea43591a2898001f4245fddf";
    hash = "sha256-qWsUPZfQkuEUiuCSsqs92MIMEvdD+q2bwKir3oE5thc=";
    meta = {
      license = lib.licenses.cc0;
    };
  };

  java = {
    version = "0.23.5";
    url = "github:tree-sitter/tree-sitter-java";
    hash = "sha256-OvEO1BLZLjP3jt4gar18kiXderksFKO0WFXDQqGLRIY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  javascript = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-javascript";
    hash = "sha256-2Jj/SUG+k8lHlGSuPZvHjJojvQFgDiZHZzH8xLu7suE=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  jsdoc = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-jsdoc";
    hash = "sha256-xjLC56NiOwwb5BJ2DLiG3rknMR3rrcYrPuHI24NVL+M=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  json = {
    version = "0.24.8";
    url = "github:tree-sitter/tree-sitter-json";
    hash = "sha256-DNZC2cTy1C8OaMOpEHM6NoRtOIbLaBf0CLXXWCKODlw=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  json5 = {
    version = "0.1.0";
    url = "github:joakker/tree-sitter-json5";
    hash = "sha256-QfzqRUe9Ji/QXBHHOJHuftIJKOONtmS1ml391QDKfTI=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  jsonnet = {
    version = "0-unstable-2024-08-15";
    url = "github:sourcegraph/tree-sitter-jsonnet/ddd075f1939aed8147b7aa67f042eda3fce22790";
    hash = "sha256-ODGRkirfUG8DqV6ZcGRjKeCyEtsU0r+ICK0kCG6Xza0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  julia = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-julia";
    hash = "sha256-jwtMgHYSa9/kcsqyEUBrxC+U955zFZHVQ4N4iogiIHY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  just = {
    version = "0-unstable-2025-01-05";
    url = "github:IndianBoy42/tree-sitter-just/bb0c898a80644de438e6efe5d88d30bf092935cd";
    hash = "sha256-FwEuH/2R745jsuFaVGNeUTv65xW+MPjbcakRNcAWfZU=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  kdl = {
    version = "1.1.0";
    url = "github:tree-sitter-grammars/tree-sitter-kdl";
    hash = "sha256-+oJqfbBDbrNS7E+x/QCX9m6FVf0NLw4qWH9n54joJYA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  koka = {
    version = "0-unstable-2025-07-26";
    url = "github:mtoohey31/tree-sitter-koka/6dce132911ac375ac1a3591c868c47a2a84b30aa";
    hash = "sha256-QXKfXg1qs3HNvjk1J8Kzm6uwR0frXXEONlJQPCqioNA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  kotlin = rec {
    version = "0.3.8";
    url = "github:fwcd/tree-sitter-kotlin?ref=${version}";
    hash = "sha256-kze1kF8naH2qQou58MKMhzmMXk0ouzcP6i3F61kOYi8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  latex = {
    version = "0.6.0";
    url = "github:latex-lsp/tree-sitter-latex";
    hash = "sha256-nb1pOSHawLIw7/gaepuq2EN0a/F7/un4Xt5VCnDzvWs=";
    generate = true;
    meta = {
      license = lib.licenses.mit;
    };
  };

  ledger = {
    version = "0-unstable-2025-05-04";
    url = "github:cbarrete/tree-sitter-ledger/96c92d4908a836bf8f661166721c98439f8afb80";
    hash = "sha256-L2xUTItnQ/bcieasItrozjAEJLm/fsUUyMex2juCnjw=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  llvm = {
    version = "0-unstable-2024-10-07";
    url = "github:benwilliamgraham/tree-sitter-llvm/c14cb839003348692158b845db9edda201374548";
    hash = "sha256-L3XwPhvwIR/mUbugMbaHS9dXyhO7bApv/gdlxQ+2Bbo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  lua = {
    version = "0.0.19-unstable-2025-05-16";
    url = "github:MunifTanjim/tree-sitter-lua/4fbec840c34149b7d5fe10097c93a320ee4af053";
    hash = "sha256-fO8XqlauYiPR0KaFzlAzvkrYXgEsiSzlB3xYzUpcbrs=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  make = {
    version = "0-unstable-2021-12-16";
    url = "github:alemuller/tree-sitter-make/a4b9187417d6be349ee5fd4b6e77b4172c6827dd";
    hash = "sha256-qQqapnKKH5X8rkxbZG5PjnyxvnpyZHpFVi/CLkIn/x0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  markdown = {
    version = "0.5.2";
    url = "github:tree-sitter-grammars/tree-sitter-markdown";
    hash = "sha256-JJCFksPDwaiOmU+nZ3PHeLHlPKWTZBTnqcD/tQorWdU=";
    location = "tree-sitter-markdown";
    meta = {
      license = lib.licenses.mit;
    };
  };

  markdown-inline = {
    language = "markdown_inline";
    version = "0.5.2";
    url = "github:tree-sitter-grammars/tree-sitter-markdown";
    hash = "sha256-JJCFksPDwaiOmU+nZ3PHeLHlPKWTZBTnqcD/tQorWdU=";
    location = "tree-sitter-markdown-inline";
    meta = {
      license = lib.licenses.mit;
    };
  };

  netlinx = {
    version = "1.0.4";
    url = "github:norgate-av/tree-sitter-netlinx";
    hash = "sha256-WCzt5cglAQ9/1VRP/TJ0EjeLXrF9erIGMButRV7iAic=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  nickel = {
    version = "0.5.0";
    url = "github:nickel-lang/tree-sitter-nickel";
    hash = "sha256-2la/9XxL2dN+rzTotgDXQFz9ktDXQ3Og9svX5Din2zo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  nix = {
    version = "0.3.0-unstable-2025-12-03";
    url = "github:nix-community/tree-sitter-nix/eabf96807ea4ab6d6c7f09b671a88cd483542840";
    hash = "sha256-cSiBd0XkSR8l1CF2vkThWUtMxqATwuxCNO5oy2kyOZY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  norg-meta = {
    version = "0.1.0";
    url = "github:nvim-neorg/tree-sitter-norg-meta";
    hash = "sha256-8qSdwHlfnjFuQF4zNdLtU2/tzDRhDZbo9K54Xxgn5+8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  norg = {
    version = "0.2.6";
    url = "github:nvim-neorg/tree-sitter-norg";
    hash = "sha256-z3h5qMuNKnpQgV62xZ02F5vWEq4VEnm5lxwEnIFu+Rw=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  nu = {
    version = "0-unstable-2025-12-13";
    url = "github:nushell/tree-sitter-nu/4c149627cc592560f77ead1c384e27ec85926407";
    hash = "sha256-h02kb3VxSK/fxQENtj2yaRmAQ5I8rt5s5R8VrWOQWeo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  ocaml = {
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-ocaml";
    hash = "sha256-e08lrKCyQRpb8pnLV6KK4ye53YBjxQ52nnDIzH+7ONc=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  ocaml-interface = {
    language = "ocaml_interface";
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-ocaml";
    hash = "sha256-e08lrKCyQRpb8pnLV6KK4ye53YBjxQ52nnDIzH+7ONc=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  org-nvim = {
    version = "0-unstable-2023-06-19";
    url = "github:emiasims/tree-sitter-org/64cfbc213f5a83da17632c95382a5a0a2f3357c1";
    hash = "sha256-/03eZBbv23W5s/GbDgPgaJV5TyK+/lrWUVeINRS5wtA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  perl = {
    version = "1.1.1";
    url = "github:ganezdragon/tree-sitter-perl";
    hash = "sha256-1RnL1dFbTWalqIYg8oGNzwvZxOFPPKwj86Rc3ErfYMU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  pgn = {
    version = "1.4.3";
    url = "github:rolandwalker/tree-sitter-pgn";
    hash = "sha256-7N0irNJt/tiKywUSZAIVt/E1urNXDMG+hYvu+EPpfXA=";
    meta = {
      license = lib.licenses.bsd2;
    };
  };

  php = {
    version = "0.24.2";
    url = "github:tree-sitter/tree-sitter-php";
    hash = "sha256-jI7yzcoHS/tNxUqJI4aD1rdEZV3jMn1GZD0J+81Dyf0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  phpdoc = {
    version = "0.1.8";
    url = "github:claytonrcarter/tree-sitter-phpdoc";
    hash = "sha256-X+ElKI0ZMLCmxEanKsDRL/1KzGZfBrG7zITsT+jSrtQ=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        Stebalien
      ];
    };
  };

  pioasm = {
    version = "0-unstable-2024-10-12";
    url = "github:leo60228/tree-sitter-pioasm/afece58efdb30440bddd151ef1347fa8d6f744a9";
    hash = "sha256-rUuolF/jPJGiqunD6SLUJ0x/MTIJ+mJ1QSBCasUw5T8=";
    meta = {
      license = lib.licenses.isc;
    };
  };

  prisma = {
    version = "1.6.0";
    url = "github:victorhqc/tree-sitter-prisma";
    hash = "sha256-VE9HUG0z6oPVlA8no011vwYI2HxufJEuXXnCGbCgI4Q=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  proto = {
    version = "0-unstable-2021-06-12";
    url = "github:mitchellh/tree-sitter-proto/42d82fa18f8afe59b5fc0b16c207ee4f84cb185f";
    hash = "sha256-cX+0YARIa9i8UymPPviyoj+Wh37AFYl9fsoNZMQXPgA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  pug = {
    version = "0-unstable-2024-11-17";
    url = "github:zealot128/tree-sitter-pug/13e9195370172c86a8b88184cc358b23b677cc46";
    hash = "sha256-Yk1oBv9Flz+QX5tyFZwx0y67I5qgbnLhwYuAvLi9eV8=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  python = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-python";
    hash = "sha256-F5XH21PjPpbwYylgKdwD3MZ5o0amDt4xf/e5UikPcxY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  ql-dbscheme = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ql-dbscheme";
    hash = "sha256-lXHm+I3zzCUOR/HjnhQM3Ga+yZr2F2WN28SmpT9Q6nE=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  ql = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ql";
    hash = "sha256-mJ/bj09mT1WTaiKoXiRXDM7dkenf5hv2ArXieeTVe6I=";
    meta = {
      license = lib.licenses.mit;
    };
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
    meta = {
      license = lib.licenses.asl20;
    };
  };

  r = {
    version = "1.2.0";
    url = "github:r-lib/tree-sitter-r";
    hash = "sha256-SkCLFIUvJWTtg4m5NMfHbBKald470Kni2mhj2Oxc5ZU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  razor = {
    version = "0-unstable-2025-02-17";
    url = "github:tris203/tree-sitter-razor/fe46ce5ea7d844e53d59bc96f2175d33691c61c5";
    hash = "sha256-E4fgy588g6IP258TS2DvoILc1Aikvpfbtq20VIhBE4U=";
    meta = {
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [
        tris203
      ];
    };
  };

  regex = {
    version = "0.25.0";
    url = "github:tree-sitter/tree-sitter-regex";
    hash = "sha256-bR0K6SR19QuQwDUic+CJ69VQTSGqry5a5IOpPTVJFlo=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  rego = {
    version = "0-unstable-2024-06-12";
    url = "github:FallenAngel97/tree-sitter-rego/20b5a5958c837bc9f74b231022a68a594a313f6d";
    hash = "sha256-XwlVsOlxYzB0x+T05iuIp7nFAoQkMByKiHXZ0t5QsjI=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  river = {
    version = "0-unstable-2023-11-22";
    url = "github:grafana/tree-sitter-river/eafcdc5147f985fea120feb670f1df7babb2f79e";
    hash = "sha256-fhuIO++hLr5DqqwgFXgg8QGmcheTpYaYLMo7117rjyk=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  rst = {
    version = "0.2.0";
    url = "github:stsewd/tree-sitter-rst";
    hash = "sha256-EYUn60fU2hMizL+4PITtzJFJKdBktoPjMsYJ1R70LdM=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  ruby = {
    version = "0.23.1";
    url = "github:tree-sitter/tree-sitter-ruby";
    hash = "sha256-iu3MVJl0Qr/Ba+aOttmEzMiVY6EouGi5wGOx5ofROzA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  rust = {
    version = "0.24.0";
    url = "github:tree-sitter/tree-sitter-rust";
    hash = "sha256-y3sJURlSTM7LRRN5WGIAeslsdRZU522Tfcu6dnXH/XQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  scala = {
    version = "0.24.0";
    url = "github:tree-sitter/tree-sitter-scala";
    hash = "sha256-ZE+zjpb52hvehJjNchJYK81XZbGAudeTRxlczuoix5g=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  scheme = {
    version = "0.24.7-1-unstable-2025-12-13";
    url = "github:6cdh/tree-sitter-scheme/b5c701148501fa056302827442b5b4956f1edc03";
    hash = "sha256-SLuK8S03pKVVhxJTkE3ZJvNaNnmXD323YwE7ah2VxyQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  scss = {
    version = "1.0.0";
    url = "github:serenadeai/tree-sitter-scss";
    hash = "sha256-BFtMT6eccBWUyq6b8UXRAbB1R1XD3CrrFf1DM3aUI5c=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  slint = {
    version = "0-unstable-2025-12-09";
    url = "github:slint-ui/tree-sitter-slint/10fb0f188d7950400773c06ba6c31075866e14bf";
    hash = "sha256-60DfIx7aQqe0/ocxbpr00eU3IPs23E8TUILcVGrBYVs=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  smithy = {
    version = "0.2.0";
    url = "github:indoorvivants/tree-sitter-smithy";
    hash = "sha256-3cqT6+e0uqAtd92M55qSbza1eph8gklGlEGyO9R170w=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  sml = {
    version = "0.23.0";
    url = "github:MatthewFluet/tree-sitter-sml";
    hash = "sha256-hqsyHFcSmvyR50TKtOcidwABW+P31qisgSOtWTWM0tE=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  solidity = {
    version = "1.2.13";
    url = "github:JoranHonig/tree-sitter-solidity";
    hash = "sha256-b+DHy7BkkMg88kLhirtCzjF3dHlCFkXea65aGC18fW0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  sparql = {
    version = "0-unstable-2024-06-26";
    url = "github:GordianDziwis/tree-sitter-sparql/d853661ca680d8ff7f8d800182d5782b61d0dd58";
    hash = "sha256-0BV0y8IyeIPpuxTixlJL1PsDCuhXbGaImu8JU8WFoPU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  sql = {
    version = "0.3.11";
    url = "github:derekstride/tree-sitter-sql";
    hash = "sha256-efeDAUgCwV9UBXbLyZ1a4Rwcvr/+wke8IzkxRUQnddM=";
    generate = true;
    meta = {
      license = lib.licenses.mit;
    };
  };

  supercollider = {
    version = "0.3.2";
    url = "github:madskjeldgaard/tree-sitter-supercollider";
    hash = "sha256-drn1S4gNm6fOSUTCa/CrAqCWoUn16y1hpaZBCPpyaNE=";
    meta = {
      license = lib.licenses.isc;
    };
  };

  surface = {
    version = "0.2.0";
    url = "github:connorlay/tree-sitter-surface";
    hash = "sha256-Hur6lae+9nk8pWL531K52fEsCAv14X5gmYKD9UULW4g=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  svelte = {
    version = "0.11.0";
    url = "github:Himujjal/tree-sitter-svelte";
    hash = "sha256-novNVlLVHYIfjmC7W+F/1F0RxW6dd27/DwQ3n5UO6c4=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  talon = rec {
    version = "5.0.0";
    url = "github:wenkokke/tree-sitter-talon?ref=${version}";
    hash = "sha256-NfPwnySeztMx3qzDbA4HE5WNVd6aImioZkvWi1lXh88=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  templ = {
    version = "1.0.0-unstable-2025-12-03";
    url = "github:vrischmann/tree-sitter-templ/3057cd485f7f23a8ad24107c6adc604f8c5ce3db";
    hash = "sha256-iv5Egh0CcBEsD86IGESI5Bn0NcGji3wruD8UR1JNlk0=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  tera = {
    version = "0.1.0";
    url = "github:uncenter/tree-sitter-tera";
    hash = "sha256-1Gb947YJnEFrCVKAuz06kwJdKD9PMab/alFJtyYjBso=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  tiger = {
    version = "0.3.0-unstable-2025-03-13";
    url = "github:ambroisie/tree-sitter-tiger/4a77b2d7a004587646bddc4e854779044b6db459";
    hash = "sha256-jLdJ3nLShoBxVCcUbnaswYG5d4UU8aaE1xexb2LnmTQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  tlaplus = rec {
    # FIXME: remove language override after release is available that includes
    # https://github.com/tlaplus-community/tree-sitter-tlaplus/pull/138
    language = "@tlaplus/tlaplus";
    version = "1.5.0";
    url = "github:tlaplus-community/tree-sitter-tlaplus?ref=${version}";
    hash = "sha256-k34gkAd0ueXEAww/Hc1mtBfn0Kp1pIBQtjDZ9GQeB4Q=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  todotxt = {
    version = "0-unstable-2024-01-15";
    url = "github:arnarg/tree-sitter-todotxt/3937c5cd105ec4127448651a21aef45f52d19609";
    hash = "sha256-OeAh51rcFTiexAraRzIZUR/A8h9RPwKY7rmtc3ZzoRQ=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  toml = {
    version = "0.5.1-unstable-2022-04-21";
    url = "github:tree-sitter/tree-sitter-toml/342d9be207c2dba869b9967124c679b5e6fd0ebe";
    hash = "sha256-V2c7K16g8PikE9eNgrM6iUDiu4kzBvHMFQwfkph+8QI=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  tsq = {
    version = "0.19.0-unstable-2024-02-24";
    url = "github:tree-sitter/tree-sitter-tsq/49da6de661be6a07cb51018880ebe680324e7b82";
    hash = "sha256-md4xynJx9F/l6N+JZYU8CLXmz50fV13L8xGJVUqk6do=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  tsx = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-typescript";
    hash = "sha256-CU55+YoFJb6zWbJnbd38B7iEGkhukSVpBN7sli6GkGY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  turtle = {
    version = "0-unstable-2024-07-02";
    url = "github:GordianDziwis/tree-sitter-turtle/7f789ea7ef765080f71a298fc96b7c957fa24422";
    hash = "sha256-z6f73euFAG9du5owz7V9WLbWK81Jg0DwxN1metKPbTA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  twig = {
    version = "0.7.0";
    url = "github:kaermorchen/tree-sitter-twig";
    hash = "sha256-JvJeSwdqyGNjWwJpcRiJ1hHVlUge3XX0xr/WBJ/LRhk=";
    meta = {
      license = lib.licenses.mpl20;
    };
  };

  typescript = {
    version = "0.23.2";
    url = "github:tree-sitter/tree-sitter-typescript";
    hash = "sha256-CU55+YoFJb6zWbJnbd38B7iEGkhukSVpBN7sli6GkGY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  typst = {
    version = "0.11.0";
    url = "github:uben0/tree-sitter-typst";
    hash = "sha256-n6RTRMJS3h+g+Wawjb7I9NJbz+w/SGi+DQVj1jiyGaU=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  uiua = {
    version = "0.13.0";
    url = "github:shnarazk/tree-sitter-uiua";
    hash = "sha256-b/uR04wTiLVTgrLr2OuBzZ0LJd35BozFAe2MdBVW0Qk=";
    meta = {
      license = lib.licenses.mpl20;
    };
  };

  verilog = {
    version = "1.0.3";
    url = "github:tree-sitter/tree-sitter-verilog";
    hash = "sha256-SlK33WQhutIeCXAEFpvWbQAwOwMab68WD3LRIqPiaNY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  vim = {
    version = "0-unstable-2023-05-05";
    url = "github:vigoux/tree-sitter-viml/7c317fbade4b40baa7babcd6c9097c157d148e60";
    hash = "sha256-/TyPUBsKRcF9Ig8psqd4so2IMbHtTu4weJXgfd96Vrs=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  vue = {
    version = "0.2.1-unstable-2021-04-04";
    url = "github:ikatyang/tree-sitter-vue/91fe2754796cd8fba5f229505a23fa08f3546c06";
    hash = "sha256-NeuNpMsKZUP5mrLCjJEOSLD6tlJpNO4Z/rFUqZLHE1A=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  wgsl = {
    version = "0-unstable-2023-01-09";
    url = "github:szebniok/tree-sitter-wgsl/40259f3c77ea856841a4e0c4c807705f3e4a2b65";
    hash = "sha256-voLkcJ/062hzipb3Ak/mgQvFbrLUJdnXq1IupzjMJXA=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  wing = {
    version = "0.83.11";
    url = "github:winglang/tree-sitter-wing";
    hash = "sha256-sL1ZoNuNUvTcOUf2I/6cQkeOPj4Jwqmv5zGXETdMByY=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  yaml = {
    version = "0.7.2";
    url = "github:tree-sitter-grammars/tree-sitter-yaml";
    hash = "sha256-BX6TOfAZLW+0h2TNsgsLC9K2lfirraCWlBN2vCKiXQ4=";
    meta = {
      license = lib.licenses.mit;
    };
  };

  yang = {
    version = "0-unstable-2022-11-21";
    url = "github:hubro/tree-sitter-yang/2c0e6be8dd4dcb961c345fa35c309ad4f5bd3502";
    hash = "sha256-6EIK1EStHrUHBLZBsZqd1LL05ZAJ6PKUyIzBBsTVjO8=";
    meta = {
      license = lib.licenses.asl20;
    };
  };

  zig = {
    version = "0-unstable-2024-10-13";
    url = "github:maxxnino/tree-sitter-zig/a80a6e9be81b33b182ce6305ae4ea28e29211bd5";
    hash = "sha256-o3RAbW8kLSfKxuQ/z7WDb5BaDVxZUG5oFutovRkErjk=";
    meta = {
      license = lib.licenses.mit;
    };
  };

}
