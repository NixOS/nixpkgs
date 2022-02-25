{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6O/7GoGH0xNbTfIFeD5VLrifNFpHcxxG0bdq/YQb3Ew=";
  };

  cargoHash = "sha256-YdHIyCJ00MKH8PL0osOqQIMwaws3+cOUwvhvA8mOp84=";

  preBuild = ''
    rm build.rs

    export \
      VERGEN_BUILD_SEMVER="${version}" \
      VERGEN_BUILD_TIMESTAMP="$SOURCE_DATE_EPOCH" \
      VERGEN_GIT_SHA="${src.rev}" \
      VERGEN_RUSTC_HOST_TRIPLE=""
  '';

  meta = with lib; {
    description = "Authoritative dns server for A/AAAA container records";
    homepage = "https://github.com/containers/aardvark-dns";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
