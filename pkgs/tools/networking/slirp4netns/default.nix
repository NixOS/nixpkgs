{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, libcap, libseccomp }:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "0g7apfw33wkxxj7qwvlnnhv7qy13s1gkbmvns8612c0yfv9jrsvq";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libcap libseccomp glib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/rootless-containers/slirp4netns;
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej saschagrunert ];
    platforms = platforms.linux;
  };
}
