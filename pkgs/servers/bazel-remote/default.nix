{ stdenv, fetchFromGitHub, buildGoPackage, cacert, git, go }:

buildGoPackage {
  name = "bazel-remote";

  src = fetchFromGitHub {
    owner = "buchgr";
    repo = "bazel-remote";
    rev = "57a18163783d3d0cb199ad93bcc788c864ec4140";
    sha256 = "18s977715sc44sgnf0rn48jmi5d7saijnh7xfx7mg5r70llvppk6";
  };

  goPackagePath = "github.com/buchgr/bazel-remote";

  meta = with stdenv.lib; {
    homepage = https://github.com/buchgr/bazel-remote;
    description = "A remote HTTP/1.1 cache for Bazel https://bazel.build";
    license = licenses.asl20;
    maintainers = [ maintainers.shmish111 ];
    platforms = platforms.all;
  };

  goDeps = ./deps.nix;

}
