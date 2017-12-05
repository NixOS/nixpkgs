{ stdenv, fetchzip, python27, python27Packages, makeWrapper }:

with python27Packages;

stdenv.mkDerivation rec {
  name = "google-app-engine-go-sdk-${version}";
  version = "1.9.55";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${version}.zip";
        sha256 = "1gwrmqs69h3wbx6z0a7shdr8gn1qiwrkvh3pg6mi7dybwmd1x61h";
      }
    else
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-${version}.zip";
        sha256 = "0b8r2fqg9m285ifz0jahd4wasv7cq61nr6p1k664w021r5y5lbvr";
      };

  buildInputs = [python27 makeWrapper];

  installPhase = ''
    mkdir -p $out/bin $out/share/
    cp -r "$src" "$out/share/go_appengine"

    # create wrappers with correct env
    for i in goapp appcfg.py; do
      makeWrapper "$out/share/go_appengine/$i" "$out/bin/$i" \
        --prefix PATH : "${python27}/bin" \
        --prefix PYTHONPATH : "$(toPythonPath ${cffi}):$(toPythonPath ${cryptography}):$(toPythonPath ${pyopenssl})"
    done
  '';

  meta = with stdenv.lib; {
    description = "Google App Engine SDK for Go";
    version = version;
    homepage = https://cloud.google.com/appengine/docs/go/;
    license = licenses.asl20;
    platforms = ["x86_64-linux" "x86_64-darwin"];
    maintainers = with maintainers; [ lufia ];
  };
}
