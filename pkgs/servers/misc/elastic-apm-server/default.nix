{ elk6Version
, enableUnfree ? true
, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
}:

with stdenv.lib;
let

  inherit (builtins) elemAt;
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    if enableUnfree
    then {
      "x86-linux" = "0xa7jfsmg6mzw881k7j8rkph586dpcl7afycdds70n43ixrqsp07";
      "x86_64-linux" = "0cw0xqx4zyanhbh6irpkn9anw00navwqnfhzpwxpmkmn7w4lj64b";
      "x86_64-darwin" = "0b15m4j11qirbkq30i7m5xd51jz39ym8qiah18276vc6i7h13zbf";
    }
    else {
      "x86-linux" = "0iq34g4ypbdbwbaiyaicj0zj9c0xdryd6b3y0dxcdbhywjn32a5v";
      "x86_64-linux" = "09nb2n4mn1bp4iprgrks3d2chxsd7a5wzys969vfxxc54y9bhy8x";
      "x86_64-darwin" = "1nr75mygiza6l5v3daqsf2cpb47hkjpv0mnajlhacpf24cvvxlkb";
    };

in stdenv.mkDerivation (rec {
  name = "apm-server-${optionalString (!enableUnfree) "oss-"}${version}";
  version = elk6Version;

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/apm-server/${name}-${plat}-${arch}.tar.gz";
    sha256 = shas."${stdenv.hostPlatform.system}" or (throw "Unknown architecture");
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp apm-server $out/bin
    cp -r apm-server.yml fields.yml kibana $out/share
  '';

  passthru = { inherit enableUnfree; };

  meta = {
    description = "Open Source Application Performance Monitoring";
    license = if enableUnfree then licenses.elastic else licenses.asl20;
    platforms = platforms.unix;
  };
} // optionalAttrs enableUnfree {
  dontPatchELF = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  postFixup = ''
    for exe in $(find $out/bin -executable -type f); do
      echo "patching $exe..."
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$exe"
    done
  '';
})
