{ lib
, pkgs
, fetchurl
, stdenv
}:

let

  mkWordpressPlugin = a@{
    pluginName,
    namePrefix ? "wordpressplugin-",
    src,
    unpackPhase ? "",
    configurePhase ? ":",
    buildPhase ? ":",
    addonInfo ? null,
    preInstall ? "",
    postInstall ? "",
    path ? lib.getName pluginName,
    ...
  }:
    stdenv.mkDerivation (a // {
      pname = namePrefix + pluginName;

      inherit pluginName unpackPhase configurePhase buildPhase addonInfo preInstall postInstall;

      installPhase = "mkdir -p $out; cp -R * $out/";
    });

in rec {
  inherit mkWordpressPlugin;

  anti-spam-bee = mkWordpressPlugin {
    pluginName = "anti-spam-bee";
    version = "2.9.4";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/antispam-bee.2.9.4.zip";
      sha256 = "00d2z2z9g08wx8510yd81b6axxhv5cfllrkdvsd6ysa649172ny9";
    };
    buildInputs = [ pkgs.unzip ];
  };

  code-syntax-block = mkWordpressPlugin {
    pluginName = "code-syntax-block";
    version = "2.0.3";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/code-syntax-block.2.0.3.zip";
      sha256 = "1mmwyw8mc9nfh6qil1zji25ghrrhi5z1m8bvk76w6z8xs79q9jmr";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  lightbox-with-photoswipe = mkWordpressPlugin {
    pluginName = "lightbox-with-photoswipe";
    version = "3.1.12";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/lightbox-photoswipe.3.1.12.zip";
      sha256 = "0gzr5cmzrn7ydgi0l7xdmhg2ms2fyhz8j02dccxc3kgd61j9lmzw";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wp-gdpr-compliance = mkWordpressPlugin {
    pluginName = "wp-gdpr-compliance";
    version = "1.5.6";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/wp-gdpr-compliance.1.5.6.zip";
      sha256 = "1n7wphnc9kj75xigp3rhkw779lv586ni1cnd6g0slyjc1x7s975g";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  co-authors-plus = mkWordpressPlugin {
    pluginName = "co-authors-plus";
    version = "3.4.5";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/co-authors-plus.3.4.5.zip";
      sha256 = "18zzkmpl8m0y4f5ab3vjwn5jx8nla66g89r2lc02gc4mks47j04w";
    };
    buildInputs = [ pkgs.unzip pkgs.php ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wp-statistics = mkWordpressPlugin {
    pluginName = "wp-statistics";
    version = "13.0.8";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/wp-statistics.13.0.8.zip";
      sha256 = "16325x9n9rgkl6nii84vbcvjsrza1dlzrf1n4p3nihfanpd6dgrg";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wp-user-avatar = mkWordpressPlugin {
    pluginName = "wp-user-avatar";
    version = "1.4.0";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/wp-user-avatars.zip";
      sha256 = "1a1iliq8p20qnn5jq8qyz07cw03kiyggjvd8457dmlf5vhbljp0l";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  opengraph = mkWordpressPlugin {
    pluginName = "opengraph";
    version = "1.10.0";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/opengraph.1.10.0.zip";
      sha256 = "0b9scyppj0l4m416d3sm2pbfz0zlpglrbqpffdk2qvljqdlma8nv";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  simple-login-captcha = mkWordpressPlugin {
    pluginName = "simple-login-captcha";
    version = "1.3.3";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/simple-login-captcha.1.3.3.zip";
      sha256 = "0p2df3h9knfhxfaz4z5b8samq3s9v4pn7ivclldcwwvg9kcmfhmw";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  disable-xml-rpc = mkWordpressPlugin {
    pluginName = "disable-xml-rpc";
    version = "1.0.1";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/disable-xml-rpc.1.0.1.zip";
      sha256 = "1q99yjikc0agpbrm5wrcc0kzrczwfq82w2nvrj13g2b8cix3yaya";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  async-javascript = mkWordpressPlugin {
    pluginName = "async-javascript";
    version = "2.20.12.09";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/async-javascript.2.20.12.09.zip";
      sha256 = "0vgcxs5cmifq931lsla04maif9gvs54139wd55azbraxrh0fxr8f";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  webp-converter-for-media = mkWordpressPlugin {
    pluginName = "webp-converter-for-media";
    version = "3.0.1";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/webp-converter-for-media.zip";
      sha256 = "1rf2h3gpyfdqh43qippplqrflkh50hdypssig1xnvjwga86abwc8";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  breeze = mkWordpressPlugin {
    pluginName = "breeze";
    version = "1.2.0";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/breeze.1.2.0.zip";
      sha256 = "0zjc32fzvqkflva3h0ghz0qwajfza0dzc2hnd1yb02hf4qbyv8vz";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  jetpack = mkWordpressPlugin {
    pluginName = "jetpack";
    version = "9.7";
    src = fetchurl {
      url = "https://downloads.wordpress.org/plugin/jetpack.9.7.zip";
      sha256 = "16sbbk26fc40yngmifs78dqdcsblpfyjj02b9c88ymf2yc0fslxv";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

}

