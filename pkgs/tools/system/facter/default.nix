{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.14.14";

  src = fetchFromGitHub {
    sha256 = "07pfa11i3nn2dk5g3c1qj3g7d2s8gd2fr0lmfijndaqxm7gjrn1a";
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
