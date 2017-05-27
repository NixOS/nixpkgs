{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "fsql-${version}";
  version = "0.1.0";

  goPackagePath = "github.com/kshvmdn/fsql";

  src = fetchgit {
    rev = "v${version}";
    url = "https://github.com/kshvmdn/fsql";
    sha256 = "1wkf9rr6x4b5bvxj9zwfw9hd870c831j7mc6fvd448id653wh122";
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
