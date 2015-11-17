{ stdenv, fetchFromGitHub, autoreconfHook }:

let version = "0.3.18"; in
stdenv.mkDerivation {
  name = "uptimed-${version}";
  
  src = fetchFromGitHub {
    sha256 = "108h8ck8cyzvf3xv23vzyj0j8dffdmwavj6nbn9ryqhqhqmk4fhb";
    rev = "v${version}";
    repo = "uptimed";
    owner = "rpodgorny";
  };

  meta = with stdenv.lib; {
    description = "Uptime record daemon";
    longDescription = ''
      An uptime record daemon keeping track of the highest uptimes a computer
      system ever had. It uses the system boot time to keep sessions apart from
      each other. Uptimed comes with a console front-end to parse the records,
      which can also easily be used to show your records on a web page.
    '';
    homepage = https://github.com/rpodgorny/uptimed/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

  patches = [ ./no-var-spool-install.patch ];

  buildInputs = [ autoreconfHook ];
}
