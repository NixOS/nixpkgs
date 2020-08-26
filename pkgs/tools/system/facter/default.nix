{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.14.12";

  src = fetchFromGitHub {
    sha256 = "1n0m2w133bpbbpc1imp89xlinmny7xaz1w87cs18p1lnk2w043lc";
    rev = version;
    repo = pname;
    owner = "puppetlabs";
  };

  CXXFLAGS = stdenv.lib.optionalString stdenv.cc.isGNU "-fpermissive -Wno-error=catch-value";
  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lblkid";

  cmakeFlags = [
    "-DFACTER_RUBY=${ruby}/lib/libruby${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DRUBY_LIB_INSTALL=${placeholder "out"}/lib/ruby"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost cpp-hocon curl leatherman libwhereami libyamlcpp openssl ruby utillinux ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/puppetlabs/facter";
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };
}
