{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "0.16";

  sourceRoot = "${src.name}/re2c";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "0cijgmbyx34nwl2jmsswggkgvzy364871rkbxz8biq9x8xrhhjw5";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
