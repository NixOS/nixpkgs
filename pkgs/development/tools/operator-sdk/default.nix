{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s59rgr0ssics1487mvx0h37zs7dfjimsvkbs2d8wqc3r8asw0g4";
  };

  vendorSha256 = "0xvjsiaa3qvlix1fm07z080vh79wg0xyx2s6jqnqn7fb3nh65kn7";

  doCheck = false;

  subPackages = [ "cmd/operator-sdk" ];

  buildInputs = [ go makeWrapper ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;
  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding.";
    homepage = "https://github.com/operator-framework/operator-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
