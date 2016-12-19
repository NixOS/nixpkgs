{ stdenv, fetchFromGitHub, gnused, perl, libgcrypt, zlib, bzip2 }:

stdenv.mkDerivation rec {
  name = "munge-0.5.11";

  src = fetchFromGitHub {
    owner = "dun";
    repo = "munge";
    rev = "${name}";
    sha256 = "02847p742nq3cb8ayf5blrdicybq72nfsnggqkxr33cpppmsfwg9";
  };

  buildInputs = [ gnused perl libgcrypt zlib bzip2 ];

  preConfigure = ''
    # Remove the install-data stuff, since it tries to write to /var
    sed -i '505,511d' src/etc/Makefile.in
  '';

  configureFlags = [
    "--localstatedir=/var"
  ];

  meta = {
    description = ''
      An authentication service for creating and validating credentials
    '';
    maintainers = [ stdenv.lib.maintainers.rickynils ];
    platforms = stdenv.lib.platforms.unix;
  };
}
