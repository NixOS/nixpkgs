# Build generators from the same sources as the target libraries. In particular,
# a newer system protoc may emit code incompatible with the vendored protobuf.
{
  stdenv,
  cmake,
  ninja,
  src,
}:
{
  sleef = stdenv.mkDerivation {
    name = "torch-native-sleef-generators";
    src = "${src}/third_party/sleef";
    nativeBuildInputs = [
      cmake
      ninja
    ];
    cmakeFlags = [
      "-DSLEEF_BUILD_TESTS=OFF"
      "-DSLEEF_BUILD_DFT=OFF"
      "-DSLEEF_BUILD_GNUABI_LIBS=OFF"
      "-DSLEEF_DISABLE_OPENMP=ON"
    ];
    # Upstream has no aggregate target for these generators. Build them without
    # building the native SLEEF libraries; the cross build supplies those.
    ninjaFlags = [
      "mkrename"
      "mkrename_gnuabi"
      "mkmasked_gnuabi"
      "mkalias"
      "mkdisp"
    ];
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      cp bin/* "$out/bin/"
      runHook postInstall
    '';
  };

  protoc = stdenv.mkDerivation {
    name = "torch-native-protoc";
    src = "${src}/third_party/protobuf";
    nativeBuildInputs = [
      cmake
      ninja
    ];
    cmakeDir = "../cmake";
    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-Dprotobuf_BUILD_TESTS=OFF"
      "-Dprotobuf_WITH_ZLIB=OFF"
      "-Dprotobuf_BUILD_SHARED_LIBS=OFF"
    ];
    ninjaFlags = [ "protoc" ];
    installPhase = ''
      runHook preInstall
      install -Dm755 protoc "$out/bin/protoc"
      runHook postInstall
    '';
  };
}
