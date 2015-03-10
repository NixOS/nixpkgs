{ stdenv, fetchurl, scons, boost, gperftools, pcre, snappy
, libyamlcpp, sasl, openssl, libpcap }:

with stdenv.lib;

let version = "2.6.8";
    system-libraries = [
      "pcre"
      "boost"
      "snappy"
      # "stemmer" -- not nice to package yet (no versioning, no makefile, no shared libs)
      "yaml"
      # "v8"
    ] ++ optionals (!stdenv.isDarwin) [ "tcmalloc" ];
    buildInputs = [
      sasl boost gperftools pcre snappy
      libyamlcpp sasl openssl libpcap
    ];

    other-args = concatStringsSep " " ([
      "--ssl"
      "--use-sasl-client"
      "--extrapath=${concatStringsSep "," buildInputs}"
    ] ++ map (lib: "--use-system-${lib}") system-libraries);

in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "01hs65xswggy628hxka2f63qvwz5rfhqlkb05kr20wz1kl6zd5qr";
  };

  nativeBuildInputs = [ scons ];
  inherit buildInputs;

  postPatch = ''
    # fix yaml-cpp detection
    sed -i -e "s/\[\"yaml\"\]/\[\"yaml-cpp\"\]/" SConstruct

    # bug #482576
    sed -i -e "/-Werror/d" src/third_party/v8/SConscript

    # fix inclusion of std::swap
    sed -i '1i #include <algorithm>' src/mongo/shell/linenoise_utf8.h

    # fix environment variable reading
    substituteInPlace SConstruct \
        --replace "Environment( BUILD_DIR" "Environment( ENV = os.environ, BUILD_DIR"
  '';

  buildPhase = ''
    scons all --release ${other-args}
  '';

  installPhase = ''
    mkdir -p $out/lib
    scons install --release --prefix=$out ${other-args}
  '';

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = licenses.agpl3;

    maintainers = with maintainers; [ bluescreen303 offline wkennington ];
    platforms = platforms.unix;
  };
}
