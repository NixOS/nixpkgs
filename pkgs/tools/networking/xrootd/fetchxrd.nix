{ lib
, runCommandLocal
, buildPlatform
, xrootd
}:

{ name ? ""
, pname ? ""
, version ? ""
, urls ? [ ]
, url ? if urls == [ ] then abort "Expect either non-empty `urls` or `url`" else builtins.head urls
, hash ? lib.fakeHash
}:

(runCommandLocal name
  {
    nativeBuildInputs = [ xrootd ];
    outputHashAlgo = null;
    outputHashMode = "flat";
    outputHash = hash;
    inherit url;
    urls = if urls == [ ] then lib.singleton url else urls;
  }
  ''
    for u in $urls; do
      xrdcp --verbose --force "$u" "$out"
      ret=$?
      (( ret != 0 )) || break
    done
    if (( ret )); then
      echo "xrdcp failed trying to download any of the urls" >&2
      exit $ret
    fi
  '').overrideAttrs (finalAttrs:
if (pname != "" && version != "") then {
  inherit pname version;
  name = "${pname}-${version}";
} else {
  name = if (name != "") then name else (baseNameOf finalAttrs.url);
})
