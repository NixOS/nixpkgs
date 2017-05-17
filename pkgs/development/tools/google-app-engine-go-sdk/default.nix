{ stdenv, fetchurl, unzip, python27, python27Packages, makeWrapper }:

with python27Packages;

assert stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin";

stdenv.mkDerivation rec {
  name = "google-app-engine-go-sdk-${version}";
  version = "1.9.53";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${version}.zip";
        sha1 = "9152e132bfe00ecc7605ca8b4c233f8656ada8a6";
      }
    else
      fetchurl {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-${version}.zip";
        sha1 = "9f352b81a3f4eb97937c45431a7a955f3ba77fc2";
      };

  buildInputs = [python27 unzip makeWrapper];

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p "$out"
    unzip -d "$out" "$src"

    # create wrappers with correct env
    for i in goapp appcfg.py
	do
        prog="$out/go_appengine/$i"
        wrapper="$out/bin/$i"
        makeWrapper "$prog" "$wrapper" \
            --prefix PATH : "${python27}/bin" \
            --prefix PYTHONPATH : "$(toPythonPath ${cffi}):$(toPythonPath ${cryptography}):$(toPythonPath ${pyopenssl})"
    done
  '';

  meta = with stdenv.lib; {
    description = "Google App Engine SDK for Go";
    version = version;
    homepage = "https://cloud.google.com/appengine/docs/go/";
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
  };
}
