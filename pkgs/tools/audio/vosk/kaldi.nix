{ lib
, openfst
, fetchFromGitHub
, stdenv
, writeText
, autoconf
, automake
, libtool
, gfortran
, openblas
}:
let
  openfst' = openfst.overrideAttrs (oldAttrs: {
    version = "1.8.0"; # this needs to match the version from kaldi/tools/Makefile

    # not pinned, so it should be updated to the latest version when updating kaldi
    src = fetchFromGitHub {
      owner = "alphacep";
      repo = "openfst";
      rev = "7dfd808194105162f20084bb4d8e4ee4b65266d5";
      sha256 = "sha256-XiPR4AaSa/7OqYoYZOwlW3UhAsYmscBE36xffI2gPPg=";
    };

    # from OPENFST_CONFIGURE in kaldi/tools/Makefile
    configureFlags = [
      "--enable-shared"
      "--enable-far"
      "--enable-ngram-fsts"
      "--enable-lookahead-fsts"
      "--with-pic"
    ];
  });

  # pinned in kaldi/tools/Makefile
  cub = fetchFromGitHub {
    owner = "nvidia";
    repo = "cub";
    rev = "1.8.0";
    sha256 = "sha256-j52BSkTItExznQApZbv868ipU4SCAu0EOqljzzKnIdk=";
    meta.license = lib.licenses.bsd3;
  };

  # When updating, always update the git revision (rev) and the version base.
  # The version base can be obtained by running src/base/get_version.sh in the kaldi source.
  # Only the first three components (major.minor.patch) should be put in here,
  # the last one (short git commit hash) will automatically be appended
  version_base = "5.5.1046";
  rev = "76cd51d44c0a61e3905c35cadb2ec5f54f3e42d1";
in
stdenv.mkDerivation rec {
  pname = "kaldi";
  version = "${version_base}-${lib.substring 0 5 rev}";

  src = fetchFromGitHub {
    owner = "alphacep";
    repo = "kaldi";
    inherit rev;
    sha256 = "sha256-utsHBkkjQzUcsPeEuag7BMf9wSdZxEO98aGEP4iFx30=";
  };

  sourceRoot = "source/src";

  postPatch = ''
    # disable script (requires .git) and hardcode version
    echo > base/get_version.sh
    ln -s ${writeText "version.h" ''
      #define KALDI_VERSION "${version}"
      #define KALDI_GIT_HEAD "${rev}"
    ''} base/version.h

    # otherwise /build/source/src/lib gets added to RPATH
    substituteInPlace makefiles/default_rules.mk \
      --replace '-Wl,-rpath -Wl,$(KALDILIBDIR)' "-Wl,-rpath, -Wl,$out/lib" \
      --replace '-Wl,-rpath=$(shell readlink -f $(KALDILIBDIR))' "-Wl,-rpath=$out/lib"
  '';

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  buildInputs = [
    gfortran.cc.lib
    # Vosk’s guide states that their Kaldi fork requires OpenBLAS with CLAPACK.
    # However, it works just as well with regular OpenBLAS,
    # which also avoids introducing a different OpenBLAS derivation.
    openblas
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs configure
  '';

  dontAddPrefix = true;
  configureFlags = [
    "--shared"
    "--fst-root=${openfst'}"
    "--fst-version=${openfst'.version}"
    "--cub-root=${cub}"
    "--openblas-root=${openblas}"
  ];

  makeFlags = [ "online2" "lm" "rnnlm" ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -rL lib $out/lib
    runHook postInstall
  '';

  passthru = {
    openfst = openfst';
  };

  meta = with lib; {
    homepage = "https://github.com/alphacep/kaldi/tree/vosk";
    description = "Kaldi fork for the Vosk offline speech recognition API";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
