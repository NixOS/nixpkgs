{ stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "caps2esc";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "interception/linux/plugins";
    repo = pname;
    rev = "v${version}";
    sha256 = "10xv56vh5h3lxyii3ni166ddv1sz2pylrjmdwxhb4gd2p5zgl1ji";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/caps2esc";
    description = "Transforming the most useless key ever into the most useful one";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
