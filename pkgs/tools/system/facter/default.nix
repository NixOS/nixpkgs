{ lib, stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, yaml-cpp, openssl, ruby, util-linux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.14.17";

  src = fetchFromGitHub {
    sha256 = "sha256-RvsUt1DyN8Xr+Xtz84mbKlDwxLewgK6qklYVdQHu6q0=";
    rev = version;
    repo = pname;
    owner = "puppetlabs";
  };

  CXXFLAGS = lib.optionalString stdenv.cc.isGNU "-fpermissive -Wno-error=catch-value";
  NIX_LDFLAGS = lib.optionalString stdenv.isLinux "-lblkid";

  cmakeFlags = [
    "-DFACTER_RUBY=${ruby}/lib/libruby${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DRUBY_LIB_INSTALL=${placeholder "out"}/lib/ruby"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost cpp-hocon curl leatherman libwhereami yaml-cpp openssl ruby util-linux ];

  meta = with lib; {
    homepage = "https://github.com/puppetlabs/facter";
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };
}
