{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "boost-build-${version}";
  version = "2016.03";

  src = fetchFromGitHub {
    owner = "boostorg";
    repo = "build";
    rev = version;
    sha256 = "1qw5marmp7z09nwcjlqrmqdg9b6myfqj3zvfz888x9mbidrmhn6p";
  };

  hardeningDisable = [ "format" ];

  patchPhase = ''
    grep -r '/usr/share/boost-build' \
      | awk '{split($0,a,":"); print a[1];}' \
      | xargs sed -i "s,/usr/share/boost-build,$out/share/boost-build,"
  '';

  buildPhase = ''
    ./bootstrap.sh
  '';

  installPhase = ''
    ./b2 install --prefix=$out
  '';

  meta = with stdenv.lib; {
    homepage = http://www.boost.org/boost-build2/;
    license = stdenv.lib.licenses.boost;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
