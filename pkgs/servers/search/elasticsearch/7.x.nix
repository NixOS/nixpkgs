{ elk7Version
, enableUnfree ? true
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, utillinux, gnugrep, coreutils
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
      x86_64-linux  = "07w6lvbapirpvpl5wa33fdzykg74hk8zyv97zs3if4zqj78kcwsg";
      x86_64-darwin = "1ph2nv8dbr73zwvf5slzs2900sky5jjafif0gvdh2lj173ph12ic";
    }
    else {
      x86_64-linux  = "1idxlb14kspqvms9n1r3pc1ff4q4pj632433fm2dwiaslyvyv7kq";
      x86_64-darwin = "0knjk01fliklv863l5dg1j3ps3pqf4gykya8p6ry97879p5pjvcr";
    };
in
stdenv.mkDerivation (rec {
  version = elk7Version;
  name = "elasticsearch-${optionalString (!enableUnfree) "oss-"}${version}";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
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
      --prefix PATH : "${makeBinPath [ utillinux coreutils gnugrep ]}" \
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
