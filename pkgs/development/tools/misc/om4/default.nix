{ stdenv, fetchFromGitHub, bison, flex, lib }:

stdenv.mkDerivation rec {
  pname = "om4";
  version = "6.7";

  src = fetchFromGitHub {
    owner = "ibara";
    repo = "m4";
    rev = "${pname}-${version}";
    sha256 = "04h76hxwb5rs3ylkw1dv8k0kmkzl84ccqlwdwxb6i0x57rrqbgzx";
  };

  strictDeps = true;
  nativeBuildInputs = [ bison flex ];

  configureFlags = [ "--enable-m4" ];

  meta = with lib; {
    description = "Portable OpenBSD m4 macro processor";
    homepage = "https://github.com/ibara/m4";
    license = with licenses; [ bsd2 bsd3 isc publicDomain ];
    mainProgram = "m4";
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
