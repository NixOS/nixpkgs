{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "teler";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "kitabisa";
    repo = "teler";
    rev = "v${version}";
    sha256 = "sha256-6OeGlpimQtw4w26HRzw2wmd3wjASY199p8XXPD/JMy8=";
  };

  vendorSha256 = "sha256-L+wjurURpesCA2IK0r1sxvOUvNJT1wiRp75kpe6LH5s=";

  # test require internet access
  doCheck = false;

  meta = with lib; {
    description = "Real-time HTTP Intrusion Detection";
    longDescription = ''
      teler is an real-time intrusion detection and threat alert
      based on web log that runs in a terminal with resources that
      we collect and provide by the community.
    '';
    homepage = "https://github.com/kitabisa/teler";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
