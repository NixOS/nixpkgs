{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix args {
  version = "1.20.2";
  sha256 = "0hjsyjzd35qyw49w210f67g678kvzinw4kg1acb0l6c2fxspd24m";
  extraPatches = [
    (fetchpatch {
      name = "CVE-2021-3618.patch";
      url = "https://github.com/nginx/nginx/commit/173f16f736c10eae46cd15dd861b04b82d91a37a.patch";
      sha256 = "0cnxmbkp6ip61w7y1ihhnvziiwzz3p3wi2vpi5c7yaj5m964k5db";
    })
  ];
}
