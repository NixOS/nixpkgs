{ lib
, rustPlatform
, llvmPackages
, clang
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "sonic-server";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "valeriansaliou";
    repo = "sonic";
    rev = "f5302f5c424256648ba0be32b3c5909d846821fe";
    sha256 = "sha256-WebEluXijgJckZQOka2BDPYn7PqzPTsIcV2T380fxW8=";
  };

  cargoSha256 = "sha256-ObhKGjaIma6fUVUT3xadpy/GPYlnm0nKmRVxFmoePyQ=";

  doCheck = false;

  nativeBuildInputs = [
    llvmPackages.libclang
    llvmPackages.libcxxClang
    clang
  ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion clang}/include";

  postPatch = ''
    substituteInPlace src/main.rs --replace "./config.cfg" "$out/etc/sonic/config.cfg"
  '';

  postInstall = ''
    mkdir -p $out/etc/
    mkdir -p $out/usr/lib/systemd/system/

    install -Dm444 -t $out/etc/sonic config.cfg
    substitute \
      ./examples/config/systemd.service $out/usr/lib/systemd/system/sonic-server.service \
      --replace /bin/sonic $out/bin/sonic \
      --replace /etc/sonic.cfg $out/etc/sonic/config.cfg
  '';

  meta = with lib; {
    description = "Fast, lightweight and schema-less search backend";
    homepage = "https://github.com/valeriansaliou/sonic";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pleshevskiy ];
  };
}
