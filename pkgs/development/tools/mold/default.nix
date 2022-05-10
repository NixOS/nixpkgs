{ stdenv
, fetchFromGitHub
, lib
, coreutils
, autoPatchelfHook
, cmake
, llvmPackages_latest
, xxHash
, zlib
, openssl
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "mold";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rui314";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qrIaHDjPiOzQ8Gi7aPT0BM9oIgWr1IdcT7vvYmsea7k=";
  };

  buildInputs = [ zlib openssl ];
  nativeBuildInputs = [ autoPatchelfHook cmake xxHash ];

  enableParallelBuilding = true;
  dontUseCmakeConfigure = true;
  EXTRA_LDFLAGS = "-fuse-ld=${llvmPackages_latest.lld}/bin/ld.lld";
  LTO = 1;
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  suffixSalt = lib.replaceStrings ["-" "."] ["_" "_"] stdenv.targetPlatform.config;
  wrapperName = "MOLD_WRAPPER";
  coreutils_bin = lib.getBin coreutils;
  postInstall = let
    targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                                          (stdenv.targetPlatform.config + "-");
  in ''
    mkdir -p $out/nix-support

    mv $out/bin/mold $out/bin/.mold

    export prog=$out/bin/.mold
    substituteAll \
      ${../../../build-support/bintools-wrapper/ld-wrapper.sh} \
      "$out/bin/${targetPrefix}mold"
    chmod +x "$out/bin/${targetPrefix}mold"
    ln -s $out/bin/${targetPrefix}mold $out/bin/${targetPrefix}ld

    substituteAll \
      ${../../../build-support/bintools-wrapper/add-flags.sh} \
      $out/nix-support/add-flags.sh
    substituteAll \
      ${../../../build-support/bintools-wrapper/add-hardening.sh} \
      $out/nix-support/add-hardening.sh
    substituteAll \
      ${../../../build-support/wrapper-common/utils.bash} \
      $out/nix-support/utils.bash
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A high performance drop-in replacement for existing unix linkers";
    homepage = "https://github.com/rui314/mold";
    license = lib.licenses.agpl3Plus;
    maintainers = with maintainers; [ nitsky ];
    platforms = platforms.unix;
    # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.14 or newer
    broken = stdenv.isAarch64 || stdenv.isDarwin;
  };
}
