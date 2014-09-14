{ stdenv, fetchurl, scons, boost, gperftools, pcre, snappy
, libyamlcpp, sasl, openssl, libpcap }:

with stdenv.lib;

let version = "2.6.4";
    system-libraries = [
      "pcre"
      "boost"
      "snappy"
      # "stemmer" -- not nice to package yet (no versioning, no makefile, no shared libs)
      "yaml"
      # "v8"
    ] ++ optionals (!stdenv.isDarwin) [ "tcmalloc" ];
    buildInputs = [
      sasl boost boost.lib gperftools pcre snappy
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
    sha256 = "1h4rrgcb95234ryjma3fjg50qsm1bnxjx5ib0c3p9nzmc2ji2m07";
  };

  nativeBuildInputs = [ scons ];
  inherit buildInputs;

  postPatch = ''
    # fix yaml-cpp detection
    sed -i -e "s/\[\"yaml\"\]/\[\"yaml-cpp\"\]/" SConstruct

    # bug #482576
    sed -i -e "/-Werror/d" src/third_party/v8/SConscript

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
