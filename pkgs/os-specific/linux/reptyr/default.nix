{stdenv, fetchgit}:
stdenv.mkDerivation rec {
  version = "0.4";
  name = "reptyr-${version}";
  src = fetchgit {
    url = "https://github.com/nelhage/reptyr.git";
    rev = "refs/tags/${name}";
    sha256 = "2d2814c210e4bde6f9bcf3aa20477287d7e4a5aa7ee09110b37d2eaaf7e5ecae";
  };
  makeFlags = ["PREFIX=$(out)"];
  meta = {
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [raskin];
    license = stdenv.lib.licenses.mit;
    description = ''A Linux tool to change controlling pty of a process'';
  };
}
