{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "14zp0bi0p1rfbx1pxi5y28ndxwbqbvfx0pvy3jh1mnx5qsii1gcq";
  };

  vendorSha256 = "1333nq5cy4q105zj1qg3zxdn4ymfnq2cd1kg2r0d6qq2jab7iawh";
  regenGoMod = true;

  buildFlagsArray = [ "-ldflags=-s -w -X main.BazeliskVersion=${version}" ];

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
