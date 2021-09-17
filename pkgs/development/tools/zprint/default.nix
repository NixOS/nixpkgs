{ stdenv, lib, fetchurl, graalvm11-ce, glibcLocales }:

stdenv.mkDerivation rec {
  pname = "zprint";
  version = "1.1.2";

  src = fetchurl {
    url =
      "https://github.com/kkinnear/${pname}/releases/download/${version}/${pname}-filter-${version}";
    sha256 = "1wh8jyj7alfa6h0cycfwffki83wqb5d5x0p7kvgdkhl7jx7isrwj";
  };

  dontUnpack = true;

  LC_ALL = "en_US.UTF-8";
  nativeBuildInputs = [ graalvm11-ce glibcLocales ];

  buildPhase = ''
    native-image \
    --no-server \
    -J-Xmx7G \
    -J-Xms4G \
    -jar ${src} \
    -H:Name=${pname} \
    -H:EnableURLProtocols=https,http \
    -H:+ReportExceptionStackTraces \
    ${lib.optionalString stdenv.isDarwin ''-H:-CheckToolchain''} \
    --report-unsupported-elements-at-runtime \
    --initialize-at-build-time \
    --no-fallback
  '';

  installPhase = ''
    mkdir -p $out/bin
    install ${pname} $out/bin
  '';

  meta = with lib; {
    description = "Clojure/EDN source code formatter and pretty printer";
    longDescription = ''
      Library and command line tool providing a variety of pretty printing capabilities
      for both Clojure code and Clojure/EDN structures. It can meet almost anyone's needs.
      As such, it supports a number of major source code formatting approaches
    '';
    homepage = "https://github.com/kkinnear/zprint";
    license = licenses.mit;
    platforms = graalvm11-ce.meta.platforms;
    maintainers = with maintainers; [ stelcodes ];
  };
}
