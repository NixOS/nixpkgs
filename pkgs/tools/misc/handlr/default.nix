{ lib, rustPlatform, fetchFromGitHub, shared-mime-info }:

rustPlatform.buildRustPackage rec {
  pname = "handlr";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "chmln";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mxkirsicagvfyihcb06g2bsz5h0zp7xc87vldp4amgddzaxhpbg";
  };

  cargoSha256 = "11glh6f0cjrq76212h80na2rgwpzjmk0j78y3i98nv203rkrczid";

  nativeBuildInputs = [ shared-mime-info ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  meta = with lib; {
    description = "Alternative to xdg-open to manage default applications with ease";
    homepage = "https://github.com/chmln/handlr";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
