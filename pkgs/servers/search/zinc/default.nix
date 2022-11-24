{ lib, stdenv, fetchFromGitHub, pkgs, buildGoModule }:

let
  nodeDependencies = (pkgs.callPackage ./web/default.nix {}).nodeDependencies.override (old: {
    CYPRESS_INSTALL_BINARY = "0";
  });
in
buildGoModule rec {
  pname = "zinc";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "zinclabs";
    repo = pname;
    rev = "e9bd2126489f3f8317ff4f466176f4b811792ced";
    sha256 = "sha256-qu3foI5Rnt2sf+B+roJOwUNvOfawKmcKq7UrmviQsHA=";
  };

  # refresh web packaging by:
  #   git clone zinc
  #   cd zinc/web
  #   node2nix -l ./package-lock.json -d
  #   cp *.nix ~/Dev/custom-nixpkgs/zinc/web/
  web = stdenv.mkDerivation {
    pname = "${pname}-web";
    inherit src version;
    buildInputs = [pkgs.nodejs-18_x];
    buildPhase = ''
      cd web
      export PATH="${nodeDependencies}/bin:$PATH"
      ln -s ${nodeDependencies}/lib/node_modules ./node_modules
      npm run build
    '';
    installPhase = ''
      cp -r dist $out/
    '';
  };

  vendorSha256 = "sha256-akjb0cxHbITKS26c+7lVSHWO/KRoQVVKzAOra+tdAD8=";
  preBuild = ''
    # (can't symlink; "can't embed irregular file")
    cp -rf ${web} web/dist
  '';
  buildPhase = ''
    runHook preBuild
    go build \
      -o zinc \
      -ldflags="-s -w -X github.com/zinclabs/zinc/pkg/meta.Version=${version} -X github.com/zinclabs/zinc/pkg/meta.CommitHash=${src.rev} -X github.com/zinclabs/zinc/pkg/meta.BuildDate=19691231" \
      cmd/zinc/main.go
    runHook postInstall
  '';

  preCheck = ''
    export ZINC_FIRST_ADMIN_USER=admin
    export ZINC_FIRST_ADMIN_PASSWORD=Complexpass#123
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp zinc $out/bin/
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "ZincSearch - A lightweight alternative to elasticsearch that requires minimal resources";
    license = licenses.asl20;
    maintainers = with maintainers; [ mfenniak ];
    platforms = platforms.linux;
  };
}
