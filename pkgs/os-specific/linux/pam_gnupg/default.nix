{ stdenv, fetchFromGitHub, autoreconfHook, pam, gnupg }:

stdenv.mkDerivation rec {
  pname = "pam-gnupg";
  version = "0.1";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ pam gnupg ];
  installFlags = [ "DESTDIR=$(out)" ];

  src = fetchFromGitHub {
    owner = "cruegge";
    repo = pname;
    rev = "v${version}";
    sha256 = "0b70mazyvcbg6xyqllm62rwhbz0y94pcy202db1qyy4w8466bhsw";
  };
  meta = with stdenv.lib; {
    description = "Unlocks GnuPG keys on login";
    longDescription = ''
      A PAM module that hands over your login password to gpg-agent. This can be useful if you are using a GnuPG-based password manager like pass.
    '';
    homepage = "https://github.com/cruegge/pam-gnupg";

    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.linux;
  };
}
