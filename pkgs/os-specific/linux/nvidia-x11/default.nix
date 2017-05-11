{ callPackage }:

let
  generic = args: callPackage (import ./generic.nix args) { };
in
{
  # Policy: use the highest stable version as the default (on our master).
  stable = generic {
    version = "375.66";
    sha256_32bit = "0k7ib5ah3c2apzgzxlq75l48zm8901mbwj7slv18k3rhk8j0w8i9";
    sha256_64bit = "1h01s8brpz42jwc24dsflm4psd3zsy26ds98h0adgwx51dbpzqsr";
    settingsSha256 = "0bpdayyqw4cpgl7bgddfz6w5j8y3wsgr89p5vxnzgk9g0vgqxh5h";
    persistencedSha256 = "113rllf9l26z546jjfijpxllp17qcpawblzxvsqc6rbzbkmvcdwi";
  };

  beta = generic {
    version = "378.13";
    sha256_32bit = "1ca6kbk20kki5f698x1ga9b1v1is4mr10f7f70s3gixak1h2mrh5";
    sha256_64bit = "1vj2vyy6vim0qis7iqq4la6k6bnby65p3qjbl888qnpjkqj7kqrx";
    settingsSha256 = "08q04cd769l1i6737ylvanaxrqg8fym05kjp7kvpz28764g96gxj";
    persistencedSha256 = "0hmxp5fbxwl9f7c9fspg65my6lwynpqhz02zw7100dgwqb2vn1qj";
  };

  legacy_340 = generic {
    version = "340.102";
    sha256_32bit = "0a484i37j00d0rc60q0bp6fd2wfrx2c4r32di9w5svqgmrfkvcb1";
    sha256_64bit = "0nnz51d48a5fpnnmlz1znjp937k3nshdq46fw1qm8h00dkrd55ib";
    settingsSha256 = "0nm5c06b09p6wsxpyfaqrzsnal3p1047lk6p4p2a0vksb7id9598";
    persistencedSha256 = "1jwmggbph9zd8fj4syihldp2a5bxff7q1i2l9c55xz8cvk0rx08i";
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
