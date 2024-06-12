{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
    fetchURL = import <nix/fetchurl.nix>;
    trivialBuilder = (import ./trivial-builder.nix);
    make = trivialBuilder rec {
      inherit (localSystem) system;
      name = "make";
      ver = "4.3";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.gz";
      sha256 = "06cfqzpqsvdnsxbysl5p2fgdgxgl9y4p7scpnrfa8z2zgkjdspz0";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                      ];
    };
    bash = trivialBuilder rec {
      inherit (localSystem) system;
      name = "bash";
      ver = "4.4.18";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.gz";
      sha256 = "08vz660768mnnax7n8d4d85jxafwdmsxsi7fh0hzvmafbvn9wkb0";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                      ];
    };
    coreutils = trivialBuilder rec {
      inherit (localSystem) system;
      name = "coreutils";
      ver = "8.31";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "1zg9m79x1i2nifj4kb0waf9x3i5h6ydkypkjnbsb9rnwis8rqypz";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                        "--without-gmp"
                        "--without-libpth-prefix"
                      ];
    };
    findutils = trivialBuilder rec {
      inherit (localSystem) system;
      name = "findutils";
      ver = "4.7.0";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "16kqz9yz98dasmj70jwf5py7jk558w96w0vgp3zf9xsqk3gzpzn5";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                        "--without-gmp"
                        "--without-libpth-prefix"
                      ];
    };
    diffutils = trivialBuilder rec {
      inherit (localSystem) system;
      name = "diffutils";
      ver = "3.7";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "09isrg0isjinv8c535nxsi1s86wfdfzml80dbw41dj9x3hiad9xk";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                        "--without-libsigsegv-prefix"
                      ];
    };
    grep = trivialBuilder rec {
      inherit (localSystem) system;
      name = "grep";
      ver = "3.4";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "1yy33kiwrxrwj2nxa4fg15bvmwyghqbs8qwkdvy5phm784f7brjq";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                        "--disable-perl-regexp"
                        "--without-libsegsegv-prefix"
                      ];
    };
    patch = trivialBuilder rec {
      inherit (localSystem) system;
      name = "patch";
      ver = "2.7.6";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "1zfqy4rdcy279vwn2z1kbv19dcfw25d2aqy9nzvdkq5bjzd0nqdc";
    };
    gawk = trivialBuilder rec {
      inherit (localSystem) system;
      name = "gawk";
      ver = "5.0.1";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "15570p7g2x54asvr2fsc56sxzmm08fbk4mzpcs5n92fp9vq8cklf";
      configureArgs = [ "--disable-nls"
                        "--disable-mpfr"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                        "--without-libsegsegv-prefix"
                      ];
    };
    cpio = trivialBuilder rec {
      inherit (localSystem) system;
      name = "cpio";
      ver = "2.13";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.gz";
      sha256 = "126vyg4a8wcdwh6npgvxy6gq433bzgz3ph37hmjpycc4r7cp0x78";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                      ];
    };
    sed = trivialBuilder rec {
      inherit (localSystem) system;
      name = "sed";
      ver = "4.8";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "0cznxw73fzv1n3nj2zsq6nf73rvsbxndp444xkpahdqvlzz0r6zp";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                      ];
    };
    cacert = fetchURL rec {
      url = "https://curl.haxx.se/ca/cacert-2020-01-01.pem";
      sha256 = "07q808n307gzaga93abpf6an7c3rd35p18psdc1dd83lspgp1xxd";
      executable = false;
    };
    curl = trivialBuilder rec {
      inherit (localSystem) system;
      name = "curl";
      ver = "7.68.0";
      url = "https://curl.haxx.se/download/${name}-${ver}.tar.xz";
      sha256 = "0nh3j90w6b97wqcgxjfq55qhkz9s38955fbhwzv2fsi7483j895p";
      configureArgs = [ "--disable-nls"
                        "--disable-ares"
                        "--disable-debug"
                        "--disable-ldap"
                        "--disable-ldaps"
                        "--disable-rtsp"
                        "--disable-dict"
                        "--disable-telnet"
                        "--disable-tftp"
                        "--disable-pop3"
                        "--disable-imap"
                        "--disable-smb"
                        "--disable-smtp"
                        "--disable-gopher"
                        "--disable-manual"
                        "--disable-verbose"
                        "--disable-sspi"
                        "--disable-tls-srp"
                        "--disable-unix-sockets"
                        "--without-brotli"
                        "--without-gnutls"
                        "--without-mbedtls"
                        "--without-wolfssl"
                        "--without-bearssl"
                        "--without-libidn2"
                        "--without-librtmp"
                        "--without-nghttp2"
                        "--with-ssl=/usr"
                        "--with-ca-bundle=${cacert}"
                      ];
    };
    bashExe = "${bash}/bin/bash";
in
[

  ({}: {
    __raw = true;

    bootstrapTools = derivation ({
      inherit system;
      inherit make bash coreutils findutils
        diffutils grep patch gawk cpio sed
        curl;

      name = "trivial-bootstrap-tools";
      builder = bashExe;
      args = [ ./trivial-bootstrap.sh ];
      buildInputs = [ make ];
      mkdir = "/bin/mkdir";
      ln = "/bin/ln";
    } // lib.optionalAttrs config.contentAddressedByDefault {
      __contentAddressed = true;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    });
  })

  ({ bootstrapTools, ... }: rec {
    __raw = true;

    inherit bootstrapTools;

    fetchurl = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenv;
      curl = bootstrapTools;
    };

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-1";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;
      initialPath = [ "/" "/usr" ];
      shell = "${bootstrapTools}/bin/bash";
      fetchurlBoot = null;
      cc = null;
      overrides = self: super: {
      };
    };
  })

  (prevStage: {
    __raw = true;

    inherit (prevStage) bootstrapTools;

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-0";
      inherit config;
      initialPath = [ prevStage.bootstrapTools ];
      inherit (prevStage.stdenv)
        buildPlatform hostPlatform targetPlatform
        shell;
      fetchurlBoot = prevStage.fetchurl;
      cc = null;
    };
  })

  (prevStage: {
    inherit config overlays;
    stdenv = import ../generic rec {
      name = "stdenv-freebsd-boot-3";
      inherit config;

      inherit (prevStage.stdenv)
        buildPlatform hostPlatform targetPlatform
        initialPath shell fetchurlBoot;

      cc = lib.makeOverridable (import ../../build-support/cc-wrapper) {
        inherit lib;
        nativeTools  = true;
        nativePrefix = "/usr";
        nativeLibc   = true;
        stdenvNoCC = prevStage.stdenv;
        buildPackages = {
          inherit (prevStage) stdenv;
        };
        cc           = {
          name    = "clang-9.9.9";
          cc      = "/usr";
          outPath = prevStage.bootstrapTools;
        };
        isClang      = true;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = prevStage.stdenv;
          nativeTools  = true;
          nativeLibc   = true;
          propagateDoc = false;
          nativePrefix = "/usr";
          bintools     = { name = "${name}-binutils";
                           outPath = prevStage.bootstrapTools; };
        };
      };

      preHook = "export NIX_NO_SELF_RPATH=1";
    };
  })

]
