{ lib
, rustPlatform
, fetchFromGitHub
  # lua54 implies lua52/lua53
, features ? [ "lua54" "luau" ]
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Lfd6jULV64vP5GQtOQ/wqyu4zZNpU83HSVGXQ8AtnvQ=";
  };

  cargoSha256 = "sha256-rojb15M58TnGZfptTMVCC6XaI9RBlpVL7s/Mb18CaSM=";

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
