{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  installShellFiles,
  libbsd,
  CoreFoundation,
  IOKit,
}:

stdenv.mkDerivation rec {
  pname = "pdisk";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "apple-oss-distributions";
    repo = pname;
    rev = "${pname}-${lib.versions.minor version}";
    hash = "sha256-+gBgnk/1juEHE0nXaz7laUaH7sxrX5SzsLGr0PHsdHs=";
  };

  patches = [
    # Fix makefile for Unix
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/makefile.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9";
      sha256 = "sha256-mLFclu8IlDN/gxNTI7Kei6ARketlAhJRu8ForFUzFU0=";
    })
    # Fix lseek usage in file_media.c
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/file_media.c.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9";
      sha256 = "sha256-CCq5fApwx6w1GKDrgP+0nUdQy/5z5ON7/fdp4M63nko=";
    })
    # Fix open_partition_map call in cvt_pt.c
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/cvt_pt.c.patch?h=pdisk&id=39dc371712d2f7dbd38f6e8ddc6ba661faa1a7a9";
      sha256 = "sha256-jScPfzt9/fQHkf2MfHLvYsh/Rw2NZZXkzZiiVo8F5Mc=";
    })
    # Replace removed sys_nerr and sys_errlist with strerror
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/linux_strerror.patch?h=pdisk&id=d0c930ea8bcac008bbd0ade1811133a625caea54";
      sha256 = "sha256-HGJIS+vTn6456KtaETutIgTPPBm2C9OHf1anG8yaJPo=";
    })
  ];

  postPatch =
    ''
      substituteInPlace makefile \
        --replace 'cc' '${stdenv.cc.targetPrefix}cc'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace makefile \
        --replace '-lbsd' '-framework CoreFoundation -framework IOKit'
    '';

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libbsd
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
      CoreFoundation
      IOKit
    ];

  env.NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 cvt_pt $out/bin/cvt_pt
    install -Dm755 pdisk $out/bin/pdisk

    installManPage pdisk.8
    install -Dm644 pdisk.html $out/share/doc/pdisk/pdisk.html

    runHook postInstall
  '';

  meta = with lib; {
    description = "Low-level Apple partition table editor for Linux, OSS Apple version";
    homepage = "https://github.com/apple-oss-distributions/pdisk";
    license = with licenses; [
      hpnd # original license statements seems to match this (in files that are shared with mac-fdisk)
      apple-psl10 # new files
    ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}
