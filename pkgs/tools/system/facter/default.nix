{ lib, stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, util-linux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.14.16";

  src = fetchFromGitHub {
    sha256 = "sha256-VZIeyLJBlh5/r0EHinSiPiQyCNUBFBYjDZ6nTVnZBbE=";
    rev = version;
    repo = pname;
    owner = "puppetlabs";
  };

  env.CXXFLAGS = lib.optionalString stdenv.cc.isGNU "-fpermissive -Wno-error=catch-value";
  env.NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lblkid";
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  cmakeFlags = [
    "-DFACTER_RUBY=${ruby}/lib/libruby${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DRUBY_LIB_INSTALL=${placeholder "out"}/lib/ruby"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost cpp-hocon curl leatherman libwhereami libyamlcpp openssl ruby util-linux ];

  meta = with lib; {
    homepage = "https://github.com/puppetlabs/facter";
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };
}
