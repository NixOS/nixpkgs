{ lib, stdenv, fetchFromGitHub, buildGoModule, Cocoa, WebKit }:

buildGoModule rec {
  pname = "unpackerr";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "davidnewhall";
    repo = "unpackerr";
    rev = "v${version}";
    sha256 = "0ss12i8bclz1q9jgr54shvs8zgcs6jrwdm1vj9gvycyd5sx4717s";
  };

  vendorSha256 = "1j79vmf0mkwkqrg5j6fm2b8y3a23y039kbiqkiwb56724bmd27dd";

  buildInputs = lib.optionals stdenv.isDarwin [ Cocoa WebKit ];

  meta = with lib; {
    description = "Extracts downloads for Radarr, Sonarr, Lidarr - Deletes extracted files after import";
    homepage = "https://github.com/davidnewhall/unpackerr";
    maintainers = with maintainers; [ nullx76 ];
    license = licenses.mit;
  };
}
