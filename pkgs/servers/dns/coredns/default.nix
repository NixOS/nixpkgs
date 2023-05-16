{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "coredns";
<<<<<<< HEAD
  version = "1.11.0";
=======
  version = "1.10.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Mn8hOsODTlnl6PJaevMcyIKkIx/1Lk2HGA7fSSizR20=";
  };

  vendorHash = "sha256-9LFwrG6RxZaCLxrNabdnq++U5Aw+d2w90Zqt/wszNTY=";
=======
    sha256 = "sha256-/+D/jATZhHSxLPB8RkPLUYAZ3O+/9l8XIhgokXz2SUQ=";
  };

  vendorHash = "sha256-aWmwzIHScIMb3DPzr4eto2yETMgKd/hUy18X8KxQGos=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  outputs = [ "out" "man" ];

  postPatch = ''
    substituteInPlace test/file_cname_proxy_test.go \
      --replace "TestZoneExternalCNAMELookupWithProxy" \
                "SkipZoneExternalCNAMELookupWithProxy"

    substituteInPlace test/readme_test.go \
      --replace "TestReadme" "SkipReadme"
  '' + lib.optionalString stdenv.isDarwin ''
    # loopback interface is lo0 on macos
    sed -E -i 's/\blo\b/lo0/' plugin/bind/setup_test.go
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = with lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}
