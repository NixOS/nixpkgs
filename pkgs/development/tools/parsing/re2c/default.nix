{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "1.0.3";

  sourceRoot = "${src.name}/re2c";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "0grx7nl9fwcn880v5ssjljhcb9c5p2a6xpwil7zxpmv0rwnr3yqi";
  };

  nativeBuildInputs = [ autoreconfHook ];

  preCheck = ''
    patchShebangs run_tests.sh
  '';

  meta = with stdenv.lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "http://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
