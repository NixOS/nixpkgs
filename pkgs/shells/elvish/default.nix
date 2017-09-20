{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "elvish-${version}";
  version = "0.10.1";

  postInstall = stdenv.lib.optionalString (stdenv.isDarwin) ''
    install_name_tool -delete_rpath $out/lib $bin/bin/elvish
  '';

  goPackagePath = "github.com/elves/elvish";

  src = fetchFromGitHub {
    repo = "elvish";
    owner = "elves";
    rev = version;
    sha256 = "1xfimsi8piaw42w9dnzfhimix9rz1bygx6m1csign6h4n4b70rr8";
  };

  meta = with stdenv.lib; {
    description = "A friendly and expressive Unix shell";
    homepage = https://github.com/elves/elvish;
    license = licenses.bsd2;
    maintainers = with maintainers; [ vrthra ];
    platforms = with platforms; linux ++ darwin;
  };
}
