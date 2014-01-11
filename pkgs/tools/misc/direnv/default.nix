{ fetchurl, stdenv, go }:

let
  version = "2.2.0";
in
stdenv.mkDerivation {
  name = "direnv-${version}";
  src = fetchurl {
    url = "http://github.com/zimbatm/direnv/archive/v${version}.tar.gz";
    name = "direnv-${version}.tar.gz";
    sha256 = "e718ec2eec4e3a6ff78938445fc9702d7835ccfc8fa90f4293e387ac1305bf98";
  };

  buildInputs = [ go ];

  buildPhase = "make";
  installPhase = "make install DESTDIR=$out";

  meta = {
    description = "a shell extension that manages your environment";
    longDescription = ''
      Once hooked into your shell direnv is looking for an .envrc file in your
      current directory before every prompt.

      If found it will load the exported environment variables from that bash
      script into your current environment, and unload them if the .envrc is
      not reachable from the current path anymore.

      In short, this little tool allows you to have project-specific
      environment variables.
    '';
    homepage = http://direnv.net;
    license = stdenv.lib.licenses.mit;
    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.zimbatm ];
  };
}
