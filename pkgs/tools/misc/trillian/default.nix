{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "trillian";
  version = "1.3.11";
  vendorSha256 = "0zxp1gjzcc3z6vkpc2bchbs1shwm1b28ks0jh4gf6zxpp4361j4l";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lh19wba90y91l5jj8ilzjqxgmqqqdvyn7pzrwvmzv7iiy18wcmh";
  };

  # Remove tests that require networking
  postPatch = ''
    rm cmd/get_tree_public_key/main_test.go
  '';

  subPackages = [
    "cmd/trillian_log_server"
    "cmd/trillian_log_signer"
    "cmd/trillian_map_server"
    "cmd/createtree"
    "cmd/deletetree"
    "cmd/get_tree_public_key"
    "cmd/updatetree"
  ];

  meta = with lib; {
    homepage = "https://github.com/google/trillian";
    description = "A transparent, highly scalable and cryptographically verifiable data store.";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
