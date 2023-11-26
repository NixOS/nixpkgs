{ lib, boringssl, stdenv, fetchgit, fetchFromGitHub, fetchurl, cmake, zlib, perl, libevent }:
let
  versions = lib.importJSON ./versions.json;

  fetchGitilesPatch = { name, url, sha256 }:
    fetchurl {
      url = "${url}%5E%21?format=TEXT";
      inherit name sha256;
      downloadToTemp = true;
      postFetch = ''
        base64 -d < $downloadedFile > $out
      '';
    };

  # lsquic requires a specific boringssl version (noted in its README)
  boringssl' = boringssl.overrideAttrs ({ preBuild, ... }: {
    version = versions.boringssl.rev;
    src = fetchgit {
      url = "https://boringssl.googlesource.com/boringssl";
      inherit (versions.boringssl) rev sha256;
    };

    patches = [
      # Use /etc/ssl/certs/ca-certificates.crt instead of /etc/ssl/cert.pem
      ./use-etc-ssl-certs.patch

      # because lsquic requires that specific boringssl version and that
      # version does not yet include fixes for gcc11 build errors, they
      # must be backported
      (fetchGitilesPatch {
        name = "fix-mismatch-between-header-and-implementation-of-bn_sqr_comba8.patch";
        url = "https://boringssl.googlesource.com/boringssl/+/139adff9b27eaf0bdaac664ec4c9a7db2fe3f920";
        sha256 = "05sp602dvh50v46jkzmh4sf4wqnq5bwy553596g2rhxg75bailjj";
      })
      (fetchGitilesPatch {
        name = "use-an-unsized-helper-for-truncated-SHA-512-variants.patch";
        url = "https://boringssl.googlesource.com/boringssl/+/a24ab549e6ae246b391155d7bed3790ac0e07de2";
        sha256 = "0483jkpg4g64v23ln2blb74xnmzdjcn3r7w4zk7nfg8j3q5f9lxm";
      })
/*
      # the following patch is too complex, so we will modify the build flags
      # of crypto/fipsmodule/CMakeFiles/fipsmodule.dir/bcm.c.o in preBuild
      # and turn off -Werror=stringop-overflow
      (fetchGitilesPatch {
        name = "make-md32_common.h-single-included-and-use-an-unsized-helper-for-SHA-256.patch";
        url = "https://boringssl.googlesource.com/boringssl/+/597ffef971dd980b7de5e97a0c9b7ca26eec94bc";
        sha256 = "1y0bkkdf1ccd6crx326agp01q22clm4ai4p982y7r6dkmxmh52qr";
      })
*/
      (fetchGitilesPatch {
        name = "fix-array-parameter-warnings.patch";
        url = "https://boringssl.googlesource.com/boringssl/+/92c6fbfc4c44dc8462d260d836020d2b793e7804";
        sha256 = "0h4sl95i8b0dj0na4ngf50wg54raxyjxl1zzwdc810abglp10vnv";
      })
    ];

    preBuild = preBuild + lib.optionalString stdenv.isLinux ''
      sed -e '/^build crypto\/fipsmodule\/CMakeFiles\/fipsmodule\.dir\/bcm\.c\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=stringop-overflow/' \
          -i build.ninja
    '' + lib.optionalString stdenv.cc.isGNU ''
      # Silence warning that causes build failures with GCC.
      sed -e '/^build ssl\/test\/CMakeFiles\/bssl_shim\.dir\/settings_writer\.cc\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=ignored-attributes/' \
          -e '/^build ssl\/test\/CMakeFiles\/handshaker\.dir\/settings_writer\.cc\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=ignored-attributes/' \
          -i build.ninja
    '' + lib.optionalString stdenv.cc.isClang (
      # Silence warnings that cause build failures with newer versions of clang.
      let
        clangVersion = lib.getVersion stdenv.cc;
      in
      lib.optionalString (lib.versionAtLeast clangVersion "13") ''
        sed -e '/^build crypto\/CMakeFiles\/crypto\.dir\/x509\/t_x509\.c\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=unused-but-set-variable/' \
            -e '/^build tool\/CMakeFiles\/bssl\.dir\/digest\.cc\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=unused-but-set-variable/' \
            -i build.ninja
      '' + lib.optionalString (lib.versionAtLeast clangVersion "16") ''
        sed -e '/^build crypto\/CMakeFiles\/crypto\.dir\/trust_token\/trust_token\.c\.o:/,/^ *FLAGS =/ s/^ *FLAGS = -Werror/& -Wno-error=single-bit-bitfield-constant-conversion/' \
            -i build.ninja
      ''
    );
  });
in
stdenv.mkDerivation rec {
  pname = "lsquic";
  version = versions.lsquic.version;

  src = fetchFromGitHub {
    owner = "litespeedtech";
    repo = pname;
    rev = "v${version}";
    inherit (versions.lsquic) sha256;
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace ".so" "${stdenv.hostPlatform.extensions.sharedLibrary}"
  '';

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ boringssl' libevent zlib ];

  cmakeFlags = [
    "-DBORINGSSL_DIR=${lib.getDev boringssl'}"
    "-DBORINGSSL_LIB_crypto=${lib.getLib boringssl'}/lib/libcrypto.a"
    "-DBORINGSSL_LIB_ssl=${lib.getLib boringssl'}/lib/libssl.a"
    "-DZLIB_LIB=${zlib}/lib/libz.so"
  ];

  # adapted from lsquic.cr’s Dockerfile
  # (https://github.com/iv-org/lsquic.cr/blob/master/docker/Dockerfile)
  installPhase = ''
    runHook preInstall

    mkdir combinedlib
    cd combinedlib
    ar -x ${lib.getLib boringssl'}/lib/libssl.a
    ar -x ${lib.getLib boringssl'}/lib/libcrypto.a
    ar -x ../src/liblsquic/liblsquic.a
    ar rc liblsquic.a *.o
    ranlib liblsquic.a
    install -D liblsquic.a $out/lib/liblsquic.a

    runHook postInstall
  '';

  passthru.boringssl = boringssl';

  meta = with lib; {
    description = "A library for QUIC and HTTP/3 (version for Invidious)";
    homepage = "https://github.com/litespeedtech/lsquic";
    maintainers = with maintainers; [ infinisil sbruder ];
    license = with licenses; [ openssl isc mit bsd3 ]; # statically links against boringssl, so has to include its licenses
  };
}
