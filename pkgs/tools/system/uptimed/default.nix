{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "uptimed";
  version = "0.4.2";

  src = fetchFromGitHub {
    sha256 = "0wnnpjfxnycigqj6hag0n6p5piss8cv40y9jda72d9s4df5n91z8";
    rev = "v${version}";
    repo = "uptimed";
    owner = "rpodgorny";
  };

  nativeBuildInputs = [ autoreconfHook ];
  patches = [ ./no-var-spool-install.patch ];

  meta = with stdenv.lib; {
    description = "Uptime record daemon";
    longDescription = ''
      An uptime record daemon keeping track of the highest uptimes a computer
      system ever had. It uses the system boot time to keep sessions apart from
      each other. Uptimed comes with a console front-end to parse the records,
      which can also easily be used to show your records on a web page.
    '';
    homepage = "https://github.com/rpodgorny/uptimed/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };

}
