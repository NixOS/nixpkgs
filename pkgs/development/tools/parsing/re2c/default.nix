{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, python3
}:

stdenv.mkDerivation rec {
  pname = "re2c";
  version = "2.2";

  src = fetchFromGitHub {
    owner  = "skvadrik";
    repo   = "re2c";
    rev    = version;
    sha256 = "0snfxk1cf2f4dy4hcxd1fx1grav3di0qjgqqn97k85zsf9f6ys78";
  };

  nativeBuildInputs = [
    autoreconfHook
    python3
  ];

  doCheck = true;
  enableParallelBuilding = true;

  preCheck = ''
    patchShebangs run_tests.py
  '';

  meta = with lib; {
    description = "Tool for writing very fast and very flexible scanners";
    homepage    = "https://re2c.org";
    license     = licenses.publicDomain;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
