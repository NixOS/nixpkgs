{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.6.1";

  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g5zwdk7p1snqcbm4w3hsi3fm7sbsijrfj4ajxg7mifywqpmzm2l";
  };

  vendorSha256 = "1jgm6j04glvk7ib5yd0h04p9qxzl1ca100cv909kngx52jp61yxp";

  doCheck = false;

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
