{ stdenv, fetchFromGitHub, autoreconfHook, pkg-config, glib, libcap, libseccomp }:

stdenv.mkDerivation rec {
  pname = "slirp4netns";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "rootless-containers";
    repo = "slirp4netns";
    rev = "v${version}";
    sha256 = "1932q80s6187k4fsvgia5iwc9lqsdkxzqqwpw1ksy0mx8wzmwbih";
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
