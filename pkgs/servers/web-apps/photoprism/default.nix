{ lib
, pkgs
, stdenv
, buildGoModule
, fetchzip
, fetchFromGitHub
, coreutils
, darktable
, rawtherapee
, ffmpeg
, libheif
, exiftool
, nodejs
, libtensorflow-bin
}:

let
  version = "2020-09-21";
  pname = "photoprism";

  src = fetchFromGitHub {
    owner = "photoprism";
    repo = pname;
    rev = "d030a602d47cf7279dddc301d74156ca9c21e7ef";
    sha256 = "0gmvl4svcvdqb0y7chsn3dd13iznq4v3ms1rfvqcbrkhpqn3qhpd";
  };

  fetchModel = {name, sha256}:
  fetchzip {
    inherit sha256;
    url = "https://dl.photoprism.org/tensorflow/${name}.zip";
    stripRoot = false;
  };

  nasnet = fetchModel {
    name = "nasnet";
    sha256 = "0qb1sidgpx3a4synl6s4x993clgx8iv1khigbf92fbwrz66bjpbc";
  };

  nsfw = fetchModel {
    name = "nsfw";
    sha256 = "1y4mh7lsjw4syrgfpn6iy4qfqf6a7yi66m7j2lxyc70sd1rcfbyg";
  };

  backend = buildGoModule rec {
    inherit pname version src;
    doCheck = false;
    buildInputs = [
      coreutils
      libtensorflow-bin
    ];
    postPatch = ''
      substituteInPlace internal/commands/passwd.go --replace '/bin/stty' "${coreutils}/bin/stty"
    '';
    vendorSha256 = "12g0fywzqpvnmmz4rkzanvbg2m0aj5qa3q30dwczpqwbyarsg0yl";
  };

  nodeDependencies = (import ./node-composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  }).nodeDependencies;

  frontend = stdenv.mkDerivation {
    name = "photoprism-frontend";
    inherit src;
    buildInputs = [ nodejs ];

    buildPhase = ''
      runHook preBuild

      pushd frontend
      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      export PATH="${nodeDependencies}/bin:$PATH"
      NODE_ENV=production npm run build
      popd

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r assets $out/

      runHook postInstall
    '';
  };

in
stdenv.mkDerivation {

  inherit pname version;

  buildInputs = [
    darktable
    rawtherapee
    ffmpeg
    libheif
    exiftool
  ];

  phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,assets}
    # install backend
    cp ${backend}/bin/photoprism $out/bin/photoprism
    # install frontend
    cp -r ${frontend}/assets $out/
    # install tensorflow models
    cp -r ${nasnet}/nasnet $out/assets
    cp -r ${nsfw}/nsfw $out/assets

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/photoprism/photoprism";
    description = "Personal Photo Management powered by Go and Google TensorFlow ";
    platforms = platforms.linux;
    license = licenses.agpl3;
    maintainers = with maintainers; [ ];
  };
}
