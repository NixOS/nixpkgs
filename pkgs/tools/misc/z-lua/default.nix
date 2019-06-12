{ stdenv, fetchFromGitHub, lua }:

stdenv.mkDerivation rec {
  pname = "z-lua";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "skywind3000";
    repo = "z.lua";
    rev = "v${version}";
    sha256 = "01n4x84rpmyjyfga90s2s63gdk17z944hz35fk95qnshc5fapfq8";
  };

  dontBuild = true;

  buildInputs = [ lua ];

  installPhase = ''
    install -Dm755 z.lua $out/bin/z
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/skywind3000/z.lua;
    description = "A new cd command that helps you navigate faster by learning your habits";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
