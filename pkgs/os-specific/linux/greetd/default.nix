{ rustPlatform
, lib
, fetchFromSourcehut
, pam
, scdoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "greetd";
  version = "0.8.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "sha256-20D6HanUeAc0S9czkNJFmhsrfEqodpafkHsmwKccrHQ=";
  };

  cargoHash = "sha256-8nMQ81Y0DnPs9WmxNASlcjTEVw5lh+nZtZ7vmmBCu2g=";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  buildInputs = [
    pam
  ];

  postInstall = ''
    for f in man/*; do
      scdoc < "$f" > "$(sed 's/-\([0-9]\)\.scd$/.\1/' <<< "$f")"
      rm "$f"
    done
    installManPage man/*
  '';

  meta = with lib; {
    description = "Minimal and flexible login manager daemon";
    longDescription = ''
      greetd is a minimal and flexible login manager daemon
      that makes no assumptions about what you want to launch.
      Comes with agreety, a simple, text-based greeter.
    '';
    homepage = "https://sr.ht/~kennylevinsen/greetd/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
