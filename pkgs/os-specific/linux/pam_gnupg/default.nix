{ stdenv, fetchFromGitHub, autoreconfHook, pam, gnupg }:

stdenv.mkDerivation rec {
  pname = "pam_gnupg";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "cruegge";
    repo = "pam-gnupg";
    rev = "v${version}";
    sha256 = "0b70mazyvcbg6xyqllm62rwhbz0y94pcy202db1qyy4w8466bhsw";
  };

  configureFlags = [
    "--with-moduledir=${placeholder "out"}/lib/security"
  ];

  buildInputs = [ pam gnupg ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Unlock GnuPG keys on login";
    longDescription = ''
      A PAM module that hands over your login password to gpg-agent. This can
      be useful if you are using a GnuPG-based password manager like pass.
    '';
    homepage = "https://github.com/cruegge/pam-gnupg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mtreca ];
  };
}
