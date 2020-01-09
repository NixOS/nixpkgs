{ stdenv, fetchgit, autoreconfHook, gnupg, pam } :

stdenv.mkDerivation rec {
  pname = "pam_gnupg";
  version = "unstable-2019-12-06";

  src = fetchgit {
    url = https://github.com/cruegge/pam-gnupg;
    rev = "fbd75b720877e4cf94e852ce7e2b811feb330bb5";
    sha256 = "0kqn6xb85jfmhvvbd2lasnci46p2pcwy0wq233za9h7xwfr49f7d";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ gnupg pam ];

  preAutoreconf = ''
    mkdir m4
  '';

  configurePhase = ''
    ./configure --prefix=$out --with-moduledir=$out/lib/security
  '';

  meta = with stdenv.lib; {
    description = "A PAM plugin to preset GPG passphrases on login";
    homepage = "https://github.com/cruegge/pam-gnupg/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
