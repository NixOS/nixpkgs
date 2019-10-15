{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "0516rx3qx6nxavy0a1qxjx2rcvdfb2ggig0q4n7fkmrxbnwxh2c9";
  };

  modSha256 = "1f73j6ryidzi3kfy3rhsqx047vzwvzaqcsl7ykhg87rn2l2s7fdl";

  meta = with stdenv.lib; {
    description = "A user-friendly launcher for Bazel";
    longDescription = ''
      BEWARE: This package does not work on NixOS.
    '';
    homepage = "https://github.com/bazelbuild/bazelisk";
    license = licenses.asl20;
    maintainers = with maintainers; [ elasticdog ];
  };
}
