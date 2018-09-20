{ elk6Version
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

stdenv.mkDerivation (rec {
  version = elk6Version;
  name = "elasticsearch-${optionalString (!enableUnfree) "oss-"}${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}.tar.gz";
    sha256 =
      if enableUnfree
      then "0hhmpzpgxs8s6vb3yqiyj15nwqq6j12rpw5fyp92qnwpcna55kkg"
      else "0afy6wv2nizqfxnpcfpsdk9pqgsmxpfprpgdng80kjyy2nb6w5mc";
  };

  patches = [ ./es-home-6.x.patch ];

  postPatch = ''
    sed -i "s|ES_CLASSPATH=\"\$ES_HOME/lib/\*\"|ES_CLASSPATH=\"$out/lib/*\"|" ./bin/elasticsearch-env
  '';

  buildInputs = [ makeWrapper jre_headless utillinux ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    chmod -x $out/bin/*.*

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
    for exe in $(find $out/modules/x-pack/x-pack-ml/platform/linux-x86_64/bin -executable -type f); do
      echo "patching $exe..."
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$exe"
    done
  '';
})
