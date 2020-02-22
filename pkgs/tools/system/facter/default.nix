{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.14.7";

  src = fetchFromGitHub {
    sha256 = "1x71ynnp8l5bf6m1a56rwcjya2swrhpxmd0cg9ndjplam6zys2v7";
    rev = version;
    repo = pname;
    owner = "puppetlabs";
  };

  CXXFLAGS = "-fpermissive -Wno-error=catch-value";
  NIX_LDFLAGS = "-lblkid";

  cmakeFlags = [
    "-DFACTER_RUBY=${ruby}/lib/libruby.so"
    "-DRUBY_LIB_INSTALL=${placeholder "out"}/lib/ruby"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-copy";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost cpp-hocon curl leatherman libwhereami libyamlcpp openssl ruby utillinux ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/puppetlabs/facter";
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
