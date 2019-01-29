{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.12.3";

  src = fetchFromGitHub {
    sha256 = "0b9ci3r42dvqvvh3vflba75iv52n0viwddw9qpjsprb35ff9vzp7";
    rev = version;
    repo = "facter";
    owner = "puppetlabs";
  };

  CXXFLAGS = "-fpermissive";
  NIX_LDFLAGS = "-lblkid";

  cmakeFlags = [ "-DFACTER_RUBY=${ruby}/lib/libruby.so" ];

  # since we cant expand $out in cmakeFlags
  preConfigure = "cmakeFlags+=\" -DRUBY_LIB_INSTALL=$out/lib/ruby\"";

  buildInputs = [ boost cmake cpp-hocon curl leatherman libwhereami libyamlcpp openssl ruby utillinux ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };
}
