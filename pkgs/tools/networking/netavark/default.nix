{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, mandown
}:

rustPlatform.buildRustPackage rec {
  pname = "netavark";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-r9NoPDFCqmzESxlovs91j0OyunGDmfWJXN+U1f0w2QQ=";
  };

  cargoHash = "sha256-/N9oKzcAwaxI2BbeoYZ2quN+Z3UO67ecpogK2SRG9Dw=";

  preBuild = ''
    substituteInPlace Cargo.toml \
      --replace 'build = "build.rs"' ""

    rm build.rs

    export \
      VERGEN_BUILD_SEMVER="${version}" \
      VERGEN_BUILD_TIMESTAMP="$SOURCE_DATE_EPOCH" \
      VERGEN_GIT_SHA="${src.rev}" \
      VERGEN_RUSTC_HOST_TRIPLE=""
  '';

  nativeBuildInputs = [ installShellFiles mandown ];

  postBuild = ''
    make -C docs
    installManPage docs/*.1
  '';

  meta = with lib; {
    description = "Rust based network stack for containers";
    homepage = "https://github.com/containers/netavark";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
