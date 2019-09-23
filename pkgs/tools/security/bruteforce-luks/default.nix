{ stdenv, fetchFromGitHub, autoreconfHook, cryptsetup }:

stdenv.mkDerivation rec {
  pname = "bruteforce-luks";
  version = "1.3.2";

  src = fetchFromGitHub {
    sha256 = "0ws5bm5pczhvqrlhl60h8a9rdwk6xlh9wr5ndnkyxvv7m90qpy9b";
    rev = version;
    repo = "bruteforce-luks";
    owner = "glv2";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ cryptsetup ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Cracks passwords of LUKS encrypted volumes";
    longDescription = ''
      The program tries to decrypt at least one of the key slots by trying
      all the possible passwords. It is especially useful if you know
      something about the password (i.e. you forgot a part of your password but
      still remember most of it). Finding the password of a volume without
      knowing anything about it would take way too much time (unless the
      password is really short and/or weak). It can also use a dictionary.
    '';
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
