{ stdenv, fetchurl, boost, cmake, curl, libyamlcpp, openssl, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.1.3";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "1ngp3xjdh6x1w7lsi4lji2xzqp0x950jngcdlq11lcr0wfnzwyxj";
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
