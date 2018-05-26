{ stdenv, fetchgit, autoreconfHook, libcap }:

stdenv.mkDerivation rec {
  name = "torsocks-${version}";
  version = "2.2.0";

  src = fetchgit {
    url    = meta.repositories.git;
    rev    = "refs/tags/v${version}";
    sha256 = "1xwkmfaxhhnbmvp37agnby1n53hznwhvx0dg1hj35467qfx985zc";
  };

  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    # Patch torify_app()
    sed -i \
      -e 's,\(local app_path\)=`which $1`,\1=`type -P $1`,' \
      -e 's,\(local getcap\)=.*,\1=${libcap}/bin/getcap,' \
      src/bin/torsocks.in
  '';

  doInstallCheck = true;
  installCheckTarget = "check-recursive";

  meta = {
    description      = "Wrapper to safely torify applications";
    homepage         = https://github.com/dgoulet/torsocks;
    repositories.git = https://git.torproject.org/torsocks.git;
    license          = stdenv.lib.licenses.gpl2;
    platforms        = stdenv.lib.platforms.unix;
    maintainers      = with stdenv.lib.maintainers; [ phreedom thoughtpolice ];
  };
}
