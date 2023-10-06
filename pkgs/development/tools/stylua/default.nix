{ lib
, rustPlatform
, fetchFromGitHub
  # lua54 implies lua52/lua53
, features ? [ "lua54" "luau" ]
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-f4U3vzgvFF1N6X8f8zwtqSaQfiwNX7CecpcJ0GKx2P0=";
  };

  cargoSha256 = "sha256-az5j0qvP3mZXRJZOmslDb40MSMS+iAvXYVNGw8vt7gg=";

  # remove cargo config so it can find the linker on aarch64-unknown-linux-gnu
  postPatch = ''
    rm .cargo/config.toml
  '';

  buildFeatures = features;

  meta = with lib; {
    description = "An opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "stylua";
  };
}
