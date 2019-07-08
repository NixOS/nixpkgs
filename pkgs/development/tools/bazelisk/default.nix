{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "0.0.8";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "16jiy71x8zr3x94p3qms3xbl8632avhwi66i82wv03n4ahkyb6qr";
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
