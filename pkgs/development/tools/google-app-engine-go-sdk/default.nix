{ stdenv, fetchzip, python27, python27Packages }:

assert stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin";

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

  buildInputs = with python27Packages; [
    (python27.withPackages(ps: [ cffi cryptography pyopenssl ]))
  ];

  installPhase = ''
    mkdir -p $out/bin $out/share/
    cp -r "$src" "$out/share/go_appengine"

    # create wrappers with correct env
    for i in goapp appcfg.py; do
      ln -s "$out/share/go_appengine/$i" "$out/bin/$i"
    done
  '';

  meta = with stdenv.lib; {
    description = "Google App Engine SDK for Go";
    version = version;
    homepage = "https://cloud.google.com/appengine/docs/go/";
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ lufia ];
  };
}
