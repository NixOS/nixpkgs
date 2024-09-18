{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, autoreconfHook
, libcap
}:

stdenv.mkDerivation rec {
  pname = "torsocks";
  version = "2.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "torsocks";
    rev = "v${version}";
    sha256 = "sha256-ocJkoF9LMLC84ukFrm5pzjp/1gaXqDz8lzr9TdG+f88=";
  };

  patches = [
    # fix compatibility with C99
    # https://gitlab.torproject.org/tpo/core/torsocks/-/merge_requests/9
    (fetchpatch {
      url = "https://gitlab.torproject.org/tpo/core/torsocks/-/commit/1171bf2fd4e7a0cab02cf5fca59090b65af9cd29.patch";
      hash = "sha256-qu5/0fy72+02QI0cVE/6YrR1kPuJxsZfG8XeODqVOPY=";
    })
    # tsocks_libc_accept4 only exists on Linux, use tsocks_libc_accept on other platforms
    (fetchpatch {
      url = "https://gitlab.torproject.org/tpo/core/torsocks/uploads/eeec9833512850306a42a0890d283d77/0001-Fix-macros-for-accept4-2.patch";
      hash = "sha256-XWi8+UFB8XgBFSl5QDJ+hLu/dH4CvAwYbeZz7KB10Bs=";
    })
    # no gethostbyaddr_r on darwin
    ./torsocks-gethostbyaddr-darwin.patch
  ];

  postPatch = ''
    # Patch torify_app()
    sed -i \
      -e 's,\(local app_path\)=`which $1`,\1=`type -P $1`,' \
      src/bin/torsocks.in
  '' + lib.optionalString stdenv.isLinux ''
    sed -i \
      -e 's,\(local getcap\)=.*,\1=${libcap}/bin/getcap,' \
      src/bin/torsocks.in
  '';

  nativeBuildInputs = [ autoreconfHook ];

  doInstallCheck = true;
  installCheckTarget = "check-recursive";

  meta = {
    description      = "Wrapper to safely torify applications";
    mainProgram = "torsocks";
    homepage         = "https://gitlab.torproject.org/tpo/core/torsocks";
    license          = lib.licenses.gpl2Plus;
    platforms        = lib.platforms.unix;
    maintainers      = with lib.maintainers; [ thoughtpolice ];
  };
}
