{ stdenv, fetchFromGitHub, boost, cmake, cpp-hocon, curl, leatherman, libyamlcpp, openssl, ruby, utillinux }:

stdenv.mkDerivation rec {
  name = "facter-${version}";
  version = "3.5.1";
  src = fetchFromGitHub {
    sha256 = "1rhfww0knjh6bj3b0ykxgfgw6rg2bzibkdrisq3nhl3djfq7r1a8";
    rev = version;
    repo = "facter";
    owner = "puppetlabs";
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
