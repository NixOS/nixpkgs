{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.4.0";

  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "14zp0bi0p1rfbx1pxi5y28ndxwbqbvfx0pvy3jh1mnx5qsii1gcq";
  };

  vendorSha256 = "10156k90ky3znb9rxhy7zasskxmlcs5cn9f3xk25ana1c66vxszr";

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