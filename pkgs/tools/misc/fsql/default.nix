{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "fsql-${version}";
  version = "0.1.1";

  goPackagePath = "github.com/kshvmdn/fsql";

  src = fetchgit {
    rev = "refs/tags/v${version}";
    url = "https://github.com/kshvmdn/fsql";
    sha256 = "1zvblhfd15l86dcx0p12yrc2rrmfdpzyd107508pb72r2ar638vh";
  };

  meta = with stdenv.lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = https://github.com/kshvmdn/fsql;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
    inherit version;
  };

}
