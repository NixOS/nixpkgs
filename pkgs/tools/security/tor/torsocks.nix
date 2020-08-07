{ stdenv, fetchgit, fetchurl, autoreconfHook, libcap }:

stdenv.mkDerivation rec {
  pname = "torsocks";
  version = "2.3.0";

  src = fetchgit {
    url    = meta.repositories.git;
    rev    = "refs/tags/v${version}";
    sha256 = "0x0wpcigf22sjxg7bm0xzqihmsrz51hl4v8xf91qi4qnmr4ny1hb";
  };

  nativeBuildInputs = [ autoreconfHook ];

  patches = stdenv.lib.optional stdenv.isDarwin
    (fetchurl {
       url = "https://trac.torproject.org/projects/tor/raw-attachment/ticket/28538/0001-Fix-macros-for-accept4-2.patch";
       sha256 = "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0";
     });

  postPatch = ''
    # Patch torify_app()
    sed -i \
      -e 's,\(local app_path\)=`which $1`,\1=`type -P $1`,' \
      src/bin/torsocks.in
  '' + stdenv.lib.optionalString stdenv.isLinux ''
    sed -i \
      -e 's,\(local getcap\)=.*,\1=${libcap}/bin/getcap,' \
      src/bin/torsocks.in
  '';

  doInstallCheck = true;
  installCheckTarget = "check-recursive";

  meta = {
    description      = "Wrapper to safely torify applications";
    homepage         = "https://github.com/dgoulet/torsocks";
    repositories.git = "https://git.torproject.org/torsocks.git";
    license          = stdenv.lib.licenses.gpl2;
    platforms        = stdenv.lib.platforms.unix;
    maintainers      = with stdenv.lib.maintainers; [ phreedom thoughtpolice ];
  };
}
