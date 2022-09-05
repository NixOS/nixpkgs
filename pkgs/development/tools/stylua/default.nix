{ fetchFromGitHub
, lib
, rustPlatform
, lua52Support ? true
, luauSupport ? false
, fetchpatch
}:

rustPlatform.buildRustPackage rec {
  pname = "stylua";
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "johnnymorganz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-l4q6Qlgdxgm4K5+NkWMZI3Hhtx6m/0DG9PE4gvo/ylo=";
  };

  cargoSha256 = "sha256-zlk9KdiSKWknyuJTTqpzCeSJUXJGDK2A0g1ss8AHoYs=";

  cargoPatches = [
    # fixes broken 0.14.3 lockfile
    (fetchpatch {
      url = "https://github.com/JohnnyMorganz/StyLua/commit/834f632f67af6425e7773eaade8d23a880946843.patch";
      sha256 = "sha256-oM2gaILwiNMqTGFRQBw6/fxbjljNWxeIb0lcXcAJR3w=";
    })
  ];

  buildFeatures = lib.optional lua52Support "lua52"
    ++ lib.optional luauSupport "luau";

  meta = with lib; {
    description = "An opinionated Lua code formatter";
    homepage = "https://github.com/johnnymorganz/stylua";
    changelog = "https://github.com/johnnymorganz/stylua/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
