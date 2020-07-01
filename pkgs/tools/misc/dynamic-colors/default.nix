{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "dynamic-colors";
  version = "0.2.2.2";

  src = fetchFromGitHub {
    owner  = "peterhoeg";
    repo   = "dynamic-colors";
    rev    = "v${version}";
    sha256 = "0i63570z9aqbxa8ixh4ayb3akgjdnlqyl2sbf9d7x8f1pxhk5kd5";
  };

  PREFIX = placeholder "out";

  postPatch = ''
    substituteInPlace bin/dynamic-colors \
      --replace /usr/share/dynamic-colors $out/share/dynamic-colors
  '';

  meta = with stdenv.lib; {
    description = "Change terminal colors on the fly";
    homepage    = "https://github.com/peterhoeg/dynamic-colors";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = platforms.unix;
  };
}
