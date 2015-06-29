{ stdenv, fetchFromGitHub, scons, lua }:

stdenv.mkDerivation rec {
  version = "1.0.92";
  name = "toluapp-${version}";

  src = fetchFromGitHub {
    owner = "eddieringle";
    repo  = "toluapp";
    rev   = "b1e680dc486c17128a3c21f89db1693ff06c02b1";
    sha256 = "1d1a9bll9825dg4mz71vwykvfd3s5zi2yvzbfsvlr3qz1l3zqfwb";
  };

  buildInputs = [ lua scons ];

  patches = [ ./environ-and-linux-is-kinda-posix.patch ];

  preConfigure = ''
    substituteInPlace config_posix.py \
      --replace /usr/local $out
  '';

  NIX_CFLAGS_COMPILE = "-fPIC";

  buildPhase = ''scons'';

  installPhase = ''scons install'';

  meta = {
    license = stdenv.lib.licenses.mit;
  };

}
