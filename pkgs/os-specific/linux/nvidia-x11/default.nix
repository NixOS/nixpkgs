{ callPackage }:

let
  generic = args: callPackage (import ./generic.nix args) { };
in
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "375.39";
    sha256_32bit = "0mlly5n84640xa2mcdqqg44s42ck6g3lj5skf7gmfp2w5ibzccvz";
    sha256_64bit = "19w5v81f770rqjrvdwz11k015zli2y8f4x10ydqxcy0nhhh5mgli";
    settingsSha256 = "0f881q4jzliqzqi1p5lzwz86h829m5g74zdj7nlfi1cc6s45g5p5";
    persistencedSha256 = "0zj6wdcgg2ljhvsssfsqz9wk28ykmsh4gwmis31q3rsrkq668x33";
  };

  beta = generic {
    version = "378.13";
    sha256_32bit = "1ca6kbk20kki5f698x1ga9b1v1is4mr10f7f70s3gixak1h2mrh5";
    sha256_64bit = "1vj2vyy6vim0qis7iqq4la6k6bnby65p3qjbl888qnpjkqj7kqrx";
    settingsSha256 = "08q04cd769l1i6737ylvanaxrqg8fym05kjp7kvpz28764g96gxj";
    persistencedSha256 = "0hmxp5fbxwl9f7c9fspg65my6lwynpqhz02zw7100dgwqb2vn1qj";
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
