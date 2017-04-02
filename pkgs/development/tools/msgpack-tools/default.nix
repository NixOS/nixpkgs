{ stdenv, fetchurl, fetchFromGitHub, cmake, unzip }:
stdenv.mkDerivation rec {
  name = "msgpack-tools-${version}";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "ludocode";
    repo = "msgpack-tools";
    rev = "v${version}";
    sha256 = "1ygjk25zlpqjckxgqmahnz999704zy2bd9id6hp5jych1szkjgs5";
  };

  libb64 = fetchurl {
    url = "mirror://sourceforge/libb64/libb64-1.2.1.zip";
    sha256 = "1chlcc8qggzxnbpy5wrda533xyz38dk20w9wl4srrzawm45ny410";
  };

  rapidjson = fetchurl {
    url = "https://github.com/miloyip/rapidjson/archive/99ba17bd66a85ec64a2f322b68c2b9c3b77a4391.tar.gz";
    sha256 = "0jxgyy5n0lf9w36dycwwgz2wici4z9dnxlsn0z6m23zaa47g3wyw";
  };

  mpack = fetchurl {
    url = "https://github.com/ludocode/mpack/archive/df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz";
    sha256 = "1br8g3rf86h8z8wbqkd50aq40953862lgn0xk7cy68m07fhqc3pg";
  };

  postUnpack = ''
    mkdir $sourceRoot/contrib
    cp ${rapidjson} $sourceRoot/contrib/rapidjson-99ba17bd66a85ec64a2f322b68c2b9c3b77a4391.tar.gz
    cp ${libb64} $sourceRoot/contrib/libb64-1.2.1.zip
    cp ${mpack} $sourceRoot/contrib/mpack-df17e83f0fa8571b9cd0d8ccf38144fa90e244d1.tar.gz
  '';


  buildInputs = [ cmake unzip ];

  meta = with stdenv.lib; {
    description = "Command-line tools for converting between MessagePack and JSON";
    homepage = https://github.com/ludocode/msgpack-tools;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ alibabzo ];
  };
}
