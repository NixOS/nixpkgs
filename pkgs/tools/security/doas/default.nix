{ stdenv, lib, fetchFromGitHub, bison, pam }:

stdenv.mkDerivation rec {
  pname = "doas";

  version = "6.6";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "1l563z8dcgc6wcjf03lk4ddqv3g2kvizqdcvkdkpxkgqq9nv9gkb";
  };

  # otherwise confuses ./configure
  dontDisableStatic = true;

  postPatch = ''
    sed -i '/\(chown\|chmod\)/d' bsd.prog.mk
  '';

  buildInputs = [ bison pam ];

  meta = with lib; {
    description = "Executes the given command as another user";
    homepage = "https://github.com/Duncaen/OpenDoas";
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
