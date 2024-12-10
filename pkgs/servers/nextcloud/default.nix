{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  nixosTests,
  nextcloud28Packages,
  nextcloud29Packages,
  nextcloud30Packages,
  nodejs,
}:

let
  generic =
    {
      version,
      hash,
      npmHash,
      eol ? false,
      extraVulnerabilities ? [ ],
      packages,
    }:
    stdenv.mkDerivation (finalAttrs: {
      pname = "nextcloud";
      inherit version;

      src = fetchFromGitHub {
        owner = "nextcloud";
        repo = "server";
        rev = "refs/tags/v${version}";
        inherit hash;
        fetchSubmodules = true;
      };

      nativeBuildInputs = [ nodejs ];

      npmDeps = fetchNpmDeps {
        inherit (finalAttrs) src;
        name = "${finalAttrs.pname}-npm-deps";
        hash = npmHash;
      };

      passthru = {
        tests = lib.filterAttrs (
          key: _: (lib.hasSuffix (lib.versions.major version) key)
        ) nixosTests.nextcloud;
        inherit packages;
      };

      installPhase = ''
        runHook preInstall
        mkdir -p $out/
        cp -R . $out/
        runHook postInstall
      '';

      meta = {
        changelog = "https://nextcloud.com/changelog/#${lib.replaceStrings [ "." ] [ "-" ] version}";
        description = "Sharing solution for files, calendars, contacts and more";
        homepage = "https://nextcloud.com";
        maintainers = with lib.maintainers; [
          schneefux
          bachp
          globin
          ma27
        ];
        license = lib.licenses.agpl3Plus;
        platforms = lib.platforms.linux;
        knownVulnerabilities =
          extraVulnerabilities ++ (lib.optional eol "Nextcloud version ${version} is EOL");
      };
    });
in
{
  nextcloud28 = generic {
    version = "28.0.12";
    hash = "sha256-YPqSc2xVw9e2ET9+VIaoSoo8L8SeuNFLUyq7Sj5RHhI=";
    npmHash = "sha256-hZTfEZh1kT/n03wITxsHSM3COpwohIYAHtSf1N3iL4M=";
    packages = nextcloud28Packages;
  };

  nextcloud29 = generic {
    version = "29.0.9";
    hash = "sha256-Vo8DTiv7IZaYhsa5T6AQtfXi2yRn444fXCfL7xPgXDo=";
    npmHash = "sha256-InXHrwBbK+vS6ybx2tSNZ5+o7joniWSTsOfUvmYQoMU=";
    packages = nextcloud29Packages;
  };

  nextcloud30 = generic {
    version = "30.0.2";
    hash = "sha256-9slpR8n/sx/CS5QUtSnZZJEeSjn6pkKHCS8SwSb92RI=";
    npmHash = "sha256-62/3TFu2z0xoqZTqqamrSscVQReh9bVjEHLGq5E0u4A=";
    packages = nextcloud30Packages;
  };
}
