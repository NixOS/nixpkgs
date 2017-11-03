{ stdenv, fetchFromGitHub, pkgconfig, curl, openssl, fuse, libxml2, json_c, file }:

stdenv.mkDerivation rec {
  name = "hubicfuse-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "TurboGit";
    repo = "hubicfuse";
    rev = "v${version}";
    sha256 = "1y4n63bk9vd6n1l5psjb9xm9h042kw4yh2ni33z7agixkanajv1s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl openssl fuse libxml2 json_c file ];
  postInstall = ''
    install hubic_token $out/bin
    mkdir -p $out/sbin
    ln -sf $out/bin/hubicfuse $out/sbin/mount.hubicfuse
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/TurboGit/hubicfuse;
    description = "FUSE-based filesystem to access hubic cloud storage";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = [ maintainers.jpierre03 ];
  };
}
