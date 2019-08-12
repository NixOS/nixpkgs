{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "slirp4netns-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "0c3hhzm2azaxwdcxln3lhjdmyjlx6jldv4whsr07mviry8kz99m4";
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
