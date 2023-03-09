{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zfxtop";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ssleert";
    repo = "zfxtop";
    rev = version;
    hash = "sha256-9o32sryffcCt/sBnaT5QzD5oLRfJHgq1yKP8d0pk2JQ=";
  };

  vendorHash = "sha256-H1X7j77Wp8ipgNTMZbFwoSA7NrILahFK8YwoP1W3h2c=";

  meta = with lib; {
    description = "fetch top for gen Z with X written by bubbletea enjoyer";
    homepage = "https://github.com/ssleert/zfxtop";
    license = licenses.bsd2;
    maintainers = with maintainers; [ wozeparrot ];
  };
}
