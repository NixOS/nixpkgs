{ stdenv, fetchurl, boost, cmake, curl, leatherman, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.1.8";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "1fhfjf5bm5kyjiady14fxhpp7hdrkgx56vsvdbqj82km0xqcxpj9";
  };

  cmakeFlags = [ "-DFACTER_RUBY=${ruby}/lib/libruby.so" ];

  # since we cant expand $out in cmakeFlags
  preConfigure = "cmakeFlags+=\" -DRUBY_LIB_INSTALL=$out/lib/ruby\"";

  buildInputs = [ boost cmake curl leatherman libyamlcpp openssl ruby utillinux ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
