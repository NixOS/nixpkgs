{ callPackage, openssl, python3, fetchpatch, enableNpm ? true }:

let
  buildNodejs = callPackage ./nodejs.nix {
    inherit openssl;
    python = python3;
  };
in
  buildNodejs {
    inherit enableNpm;
    version = "16.5.0";
    sha256 = "16dapj5pm2y1m3ldrjjlz8rq9axk85nn316iz02nk6qjs66y6drz";
    patches = [
      # Fix CVE-2021-22930 https://github.com/nodejs/node/pull/39423.
      # It should be fixed by Node.js 16.6.0, but currently it fails to build on Darwin
      (fetchpatch {
        url = "https://github.com/nodejs/node/commit/9d950a0956bf2c3dd87bacb56807f37e16a91db4.patch";
        sha256 = "1narhk5dqdkbndh9hg0dn5ghhgrd6gsamjqszpivmp33nl5hgsx3";
      }), 
      # Brings Node version to 16.6.1 which may or may not be needed for Discord.js v13
      # (Originally was, now isn't? Confusing, but should still be updated regardless)       
      (fetchpatch {
        url = "https://github.com/nodejs/node/commit/3d53ff8ff0e721f908d8aff7a3709bc6dbb07ebb.patch";
        sha256 = "0mz5wfhf2k1qf3d57h4r8b30izhyg93g5m9c8rljlzy6ih2ymcbr";
      })
    ];
  }
