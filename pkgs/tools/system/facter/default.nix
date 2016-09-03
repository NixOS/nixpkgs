{ stdenv, fetchurl, boost, cmake, cpp-hocon, curl, leatherman, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.4.1";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "1vvvqni68l3hmnxi8jp0n2rwzxyh1vmgv6xa2954h94dfax6dmcj";
  };

  cmakeFlags = [ "-DFACTER_RUBY=${ruby}/lib/libruby.so" ];

  # since we cant expand $out in cmakeFlags
  preConfigure = "cmakeFlags+=\" -DRUBY_LIB_INSTALL=$out/lib/ruby\"";

  buildInputs = [ boost cmake cpp-hocon curl leatherman libyamlcpp openssl ruby utillinux ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
