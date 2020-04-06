{ stdenv, fetchurl, patchelfUnstable }:

with stdenv.lib;

let versions = builtins.fromJSON (builtins.readFile ./versions.json);
    arch = if stdenv.isi686 then "386"
           else if stdenv.isx86_64 then "amd64"
           else if stdenv.isAarch32 then "arm"
           else if stdenv.isAarch64 then "arm64"
           else throw "Unsupported architecture";
    os = if stdenv.isLinux then "linux"
         else if stdenv.isDarwin then "darwin"
         else throw "Unsupported os";
    versionInfo = versions."${os}-${arch}";
    inherit (versionInfo) version sha256 url;

in
stdenv.mkDerivation {
  name = "ngrok-${version}";
  version = version;

  # run ./update
  src = fetchurl { inherit sha256 url; };

  sourceRoot = ".";

  nativeBuildInputs = optionals stdenv.isLinux [ patchelfUnstable ];

  unpackPhase = "cp $src ngrok";

  buildPhase = "chmod a+x ngrok";

  installPhase = ''
    install -D ngrok $out/bin/ngrok
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "ngrok";
    longDescription = ''
      Allows you to expose a web server running on your local machine to the internet.
    '';
    homepage = https://ngrok.com/;
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    maintainers = [ maintainers.bobvanderlinden ];
  };
}
