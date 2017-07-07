{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-${version}";
  version = "0.9";

  goPackagePath = "github.com/elves/elvish";

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = version;
    sha256 = "0alsv04iihrk1nffp6fmyzxid26dqhg1k45957c2ymyzyq9cglxj";
  };

  meta = with stdenv.lib; {
    description = "A friendly and expressive Unix shell";
    homepage = https://github.com/elves/elvish;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux;
  };
}
