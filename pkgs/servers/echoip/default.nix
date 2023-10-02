{ lib
, buildGoModule
, fetchFromGitHub
, makeWrapper
}:

buildGoModule {
  pname = "echoip";
  version = "unstable-2021-08-03";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "ffa6674637a5bf906d78ae6675f9a4680a78ab7b";
    sha256 = "sha256-yN7PIwoIi2SPwwFWnHDoXnwvKohkPPf4kVsNxHLpqCE=";
  };

  vendorHash = "sha256-lXYpkeGpBK+WGHqyLxJz7kS3t7a55q55QQLTqtxzroc=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -D html/* -t $out/share/echoip/html
    wrapProgram $out/bin/echoip \
      --add-flags "-t $out/share/echoip/html"
  '';

  doCheck = false;

  meta = with lib; {
    description = "IP address lookup service";
    homepage = "https://github.com/mpolden/echoip";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rvolosatovs SuperSandro2000 ];
  };
}
