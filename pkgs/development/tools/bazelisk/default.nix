{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.6.0";

  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l1032c0nqbdyasq6f8yf0vph06w6v81w044fs70rgzsa91m038r";
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
