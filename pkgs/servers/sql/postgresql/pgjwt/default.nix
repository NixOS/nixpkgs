{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "pgjwt-${version}";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "michelp";
    repo = "pgjwt";
    rev = "12a41eef15e6d3a22399e03178560d5174d496a3";
    sha256 = "1dgx7kqkf9d7j5qj3xykx238xm8jg0s6c8h7zyl4lx8dmbz9sgsv";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin  # current postgresql extension mechanism in nixos requires bin directory
    mkdir -p $out/share/extension
    cp pg*sql *.control $out/share/extension
  '';
  meta = with stdenv.lib; {
    description = "PostgreSQL implementation of JSON Web Tokens";
    longDescription = ''
      sign() and verify() functions to create and verify JSON Web Tokens.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [spinus];
  };
}
