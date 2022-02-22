{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aardvark-dns";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RFA/C0Q4u1WMQ0bsFKbkyzar0vDRfQ6YPpu/Np3xXWA=";
  };

  cargoVendorDir = "vendor";

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
