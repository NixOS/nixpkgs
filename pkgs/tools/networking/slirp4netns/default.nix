{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib }:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "079m44l4l0p1c2sbkpzsy6zpv94glwmrc72ip2djcscnaq4b1763";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ glib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/rootless-containers/slirp4netns;
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
  };
}
