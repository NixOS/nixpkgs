{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zLHP6PI2YeW1Fn6OPuMaiAPHOdudfKO4YP3XTh9HXNc=";
  };

  vendorSha256 = "sha256-7Qy7Akp/yP+XbxVQhQuUd1FZ504A3a2BLbHI3eglIqk=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
  };
}
