{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "iferr-unstable";
  version = "2018-06-15";
  rev = "bb332a3b1d9129b6486c7ddcb7030c11b05cfc88";

  goPackagePath = "github.com/koron/iferr";

  src = fetchFromGitHub {
    inherit rev;

    owner = "koron";
    repo = "iferr";
    sha256 = "1nyqy1sgq2afiama4wy7wap8s03c0hiwwa0f6kwq3y59097rfc0c";
  };

  meta = with lib; {
    description = ''Generate "if err != nil {" block'';
    homepage = https://github.com/koron/iferr;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
