{ buildGoModule , fetchFromGitHub , lib
}:
buildGoModule rec {
	pname = "ttfsample";
	version = "0.3.0";

	src = fetchFromGitHub {
		owner = "StefanSchroeder";
		repo = "ttfsample";
		rev = "${version}";
		sha256 = "sha256-qB6n0xaBvjmBOOId4SLjc5Oi59DbtvLdSUw98AZcn0o=";

	};
	vendorSha256 = "sha256-7kse3MYIj3Q0WL/fgR6TFmMGNQUSKuJM7+IqB83rwFY=";
	meta = with lib; {
		description = "Create images of fonts";
		homepage = "https://github.com/StefanSchroeder/ttfsample";
		license = licenses.mit;
		maintainers = with maintainers; [ stefanschroeder ];
		mainProgram = "ttfsample";
	};
}
