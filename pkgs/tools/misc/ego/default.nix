{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, acl
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "ego";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "intgr";
    repo = "ego";
    rev = version;
    hash = "sha256-613RM7Ldye0wHAH3VMhzhyT5WVTybph3gS/WNMrsgGI=";
  };

  buildInputs = [ acl ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  cargoHash = "sha256-3leKejQ8kxamjwQPH1vg2I1CYc3r8k3pYfTWpOkqq8I=";

  # requires access to /root
  checkFlags = [
    "--skip tests::test_check_user_homedir"
  ];

  postInstall = ''
    wrapProgram $out/bin/ego --prefix PATH : ${lib.makeBinPath [ xorg.xhost ]}
  '';

  meta = {
    description = "Run Linux desktop applications under a different local user";
    homepage = "https://github.com/intgr/ego";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "ego";
  };
}
