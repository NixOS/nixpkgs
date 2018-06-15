{ stdenv, fetchFromGitHub, pkgconfig, curl, openssl, fuse, libxml2, json_c, file }:

stdenv.mkDerivation rec {
  name = "hubicfuse-${version}";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "TurboGit";
    repo = "hubicfuse";
    rev = "v${version}";
    sha256 = "1x988hfffxgvqxh083pv3lj5031fz03sbgiiwrjpaiywfbhm8ffr";
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
