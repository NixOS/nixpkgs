{ stdenv, fetchFromGitHub, wafHook, openssl, boost, pkgconfig,
  python, pythonPackages, libpcap, git, ndn-cxx }:
let
  version = "0.6.4";
in stdenv.mkDerivation {
  name = "ndn-tools-${version}";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-tools";
    rev = "ndn-tools-${version}";
    sha256 = "1sjhyhc9ww38vyf3qmjzh5c4c0jc43ypzjmpqwsbq8y5zzln0gfx";
  };

  buildInputs = [ wafHook libpcap openssl boost pkgconfig python pythonPackages.sphinx git ndn-cxx ];
  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ];
  outputs = [ "out" "dev" "man" ];
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Essential Tools";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
