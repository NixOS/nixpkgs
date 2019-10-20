{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "bazelisk";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bazelbuild";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pv113sk7hfxp4m2rcriqqp6mbbzcfdr0yrx4g1yiam93rx34yb7";
  };

  modSha256 = "0gs8y618izqi0gfa46jqh79yj8lzsmc6yj95fakhp2f5i8v1xrmx";

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
