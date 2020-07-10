{ rustPlatform, fetchFromGitHub, lib, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "rav1e";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "rav1e";
    rev = "v${version}";
    sha256 = "0a9dryag4x35a2c45qiq1j5xk9ydcpw1g6kici85d2yrc2z3hwrx";
  };

  cargoSha256 = "1xaincrmpicp0skf9788w5631x1hxvifvq06hh5ribdz79zclzx3";

  nativeBuildInputs = [ nasm ];

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
    platforms = platforms.all;
  };
}
