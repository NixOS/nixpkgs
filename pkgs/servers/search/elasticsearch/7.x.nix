{ elk7Version
, enableUnfree ? true
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, utillinux
, autoPatchelfHook
, zlib
}:

with stdenv.lib;
let
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      "x86_64-linux"  = "1fi57xqwgxx0ivjyfvaybzz2k457qw59fn9qr26d86lnkigfxpk8";
      "x86_64-darwin" = "06hj96d4vl9q24dfx8ffydfs7qd440ys29654jgqp8sp7js7hjxp";
    }
    else {
      "x86_64-linux"  = "1jrcdxm1swf8ahkv3h7kyzzhdq9nwwfhimpflzdq2d831fx525y8";
      "x86_64-darwin" = "119ym2d5fqwba3aq2izh5qj8vxawb7hf183cgg00s1sm1mm8lviv";
    };
in
stdenv.mkDerivation (rec {
  version = elk7Version;
  name = "elasticsearch-${optionalString (!enableUnfree) "oss-"}${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
  };

  patches = [ ./es-home-6.x.patch ];

  postPatch = ''
    substituteInPlace bin/elasticsearch-env --replace \
      "ES_CLASSPATH=\"\$ES_HOME/lib/*\"" \
      "ES_CLASSPATH=\"$out/lib/*\""

    substituteInPlace bin/elasticsearch-cli --replace \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:\$ES_HOME/\$additional_classpath_directory/*\"" \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:$out/\$additional_classpath_directory/*\""
  '';

  buildInputs = [ makeWrapper jre_headless utillinux ]
             ++ optional enableUnfree zlib;

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod +x $out/bin/*

    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${utillinux}/bin/" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/elasticsearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  passthru = { inherit enableUnfree; };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
} // optionalAttrs enableUnfree {
  dontPatchELF = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  runtimeDependencies = [ zlib ];
  postFixup = ''
    for exe in $(find $out/modules/x-pack-ml/platform/linux-x86_64/bin -executable -type f); do
      echo "patching $exe..."
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$exe"
    done
  '';
})
