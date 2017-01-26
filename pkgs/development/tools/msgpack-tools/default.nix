{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "msgpack-tools-${version}";
  version = "v0.6";

  src = fetchFromGitHub {
    owner = "ludocode";
    repo = "msgpack-tools";
    rev = version;
    sha256 = "1ygjk25zlpqjckxgqmahnz999704zy2bd9id6hp5jych1szkjgs5";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Command-line tools for converting between MessagePack and JSON";
    homepage = https://github.com/ludocode/msgpack-tools;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ alibabzo ];
  };
}
