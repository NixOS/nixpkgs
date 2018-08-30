{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "re2c-${version}";
  version = "1.1";

  sourceRoot = "${src.name}/re2c";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "0rh5ww0pzzjkg6f42l0hjdy76dkrqxc0majbybwaay4gqsfhiadx";
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
