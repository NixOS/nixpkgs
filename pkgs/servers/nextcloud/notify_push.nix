{ lib, fetchFromGitHub, fetchpatch, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "notify_push";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nextcloud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LkC2mD3klMQRF3z5QuVPcRHzz33VJP+UcN6LxsQXq7Q=";
  };

  cargoHash = "sha256-GZikXM3AvhC2gtwE2wYbGV+aRV+QKothWQG17Vzi2Lc=";

  passthru = {
    test_client = rustPlatform.buildRustPackage {
      pname = "${pname}-test_client";
      inherit src version;

      cargoPatches = [
        # fix test client not being able to connect
        (fetchpatch {
          url = "https://github.com/nextcloud/notify_push/commit/03aa38d917bfcba4d07f72b6aedac6a5057cad81.patch";
          hash = "sha256-dcN62tA05HH1RTvG0puonJjKMQn1EouA8iuz82vh2aU=";
        })
      ];

      buildAndTestSubdir = "test_client";

      cargoHash = "sha256-RALqjI6DlWmfgKvyaH4RiSyqWsIqUyY9f709hOi2ldc=";
    };
  };

  meta = with lib; {
    description = "Update notifications for nextcloud clients";
    homepage = "https://github.com/nextcloud/notify_push";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ajs124 ];
  };
}
