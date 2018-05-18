{ stdenv, fetchFromGitHub, autoreconfHook, gawk, gnused, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "munge-0.5.13";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "${name}";
    sha256 = "1c4ff3d8ad3inbliszr4slym3b4cn19bn6mxm13mzy20jyi2rm70";
  };

  nativeBuildInputs = [ autoreconfHook gawk gnused ];
  buildInputs = [ libgcrypt zlib bzip2 ];

  preAutoreconf = ''
    # Remove the install-data stuff, since it tries to write to /var
    substituteInPlace src/Makefile.am --replace "etc \\" "\\"
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  meta = with stdenv.lib; {
    description = ''
      An authentication service for creating and validating credentials
    '';
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.rickynils ];
  };
}
