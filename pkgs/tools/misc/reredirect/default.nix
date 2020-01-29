{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "reredirect";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "jerome-pouiller";
    repo = "reredirect";
    rev = "v${version}";
    sha256 = "0aqzs940kwvw80lhkszx8spcdh9ilsx5ncl9vnp611hwlryfw7kk";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    substituteInPlace ${placeholder "out"}/bin/relink \
      --replace "reredirect" "${placeholder "out"}/bin/reredirect"
  '';

  meta = with stdenv.lib; {
    description = "Tool to dynamicly redirect outputs of a running process";
    homepage = "https://github.com/jerome-pouiller/reredirect";
    license = licenses.mit;
    maintainers = [ maintainers.tobim ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

