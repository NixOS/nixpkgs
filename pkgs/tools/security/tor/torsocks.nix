{ stdenv, fetchgit, autoreconfHook }:
stdenv.mkDerivation rec {
  pname = "torsocks";
  name = "${pname}-${version}";
  version = "1.3";
  
  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${version}";
    sha256 = "1cqplb36fkdb81kzf48xlxclf64wnp8r56x1gjayax1h6x4aal1w";
  };

  buildInputs = [ autoreconfHook ];
  preConfigure = ''
      export configureFlags="$configureFlags --libdir=$out/lib"
  '';

  meta = {
    description = "use socks-friendly applications with Tor";
    homepage = http://code.google.com/p/torsocks/;
    repositories.git = https://git.torproject.org/torsocks.git;
    license = stdenv.lib.licenses.gpl2;
  };
}
