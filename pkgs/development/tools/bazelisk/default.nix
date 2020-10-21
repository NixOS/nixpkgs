{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l4y8z44hwd6rnhnyk6l9abrvk342w72bah9k9zz6caa5i4xz2vz";
  };

  vendorSha256 = "116wy1a7gmi2w8why9hszhcybfvpwp4iq62vshb25cdcma6q4mjh";

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
