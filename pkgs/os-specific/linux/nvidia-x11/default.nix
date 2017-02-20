{ callPackage }:

let
  generic = args: callPackage (import ./generic.nix args) { };
in
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "375.26";
    sha256_32bit = "0yv19rkz2wzzj0fygfjb1mh21iy769kff3yg2kzk8bsiwnmcyybw";
    sha256_64bit = "1kqy9ayja3g5znj2hzx8pklz8qi0b0l9da7c3ldg3hlxf31v4hjg";
    settingsSha256 = "1s8zf5cfhx8m05fvws0gh1q0wy5zyyg2j510zlwp4hk35y7dic5y";
    persistencedSha256 = "15r6rbzyk4yaqkpkqs8j00zc7jbhgp8naskv93dwjyw0lnj0wgky";
  };

  beta = generic {
    version = "378.09";
    sha256_32bit = "0a1vwvsqi89pn29c9aii53xq8292dxf68sr8lxzx4bpqjqmsbapy";
    sha256_64bit = "018qqg9zlpwd2cad99vbn18rnrrkrqybs7q65h8dmxirkx4pcvh8";
    settingsSha256 = "1fjkpqmzdzk46p1chzxqvbj3cpqcwwx4qmv33yjq7z2a5zab9z8v";
    persistencedSha256 = "1svaa5a0zz0r8qy6pg9lnhy5zmffvw0h120h46qqd01pkb4yv5lc";
  };

  legacy_340 = generic {
    version = "340.101";
    sha256_32bit = "0qmhkvxj6h63sayys9gldpafw5skpv8nsm2gxxb3pxcv7nfdlpjz";
    sha256_64bit = "02k8j0xzxp2y4vay0kf982q382ny1i4g1kai93f2h5sak6sq3kyj";
    settingsSha256 = "1mavbhff24n0jn154af152fp04njd505scdlxdm850h1ycb2i3g9";
    persistencedSha256 = "1396bmmg9b1z805dzljgi2f219ji84wfnnifdbk32dpd5mrywjk0";
    useGLVND = false;
  };

  legacy_304 = generic {
    version = "304.134";
    sha256_32bit = "178wx0a2pmdnaypa9pq6jh0ii0i8ykz1sh1liad9zfriy4d8kxw4";
    sha256_64bit = "0pydw7nr4d2dply38kwvjbghsbilbp2q0mas4nfq5ad050d2c550";
    settingsSha256 = "0q92xw4fr9p5nbhj1plynm50d32881861daxfwrisywszqijhmlf";
    persistencedSha256 = null;
    useGLVND = false;
    useProfiles = false;
  };

  legacy_173 = callPackage ./legacy173.nix { };
}
