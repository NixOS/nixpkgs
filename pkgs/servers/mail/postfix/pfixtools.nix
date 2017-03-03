{ stdenv, lib, fetchFromGitHub, git, gperf, pcre, unbound, libev, tokyocabinet, pkgconfig, bash, libsrs2 }:

let
  version = "0.9";

  pfixtoolsSrc = fetchFromGitHub {
    owner = "Fruneau";
    repo = "pfixtools";
    rev = "pfixtools-${version}";
    sha256 = "1vmbrw686f41n6xfjphfshn96vl07ynvnsyjdw9yfn9bfnldcjcq";
  };

  srcRoot = "pfixtools-${pfixtoolsSrc.rev}-src";

  libCommonSrc = fetchFromGitHub {
    owner = "Fruneau";
    repo = "libcommon";
    rev = "b07e6bdea3d24748e0d39783d7d817096d10cc67";
    sha256 = "14fxldp29j4vmfmhfgwwi37pj8cz0flm1aykkxlbgakz92d4pm35";
  };

in

stdenv.mkDerivation {
  name = "pfixtools-${version}";

  src = pfixtoolsSrc;

  patches = [ ./0001-Fix-build-with-unbound-1.6.1.patch ];

  buildInputs = [git gperf pcre unbound libev tokyocabinet pkgconfig bash libsrs2];

  postUnpack = ''
    cp -Rp ${libCommonSrc}/* ${srcRoot}/common;
    chmod -R +w ${srcRoot}/common;
  '';

  postPatch = ''
    substituteInPlace postlicyd/policy_tokens.sh \
                      --replace /bin/bash ${bash}/bin/bash;
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=unused-result";

  makeFlags = "DESTDIR=$(out) prefix=";

  meta = {
    description = "A collection of postfix-related tools";
    license = with lib.licenses; [ bsd3 ];
    homepage = https://github.com/Fruneau/pfixtools;
    platforms = stdenv.lib.platforms.linux;
  };
}
