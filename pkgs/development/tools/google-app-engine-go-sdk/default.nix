{ stdenv, fetchzip, python27, python27Packages, makeWrapper }:

with python27Packages;

stdenv.mkDerivation rec {
  name = "google-app-engine-go-sdk-${version}";
  version = "1.9.53";
  src =
    if stdenv.system == "x86_64-linux" then
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${version}.zip";
        sha256 = "04lfwf7ad7gi8xn891lz87b7pr2gyycgpaq96i0cgckrj2awayz2";
      }
    else
      fetchzip {
        url = "https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_darwin_amd64-${version}.zip";
        sha256 = "18hgl4wz3rhaklkwaxl8gm70h7l8k225f86da682kafawrr8zhv4";
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
    homepage = "https://cloud.google.com/appengine/docs/go/";
    license = licenses.asl20;
    platforms = ["x86_64-linux" "x86_64-darwin"];
    maintainers = with maintainers; [ lufia ];
  };
}
