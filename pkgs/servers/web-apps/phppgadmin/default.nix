{ stdenv, lib, fetchFromGitHub } :

stdenv.mkDerivation rec {
  pname = "phppgadmin";
  version = "7.13.0";

  src = fetchFromGitHub {
    owner  = "phppgadmin";
    repo   = "phppgadmin";
    rev    = "REL_${builtins.replaceStrings [ "." ] [ "-" ] version}";
    sha256 = "13bnnidzp0q7c6jz7vcfamfi884h8q654n3x3f2b2clfpng0cc0v";
  };

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = with lib; {
    description = "Administration utility for PostgreSQL";
    longDescription = ''
      phpPgAdmin is a fully functional web-based administration utility for a PostgreSQL database server.
      It handles all the basic functionality as well as some advanced features such as triggers, views, and functions (stored procs).
    '';
    homepage = https://github.com/phppgadmin/phppgadmin;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.leonardp ];
  };
}
