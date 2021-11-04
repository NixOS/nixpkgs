{ lib
, fetchFromGitHub
, buildPerlPackage
, perlPackages
}:

buildPerlPackage rec {
  pname = "innotop";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "innotop";
    repo = "innotop";
    rev = "v${version}";
    sha256 = "6XA+3FwLtlj03so0z54NpOb9GqR5Yi0ZKd7l2ZlHwek=";
  };

  patches = [ ./innotop.patch ];

  outputs = [ "out" ];

  # The script uses usr/bin/env perl and the Perl builder adds PERL5LIB to it.
  # This doesn't work. Looks like a bug in Nixpkgs.
  # Replacing the interpreter path before the Perl builder touches it fixes this.
  postPatch = ''
    patchShebangs .
  '';

  propagatedBuildInputs = with perlPackages; [ DBI DBDmysql TermReadKey ];

  meta = with lib; {
    homepage = "https://github.com/innotop/innotop";
    description = "'top' clone for MySQL with many features and flexibility";
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
  };
}
