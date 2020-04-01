{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "1.1.0";
  pname = "2fa";

  goPackagePath = "rsc.io/2fa";

  src = fetchFromGitHub {
    owner = "rsc";
    repo = "2fa";
    rev = "v${version}";
    sha256 = "0827vl2bxd6m2rbj00x7857cs7cic3mlg5nlhqzd0n73dm5vk2za";
  };

  meta = with stdenv.lib; {
    homepage = "https://rsc.io/2fa";
    description = "Two-factor authentication on the command line";
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs ];
    license = licenses.bsd3;
  };
}
