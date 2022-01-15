{ buildGoModule
, fetchFromGitHub
, geoclue2-with-demo-agent
, lib
, m4
}:

buildGoModule {
  pname = "localtime";
  version = "unstable-2021-11-23";

  src = fetchFromGitHub {
    owner = "Stebalien";
    repo = "localtime";
    rev = "3e5d6cd64444b2164e87cea03448bfb8eefd6ccd";
    sha256 = "sha256-6uxxPq6abtRqM/R2Fw46ynP9PEkHggTSUymLYlQXQRU=";
  };

  vendorSha256 = "sha256-sf3sL6aO5jSytT2NtBkA3lhg77RIzbYkSC4fkH+cwwk=";

  postPatch = ''
    demoPath="${geoclue2-with-demo-agent}/libexec/geoclue-2.0/demos/agent"
    sed -i localtimed.go -e "s#/usr/lib/geoclue-2.0/demos/agent#$demoPath#"
  '';

  nativeBuildInputs = [ m4 ];

  installPhase = ''
    runHook preInstall
    make PREFIX="$out" install
    runHook postInstall
  '';

  meta = with lib; {
    description = "A daemon for keeping the system timezone up-to-date based on the current location";
    homepage = "https://github.com/Stebalien/localtime";
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
