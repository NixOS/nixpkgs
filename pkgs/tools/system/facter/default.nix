{ stdenv, fetchurl, boost, cmake, curl, libyamlcpp, openssl, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.0.2";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "1myf1r827bh3n0snkzwj2jnc0sax9bq6z1vv9gr90rqr73lixvig";
  };

  libyamlcpp_ = libyamlcpp.override { makePIC = true; };

  buildInputs = [ boost cmake curl libyamlcpp_ openssl utillinux ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
