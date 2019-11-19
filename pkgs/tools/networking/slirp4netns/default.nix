{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, libcap, libseccomp }:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "0i0rhb7n2i2nmbvdqdx83vi3kw4r17p7p099sr857cr3f3c221qx";
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
