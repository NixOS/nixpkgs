{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.13.0";

  src = fetchFromGitHub {
    sha256 = "1sqj8777vwb2izm86y74sivbpyxcx95sflgjn0pbqni311ck972v";
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
