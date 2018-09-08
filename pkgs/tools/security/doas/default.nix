{ stdenv, lib, fetchFromGitHub, bison, pam }:

stdenv.mkDerivation rec {
  name = "doas-${version}";

  version = "6.0";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "OpenDoas";
    rev = "v${version}";
    sha256 = "1j50l3jvbgvg8vmp1nx6vrjxkbj5bvfh3m01bymzfn25lkwwhz1x";
  };

  # otherwise confuses ./configure
  dontDisableStatic = true;

  postPatch = ''
    sed -i '/\(chown\|chmod\)/d' bsd.prog.mk
  '';

  buildInputs = [ bison pam ];

  meta = with lib; {
    description = "Executes the given command as another user";
    homepage = https://github.com/Duncaen/OpenDoas;
    license = licenses.isc;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
