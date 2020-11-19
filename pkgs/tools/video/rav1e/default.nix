{ rustPlatform, fetchFromGitHub, lib, nasm, cargo-c }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rav1e";
    rev = "v${version}";
    sha256 = "0zwjg0sv504i1ahzfy2jgng6qwmyvcrvdrp4n3s90r4kvwjkv8xs";
  };

  cargoSha256 = "1mfzshcbxky27nskxhcyrj99wd3v5f597ymgv7nb67lzp5lsyb24";

  nativeBuildInputs = [ nasm cargo-c ];

  postBuild = ''
    cargo cbuild --release --frozen --prefix=${placeholder "out"}
  '';

  postInstall = ''
    cargo cinstall --release --frozen --prefix=${placeholder "out"}
  '';

  meta = with lib; {
    description = "The fastest and safest AV1 encoder";
    longDescription = ''
      rav1e is an AV1 video encoder. It is designed to eventually cover all use
      cases, though in its current form it is most suitable for cases where
      libaom (the reference encoder) is too slow.
      Features: https://github.com/xiph/rav1e#features
    '';
    inherit (src.meta) homepage;
    changelog = "https://github.com/xiph/rav1e/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = [ maintainers.primeos ];
  };
}
