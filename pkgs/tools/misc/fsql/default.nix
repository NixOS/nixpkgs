{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fsql-${version}";
  version = "0.2.1";

  goPackagePath = "github.com/kshvmdn/fsql";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "1izcfxm77hjj8z7a2nk9bbwbz4wc2yqzs2ir8v3k822m1hvgwb9a";
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
