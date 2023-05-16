{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
<<<<<<< HEAD
    sha256 = "sha256-x/XGatlXCKo9cI92JzFItApsjuZAfZX+8IZRpy7PVUo=";
  };

  vendorHash = "sha256-f0ei/zotOj5ebURAOWUox/7J3jS2abQ5UgjninI9nRk=";
=======
    sha256 = "sha256-qyTfo4Pkp07v575p7SePwe/OfCZRVuHKGyaEQQOkYjk=";
  };

  vendorHash = "sha256-ZQKQY7budLH6eAusLMwSF5cLJ6QdiXLJc29xJk+XBxI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
<<<<<<< HEAD
=======
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
