{
  lib,
  rustPlatform,
  fetchFromGitHub,
  # lua54 implies lua52/lua53
  features ? [
    "lua54"
    "luau"
  ],
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bqUmLtJLjImWqe06CeIWIU4FP+/Vxszp2yKMosVeyZM=";
  };

  cargoHash = "sha256-EMHt9oskPJCeAu/5VG6PaMt/4NTmNOaFTM5TMOy0BV8=";

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = features;

  meta = with lib; {
    description = "Opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "stylua";
  };
}
