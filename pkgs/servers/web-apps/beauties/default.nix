{ stdenv, buildGoModule, go-bindata, fetchFromGitHub }:

buildGoModule rec {
  pname = "beauties";
  version = "0.0.14.0";

  vendorSha256 = null;
  doCheck = false;

  nativeBuildInputs = [ go-bindata ];

  subPackages = ["cmd/beauties"];

  preBuild = ''
    	go generate github.com/dsx/beauties/cmd/...
  '';

  src = fetchFromGitHub {
    owner = "dsx";
    repo = pname;
    rev = "e27e7f5ce69afe7ce966edd568d9c2ec219f7864";
    sha256 = "1rzi4x8ik4fiwmwfff2pqsb7nsvjncwbrikqnzzqi9dv4jwraymh";
  };

  meta = with stdenv.lib; {
    description = "Essential personal Internet services (pastebin, file upload, etc.)";
    homepage = "https://github.com/dsx/beauties";
    license = licenses.mit;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
