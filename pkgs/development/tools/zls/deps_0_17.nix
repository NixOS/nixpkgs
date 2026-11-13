{ linkFarm, fetchzip }:

linkFarm "zig-packages" [
  {
    name = "known_folders-0.0.0-Fy-PJiDLAAB98m3uYUzatrTb2mO2fpvwx2zpSroEtfbO";
    path = fetchzip {
      url = "https://github.com/ziglibs/known-folders/archive/6da0d0c41b78b9ed2d34fa364fcb81b5ebece6c4.tar.gz";
      hash = "sha256-F17Ivvsyyla2CBIh+kImc1O3AtD2yTDAGamzMVbVzuw=";
    };
  }
  {
    name = "diffz-0.0.1-G2tlISvOAQDORzPTSxDgiKwlHuADKeJMdJrw4kRfLufj";
    path = fetchzip {
      url = "https://github.com/ziglibs/diffz/archive/aac8aa99c436ab8277b0711922aad062c0167b12.tar.gz";
      hash = "sha256-GQ4iCZSSpVvdDQteoi02keLSqSoDOSQPH8eihum++Z0=";
    };
  }
  {
    name = "lsp_kit-0.1.0-bi_PL9o2DADHS1PDra3MGz1MXnsboN_ewNvrc419z7Fb";
    path = fetchzip {
      url = "https://github.com/zigtools/lsp-kit/archive/3e1058db66079911fdde82f833fdce6856e0a706.tar.gz";
      hash = "sha256-vsTBPP9Rf7xoVyGyi3+j9a03mLqU/gwrdDKIpFTH2v0=";
    };
  }
]
