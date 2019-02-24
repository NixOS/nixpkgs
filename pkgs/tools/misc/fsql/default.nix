{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fsql-${version}";
  version = "0.3.1";

  goPackagePath = "github.com/kshvmdn/fsql";

  src = fetchFromGitHub {
    owner = "kshvmdn";
    repo = "fsql";
    rev = "v${version}";
    sha256 = "1accpxryk4744ydfrqc3la5k376ji11yr84n66dz5cx0f3n71vmz";
  };

  meta = with stdenv.lib; {
    description = "Search through your filesystem with SQL-esque queries";
    homepage = https://github.com/kshvmdn/fsql;
    license = licenses.mit;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.unix;
    inherit version;
  };

}
