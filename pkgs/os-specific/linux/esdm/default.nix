{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, protobufc
, pkg-config
, fuse3
, meson
, ninja
, libselinux
, jitterentropy
  # A more detailed explaination of the following meson build options can be found
  # in the source code of esdm.
  # A brief explanation is given:
, selinux ? false # enable selinux support
, drngHashDrbg ? true  # set the default drng callback
, drngChaCha20 ? false # set the default drng callback
, ais2031 ? false # set the seeding strategy to be compliant with AIS 20/31
, linuxDevFiles ? true # enable linux /dev/random and /dev/urandom support
, linuxGetRandom ? true # enable linux getrandom support
, esJitterRng ? true # enable support for the entropy source: jitter rng
, esCPU ? true # enable support for the entropy source: cpu-based entropy
, esKernel ? true # enable support for the entropy source: kernel-based entropy
, esIRQ ? false # enable support for the entropy source: interrupt-based entropy
, esSched ? false # enable support for the entropy source: scheduler-based entropy
, esHwrand ? true # enable support for the entropy source: /dev/hwrng
, hashSha512 ? false # set the conditioning hash: SHA2-512
, hashSha3_512 ? true # set the conditioning hash: SHA3-512
}:

assert drngHashDrbg != drngChaCha20;
assert hashSha512 != hashSha3_512;

stdenv.mkDerivation rec {
  pname = "esdm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "esdm";
    rev = "v${version}";
    sha256 = "sha256-swBKVb5gnND76w2ULT+5hR/jVOqxEe4TAB1gyaLKE9Q=";
  };

  patches = [
    (fetchpatch {
      name = "arm64.patch";
      url = "https://github.com/smuellerDD/esdm/commit/86b93a0ddf684448aba152c8f1b3baf40a6d41c0.patch";
      sha256 = "sha256-gjp13AEsDNj23fcGanAAn2KCbYKA0cphhf4mCxek9Yg=";
    })
  ];

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ protobufc fuse3 jitterentropy ]
    ++ lib.optional selinux libselinux;

  mesonFlags = [
    (lib.mesonBool "b_lto" false)
    (lib.mesonBool "ais2031" ais2031)
    (lib.mesonEnable "linux-devfiles" linuxDevFiles)
    (lib.mesonEnable "linux-getrandom" linuxGetRandom)
    (lib.mesonEnable "es_jent" esJitterRng)
    (lib.mesonEnable "es_cpu" esCPU)
    (lib.mesonEnable "es_kernel" esKernel)
    (lib.mesonEnable "es_irq" esIRQ)
    (lib.mesonEnable "es_sched" esSched)
    (lib.mesonEnable "es_hwrand" esHwrand)
    (lib.mesonEnable "hash_sha512" hashSha512)
    (lib.mesonEnable "hash_sha3_512" hashSha3_512)
    (lib.mesonEnable "selinux" selinux)
    (lib.mesonEnable "drng_hash_drbg" drngHashDrbg)
    (lib.mesonEnable "drng_chacha20" drngChaCha20)
  ];

  doCheck = true;

  strictDeps = true;
  mesonBuildType = "release";

  meta = {
    homepage = "https://www.chronox.de/esdm.html";
    description = "Entropy Source and DRNG Manager in user space";
    license = with lib.licenses; [ gpl2Only bsd3 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ orichter thillux ];
  };
}
