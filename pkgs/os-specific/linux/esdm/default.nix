{ lib
, stdenv
, fetchFromGitHub
, protobufc
, pkg-config
, fuse3
, meson
, ninja
, libselinux
, jitterentropy
, botan3
, openssl
, libkcapi

# A more detailed explaination of the following meson build options can be found
# in the source code of esdm.
# A brief explanation is given.

# general options
, selinux ? false # enable selinux support
, drngHashDrbg ? true  # set the default drng callback
, drngChaCha20 ? false # set the default drng callback
, ais2031 ? false # set the seeding strategy to be compliant with AIS 20/31
, sp80090c ? false # set compliance with NIST SP800-90C
, cryptoBackend ? "botan" # set backend for hash and drbg operations
, linuxDevFiles ? true # enable linux /dev/random and /dev/urandom support
, linuxGetRandom ? true # enable linux getrandom support
, hashSha512 ? false # set the conditioning hash: SHA2-512
, hashSha3_512 ? true # set the conditioning hash: SHA3-512
, openSSLRandProvider ? true # build ESDM provider for OpenSSL 3.x
, botanRng ? true # build ESDM class for Botan 3.x

# client-related options (handle with care, consult source code and meson options)
# leave as is if in doubt
, connectTimeoutExponent ? 28 # (1 << EXPONENT nanoseconds)
, rxTxTimeoutExponent ? 28 # (1 << EXPONENT nanoseconds)
, reconnectAttempts ? 10 # how often to attempt unix socket connection before giving up

# entropy sources
, esJitterRng ? true # enable support for the entropy source: jitter rng (running in user space)
, esJitterRngEntropyRate ? 256 # amount of entropy to account for jitter rng source
, esJitterRngKernel ? true # enable support for the entropy source: jitter rng (running in kernel space)
, esJitterRngKernelEntropyRate ? 256 # amount of entropy to account for kernel jitter rng source
, esCPU ? true # enable support for the entropy source: cpu-based entropy
, esCPUEntropyRate ? 8 # amount of entropy to account for cpu rng source
, esKernel ? true # enable support for the entropy source: kernel-based entropy
, esKernelEntropyRate ? 128 # amount of entropy to account for kernel-based source
, esIRQ ? false # enable support for the entropy source: interrupt-based entropy
, esIRQEntropyRate ? 256 # amount of entropy to account for interrupt-based source (only set irq XOR sched != 0)
, esSched ? false # enable support for the entropy source: scheduler-based entropy
, esSchedEntropyRate ? 0 # amount of entropy to account for interrupt-based source (only set irq XOR sched != 0)
, esHwrand ? true # enable support for the entropy source: /dev/hwrng
, esHwrandEntropyRate ? 128 # amount of entropy to account for /dev/hwrng-based sources
}:

assert drngHashDrbg != drngChaCha20;
assert hashSha512 != hashSha3_512;
assert cryptoBackend == "openssl" || cryptoBackend == "botan" || cryptoBackend == "builtin" "Unsupported ESDM crypto backend";

stdenv.mkDerivation rec {
  pname = "esdm";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "smuellerDD";
    repo = "esdm";
    rev = "v${version}";
    sha256 = "sha256-UH6ws/hfHdcmbLETyZ0b4wDm8nHPdLsot3ZhIljpUlw=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ protobufc ]
    ++ lib.optional (cryptoBackend == "botan" || botanRng) botan3
    ++ lib.optional (cryptoBackend == "openssl" || openSSLRandProvider) openssl
    ++ lib.optional selinux libselinux
    ++ lib.optional esJitterRng jitterentropy
    ++ lib.optional linuxDevFiles fuse3
    ++ lib.optional esJitterRngKernel libkcapi;

  mesonFlags = [
    (lib.mesonBool "b_lto" false)
    (lib.mesonBool "fips140" false)
    (lib.mesonBool "ais2031" ais2031)
    (lib.mesonBool "sp80090c" sp80090c)
    (lib.mesonEnable "node" true) # multiple DRNGs
    (lib.mesonOption "threading_max_threads" (toString 64))
    (lib.mesonOption "crypto_backend" cryptoBackend)
    (lib.mesonEnable "linux-devfiles" linuxDevFiles)
    (lib.mesonEnable "linux-getrandom" linuxGetRandom)
    (lib.mesonOption "client-connect-timeout-exponent" (toString connectTimeoutExponent))
    (lib.mesonOption "client-rx-tx-timeout-exponent" (toString rxTxTimeoutExponent))
    (lib.mesonOption "client-reconnect-attempts" (toString reconnectAttempts))
    (lib.mesonEnable "es_jent" esJitterRng)
    (lib.mesonOption "es_jent_entropy_rate" (toString esJitterRngEntropyRate))
    (lib.mesonEnable "es_jent_kernel" esJitterRngKernel)
    (lib.mesonOption "es_jent_kernel_entropy_rate" (toString esJitterRngKernelEntropyRate))
    (lib.mesonEnable "es_cpu" esCPU)
    (lib.mesonOption "es_cpu_entropy_rate" (toString esCPUEntropyRate))
    (lib.mesonEnable "es_kernel" esKernel)
    (lib.mesonOption "es_kernel_entropy_rate" (toString esKernelEntropyRate))
    (lib.mesonEnable "es_irq" esIRQ)
    (lib.mesonOption "es_irq_entropy_rate" (toString esIRQEntropyRate))
    (lib.mesonEnable "es_sched" esSched)
    (lib.mesonOption "es_sched_entropy_rate" (toString esSchedEntropyRate))
    (lib.mesonEnable "es_hwrand" esHwrand)
    (lib.mesonOption "es_hwrand_entropy_rate" (toString esHwrandEntropyRate))
    (lib.mesonEnable "hash_sha512" hashSha512)
    (lib.mesonEnable "hash_sha3_512" hashSha3_512)
    (lib.mesonEnable "selinux" selinux)
    (lib.mesonEnable "drng_hash_drbg" drngHashDrbg)
    (lib.mesonEnable "drng_chacha20" drngChaCha20)
    (lib.mesonEnable "openssl-rand-provider" openSSLRandProvider)
    (lib.mesonEnable "botan-rng" botanRng)
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
