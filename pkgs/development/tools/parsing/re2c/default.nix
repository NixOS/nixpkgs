{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "re2c";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "06nvk5sf4vrc2bvpj4vi2xwy3ggv548sn530drz5fi67nhzgga26";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = true;
  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs run_tests.sh
  '';

  meta = with lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "https://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
