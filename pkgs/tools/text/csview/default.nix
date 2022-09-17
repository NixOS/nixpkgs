{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "csview";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yx/gGJ8QGmMaiVw+yWWhswbGpf9YZk2kWoxFXXSETyA=";
  };

  cargoSha256 = "sha256-4YJfD8TuQN9aQlbhzpv69YE20tMMIUxq6UdDpJSP7lI=";

  meta = with lib; {
    description = "A high performance csv viewer with cjk/emoji support";
    homepage = "https://github.com/wfxr/csview";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
