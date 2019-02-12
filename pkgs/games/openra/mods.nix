{ buildOpenRAMod, fetchFromGitHub, abbrevCommit, extraPostFetch }:

let
  unsafeBuildOpenRAMod = attrs: name: (buildOpenRAMod attrs name).overrideAttrs (_: {
    doCheck = false;
  });

in {
  ca = buildOpenRAMod {
    version = "96.git.fc3cf0b";
    title = "Combined Arms";
    description = "A game that combines units from the official OpenRA Red Alert and Tiberian Dawn mods";
    homepage = https://github.com/Inq8/CAmod;
    src = fetchFromGitHub {
      owner = "Inq8";
      repo = "CAmod";
      rev = "fc3cf0baf2b827650eaae9e1d2335a3eed24bac9";
      sha256 = "15w91xs253gyrlzsgid6ixxjazx0fbzick6vlkiay0znb58n883m";
    };
    engine = {
      version = "b8a7dd5";
      src = fetchFromGitHub {
        owner = "Inq8";
        repo = "CAengine" ;
        rev = "b8a7dd52ff893ed8225726d4ed4e14ecad748404";
        sha256 = "0dyk861qagibx8ldshz7d2nrki9q550f6f0wy8pvayvf1gv1dbxj";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  d2 = unsafeBuildOpenRAMod rec {
    version = "134.git.69a4aa7";
    title = "Dune II";
    description = "A modernization of the original ${title} game";
    homepage = https://github.com/OpenRA/d2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "d2";
      rev = "69a4aa708e2c26376469c0048fac13592aa452ca";
      sha256 = "1mfch4s6c05slyqvxllklbxpqq8dqcbx3515n3gyylyq43gq481r";
    };
    engine = rec {
      version = "release-20181215";
      mods = [ "cnc" "d2k" "ra" ];
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0p0izykjnz7pz02g2khp7msqa00jhjsrzk9y0g29dirmdv75qa4r";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/d2/wiki
    '';
  };

  dr = buildOpenRAMod rec {
    version = "266.git.920b476";
    title = "Dark Reign";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/drogoganor/DarkReign;
    src = fetchFromGitHub {
      owner = "drogoganor";
      repo = "DarkReign";
      rev = "920b476be1b7751db087f1f7acd504b8a048d1e2";
      sha256 = "11ir4pnichrnv4z9532fp9g166jl8fvy5kk03a2fgxssp3g40zz2";
    };
    engine = {
      version = "DarkReign";
      src = fetchFromGitHub {
        owner = "drogoganor";
        repo = "OpenRA" ;
        rev = "e08b75c2add30439228ea3dd61d6be60d1800329";
        sha256 = "125vf962p69ajrh5pxgfwsi0ksczqwvlw5kn2fvffiwvh8d5in23";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  gen = buildOpenRAMod {
    version = "1157.git.4f5e11d";
    title = "Generals Alpha";
    description = "Re-imagination of the original Command & Conquer: Generals game";
    homepage = https://github.com/MustaphaTR/Generals-Alpha;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Generals-Alpha";
      rev = "4f5e11d916e4a03d8cf1c97eef484ce2d77d7df2";
      sha256 = "1wnl4qrlhynnlahgdlxwhgsdba5wgdg9yrv9f8hkgi69j60szypd";
    };
    engine = rec {
      version = "gen-20190128_3";
      src = fetchFromGitHub {
        owner = "MustaphaTR";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1x6byz37s8qcpqj902zvkvbv95rv2mv2kj35c12gbpyc92xkqkq0";
        name = "generals-alpha-engine";
        inherit extraPostFetch;
      };
    };
  };

  kknd = let version = "145.git.5530bab"; in name: (buildOpenRAMod rec {
    inherit version;
    title = "Krush, Kill 'n' Destroy";
    description = "Re-imagination of the original ${title} game";
    homepage = https://kknd-game.com/;
    src = fetchFromGitHub {
      owner = "IceReaper";
      repo = "KKnD";
      rev = "5530babcb05170e0959e4cf2b079161e9fedde4f";
      sha256 = "07jczrarmgm6zdk0myzwgq200x19yvpjyxrnhdac08mjgyz75zk1";
    };
    engine = {
      version = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
      src = fetchFromGitHub {
        owner = "IceReaper";
        repo = "OpenRA" ;
        rev = "4e8eab4ca00d1910203c8a103dfd2c002714daa8";
        sha256 = "1yyqparf93x8yzy1f46gsymgkj5jls25v2yc7ighr3f7mi3igdvq";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  } name).overrideAttrs (origAttrs: {
    postPatch = ''
      ${origAttrs.postPatch}
      sed -i 's/{DEV_VERSION}/${version}/' mods/*/mod.yaml
    '';
  });

  mw = buildOpenRAMod rec {
    version = "257.git.c9be8f2";
    title = "Medieval Warfare";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/CombinE88/Medieval-Warfare;
    src = fetchFromGitHub {
      owner = "CombinE88";
      repo = "Medieval-Warfare";
      rev = "c9be8f2a6f1dd710b1aedd9d5b00b4cf5020e2fe";
      sha256 = "09fp7k95jd6hjqdasbspbd43z5670wkyzbbgqkll9dfsrv0sky0v";
    };
    engine = {
      version = "MedievalWarfareEngine";
      src = fetchFromGitHub {
        owner = "CombinE88";
        repo = "OpenRA" ;
        rev = "52109c0910f479753704c46fb19e8afaab353c83";
        sha256 = "0ga3855j6bc7h81q03cw6laiaiz12915zg8aqah1idvxbzicfy7l";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ra2 = buildOpenRAMod rec {
    version = "881.git.b37f4f9";
    title = "Red Alert 2";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/OpenRA/ra2;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "ra2";
      rev = "b37f4f9f07404127062d9061966e9cc89dd86445";
      sha256 = "1jiww66ma3qdk9hzyvhbcaa5h4p2mxxk22kvrw92ckpxy0bqba3h";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the original ${title} game assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  raclassic = buildOpenRAMod {
    version = "181.git.8240890";
    title = "Red Alert Classic";
    description = "A modernization of the original Command & Conquer: Red Alert game";
    homepage = https://github.com/OpenRA/raclassic;
    src = fetchFromGitHub {
      owner = "OpenRA";
      repo = "raclassic";
      rev = "8240890b32191ce34241c22158b8a79e8c380879";
      sha256 = "0dznyb6qa4n3ab87g1c4bihfc2nx53k6z0kajc7ynjdnwzvx69ww";
    };
    engine = rec {
      version = "playtest-20190106";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  rv = unsafeBuildOpenRAMod {
    version = "1330.git.9230e6f";
    title = "Romanov's Vengeance";
    description = "Re-imagination of the original Command & Conquer: Red Alert 2 game";
    homepage = https://github.com/MustaphaTR/Romanovs-Vengeance;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "Romanovs-Vengeance";
      rev = "9230e6f1dd9758467832aee4eda115e18f0e635f";
      sha256 = "0bwbmmlhp1kh8rgk2nx1ca9vqssj849amndacf318d61gksc1w9n";
    };
    engine = {
      version = "f3873ae";
      mods = [ "as" ];
      src = fetchFromGitHub {
        owner = "AttacqueSuperior";
        repo = "Engine";
        rev = "f3873ae242803051285994d77eb26f4b951594b5";
        sha256 = "02rv29wja0p5d083pd087daz7x7pp5b9ym7sci2fhg3mrnaqgwkp";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };

  sp = unsafeBuildOpenRAMod {
    version = "176.git.fc89ae8";
    title = "Shattered Paradise";
    description = "Re-imagination of the original Command & Conquer: Tiberian Sun game";
    homepage = https://github.com/ABrandau/OpenRAModSDK;
    src = fetchFromGitHub {
      owner = "ABrandau";
      repo = "OpenRAModSDK";
      rev = "fc89ae8a10e0f765ac735f923e01aa24dd20e8d2";
      sha256 = "0xyxhipmjlld0kp23fwsdwnspr7fci0mdnjd60gcsh34c7m0341p";
    };
    engine = {
      version = "SP-Bleed-Branch";
      mods = [ "as" "ts" ];
      src = fetchFromGitHub {
        owner = "ABrandau";
        repo = "OpenRA" ;
        rev = "d3545c0b751aea2105748eddaab5919313e35314";
        sha256 = "1jsldl6vnf3r9dzppdm4z7kqbrzkidda5k74wc809i8c4jjnq9rq";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ss = buildOpenRAMod rec {
    version = "77.git.23e1f3e";
    title = "Sole Survivor";
    description = "A re-imagination of the original Command & Conquer: ${title} game";
    homepage = https://github.com/MustaphaTR/sole-survivor;
    src = fetchFromGitHub {
      owner = "MustaphaTR";
      repo = "sole-survivor";
      rev = "23e1f3e5d8b98c936797b6680d95d56a69a9e2ab";
      sha256 = "104clmxphchs7r8y7hpmw103bychayz80bqj98bp89i64nv9d89x";
    };
    engine = {
      version = "6de92de";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = "6de92de8d982094a766eab97a92225c240d85493";
        sha256 = "0ps9x379plrrj1hnj4fpr26lc46mzgxknv5imxi0bmrh5y4781ql";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  ura = buildOpenRAMod {
    version = "431.git.128dc53";
    title = "Red Alert Unplugged";
    description = "Re-imagination of the original Command & Conquer: Red Alert game";
    homepage = http://redalertunplugged.com/;
    src = fetchFromGitHub {
      owner = "RAunplugged";
      repo = "uRA";
      rev = "128dc53741fae923f4af556f2293ceaa0cf571f0";
      sha256 = "1mhr8kyh313z52gdrqv31d6z7jvdldiajalca5mcr8gzg6mph66p";
    };
    engine = rec {
      version = "unplugged-cd82382";
      src = fetchFromGitHub {
        owner = "RAunplugged";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1p5hgxxvxlz8480vj0qkmnxjh7zj3hahk312m0zljxfdb40652w1";
        name = "engine";
        inherit extraPostFetch;
      };
    };
  };

  yr = unsafeBuildOpenRAMod rec {
    version = "118.git.c26bf14";
    homepage = https://github.com/cookgreen/yr;
    title = "Yuri's Revenge";
    description = "Re-imagination of the original Command & Conquer: ${title} game";
    src = fetchFromGitHub {
      owner = "cookgreen";
      repo = "yr";
      rev = "c26bf14155d040edf33c6c5eb3677517d07b39f8";
      sha256 = "15k6gv4rx3490n0cs9q7ah7q31z89v0pddsw6nqv0fhcahhvq1bc";
    };
    engine = rec {
      version = "release-20180923";
      src = fetchFromGitHub {
        owner = "OpenRA";
        repo = "OpenRA" ;
        rev = version;
        sha256 = "1pgi3zaq9fwwdq6yh19bwxscslqgabjxkvl9bcn1a5agy4bfbqk5";
        name = "engine";
        inherit extraPostFetch;
      };
    };
    assetsError = ''
      The mod expects the Command & Conquer: The Ultimate Collection assets in place:
      https://github.com/OpenRA/ra2/wiki
    '';
  };
}
