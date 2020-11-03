{ buildGoModule, go, lib, fetchFromGitHub, makeWrapper }:

buildGoModule rec {
  pname = "operator-sdk";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "operator-framework";
    repo = pname;
    rev = "v${version}";
    sha256 = "11xlay3sk5nr9pfbqifcrfi5h81qnhs3hg5b75zgqysgr4d2m987";
  };

  vendorSha256 = "1bbj23rwghqfw9vsgj9i9zrxvl480adsmjg1zb06cdhh5j1hl0vy";

  doCheck = false;

  subPackages = [ "cmd/operator-sdk" ];

  buildInputs = [ go makeWrapper ];

  # operator-sdk uses the go compiler at runtime
  allowGoReference = true;
  postFixup = ''
    wrapProgram $out/bin/operator-sdk --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = with lib; {
    description = "SDK for building Kubernetes applications. Provides high level APIs, useful abstractions, and project scaffolding";
    homepage = "https://github.com/operator-framework/operator-sdk";
    license = licenses.asl20;
    maintainers = with maintainers; [ arnarg ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
