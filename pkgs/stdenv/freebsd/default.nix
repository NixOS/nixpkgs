{ lib
, localSystem, crossSystem, config, overlays, crossOverlays ? []
}:

assert crossSystem == localSystem;
let inherit (localSystem) system;
  trivialBuilder = (import ./trivial-builder.nix);
in
[
  ({}: rec {
    __raw = true;
    hostTools = derivation ({
      inherit system;
      name = "host-tools";
      version = "9.9.9";
      builder = ./host-bootstrap.sh;
      args = ["curl" "bash" "objdump" "objcopy" "size" "strings" "as" "ar" "nm" "gprof" "dwp" "c++filt" "addr2line" "ranlib" "readelf" "elfedit"];
      shellPath = "bash";
      prefix = "";
    });

    stdenv = import ../generic {
      name = "stdenv-freebsd-boot-0";
      buildPlatform = localSystem;
      hostPlatform = localSystem;
      targetPlatform = localSystem;
      inherit config;
      initialPath = [ "/" "/usr" ];
      shell = "${hostTools}/bin/bash";
      fetchurlBoot = fetchurl;
      cc = null;
      overrides = self: super: {
        inherit fbworld hostTools;
      };
    };

    fetchurl = import ../../build-support/fetchurl {
      inherit lib;
      stdenvNoCC = stdenv;
      curl = hostTools;
    };

    fbworld = derivation (rec {
      inherit system;
      name = "fbworld";
      pname = "fbworld";
      version = "14.0-CURRENT";
      rev = "d1d7a273707a50d4ad1691b2c4dbf645dfa253ea";
      src = fetchurl {
        url = "https://github.com/freebsd/freebsd-src/archive/${rev}.tar.gz";
        sha256 = "sha256-D7pTkW4DLKqS/HxyERI/oUh+/Qh/5ri5Z3O5RcooUVI=";
      };
      outputs = ["lib" "out" "corebin" "cc" "sh" "zip"];  # misbehaves when bin is named bin?
      dname = "freebsd-src-${rev}";
      builder = ./world-builder.sh;
      patchelf = "${patchelf_}/bin/patchelf";
      #readelf = "${hostTools}/bin/readelf";
    });

    gmake = trivialBuilder rec {
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
      ver = "9.3";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "rbz8/omSNbceh2jc8HzVMlILf1T5qAZIQ/jRmakEu6o=";
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
      ver = "3.11";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "HbKu3eidDepCsW2VKPiUyNFdrk4ZC1muzHj1qVEnbqs=";
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
      patches = [{
        url = "https://git.savannah.gnu.org/cgit/cpio.git/patch/src/global.c?id=641d3f489cf6238bb916368d4ba0d9325a235afb";
        sha256 = "ftJs4vYkybaIxqtfLy0NfpBnHZ2HGCRbAUHQLHm6cVs=";
      }];
    };
    tar = trivialBuilder rec {
      inherit (localSystem) system;
      name = "tar";
      ver = "1.34";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.gz";
      sha256 = "A9kIz1doz+a3rViMkhxu0hrKv7K3m3iNEzBFNQdkeu0=";
    };
    sed = trivialBuilder rec {
      inherit (localSystem) system;
      name = "sed";
      ver = "4.9";
      url = "https://ftp.gnu.org/gnu/${name}/${name}-${ver}.tar.xz";
      sha256 = "biJrcy4c1zlGStaGK9Ghq6QteYKSLaelNRljHSSXUYE=";
      configureArgs = [ "--disable-nls"
                        "--without-libintl-prefix"
                        "--without-libiconv-prefix"
                      ];
    };
    cacert = fetchurl {
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
    zlib = trivialBuilder rec {
      inherit (localSystem) system;
      name = "zlib";
      ver = "1.2.13";
      url = "https://github.com/madler/zlib/releases/download/v${ver}/zlib-${ver}.tar.gz";
      sha256 = "s6JN6XqP28g1uYMxaVAQMLiXcDG8tUs7OsE3QPhGqzA=";
    };

    binutils = trivialBuilder rec {
      inherit (localSystem) system;
      name = "binutils";
      ver = "2.41";
      url = "https://ftp.gnu.org/gnu/binutils/binutils-${ver}.tar.gz";
      sha256 = "SNAKjcc6p9I5Sn3Aablhkdlejejw2m3JHaXM5lXCDkU=";
      make = "${gmake}/bin/make";
    };

    patchelf_ = trivialBuilder rec {
      inherit (localSystem) system;
      name = "patchelf";
      ver = "0.15.0";
      url = "https://github.com/NixOS/${name}/releases/download/${ver}/${name}-${ver}.tar.bz2";
      sha256 = "9ANtPuTY4ijewb7/8PbkbYpA6eVw4AaOOdd+YuLIvcI=";
    };
  })

  (prevStage: rec {
    inherit config overlays;

    stdenv = import ../generic rec {
        name = "stdenv-freebsd-boot-1";
        inherit config;
        initialPath = [ prevStage.coreutils prevStage.tar prevStage.findutils prevStage.gmake prevStage.sed prevStage.patchelf_ prevStage.grep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.fbworld.sh prevStage.fbworld.zip ];
        extraNativeBuildInputs = [];
        inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;
        shell = "${prevStage.bash}/bin/bash";
        cc = import ../../build-support/cc-wrapper ({
          inherit lib;
          name = "stdenv-freebsd-boot-1-cc-wrapper";
          stdenvNoCC = prevStage.stdenv;
          cc = prevStage.fbworld.cc;
          libc = prevStage.fbworld.lib;
          gnugrep = prevStage.grep;
          coreutils = prevStage.coreutils;
          nativeTools = false;
          nativeLibc = false;
          isClang = true;
          bintools = import ../../build-support/bintools-wrapper {
            inherit lib;
            stdenvNoCC = prevStage.stdenv;
            name = "stdenv-freebsd-boot-1-bintools-wrapper";
            libc = prevStage.fbworld.lib;
            propagateDoc = false;
            nativeTools = false;
            nativeLibc = false;
            bintools = prevStage.binutils;
            gnugrep = prevStage.grep;
            coreutils = prevStage.coreutils;
          };
        });
        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = stdenv;
          curl = prevStage.hostTools;
        };

        overrides = self: super: ({
          fbworld = prevStage.fbworld;
          #curl = prevStage.hostTools;
          fetchurl = prevStage.fetchurl;
        });
      };
  })

  (prevStage: rec {
    inherit config overlays;

    stdenv = import ../generic rec {
      name = "stdenv-freebsd-boot-2";
      inherit config;
      initialPath = [ prevStage.coreutils prevStage.gnutar prevStage.findutils prevStage.gnumake prevStage.gnused prevStage.patchelf prevStage.gnugrep prevStage.gawk prevStage.diffutils prevStage.patch prevStage.bash prevStage.gzip prevStage.bzip2 prevStage.xz  ];
      inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;
      shell = "${prevStage.bash}/bin/bash";
      cc = import ../../build-support/cc-wrapper ({
        inherit lib;
        name = "stdenv-freebsd-boot-2-cc-wrapper";
        stdenvNoCC = prevStage.stdenv;
        cc = prevStage.fbworld.cc;
        libc = prevStage.fbworld.lib;
        coreutils = prevStage.coreutils;
        gnugrep = prevStage.gnugrep;
        nativeTools = false;
        nativeLibc = false;
        isClang = true;
        #bintools = prevStage.bintools;
        bintools = import ../../build-support/bintools-wrapper {
          inherit lib;
          stdenvNoCC = prevStage.stdenv;
          name = "stdenv-freebsd-boot-2-bintools-wrapper";
          libc = prevStage.fbworld.lib;
          propagateDoc = false;
          nativeTools = false;
          nativeLibc = false;
          bintools = prevStage.bintools-unwrapped;
          coreutils = prevStage.coreutils;
          gnugrep = prevStage.gnugrep;
        };
      });
        fetchurlBoot = import ../../build-support/fetchurl {
          inherit lib;
          stdenvNoCC = stdenv;
          curl = prevStage.curl;
        };
      overrides = self: super: {
        inherit (prevStage) fbworld bash;
      };
    };
  })

  #(prevStage: rec {
  #  inherit config overlays;

  #  stdenv = import ../generic rec {
  #    name = "stdenv-freebsd";
  #    inherit config;
  #    initialPath = [ prevStage.fbworld ];
  #    inherit (prevStage.stdenv) buildPlatform hostPlatform targetPlatform;
  #    shell = prevStage.bash;
  #    cc = import ../../build-support/cc-wrapper ({
  #      inherit lib;
  #      name = "stdenv-freebsd-cc-wrapper";
  #      stdenvNoCC = prevStage.stdenv;
  #      cc = prevStage.fbworld;
  #      libc = prevStage.fbworld;
  #      coreutils = prevStage.fbworld;
  #      gnugrep = prevStage.gnugrep;
  #      nativeTools = false;
  #      nativeLibc = false;
  #      isClang = true;
  #      bintools = prevStage.bintools;
  #    });
  #    fetchurlBoot = prevStage.curl;
  #    overrides = self: super: {
  #    };
  #  };
  #})
]
