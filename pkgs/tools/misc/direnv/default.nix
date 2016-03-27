{ fetchurl, stdenv, go }:

stdenv.mkDerivation rec {
  name = "direnv-${version}";
  version = "2.8.0";

  src = fetchurl {
    url = "http://github.com/zimbatm/direnv/archive/v${version}.tar.gz";
    name = "direnv-${version}.tar.gz";
    sha256 = "1l1kvjgpak7cc9s37qipfw6lybb4650zwd8kcdagm409gs89mil6";
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
    maintainers = [ stdenv.lib.maintainers.zimbatm ];
    platforms = go.meta.platforms;
  };
}
