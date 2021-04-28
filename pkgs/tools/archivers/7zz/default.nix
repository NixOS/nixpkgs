{ lib, stdenv, fetchurl, autoPatchelfHook }:

let platform =       if stdenv.isi686    then "x86"
                else if stdenv.isx86_64  then "x64"
                else if stdenv.isAarch32 then "arm"
                else if stdenv.isAarch64 then "arm64"
                else throw "Unsupported architecture";

    url = "https://7-zip.org/a/7z2101-linux-${platform}.tar.xz";

    hashes = {
      x86 = "0k6vg85ld8i2pcv5sv3xbvf3swqh9qj8hf2jcpadssys3yyidqyj";
      x64 = "1yfanx98fizj8d2s87yxgsy30zydx7h5w9wf4wy3blgsp0vkbjb3";
      arm = "04iah9vijm86r8rbkhxig86fx3lpag4xi7i3vq7gfrlwkymclhm1";
      arm64 = "0a26ginpb22aydcyvffxpbi7lxh4sgs9gb6cj96qqx7cnf7bk2ri";
    };
    sha256 = hashes."${platform}";

in stdenv.mkDerivation {
  pname = "7zz";
  version = "21.01";

  src = fetchurl { inherit url sha256; };
  sourceRoot = ".";

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D -t $out/bin 7zz
    runHook postInstall
  '';

  meta = with lib; {
    description = "Command line archiver utility";
    homepage = "https://www.7-zip.org";

    # source not released yet. will be under LGPL 2.1+ with RAR exception
    license = licenses.unfree;

    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    maintainers = with maintainers; [ anna328p ];
  };
}
