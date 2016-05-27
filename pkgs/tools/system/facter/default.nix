{ stdenv, fetchurl, boost, cmake, curl, leatherman, libyamlcpp, openssl, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.1.5";
  src = fetchurl {
    url = "https://downloads.puppetlabs.com/facter/${name}.tar.gz";
    sha256 = "0k2k92y42zb6vf542zwkhvg15kv32yb4zvw6nlcqlgmyg19c5qmv";
  };

  buildInputs = [ boost cmake curl leatherman libyamlcpp openssl utillinux ];

  meta = with stdenv.lib; {
    homepage = https://github.com/puppetlabs/facter;
    description = "A system inventory tool";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
