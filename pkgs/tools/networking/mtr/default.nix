{ stdenv, lib, fetchFromGitHub, fetchpatch, autoreconfHook, pkg-config
, libcap, ncurses, jansson
, withGtk ? false, gtk3 }:

stdenv.mkDerivation rec {
  pname = "mtr${lib.optionalString withGtk "-gui"}";
  version = "0.94";

  src = fetchFromGitHub {
    owner = "traviscross";
    repo = "mtr";
    rev = "v${version}";
    sha256 = "0wnz87cr2lcl74bj8qxq9xgai40az3pk9k0z893scyc8svd61xz6";
  };

  patches = [
    # pull patch to fix build failure against ncurses-6.3:
    #  https://github.com/traviscross/mtr/pull/411
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/traviscross/mtr/commit/aeb493e08eabcb4e6178bda0bb84e9cd01c9f213.patch";
      sha256 = "1qk8lf4sha18g36mr84vbdvll2s8khgbzyyq0as3ifx44lv0qlf2";
    })
  ];

  # we need this before autoreconfHook does its thing
  postPatch = ''
    echo ${version} > .tarball-version
  '';

  # and this after autoreconfHook has generated Makefile.in
  preConfigure = ''
    substituteInPlace Makefile.in \
      --replace ' install-exec-hook' ""
  '';

  configureFlags = lib.optional (!withGtk) "--without-gtk";

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ncurses jansson ]
    ++ lib.optional withGtk gtk3
    ++ lib.optional stdenv.isLinux libcap;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A network diagnostics tool";
    homepage = "https://www.bitwizard.nl/mtr/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ koral orivej raskin globin ];
    platforms = platforms.unix;
  };
}
