{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libwhereami, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  pname = "facter";
  version = "3.13.2";

  src = fetchFromGitHub {
    sha256 = "1yaj1qlyzsaffzpm4zmzm53mc6bhpzka8wc3dfk909nzykxg34zf";
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
