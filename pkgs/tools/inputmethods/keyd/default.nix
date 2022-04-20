{ lib, fetchFromGitHub, stdenv }:

stdenv.mkDerivation rec {
  pname = "keyd";
  version = "2.2.7-beta";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G84NbhG0EjEPCZSbgCKzc2VJ+YcW7QWlniRWqOULemU=";
  };

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=" ];

  meta = with lib; {
    homepage = "https://github.com/rvaiya/keyd";
    description = "A key remapping daemon for linux";
    longDescription = ''
      Keyd has several unique features many of which are traditionally
      only found in custom keyboard firmware like QMK as well as some
      which are unique to keyd.
      It expects a configuration file at /etc/keyd/default.conf. For
      more details check out the homepage.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ taha ];
    platforms = platforms.linux;
  };
}
