{ stdenv, fetchurl, boost, cmake, curl, leatherman, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.1.6";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "1kv4k9zqpsiw362kk1rw1a4sixd0pmnh57ghd4k4pffr2dkmdfsv";
  };

  cmakeFlags = [ "-DFACTER_RUBY=${ruby}/lib/libruby.so" ];

  # since we cant expand $out in cmakeFlags
  preConfigure = "cmakeFlags+=\" -DRUBY_LIB_INSTALL=$out/lib/ruby\"";

  libyamlcpp_ = libyamlcpp.override { makePIC = true; };

  buildInputs = [ boost cmake curl leatherman libyamlcpp_ openssl ruby utillinux ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
