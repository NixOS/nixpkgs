{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, glib, libcap, libseccomp }:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "09vfa26a6cxyswpjv4chx602k9xq2nqx8a5jzvpiryyk7iq3h2hk";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ libcap libseccomp glib ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/rootless-containers/slirp4netns";
    description = "User-mode networking for unprivileged network namespaces";
    license = licenses.gpl2;
    maintainers = with maintainers; [ orivej saschagrunert ];
    platforms = platforms.linux;
  };
}
