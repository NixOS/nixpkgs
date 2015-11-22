{ stdenv, fetchgit, libxcb }:

stdenv.mkDerivation rec {
  name = "wmutils-opt-${version}";
  version = "2015-08-01";

  src = fetchgit {
    url = "git://github.com/wmutils/opt.git";
    rev = "00fb88f80f2c42cdd664dc678430e77587cd392c";
    sha256 = "0938dnx9ql0b91igw9j59grfcjhgn7s31pdvb1ixfs6w4d2g1kcr";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Optional addons to wmutils";
    homepage = https://github.com/wmutils/opt;
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
