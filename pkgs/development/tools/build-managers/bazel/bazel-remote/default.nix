{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "bazel-remote";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7zAeGJyMfMdrVDCuTWU3zikXjM/ydjnGj6Ctjckd32c=";
  };

  vendorHash = "sha256-SxGBfWcV10L6xC5XPIfv/HJWQy5g3AoV8z4/ae23DEc=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/buchgr/bazel-remote";
    description = "A remote HTTP/1.1 cache for Bazel";
    license = licenses.asl20;
    maintainers = lib.teams.bazel.members;
    platforms = platforms.darwin ++ platforms.linux;
  };
}
